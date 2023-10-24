`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent    
// Engineer: Kaitlyn Franz
// 
// Create Date: 01/23/2016 03:44:35 PM
// Design Name: Claw
// Module Name: pmod_step_driver
// Project Name: Claw_game
// Target Devices: Basys3
// Tool Versions: 2015.4
// Description: This is the state machine that drives
// the output to the PmodSTEP. It alternates one of four pins being
// high at a rate set by the clock divider. 
// 
// Dependencies: 
// 
// Revision: 1
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////

module pmod_step_driver(
    input rst,
    input clk,
    input c,
    output reg [3:0] signal_x,
    output reg [3:0] signal_y
    );
    
   
    parameter sig4 = 3'b001;
    parameter sig3 = 3'b011;
    parameter sig2 = 3'b010;
    parameter sig1 = 3'b110;
    parameter sig0 = 3'b000;
    parameter A = 0;
    parameter B = 1;
    parameter C = 2;
    
    reg en_x,dir_x,en_y,dir_y;
    reg [2:0] dir_state_x, next_dir_state_x,dir_state_y, next_dir_state_y;
    reg [4:0] state,next_state;
    reg [29:0] counter,next_count;
    
    always @ (dir_state_x, dir_x, en_x)
    begin
        case(dir_state_x)
        sig4:
        begin
            if (dir_x == 1'b0 && en_x == 1'b1)
                next_dir_state_x = sig3;
            else if (dir_x == 1'b1 && en_x == 1'b1)
                next_dir_state_x = sig1;
            else 
                next_dir_state_x = sig0;
        end  
        sig3:
        begin
            if (dir_x == 1'b0&& en_x == 1'b1)
                next_dir_state_x = sig2;
            else if (dir_x == 1'b1 && en_x == 1'b1)
                next_dir_state_x = sig4;
            else 
                next_dir_state_x = sig0;
        end 
        sig2:
        begin
            if (dir_x == 1'b0&& en_x == 1'b1)
                next_dir_state_x = sig1;
            else if (dir_x == 1'b1 && en_x == 1'b1)
                next_dir_state_x = sig3;
            else 
                next_dir_state_x = sig0;
        end 
        sig1:
        begin
            if (dir_x == 1'b0&& en_x == 1'b1)
                next_dir_state_x = sig4;
            else if (dir_x == 1'b1 && en_x == 1'b1)
                next_dir_state_x = sig2;
            else 
                next_dir_state_x = sig0;
        end
        sig0:
        begin
            if (en_x == 1'b1)
                next_dir_state_x = sig1;
            else 
                next_dir_state_x = sig0;
        end
        default:
            next_dir_state_x = sig0; 
        endcase
    end
    always @ (dir_state_y, dir_y, en_y)
    begin
        case(dir_state_y)
        sig4:
        begin
            if (dir_y == 1'b0 && en_y == 1'b1)
                next_dir_state_y = sig3;
            else if (dir_y == 1'b1 && en_y == 1'b1)
                next_dir_state_y = sig1;
            else 
                next_dir_state_y = sig0;
        end  
        sig3:
        begin
            if (dir_y == 1'b0&& en_y == 1'b1)
                next_dir_state_y = sig2;
            else if (dir_y == 1'b1 && en_y == 1'b1)
                next_dir_state_y = sig4;
            else 
                next_dir_state_y = sig0;
        end 
        sig2:
        begin
            if (dir_y == 1'b0&& en_y == 1'b1)
                next_dir_state_y = sig1;
            else if (dir_y == 1'b1 && en_y == 1'b1)
                next_dir_state_y = sig3;
            else 
                next_dir_state_y = sig0;
        end 
        sig1:
        begin
            if (dir_y == 1'b0&& en_y == 1'b1)
                next_dir_state_y = sig4;
            else if (dir_y == 1'b1 && en_y == 1'b1)
                next_dir_state_y = sig2;
            else 
                next_dir_state_y = sig0;
        end
        sig0:
        begin
            if (en_y == 1'b1)
                next_dir_state_y = sig1;
            else 
                next_dir_state_y = sig0;
        end
        default:
            next_dir_state_y = sig0; 
        endcase
    end 
    always @ (*)begin
        case(state)
            A:begin
                
                if(counter > 30'd84_266_667) begin //505_600_000 一圈 ，90度 = 126_400_000、180度 = 252_800_000、60度 = 84_266_667(約)、30度 = 42_133_333(約)
                    if(counter < 30'd126_400_000)begin
                        en_x = 0;
                        en_y = 0;
                        dir_y = 1;
                        dir_x = 1;
                    end
                    else begin
                        if(counter < 30'd210_666_667)begin
                            en_x = 1;
                            dir_x = 0;
                            en_y = 1;
                            dir_y = 1;
                        end
                        else begin
                            en_y = 0;
                            dir_y = 0;
                            en_x = 0;
                            dir_x = 0;
                        end
                    end
                end
                else begin
                    en_y = 1;
                    dir_y = 0;
                    dir_x = 0;
                    en_x = 1;
                end

                next_state = A;
                
            end
            B:begin
                
            end
            C:begin
                
            end
            default:begin
                
            end
        endcase
    end
    always @ (posedge clk, posedge rst)
    begin
        if (rst == 1'b1)begin
            dir_state_x <= sig0;
            dir_state_y <= sig0;
            state <= A;
        end
        else begin
            dir_state_x <= next_dir_state_x;
            dir_state_y <= next_dir_state_y;
            state <= next_state;
        end
    end
    always@(posedge c)begin
        if(rst) counter <= 0;
        else  counter <= (counter >= 30'd1000_000_000) ? 0 : counter + 1;
    end
    always @ (posedge clk)
    begin
        if (dir_state_x == sig4)
            signal_x <= 4'b1100;
        else if (dir_state_x == sig3)
            signal_x <= 4'b0110;
        else if (dir_state_x == sig2)
            signal_x <= 4'b0011;
        else if (dir_state_x == sig1)
            signal_x <= 4'b1001;
        else
            signal_x <= 4'b0000;
    end
    always @ (posedge clk)
    begin
        if (dir_state_y == sig4)
            signal_y <= 4'b1100;
        else if (dir_state_y == sig3)
            signal_y <= 4'b0110;
        else if (dir_state_y == sig2)
            signal_y <= 4'b0011;
        else if (dir_state_y == sig1)
            signal_y <= 4'b1001;
        else
            signal_y <= 4'b0000;
    end
endmodule
