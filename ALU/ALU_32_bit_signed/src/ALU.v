module ALU #(
    parameter WIDTH = 32
)(
    input [WIDTH-1:0] num_1,
    input [WIDTH-1:0] num_2,
    input [WIDTH-1:0] sub_reg_input,
    input [3:0] opcode, // chỉ dùng từ 0 - 9, còn lại output = 0 hết
    input clk,
    output reg [WIDTH-1:0] result,
    output reg [WIDTH-1:0] sub_reg_result,
    output reg done,
    output reg [3:0] flag // cờ báo trạng thái: overflow, zero, sign, carry 
);

    parameter OVERFLOW=3;
    parameter ZERO=2;
    parameter SIGN=1;
    parameter CARRY=0;

    parameter ADD = 4'b0000;
    parameter SUB = 4'b0001;
    parameter MUL = 4'b0010;
    parameter DIV = 4'b0011; // chú ý trường hợp chia cho 0
    parameter NEG = 4'b0100; // bù 2 của num_1
    parameter AND = 4'b0101;
    parameter OR  = 4'b0110;
    parameter XOR = 4'b0111;
    parameter NOT = 4'b1000; // đảo của num_1

    parameter ADD_CTR = 1'b0;
    parameter SUB_CTR = 1'b1;

    // reg signed [WIDTH-1:0] ADD_input_A;
    // reg signed [WIDTH-1:0] ADD_input_B;
    reg ADD_input_en;
    reg ADD_input_Ctr;
    wire signed [WIDTH-1:0] ADD_output_S;
    wire ADD_output_Cout;
    wire ADD_output_done;
    wire [3:0] ADD_output_flag;

    // reg signed [WIDTH-1:0] SUB_input_A;
    // reg signed [WIDTH-1:0] SUB_input_B;
    reg SUB_input_en;
    reg SUB_input_Ctr;
    wire signed [WIDTH-1:0] SUB_output_S;
    wire SUB_output_Cout;
    wire SUB_output_done;
    wire [3:0] SUB_output_flag;

    // reg signed [WIDTH-1:0] SUB_input_A;
    // reg signed [WIDTH-1:0] SUB_input_B;
    reg NEG_input_en;
    reg NEG_input_Ctr;
    wire signed [WIDTH-1:0] NEG_output_S;
    wire NEG_output_Cout;
    wire NEG_output_done;
    wire [3:0] NEG_output_flag;

    // reg signed [WIDTH-1:0] MUL_input_M;
    // reg signed [WIDTH-1:0] MUL_input_Q;
    reg MUL_input_en;
    reg MUL_input_reset;
    wire signed [WIDTH*2-1:0] MUL_output_A;
    wire [3:0] MUL_output_flag;
    wire MUL_done;

    // reg signed [WIDTH*2-1:0] DIV_input_Z;
    // reg signed [WIDTH-1:0] DIV_input_D;
    reg DIV_input_en;
    reg DIV_input_reset;
    wire signed [WIDTH-1:0] DIV_output_Q;
    wire signed [WIDTH-1:0] DIV_output_R;
    wire DIV_done;
    wire [3:0] DIV_flag;

    reg AND_en;
    reg [WIDTH-1:0] AND_output;
    reg [3:0] AND_flag;
    reg OR_en;
    reg [WIDTH-1:0] OR_output;
    reg [3:0] OR_flag;
    reg XOR_en;
    reg [WIDTH-1:0] XOR_output;
    reg [3:0] XOR_flag;
    reg NOT_en;
    reg [WIDTH-1:0] NOT_output;
    reg [3:0] NOT_flag;

    add ALU_ADD(
        .A_in(num_1),
        .B_in(num_2),
        .Ctr_in(ADD_CTR),
        .en(ADD_input_en),
        .clk(clk),
        .S(ADD_output_S),
        .Cout(ADD_output_Cout),
        .done(ADD_output_done),
        .flag(ADD_output_flag)
    );

    add ALU_SUB(
        .A_in(num_1),
        .B_in(num_2),
        .Ctr_in(SUB_CTR),
        .en(SUB_input_en),
        .clk(clk),
        .S(SUB_output_S),
        .Cout(SUB_output_Cout),
        .done(SUB_output_done),
        .flag(SUB_output_flag)
    );

    add ALU_NEG(
        .A_in(0),
        .B_in(num_1),
        .Ctr_in(SUB_CTR),
        .en(NEG_input_en),
        .clk(clk),
        .S(NEG_output_S),
        .Cout(NEG_output_Cout),
        .done(NEG_output_done),
        .flag(NEG_output_flag)
    );

    mul ALU_MUL(
        .M_in(num_1),
        .Q_in(num_2),
        .clk(clk),
        .reset(0),
        .en(MUL_input_en),
        .done(MUL_done),
        .A_out(MUL_output_A),
        .flag(MUL_output_flag)
    );

    div #(.WIDTH(WIDTH)) ALU_DIV(
        .Z_in({sub_reg_input, num_1}),
        .D_in(num_2),
        .clk(clk),
        .reset(DIV_input_reset),
        .en(DIV_input_en),
        .done(DIV_done),
        .Q(DIV_output_Q),
        .R(DIV_output_R),
        .flag(DIV_flag)
    );

    always @(*) begin : AND_module
        if(AND_en) begin
            AND_output = num_1 & num_2;
            
            if(AND_output == 0) begin
                AND_flag[ZERO] = 1; // zero
            end else begin
                AND_flag[ZERO] = 0;
            end
            AND_flag[OVERFLOW] = 0;
            AND_flag[SIGN] = AND_output[WIDTH-1];
            AND_flag[CARRY] = 0;
        end else begin
            AND_flag = 4'b0000;
            AND_output = 0;
        end
    end

    always @(*) begin : OR_module
        if(OR_en) begin
            OR_output = num_1 | num_2;
            
            if(OR_output == 0) begin
                OR_flag[ZERO] = 1; // zero
            end else begin
                OR_flag[ZERO] = 0;
            end
            OR_flag[OVERFLOW] = 0;
            OR_flag[SIGN] = OR_output[WIDTH-1];
            OR_flag[CARRY] = 0;
        end else begin
            OR_flag = 4'b0000;
            OR_output = 0;
        end
    end

    always @(*) begin : XOR_module

        if(XOR_en) begin
            XOR_output = num_1 ^ num_2;
            
            if(XOR_output == 0) begin
                XOR_flag[ZERO] = 1; // zero
            end else begin
                XOR_flag[ZERO] = 0;
            end
            XOR_flag[OVERFLOW] = 0;
            XOR_flag[SIGN] = XOR_output[WIDTH-1];
            XOR_flag[CARRY] = 0;
        end else begin
            XOR_flag = 4'b0000;
            XOR_output = 0;
        end

    end

    always @(*) begin : NOT_module
        if(NOT_en) begin
            NOT_output = ~num_1;
            
            if(NOT_output == 0) begin
                NOT_flag[ZERO] = 1; // zero
            end else begin
                NOT_flag[ZERO] = 0;
            end
            NOT_flag[OVERFLOW] = 0;
            NOT_flag[SIGN] = NOT_output[WIDTH-1];
            NOT_flag[CARRY] = 0;
        end else begin
            NOT_flag = 4'b0000;
            NOT_output = 0;
        end
    end

    always @(*) begin : OPCODE_drive_output
        case(opcode)
            ADD: begin
                ADD_input_en <= 1;
                flag <= ADD_output_flag;
                result <= ADD_output_S;
                done <= ADD_output_done;

            end
            SUB: begin
                SUB_input_en <= 1;
                flag <= SUB_output_flag;
                result <= SUB_output_S;
                done <= SUB_output_done;
            end
            NEG: begin
                NEG_input_en <= 1;
                flag <= NEG_output_flag;
                result <= NEG_output_S;
                done <= NEG_output_done;
            end
            MUL: begin
                MUL_input_en <= 1;
                flag <= MUL_output_flag;
                {sub_reg_result, result} <= MUL_output_A;
                done <= MUL_done;
            end
            DIV: begin
                DIV_input_en <= 1;
                flag <= DIV_flag;
                result <= DIV_output_Q;
                sub_reg_result <= DIV_output_R;
                done <= DIV_done;
            end
            AND: begin
                AND_en <= 1;
                flag <= AND_flag;
                result <= AND_output;
                done <= 1;
            end
            OR: begin
                OR_en <= 1;
                flag <= OR_flag;
                result <= OR_output;
                done <= 1;
            end
            XOR: begin
                XOR_en <= 1;
                flag <= XOR_flag;
                result <= XOR_output;
                done <= 1;
            end
            NOT: begin
                NOT_en <= 1;
                flag <= NOT_flag;
                result <= NOT_output;
                done <= 1;
            end 
            default: begin
                result <= 0;
                flag <= 4'b1111;
                sub_reg_result <= 0;
                done <= 0;
            end
        endcase
    end

endmodule
