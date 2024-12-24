module traffic_light (
    input clk_in,
    input rst,
    input en,
    input rst_clk,
    input car,
    output [6:0] highway_0,
    output [6:0] highway_1,
    output [6:0] country_0,
    output [6:0] country_1,
    output reg check,
    output reg [3:0] state_out,

    output reg [17:0] road // đường nào được đi thì sáng đèn, quy định là cao tốc thì màu đỏ, đường thường màu xanh

    // output done // test
);  
    wire clk;
    clock clock_module(
        .clk_in(clk_in),
        .clk_out(clk),
        .rst(rst_clk)
    );

    reg [3:0] highway_bin [1:0];
    reg [3:0] country_bin [1:0];

    parameter s0 = 2'b00;// Cao tốc: đèn xanh, Đường thường: đèn đỏ 
    parameter s1 = 2'b01;// Cao tốc: đèn vàng, Đường thường: đèn đỏ
    parameter s2 = 2'b10;// Cao tốc: đèn đỏ, Đường thường: đèn xanh
    parameter s3 = 2'b11;// Cao tốc: đèn đỏ, Đường thường: đèn vàng
    reg [1:0] state;

    wire wait_green;
    wire wait_yellow;


    reg en_red;
    reg rst_red;
    wire done_red;
    wire [3:0] red_num [1:0];

    reg en_green;
    reg rst_green;
    wire done_green;
    wire [3:0] green_num [1:0];

    reg en_yellow;
    reg rst_yellow;
    wire done_yellow;
    wire [3:0] yellow_num [1:0];

    assign wait_green = ~done_green;
    assign wait_yellow = ~done_yellow;

    light #(
        .MAX_0(9),
        .MAX_1(0)
    )red (
        .clk(clk),
        .rst((rst_red | rst)), // khi bấm nút rst thì đưa tất cả các đèn về trạng thái đợi để đếm ngược
        .en((en_red & en)),
        .done(done_red),
        .num_0(red_num[0]),
        .num_1(red_num[1])
    );

    light #(
        .MAX_0(5),
        .MAX_1(0)
    )green (
        .clk(clk),
        .rst((rst_green | rst)), // khi bấm nút rst thì đưa tất cả các đèn về trạng thái đợi để đếm ngược
        .en((en_green & en)),
        .done(done_green),
        .num_0(green_num[0]),
        .num_1(green_num[1])
    );

    light #(
        .MAX_0(3),
        .MAX_1(0)
    )yellow (
        .clk(clk),
        .rst((rst_yellow | rst)), // khi bấm nút rst thì đưa tất cả các đèn về trạng thái đợi để đếm ngược
        .en((en_yellow & en)),
        .done(done_yellow),
        .num_0(yellow_num[0]),
        .num_1(yellow_num[1])
    );

    always @(posedge clk) begin
        if(rst == 1'b1) begin
            state <= s0;
            check <= 1;
        end else begin
            check <= 0;
            case(state)
                s0: begin 

                    en_yellow <= 0;
                    rst_yellow <= 1; // đợi sẵn để đếm ngược

                    if(done_green && (car != 1'b1))begin
                        en_red <= 0;
                        rst_red <= 1;
                        en_green<= 0;
                        rst_green <= 1;
                    end else begin
                        en_red <= 1;
                        rst_red <= 0;
                        en_green <= 1;
                        rst_green <= 0;
                    end

                    if ((car == 1'b1) && (wait_green == 1'b0)) begin
                        state <= s1;
                    end
                    else begin
                        state <= s0;   
                    end
                end
                s1: begin
                    en_green <= 0;
                    rst_green <= 1;
                    en_red <= 1;
                    rst_red <= 0;
                    en_yellow <= 1;
                    rst_yellow <= 0;

                    if(done_yellow == 1'b1) begin
                        state <= s2;
                        // check<=1;
                    end
                    else begin
                        state <= s1;
                        check<=1;
                    end
                end
                s2: begin

                    en_green <= 1;
                    rst_green <= 0;
                    en_red <= 1;
                    rst_red <= 0;
                    en_yellow <= 0;
                    rst_yellow <= 1; // đợi sẵn để đếm ngược
                    if (wait_green == 1'b0) begin
                        state <= s3;
                    end
                    else begin
                        state <= s2;
                    end
                end
                s3: begin
                    en_green <= 0;
                    rst_green <= 1;
                    en_red <= 1;
                    rst_red <= 0;
                    en_yellow <= 1;
                    rst_yellow <= 0;
                    if ((car == 1'b0) && (wait_yellow == 1'b0)) begin
                        state <= s0;
                        // check <= 1;
                    end else if ((car == 1'b1) && (wait_yellow == 1'b0)) begin
                        state <= s2;
                    end
                    else begin
                        state <= s3;
                    end
                end
                default: begin
                    check<=1;
                end
            endcase

        end
    end

    always @(posedge clk) begin
        case (state)
            s0: begin
                road <= 18'b111111111000000000;
                state_out <= 4'b0001;

                highway_bin[0] <= green_num[0];
                highway_bin[1] <= green_num[1];
                country_bin[0] <= red_num[0];
                country_bin[1] <= red_num[1];
            end
            s1: begin
                road <= 18'b000000000000000000;
                state_out <= 4'b0010;


                highway_bin[0] <= yellow_num[0];
                highway_bin[1] <= yellow_num[1];
                country_bin[0] <= red_num[0];
                country_bin[1] <= red_num[1];
            end
            s2: begin
                road <= 18'b000000000111111111;
                state_out = 4'b0100;

                highway_bin[0] <= red_num[0];
                highway_bin[1] <= red_num[1];
                country_bin[0] <= green_num[0];
                country_bin[1] <= green_num[1];
            end
            s3: begin
                road <= 18'b000000000000000000;
                state_out = 4'b1000;


                highway_bin[0] <= red_num[0];
                highway_bin[1] <= red_num[1];
                country_bin[0] <= yellow_num[0];
                country_bin[1] <= yellow_num[1];
            end
        endcase
    end
//  ---------------------- Display ----------------------
    seven_seg_decoder decoder_highway_0(
        .bin_num(highway_bin[0]),
        .seg_num(highway_0)
    );
    seven_seg_decoder decoder_highway_1(
        .bin_num(highway_bin[1]),
        .seg_num(highway_1)
    );
    seven_seg_decoder decoder_country_0(
        .bin_num(country_bin[0]),
        .seg_num(country_0)
    );
    seven_seg_decoder decoder_country_1(
        .bin_num(country_bin[1]),
        .seg_num(country_1)
    );
endmodule