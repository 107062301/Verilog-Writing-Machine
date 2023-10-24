`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [6-1:0] addr;
input [7:0] din;
output reg[5:0] dout;
parameter  read = 0;
parameter  write = 1;
parameter  other = 3;

reg [5:0]data[64:0];
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
		    dout<=5'b00000;
		   end
		   
		   other:begin
		    dout<=5'b00000;
		   end
		   default:begin
		   
		   end
		
		endcase
end

endmodule