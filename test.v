`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/09 00:25:48
// Design Name: 
// Module Name: mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mem(clk,enter,digit,led,rst);
    input clk;
    input rst;
    input enter;
    input [4:0] digit;
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    output reg[2:0]led;
    
    parameter Get = 0;
    parameter Write = 1;
    reg[1:0]state,next_state;
    reg [5:0] controll;
    reg wen,ren;
    //reg [2:0] num;
    reg[5:0]word,next_word,addr,next_addr;
    wire [7:0]dat_out;
    wire d0de,d1de,d2de,d3de,d4de,d5de;
    wire d0o,d1o,d2o,d3o,d4o,d5o,clk_25MHz,clk_22;
    onepulse o1 (d0de, clk_22, d0o);
    debounce d1 (d0de, digit[0], clk);
    onepulse o2 (d1de, clk_22, d1o);
    debounce d2 (d1de, digit[1], clk);
    onepulse o3 (d2de, clk_22, d2o);
    debounce d3 (d2de, digit[2], clk);
    onepulse o4 (d3de, clk_22, d3o);
    debounce d4 (d3de, digit[3], clk);
    onepulse o5 (d4de, clk_22, d4o);
    debounce d5 (d4de, digit[4], clk);
     wire [8:0] KEY_CODES [0:33] = {
		key_down[9'b0_0100_0101],	// 0 => 45
		key_down[9'h1C],	// A
		key_down[9'h32],	//B
		key_down[9'h21],	// C
		key_down[9'h23],	// D
		key_down[9'h24],	// E
		key_down[9'h2B],	// F
		key_down[9'h34],	// G
		key_down[9'h33],	// H
		key_down[9'h43],	// I
		key_down[9'h3B], // J
		key_down[9'h42], // K
		key_down[9'h4B], // L
		key_down[9'h3A], // M
		key_down[9'h31], // N
		key_down[9'h44], // O
		key_down[9'h4D], // P
		key_down[9'h15], // Q
		key_down[9'h2D], // R
		key_down[9'h1B], // S
        key_down[9'h2C], // T
		key_down[9'h3C], // U
		key_down[9'h2A], // V
		key_down[9'h1D], // W
		key_down[9'h22], // X
		key_down[9'h35], // Y
		key_down[9'h1A], // Z
        key_down[9'h75], // up
        key_down[9'h72], // down
        key_down[9'h6B], // left
        key_down[9'b101110100], // right
        key_down[9'h29], // space
        key_down[9'h4E],  // underline
        key_down[9'h5A] //enter
	};
    onepulse o1 (ade, clk, ao);
    debounce d1 (ade, KEY_CODES[01], clk);
    onepulse o2 (bde, clk, bo);
    debounce d2 (bde, KEY_CODES[02], clk);
    onepulse o3 (cde, clk, co);
    debounce d3 (cde, KEY_CODES[03], clk);
    onepulse o4 (dde, clk, do);
    debounce d4 (dde, KEY_CODES[04], clk);
    onepulse o5 (ede, clk, eo);
    debounce d5 (ede, KEY_CODES[05], clk);
    onepulse o6 (fde, clk, fo);
    debounce d6 (fde, KEY_CODES[06], clk);
    onepulse o7 (gde, clk, go);
    debounce d7 (gde, KEY_CODES[07], clk);
    onepulse o8 (hde, clk, ho);
    debounce d8 (hde, KEY_CODES[08], clk);
    Memory m1(clk,ren,wen,addr,controll,dat_out);
    clock_divisor clk_wiz_0_inst(
      .clk(clk),
      .clk1(clk_25MHz),
      .clk22(clk_22)
    );
    /*always @ (*)begin
        if(digit[0] == 1) num = 1;
        else if(digit[1] == 1) num = 2;
        else if(digit[2] == 1) num = 3;
        else if(digit[3] == 1) num = 4;
        else if(digit[4] == 1) num = 5;
        else num = 0;
      end*/
    always @ (*)begin
        case(state)
            Get:begin
                if(controll != 34)begin
                    next_word = word + 1;
                    next_addr = addr + 1;
                    next_state = Get;
                    wen = 1;
                    ren = 0;
                    next_state = Get;
                end
                else begin
                    if(enter == 1)begin
                        next_word = word;
                        next_addr = 0;
                        next_state = Write;
                        wen = 0;
                        ren = 0;
                    end
                    else begin
                        next_word = word;
                        next_addr = word;
                        next_state = Get;
                        wen = 0;
                        ren = 0;
                    end
                end
                led = 0;
            end
            Write:begin
                if(word != 0)begin
                    next_word= word- 1;
                    next_addr = addr + 1;
                    next_state = Write;
                    led = dat_out;
                    wen = 0;
                    ren = 1;
                end
                else begin
                    next_state = Get;
                    next_addr = 0;
                    next_word = 0;
                    wen = 0;
                    ren = 0;
                    led = 0;
                end
            end
         endcase
      end
    always @(posedge clk_22) begin
		if(rst)begin
		  state <= Get;
		  addr <= 0;
		  word <= 0;
		end
		else begin
		  addr <= next_addr;
		  word <= next_word;
		  state <= next_state;
		end
    always @ (*) begin
		
			if(KEY_CODES[00] == 1) controll = 4'b0000;
			else if(ao == 1) controll = 4'b0001; //A
			else if(bo == 1) controll = 4'b0010; //B
			else if(co == 1) controll = 4'b0011; //C
			else if(do == 1) controll = 4'b0100; //D
			else if(eo == 1) controll = 4'b0101; //E
			else if(fo == 1) controll = 4'b0110; //F
			else if(go == 1) controll = 4'b0111; //G
			else if(ho == 1) controll = 4'b1000; //H
			else if(KEY_CODES[09] == 1) controll = 4'b1001; //I
			else if(KEY_CODES[10] == 1) controll = 4'b1010; //J
			else if(KEY_CODES[11] == 1) controll = 4'b1011; //K
			else if(KEY_CODES[12] == 1) controll = 4'b1100; //L
			else if(KEY_CODES[13] == 1) controll = 4'b1101; //M
			else if(KEY_CODES[14] == 1)  controll = 4'b1110; //N
			else if(KEY_CODES[15] == 1)  controll = 4'b1111; //O
			else if(KEY_CODES[16] == 1)  controll = 5'b10000; //P
			else if(KEY_CODES[17] == 1)  controll = 5'b10001; //Q
			else if(KEY_CODES[18] == 1)  controll = 5'b10010; //R
			else if(KEY_CODES[19] == 1)  controll = 5'b10011; //S
			else if(KEY_CODES[20] == 1)  controll = 5'b10100; //T
            else if(KEY_CODES[21] == 1)  controll = 5'b10101; //U
			else if(KEY_CODES[22] == 1)  controll = 5'b10110; //V
			else if(KEY_CODES[23] == 1)  controll = 5'b10111; //W
			else if(KEY_CODES[24] == 1)  controll = 5'b11000; //X
            else if(KEY_CODES[25] == 1)  controll = 5'b11001; //Y
			else if(KEY_CODES[26] == 1)  controll = 5'b11010; //Z
            else if(KEY_CODES[27] == 1)  controll = 5'd29; //up
			else if(KEY_CODES[28] == 1)  controll = 5'd30; //down
			else if(KEY_CODES[29] == 1)  controll = 5'd31; //left
			else if(KEY_CODES[30] == 1)  controll = 6'd32; //right
            else if(KEY_CODES[31] == 1)  controll = 5'd27; //space
			else if(KEY_CODES[32] == 1)  controll = 5'd28; //underline
			else if(KEY_CODES[33] == 1)   controll = 6'd34;//enter
            else controll = 6'd34;
	end
end
    
    
    
endmodule
`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [6-1:0] addr;
input [8-1:0] din;
output reg[8-1:0] dout;
parameter  read = 0;
parameter  write = 1;
parameter  other = 3;

reg [8-1:0]data[64:0];
reg [1:0]state; 

always @(*)begin
    if(ren == 1)begin
        state = read;
    end
    else begin
        if(wen == 1)begin
            state = write;
        end
        else begin
            state = other;
        end
    end
end

always @(posedge clk) begin
		case(state)
		   read:begin
		    dout <= data[addr];
		   end
		    
		   write:begin
		    data[addr] <= din;
		    dout<=8'b00000000;
		   end
		   
		   other:begin
		    dout<=8'b00000000;
		   end
		   default:begin
		   
		   end
		
		endcase
end

endmodule
module onepulse (PB_debounced, clk, PB_one_pulse);
     input PB_debounced;
     input clk;
     output PB_one_pulse;
     reg PB_one_pulse;
     reg PB_debounced_delay;
     reg [21:0]count,next_count;
     always @(posedge clk) begin
         PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
         PB_debounced_delay <= PB_debounced;
     end
     
endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; // signal of a pushbutton after being debounced
    input pb; // signal from a pushbutton
    input clk;

    reg [3:0] DFF; // use shift_reg to filter pushbutton bounce
    always @(posedge clk) begin
         DFF[3:1] <= DFF[2:0];
         DFF[0] <= pb;
    end
     
    assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
     
endmodule
module clock_divisor(clk1, clk, clk22);
input clk;
output clk1;
output clk22;
reg [21:0] num;
wire [21:0] next_num;

always @(posedge clk) begin
  num <= next_num;
end

assign next_num = num + 1'b1;
assign clk1 = num[1];
assign clk22 = num[21];
endmodule