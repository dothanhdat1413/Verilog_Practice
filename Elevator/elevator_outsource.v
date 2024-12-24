module elevator #(
    parameter TEST = 0
)(
    input clk_in,
    input en,
    input rst,
    input [7:0] call,
    input [4:0] choose,
    input h_open_in,
    input h_close_in,
    output [6:0] cur_fl_out, // dùng module
    output [4:0] choose_fl_out, // assign
    output  [7:0] call_fl_out, // led
    output reg [6:0] door_out_0, // 7 seg
    output reg [6:0] door_out_1, // 7 seg
    output reg [6:0] move_dir_out_0, // 7 seg
    output reg [6:0] move_dir_out_1, // 7 seg
    output reg [1:0] hold, // led
    output [4:0] move_fl_check, // led
    output [1:0] state_check,
    output reg check
);
    wire h_open = ~ h_open_in;
    wire h_close = ~ h_close_in;

    integer i;
    reg door; // Trạng thái cửa
    parameter CLOSE_DOOR = 1'b0;
    parameter OPEN_DOOR = 1'b1;

    wire [4:0] cur_fl; // Tầng hiện tại
    wire [4:0] call_fl; // Tầng gọi thang
    wire [7:0] call_fl_dir; // Hướng của tầng gọi thang, giống call nhưng dùng để lái 
    wire [4:0] choose_fl; // Tầng chọn khi ở trong thang
    reg [4:0] move_fl; // Tầng sẽ di chuyển tới
    assign move_fl_check = move_fl;
    reg [1:0] move_dir; // Hướng di chuyển
    parameter DOWN_DIR = 2'b00; // Đi xuống
    parameter D_STOP_DIR = 2'b01; // Dừng sau khi đi xuống
    parameter U_STOP_DIR = 2'b10; // Dừng sau khi đi lên
    parameter UP_DIR = 2'b11; // Đi lên

    reg [1:0] state;
    assign state_check = state;
    parameter IDLE = 2'b01;
    parameter OPEN = 2'b10;
    parameter MOVE = 2'b11;

    wire clk;

    generate 
        if(TEST == 0) begin
            clock #(.TIME(12499999)) clock_module(
                .clk_in(clk_in),
                .rst(1'b0),
                .clk_out(clk)
            ); // đagn test thì để là 1, chạy thì là 12499999
        end else begin
            assign clk = clk_in;
        end
    endgenerate


    reg move_en; // Cho di chuyển
    reg move_mode;// cho bộ đếm di chuyển
    parameter UP_MODE = 1'b0;
    parameter DOWN_MODE = 1'b1;
    cus_counter # (
        .MAX(5'b10000),
        .MIN(5'b00001),
        .WIDTH(5),
        .TIME(3)
    )cus_counter_module (
        .clk(clk),
        .en(en & move_en),
        .rst(rst),
        .mode(move_mode),
        .num(cur_fl)
    );

    reg wait_done; // Đợi cửa mở xong
    reg wait_en; // Bật bộ đếm chờ
    reg wait_rst; // Reset bộ đếm chờ
    reg wait_st; // Set bộ đếm chờ là xong
    reg [3:0] count; // Đếm tối đa 7s
    parameter WAIT_TIME = 4; // 7s

    /* 
    input wait_en, // Bật bộ đếm chờ
    input wait_rst, // Reset bộ đếm chờ
    input wait_st, // Set bộ đếm chờ là xong
    output wait_done, // Đợi cửa mở xong
    */
    always @(posedge clk) begin : wait_module // ưu tiên rst nhất, sau đó tới wait_en, cuối cùng là wait_st, chỉ khi ko được enalbe thì mới xét st_wait
        if(wait_rst) begin
            count <= 0;
            wait_done <= 0;
        end else if (en) begin
            if(wait_en) begin
                if(count == WAIT_TIME) begin
                    wait_done <= 1;
                end else begin
                    count <= count + 1;
                end
            end else if(wait_st) begin
                count <= WAIT_TIME;
                wait_done <= 1;
            end else begin
                wait_done <= 0;
            end
        end
    end

    reg [7:0] off_call_fl;
    call_floor #(
        .WIDTH(5)
    ) call_floor_module(
        .clk(clk_in),
        .rst(rst),
        .call(call),
        .off(off_call_fl),
        .call_fl(call_fl),
        .dir_fl(call_fl_dir)
    );

    reg [4:0] off_choose_fl;
    choose_floor choose_floor_module(
        .clk(clk_in),
        .rst(rst),
        .choose(choose),
        .off(off_choose_fl),
        .choose_fl(choose_fl)
    );

    always @(posedge clk_in) begin : dir_change
        if(rst == 1'b1) begin
            move_dir <= D_STOP_DIR;
            move_mode <= DOWN_MODE;
        end else begin
            if(move_fl > cur_fl) begin // Tầng cần tới ở trên
                move_dir <= UP_DIR;
                move_mode <= UP_MODE;
            end else if(move_fl < cur_fl) begin // Tầng cần tới ở dưới
                move_dir <= DOWN_DIR;
                move_mode <= DOWN_MODE;
            end
            if(move_fl == 0) begin
                move_mode <= move_mode;
                case(move_mode) // Khi dừng lại sẽ biết là vừa đi xuống hay vừa đi lên
                    UP_MODE: begin
                        move_dir <= U_STOP_DIR;
                    end
                    DOWN_MODE: begin
                        move_dir <= D_STOP_DIR;
                    end
                    default: begin
                        move_dir <= D_STOP_DIR;
                    end
                endcase
            end
        end 
    end

    always @(*) begin : door_change
        case(state)
            IDLE: begin
                door <= CLOSE_DOOR;
            end
            OPEN: begin
                door <= OPEN_DOOR;
            end
            MOVE: begin
                door <= CLOSE_DOOR;
            end
            default: begin
                door <= CLOSE_DOOR;
            end
        endcase
    end
    reg wait_en_h_open;
    reg wait_en_call;
    reg wait_en_choose;

    reg state_h_open;
    reg off_state_h_open;
    
    reg state_h_close;
    reg off_state_h_close;

    reg idle_to_open_call;
    reg idle_to_open_choose;
    reg idle_to_open;

    reg idle_to_move_call;
    reg idle_to_move_choose;
    reg idle_to_move;

    wire [7:0] call_fl_dir_check_down = {cur_fl[4],1'b0, cur_fl[3], 1'b0, cur_fl[2], 1'b0, cur_fl[1], 1'b0};
    wire [7:0] call_fl_dir_check_up =    {1'b0,  cur_fl[3], 1'b0, cur_fl[2], 1'b0, cur_fl[1], 1'b0, cur_fl[0]}; // chỉ để check thôi 
    
    parameter check_up_0 = 8'b01010100; // chỉ xét các tầng lớn hơn tầng 1 (đi lên)
    parameter check_down_0 = 8'b00000000; // chỉ xét các tầng nhỏ hơn tầng 1 (đi xuống) (ko có)
    parameter check_up_1 = 8'b11010000; // chỉ xét các tầng lớn hơn tầng 2 (đi lên)
    parameter check_down_1 = 8'b00000001; // chỉ xét các tầng nhỏ hơn tầng 2 (đi xuống) ở đây hết rồi nên là nếu call ở tầng 1 này thì xuống đón
    parameter check_up_2 = 8'b11000000; // chỉ xét các tầng lớn hơn tầng 3 
    parameter check_down_2 = 8'b00000011; // chỉ xét các tầng nhỏ hơn tầng 3
    parameter check_up_3 = 8'b10000000; // chỉ xét các tầng lớn hơn tầng 4
    parameter check_down_3 = 8'b00001011; // chỉ xét các tầng nhỏ hơn tầng 4
    parameter check_up_4 = 8'b00000000; // chỉ xét các tầng lớn hơn tầng 5
    parameter check_down_4 = 8'b00101011; // chỉ xét các tầng nhỏ hơn tầng 5

    always @(posedge clk_in) begin : input_change
        if((state == IDLE) || (state == OPEN)) begin
            if(h_open) begin
                state_h_open <= 1;
            end else if (off_state_h_open)begin
                state_h_open <= 0;
            end else begin
                state_h_open <= state_h_open;
            end
        end else begin
            state_h_open <= 0;
        end

        if(state == OPEN) begin
            if(h_close) begin
                state_h_close <= 1;
            end else if (off_state_h_close)begin
                state_h_close <= 0;
            end else begin
                state_h_close <= state_h_close;
            end
        end else begin
            state_h_close <= 0;
        end
    end

    reg [4:0] choose_move;
    reg [4:0] call_move;
    parameter TOP_FLOOR = 5'b10000;
    parameter FORTH_FLOOR = 5'b01000;
    parameter THIRD_FLOOR = 5'b00100;
    parameter SECOND_FLOOR = 5'b00010;
    parameter BOTTOM_FLOOR = 5'b00001;

    parameter OFF_TOP_FLOOR = 8'b10000000;
    parameter OFF_BOTTOM_FLOOR = 8'b00000001;

    parameter UPPER_SECOND_FLOOR = 5'b11100;
    parameter UPPER_THIRD_FLOOR = 5'b11000;
    parameter LOWER_THIRD_FLOOR = 5'b00011;
    parameter LOWER_FORTH_FLOOR = 5'b00111;


    always @(posedge clk) begin : state_change
        if(rst == 1'b1) begin
            state <= IDLE;
            move_fl <= 0;
            wait_en <= 0;
            wait_st <= 0;
            wait_rst <= 1;

            choose_move <= 0;
            call_move <= 0;

            idle_to_open <= 0;
            idle_to_open_call <= 0;
            idle_to_open_choose <= 0;
            idle_to_move <= 0;
            idle_to_move_call <= 0;
            idle_to_move_choose <= 0;

        end else begin
            case(state)
                IDLE: begin
                    check <= 0;
                    wait_rst <= 1;
                    wait_en <= 0;
                    wait_st <= 0;
                    move_en <= 0;


                    idle_to_open <= state_h_open | idle_to_open_call | idle_to_open_choose;

                    idle_to_move <= idle_to_move_call | idle_to_move_choose;

                    move_fl <= move_fl | call_move | choose_move;

                    if(call_fl & cur_fl) begin 
                        idle_to_open_call <= 1;
                        idle_to_move_call <= 0;
                        if(cur_fl & TOP_FLOOR) begin 
                            off_call_fl <= OFF_TOP_FLOOR;
                        end else if (cur_fl & BOTTOM_FLOOR) begin 
                            off_call_fl <= OFF_BOTTOM_FLOOR;
                        end else begin
                            for(i = 1; i < 4; i = i + 1) begin
                                if(cur_fl[i]) begin
                                    if(call_fl_dir[i*2]) begin
                                        off_call_fl <= OFF_BOTTOM_FLOOR << (i*2); 
                                    end else begin 
                                        off_call_fl <= OFF_BOTTOM_FLOOR << (i*2-1);
                                    end
                                end
                            end
                        end

                    end else if(call_fl) begin // Di chuyển nếu đang ở trong thang có tầng gọi thang mà khác tầng hiện tại
                        idle_to_open_call <= 0;
                        idle_to_move_call <= 1;
                        off_call_fl <= 0;
                        case(move_dir) 
                            U_STOP_DIR: begin // Dùng sau khi đi lên
                                if(call_fl [4]) begin
                                    call_move <= TOP_FLOOR;
                                end else if(call_fl [3]) begin
                                    call_move <= FORTH_FLOOR;
                                end else if(call_fl [2]) begin
                                    call_move <= THIRD_FLOOR;
                                end else if(call_fl [1]) begin
                                    call_move <= SECOND_FLOOR;
                                end else if(call_fl [0]) begin
                                    call_move <= BOTTOM_FLOOR;
                                end else begin
                                    call_move <= 0;
                                end
                            end
                            D_STOP_DIR: begin // Dừng sau khi đi xuống
                                if(call_fl [0]) begin
                                    call_move <= BOTTOM_FLOOR;
                                end else if(call_fl [1]) begin
                                    call_move <= SECOND_FLOOR;
                                end else if(call_fl [2]) begin
                                    call_move <= THIRD_FLOOR;
                                end else if(call_fl [3]) begin
                                    call_move <= FORTH_FLOOR;
                                end else if(call_fl [4]) begin
                                    call_move <= TOP_FLOOR;
                                end else begin
                                    call_move <= 0;
                                end
                            end
                        endcase
                    end else begin
                        idle_to_open_call <= 0;
                        idle_to_move_call <= 0;
                        call_move <= 0;
                        off_call_fl <= 0;
                    end

                    if(choose_fl & cur_fl) begin // Nếu đang ở trong thang mà chọn tầng hiện tại thì mở cửa
                        idle_to_open_choose <= 1;
                        idle_to_move_choose <= 0;
                        choose_move <= 0;
                        off_choose_fl <= choose_fl & cur_fl;
                    end else if(choose_fl)begin // Di chuyển nếu đang ở trong thang mà chọn tầng khác tầng hiện tại 
                        idle_to_move_choose <= 1;
                        idle_to_open_choose <= 0;
                        off_choose_fl <= 0;
                        if(choose_fl [4]) begin
                            choose_move <= TOP_FLOOR;
                        end else if(choose_fl [3]) begin
                            choose_move <= FORTH_FLOOR;
                        end else if(choose_fl [2]) begin
                            choose_move <= THIRD_FLOOR;
                        end else if(choose_fl [1]) begin
                            choose_move <= SECOND_FLOOR;
                        end else if(choose_fl [0]) begin
                            choose_move <= BOTTOM_FLOOR;
                        end
                    end else begin
                        idle_to_open_choose <= 0;
                        idle_to_move_choose <= 0;
                        choose_move <= 0;
                        off_choose_fl <= 0;
                    end
                    
                    if(idle_to_open) begin
                        state <= OPEN;
                        off_state_h_open <= 1;
                    end else if(idle_to_move) begin
                        state <= MOVE;
                        off_state_h_open <= 0;
                    end else begin
                        state <= IDLE;
                        off_state_h_open <= 0;
                    end
                
                end
                OPEN: begin
                    idle_to_open <= 0;
                    idle_to_open_call <= 0;
                    idle_to_open_choose <= 0;
                    idle_to_move <= 0;
                    idle_to_move_call <= 0;
                    idle_to_move_choose <= 0;

                    wait_rst <= 0;
                    wait_en <= (wait_en_h_open & wait_en_call & wait_en_choose);
                    move_en <= 0;
                    move_fl <= move_fl | choose_move | call_move;

                    if(state_h_open) begin // Giữ mở cửa
                        wait_en_h_open <= 0; // en = 0
                        off_state_h_open <= 1;
                    end else begin
                        wait_en_h_open <= 1; // en phụ thuộc các cái còn lại
                        off_state_h_open <= 0;
                    end
                    // Nếu tầng hiện tại có chọn thang hoặc là đang gọi thang thì nếu người dùng nhấn vào thì tắt đi nếu như ko cần thiết
                    if(choose_fl || call_fl) begin // khi có gọi thang thì mới cần xét
                        if(choose_fl & cur_fl) begin // Nếu tầng hiện tại có chọn thang thì xem xét để tắt tầng chọn thang này và lại quay trở lại trạng thái này để đếm
                            off_choose_fl <= choose_fl & cur_fl; // tắt tầng chọn thang hiện tại
                            wait_en_choose <= 0; // giữ trạng thái mở cửa cho đến khi ko còn ai chọn tầng hiện tại nữa
                            choose_move <= 0;
                        end else if(choose_fl) begin // Nếu người trong thang chọn khác tầng hiện tại
                            wait_en_choose <= 1; // en phụ thuộc các cái còn lại
                            off_choose_fl <= 0;
                            case (move_dir)  // Xét cho vào move_fl
                                UP_DIR: begin // chỉ chọn các tầng lớn hơn tầng hiện tại
                                    case(cur_fl) 
                                        BOTTOM_FLOOR: begin // tầng 1
                                            choose_move <= choose_fl;
                                        end
                                        SECOND_FLOOR: begin // tầng 2
                                            choose_move <= (choose_fl & UPPER_SECOND_FLOOR); // chọn các tầng lớn hơn tầng 2
                                        end
                                        THIRD_FLOOR: begin // tầng 3
                                            choose_move <= (choose_fl & UPPER_THIRD_FLOOR); 
                                        end
                                        FORTH_FLOOR: begin // tầng 4
                                            choose_move <= (choose_fl & TOP_FLOOR);
                                        end
                                        TOP_FLOOR: begin // tầng 5 (giữ nguyên_ko xảy ra trường hợp này)
                                            choose_move <= choose_move;
                                        end

                                    endcase
                                end
                                DOWN_DIR: begin // chỉ chọn các tầng nhỏ hơn tầng hiện tại
                                    case(cur_fl)
                                        BOTTOM_FLOOR: begin // tầng 1 (giữ nguyên_ko xảy ra trường hợp này)
                                            choose_move <= 0;
                                        end
                                        SECOND_FLOOR: begin // tầng 2
                                            choose_move <= (choose_fl & BOTTOM_FLOOR); // chọn các tầng nhỏ hơn tầng 2
                                        end
                                        THIRD_FLOOR: begin // tầng 3
                                            choose_move <= (choose_fl & LOWER_THIRD_FLOOR); 
                                        end
                                        FORTH_FLOOR: begin // tầng 4
                                            choose_move <= (choose_fl & LOWER_FORTH_FLOOR);
                                        end
                                        TOP_FLOOR: begin // tầng 5
                                            choose_move <= choose_fl;
                                        end
                                    endcase
                                end
                                default: begin // mới đang dừng, thì xét tầng cao nhất cho vào move_fl
                                    if(choose_fl [4]) begin
                                        choose_move <= TOP_FLOOR;
                                    end else if(choose_fl [3]) begin
                                        choose_move <= FORTH_FLOOR;
                                    end else if(choose_fl [2]) begin
                                        choose_move <= THIRD_FLOOR;
                                    end else if(choose_fl [1]) begin
                                        choose_move <= SECOND_FLOOR;
                                    end else if(choose_fl [0]) begin
                                        choose_move <= BOTTOM_FLOOR;
                                    end 
                                end
                            endcase
                        end else begin
                            off_choose_fl <= 0;
                            wait_en_choose <= 1; // phụ thuộc còn lại
                            choose_move <= 0;
                        end

                        if(call_fl & cur_fl) begin // Nếu tầng hiện tại có gọi thang thì xem xét để tắt tầng gọi thang này
                            call_move <= 0;
                            case (move_dir)
                                DOWN_DIR: begin
                                    if(call_fl_dir & call_fl_dir_check_down) begin // Xét hướng gọi thang của tầng hiện tại (bằng 1 tức là đi xuống) thì tắt tầng này
                                        off_call_fl <= call_fl_dir & call_fl_dir_check_down;
                                        wait_en_call <= 0; // giữ trạng thái mở cửa cho đến khi ko còn ai gọi tầng hiện tại nữa
                                    end else begin 
                                        off_call_fl <= off_call_fl;
                                        wait_en_call <= 1;
                                    end
                                end
                                UP_DIR: begin 
                                    if(call_fl_dir & call_fl_dir_check_up) begin // Xét hướng gọi thang của tầng hiện tại (bằng 0 tức là đi xuống) thì tắt tầng này
                                        off_call_fl <= call_fl_dir & call_fl_dir_check_up; // tắt tầng gọi thang hiện tại
                                        wait_en_call <= 0; // giữ trạng thái mở cửa cho đến khi ko còn ai gọi tầng hiện tại nữa
                                    end else begin 
                                        off_call_fl <= off_call_fl;
                                        wait_en_call <= 1;
                                    end
                                end
                                default: begin 
                                    if(call_fl_dir & call_fl_dir_check_up) begin
                                        off_call_fl <= call_fl_dir & (call_fl_dir_check_up); // tắt tầng gọi thang hiện tại
                                        wait_en_call <= 0; 
                                    end else if(call_fl_dir & call_fl_dir_check_down) begin  // người ta bấm thang đi xuống
                                        off_call_fl <= call_fl_dir & (call_fl_dir_check_down); 
                                        wait_en_call <= 0;
                                    end else begin
                                        wait_en_call <= 1;
                                        off_call_fl <= off_call_fl;
                                    end
                                end
                            endcase
                        end else if(call_fl) begin // Nếu tầng khác call thang 
                            wait_en_call <= 1;
                            off_call_fl <= 0;
                            case (move_dir)
                                DOWN_DIR: begin
                                    case(cur_fl) 
                                        BOTTOM_FLOOR: begin
                                            call_move <= 0; // tầng 1 rồi nên ko xảy ra trường hợp này
                                        end
                                        SECOND_FLOOR: begin
                                            call_move <= 0; // đang ở tầng 2 mà thang vẫn đi xuống thì cứ tiếp tục thôi
                                        end
                                        THIRD_FLOOR: begin // tầng 3
                                            if(call_fl_dir & check_down_2) begin // có tầng 2 muốn xuống
                                                call_move <= {3'b000,call_fl_dir[1], call_fl_dir[0]};
                                            end else begin
                                                call_move <= 0;
                                            end
                                        end
                                        FORTH_FLOOR: begin
                                            if(call_fl_dir & check_down_3) begin
                                                call_move <= {2'b00, call_fl_dir[3], call_fl_dir[1], call_fl_dir[0]};
                                            end else begin 
                                                call_move <= 0;
                                            end
                                        end
                                        TOP_FLOOR: begin
                                            if(call_fl_dir & check_down_4) begin
                                                call_move <= {1'b0, call_fl_dir[5], call_fl_dir[3], call_fl_dir[1], call_fl_dir[0]};
                                            end else begin
                                                call_move <= 0;
                                            end
                                        end
                                    endcase
                                end 
                                UP_DIR: begin 
                                    case(cur_fl) 
                                        BOTTOM_FLOOR: begin
                                            if(call_fl_dir & check_up_0) begin // tầng 1
                                                call_move <= {call_fl_dir[7], call_fl_dir[6], call_fl_dir[4], call_fl_dir[2], 1'b0};
                                            end else begin
                                                call_move <= 0;
                                            end
                                        end
                                        SECOND_FLOOR: begin
                                            if(call_fl_dir & check_up_1) begin // tầng 2
                                                call_move <= {call_fl_dir[7], call_fl_dir[6], call_fl_dir[4], 2'b00};
                                            end else begin
                                                call_move <= 0;
                                            end
                                        end
                                        THIRD_FLOOR: begin
                                            if(call_fl_dir & check_up_2) begin // tầng 3
                                                call_move <= {call_fl_dir[7], call_fl_dir[6], 3'b000};
                                            end else begin
                                                call_move <= 0;
                                            end
                                        end
                                        FORTH_FLOOR: begin
                                            call_move <= 0;
                                        end
                                        TOP_FLOOR: begin
                                            call_move <= 0;
                                        end
                                    endcase
                                end
                                U_STOP_DIR: begin // Vừa đi lên xong thì xét tiếp để đi lên 
                                    if(call_fl [4]) begin
                                        call_move <= TOP_FLOOR;
                                    end else if(call_fl [3]) begin
                                        call_move <= FORTH_FLOOR;
                                    end else if(call_fl [2]) begin
                                        call_move <= THIRD_FLOOR;
                                    end else if(call_fl [1]) begin
                                        call_move <= SECOND_FLOOR;
                                    end else if(call_fl [0]) begin
                                        call_move <= BOTTOM_FLOOR;
                                    end 
                                end
                                D_STOP_DIR: begin // Vừa đi xuống xong thì xét tiếp để đi xuống
                                    if(call_fl [0]) begin
                                        call_move <= BOTTOM_FLOOR;
                                    end else if(call_fl [1]) begin
                                        call_move <= SECOND_FLOOR;
                                    end else if(call_fl [2]) begin
                                        call_move <= THIRD_FLOOR;
                                    end else if(call_fl [3]) begin
                                        call_move <= FORTH_FLOOR;
                                    end else if(call_fl [4]) begin
                                        call_move <= TOP_FLOOR;
                                    end
                                end
                            endcase
                        end else begin
                            wait_en_call <= 1;
                            call_move <= 0;
                        end
                    end else begin // nếu ko có ai gọi hay là chọn thì phụ thuộc còn lại
                        wait_en_call <= 1;
                        wait_en_choose <= 1;
                        call_move <= 0;
                        choose_move <= 0;
                    end
                    
                    if(state_h_close) begin // Đóng cửa
                        wait_st <= 1;
                        off_state_h_close <= 1;
                    end else begin // Cho phép đếm
                        wait_st <= 0;
                        off_state_h_close <= 0;
                    end

                    if(wait_done) begin // Chuyển trạng thái. Chờ xong thì đóng cừa di chuyển
                        if(move_fl) begin 
                            state <= MOVE; 
                        end else begin
                            state <= IDLE;
                            check <= 1;
                        end
                    end else begin // Chưa xong thì giữ nguyên
                        state <= OPEN;
                        check <= 0;
                    end
                    
                end
                MOVE: begin
                    check <= 0;
                    wait_rst <= 1;
                    wait_en <= 0;
                    wait_st <= 0;
                    move_en <= 1;

                    idle_to_open <= 0;
                    idle_to_open_call <= 0;
                    idle_to_open_choose <= 0;
                    idle_to_move <= 0;
                    idle_to_move_call <= 0;
                    idle_to_move_choose <= 0;


                    if(move_fl & cur_fl) begin // Chuyển trạng thái. Tới tầng cần di chuyển và tắt tầng cần di chuyển tương ứng
                        move_fl <= move_fl & (~cur_fl); 
                        state <= OPEN;
                    end else if(move_fl)begin 
                        state <= MOVE;
                        move_fl <= (move_fl | call_move | choose_move); 
                    end else begin
                        state <= IDLE;
                    end
                    
                    if(choose_fl) begin // ktra tầng và cho vào move_fl, tương tự như OPEN
                        case (move_dir) 
                            UP_DIR: begin // chỉ chọn các tầng lớn hơn tầng hiện tại
                                case(cur_fl) 
                                    BOTTOM_FLOOR: begin // tầng 1
                                        choose_move <= choose_fl;
                                    end
                                    SECOND_FLOOR: begin // tầng 2
                                        choose_move <= (choose_fl & UPPER_SECOND_FLOOR); 
                                    end
                                    THIRD_FLOOR: begin // tầng 3
                                        choose_move <= (choose_fl & UPPER_THIRD_FLOOR); 
                                    end
                                    FORTH_FLOOR: begin // tầng 4
                                        choose_move <= (choose_fl & TOP_FLOOR);
                                    end
                                    TOP_FLOOR: begin // tầng 5 (giữ nguyên_ko xảy ra trường hợp này)
                                        choose_move <= choose_move;
                                    end

                                endcase
                            end
                            DOWN_DIR: begin // chỉ chọn các tầng nhỏ hơn tầng hiện tại
                                case(cur_fl)
                                    BOTTOM_FLOOR: begin // tầng 1 (giữ nguyên_ko xảy ra trường hợp này)
                                        choose_move <= 0;
                                    end
                                    SECOND_FLOOR: begin // tầng 2
                                        choose_move <= (choose_fl & BOTTOM_FLOOR); // chọn các tầng nhỏ hơn tầng 2
                                    end
                                    THIRD_FLOOR: begin // tầng 3
                                        choose_move <= (choose_fl & LOWER_THIRD_FLOOR); 
                                    end
                                    FORTH_FLOOR: begin // tầng 4
                                        choose_move <= (choose_fl & LOWER_FORTH_FLOOR);
                                    end
                                    TOP_FLOOR: begin // tầng 5
                                        choose_move <= choose_fl;
                                    end
                                endcase
                            end
                            default: begin // 
                                choose_move <= 0;
                            end
                        endcase
                    end else begin
                        choose_move <= 0;
                    end

                    if(call_fl) begin// ktra tầng và cho vào move_fl, tương tự như OPEN
                        case (move_dir)
                            DOWN_DIR: begin
                                case(cur_fl) 
                                    BOTTOM_FLOOR: begin
                                        call_move <= 0; // tầng 1 rồi nên ko xảy ra trường hợp này
                                    end
                                    SECOND_FLOOR: begin
                                        call_move <= 0; // đang ở tầng 2 mà thang vẫn đi xuống thì cứ tiếp tục thôi
                                    end
                                    THIRD_FLOOR: begin // tầng 3
                                        if(call_fl_dir & check_down_2) begin // có tầng 2 muốn xuống
                                            call_move <= {3'b000,call_fl_dir[1], call_fl_dir[0]};
                                        end else begin
                                            call_move <= 0;
                                        end
                                    end
                                    FORTH_FLOOR: begin
                                        if(call_fl_dir & check_down_3) begin
                                            call_move <= {2'b00, call_fl_dir[3], call_fl_dir[1], call_fl_dir[0]};
                                        end else begin 
                                            call_move <= 0;
                                        end
                                    end
                                    TOP_FLOOR: begin
                                        if(call_fl_dir & check_down_4) begin
                                            call_move <= {1'b0, call_fl_dir[5], call_fl_dir[3], call_fl_dir[1], call_fl_dir[0]};
                                        end else begin
                                            call_move <= 0;
                                        end
                                    end
                                endcase
                            end 
                            UP_DIR: begin 
                                case(cur_fl) 
                                    BOTTOM_FLOOR: begin
                                        if(call_fl_dir & check_up_0) begin // tầng 1
                                            call_move <= {call_fl_dir[7], call_fl_dir[6], call_fl_dir[4], call_fl_dir[2], 1'b0};
                                        end else begin
                                            call_move <= 0;
                                        end
                                    end
                                    SECOND_FLOOR: begin
                                        if(call_fl_dir & check_up_1) begin // tầng 2
                                            call_move <= {call_fl_dir[7], call_fl_dir[6], call_fl_dir[4], 2'b00};
                                        end else begin
                                            call_move <= 0;
                                        end
                                    end
                                    THIRD_FLOOR: begin
                                        if(call_fl_dir & check_up_2) begin // tầng 3
                                            call_move <= {call_fl_dir[7], call_fl_dir[6], 3'b000};
                                        end else begin
                                            call_move <= 0;
                                        end
                                    end
                                    FORTH_FLOOR: begin
                                        call_move <= 0; // tầng 4 // đã lên thì chỉ có đi lên thôi
                                    end
                                    TOP_FLOOR: begin
                                        call_move <= 0; // tầng 5: kịch khung
                                    end
                                endcase
                            end
                            default: begin
                                call_move <= 0;
                            end
                        endcase
                    end else begin
                        call_move <= 0;
                    end
                
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    //______________Display______________

    wire [3:0] cur_fl_bin;
    one_hot_decoder one_hot_decoder_module(
        .in_num(cur_fl),
        .out_num(cur_fl_bin)
    );
    seven_seg_decoder seven_seg_decoder_cur_floor(
        .bin_num(cur_fl_bin),
        .seg_num_out(cur_fl_out)
    );

    parameter OPEN_DOOR_seg_0 =  7'b1110000;
    parameter OPEN_DOOR_seg_1 =  7'b1000110;
    parameter CLOSE_DOOR_seg_0 = 7'b1000110;
    parameter CLOSE_DOOR_seg_1 = 7'b1110000;

    always @(*) begin : door_display
        if(door) begin
            door_out_0 = OPEN_DOOR_seg_0;
            door_out_1 = OPEN_DOOR_seg_1;
        end else begin
            door_out_0 = CLOSE_DOOR_seg_0;
            door_out_1 = CLOSE_DOOR_seg_1;
        end
    end

    assign choose_fl_out = choose_fl;
    assign call_fl_out = call_fl_dir;

    parameter UP_DIR_seg_0 = 7'b1001110;   
    parameter UP_DIR_seg_1 = 7'b1111000;   
    parameter DOWN_DIR_seg_0 = 7'b1000111; 
    parameter DOWN_DIR_seg_1 = 7'b1110001; 
    parameter U_STOP_DIR_seg_0 = 7'b0111110;
    parameter U_STOP_DIR_seg_1 = 7'b0111110;
    parameter D_STOP_DIR_seg_0 = 7'b0110111;
    parameter D_STOP_DIR_seg_1 = 7'b0110111; 

    always @(*) begin : dir_display
        case(move_dir)
            UP_DIR: begin
                move_dir_out_0 = UP_DIR_seg_0;
                move_dir_out_1 = UP_DIR_seg_1;
            end
            DOWN_DIR: begin
                move_dir_out_0 = DOWN_DIR_seg_0;
                move_dir_out_1 = DOWN_DIR_seg_1;
            end
            U_STOP_DIR: begin
                move_dir_out_0 = U_STOP_DIR_seg_0;
                move_dir_out_1 = U_STOP_DIR_seg_1;
            end
            D_STOP_DIR: begin
                move_dir_out_0 = D_STOP_DIR_seg_0;
                move_dir_out_1 = D_STOP_DIR_seg_1;
            end 
            endcase
    end

    always @(*) begin : hold_display
        case(state)
            IDLE: begin
                if(h_open) begin
                    hold = 2'b10;
                end else begin
                    hold = 2'b00;
                end
            end
            OPEN: begin
                if(h_open) begin
                    hold[1] = 1'b1;
                end else begin
                    hold[1] = 1'b0;
                end

                if(h_close) begin
                    hold[0] = 1'b1;
                end else begin
                    hold[0] = 1'b0;
                end
            end
            default: begin
                hold = 2'b00;
            end
        endcase
    end
endmodule
