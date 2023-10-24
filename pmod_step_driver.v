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
    input clk_x,
    input clk_y,
    input c,
    input enter,
    input [5:0]controll,
    output reg [3:0] signal_x,
    output reg [3:0] signal_y,
    output reg [2:0] angle,
    output reg [5:0] state,
    output reg [5:0] led
    );
    
   
    parameter sig4 = 3'b001;
    parameter sig3 = 3'b011;
    parameter sig2 = 3'b010;
    parameter sig1 = 3'b110;
    parameter sig0 = 3'b000;
    parameter Wait = 0;
    parameter A = 1;
    parameter B = 2;
    parameter C = 3;
    parameter D = 4;
    parameter E = 5;
    parameter F = 6;
    parameter G = 7;
    parameter H = 8;
    parameter I = 9;
    parameter J = 10;
    parameter K = 11;
    parameter L = 12;
    parameter M = 13;
    parameter N = 14;
    parameter O = 15;
    parameter P = 16;
    parameter Q = 17;
    parameter R = 18;
    parameter S = 19;
    parameter T = 20;
    parameter U = 21;
    parameter V = 22;
    parameter W = 23;
    parameter X_ = 24;
    parameter Y = 25;
    parameter Z_ = 26;
    parameter space = 27;
    parameter under_line = 28;
    parameter up = 29;
    parameter down =30;
    parameter left = 31;
    parameter right = 32;
    parameter re_center = 33;
    parameter Get = 34;
    parameter Write = 35;
    parameter num_0 = 36;
    parameter num_1 = 37;
    parameter num_2 = 38;
    parameter num_3 = 39;
    parameter num_4 = 40;
    parameter num_5 = 41;
    parameter num_6 = 42;
    parameter num_7 = 43;
    parameter num_8 = 44;
    parameter num_9 = 45;
    parameter ctrl = 46;
    
    reg en_x,dir_x,en_y,dir_y,ren,wen;
    reg [2:0] dir_state_x, next_dir_state_x,dir_state_y, next_dir_state_y;
    reg [5:0] next_state,data_in,pos_x,next_pos_x;
    wire [5:0] data_out;
    wire clk_div;
    reg [34:0] counter,next_count;
    reg [5:0] word_count,next_word_count,addr,next_addr;

    Memory m1(c, ren, wen, addr, controll, data_out);
    clock_divisor clk_wiz_0_inst(
      .clk(c),
      .clk22(clk_div)
    );
    
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
             Get:begin
                en_x = 0;
                en_y = 0;
                angle = 5;
                next_count = 0;
                next_pos_x = pos_x;
                if(controll != 34)begin
                    if (controll == up) begin
                        next_state = up;
                        next_word_count = word_count;
                        next_addr = addr;
                        wen = 0;
                        ren = 0;
                    end
                    else if (controll == down) begin
                        next_state = down;
                        next_word_count = word_count;
                        next_addr = addr;
                        wen = 0;
                        ren = 0;
                    end 
                    else if (controll == left) begin
                        next_state = left;
                        next_word_count = word_count;
                        next_addr = addr;
                        wen = 0;
                        ren = 0;
                    end 
                    else if (controll == right) begin
                        next_state = right;
                        next_word_count = word_count;
                        next_addr = addr;
                        wen = 0;
                        ren = 0;
                    end
                    else if (controll == ctrl) begin
                        next_state = ctrl;
                        next_word_count = word_count;
                        next_addr = addr;
                        wen = 0;
                        ren = 0;
                    end  
                    else begin
                        next_word_count = word_count + 1;
                        next_addr = addr + 1;
                        wen = 1;
                        ren = 0;
                        next_state = Get;
                    end
                end
                else begin
                    if(enter == 1)begin
                        next_word_count = word_count;
                        next_addr = 0;
                        wen = 0;
                        ren = 0;
                        next_state = Write;
                    end
                    else begin
                        next_word_count = word_count;
                        next_addr = word_count;
                        wen = 0;
                        ren = 0;
                        next_state = Get;
                    end
                   
                end
                led = 0;
            end
            Write:begin
                next_count = 0;
                en_x = 0;
                en_y = 0;
                angle = 5;
                if(word_count != 0)begin
                    next_pos_x = pos_x + 1;
                    if(pos_x >= 12) begin
                        next_addr = addr;
                        next_word_count = word_count;
                        next_state = ctrl;
                    end
                    else begin
                        next_addr = addr + 1;
                        next_word_count = word_count - 1;
                        next_state = data_out;
                    end
                    ren = 1;
                    wen = 0;
                    
                    led = data_out;
                end
                else begin
                    next_word_count = 0;
                    next_pos_x = pos_x;
                    next_state = Get;
                    ren = 0;
                    wen = 0;
                    next_addr = 0;
                    led = 0;
                end
            end
            A:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        angle = 0;
                        en_y = 1;
                        dir_y = 1;
                        dir_x = 1;
                        en_x = 1;
                        next_count = counter + 1;
                        next_state = A;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd337_066_668)
                    begin
                        angle = 0;
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1;
                        dir_y = 0;
                        next_state = A;
                        next_count = counter + 1;
                    end
                    else if(counter >= 30'd337_066_668 && counter < 30'd421_233_335)
                    begin
                        angle = 5;
                        en_x = 1;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1;
                        next_count = counter + 1;
                        next_state = A;
                    end
                     else if(counter >= 30'd421_233_335 && counter < 30'd449_422_224)
                    begin
                        angle = 5;
                        en_x = 0;
                        en_y = 0;
                        dir_x = 0;
                        next_count = counter + 1;
                        next_state = A;
                    end
                    else if(counter >= 30'd449_422_224 && counter < 30'd505_600_002)
                    begin
                        angle = 0;
                        en_x = 1;
                        en_y = 0;
                        dir_x = 0;
                        next_count = counter + 1;
                        next_state = A;
                    end
                    else if(counter >= 30'd505_600_002 && counter < 30'd632_000_003)
                    begin
                        angle = 5;
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        next_count = counter + 1;
                        next_state = A;
                    end
                    else if(counter >= 30'd632_000_003 && counter < 30'd716_366_669)
                    begin
                        angle = 5;
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = A;
                    end
                else 
                    begin
                        next_state = Write;
                        en_x = 0;
                        dir_x = 0;
                        en_y = 0;
                        dir_y = 0;
                        angle = 5;
                end
            end
            B:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
               if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = B;
                        angle = 0;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd224_711_112)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state =  B;
                        angle = 0;
                    end
                    else if(counter >= 30'd224_711_112 && counter < 30'd280_888_890)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 0; 
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state =  B;
                        angle = 0;
                    end
                    else if(counter >= 30'd280_888_890 && counter < 30'd393_224_446)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state =  B;
                        angle = 0;
                    end
                    else if(counter >= 30'd393_224_446 && counter < 30'd505_600_002)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 0; 
                        dir_y = 0;    
                        next_count = counter + 1;
                        next_state =  B;
                        angle = 0;
                    end
                    else if(counter >= 30'd505_600_002 && counter < 30'd674_133_336)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state =  B;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            C:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                
               if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = C;
                        angle = 0;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd280_888_890)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state =  C;
                        angle = 0;
                    end
                    else if(counter >= 30'd280_888_890 && counter < 30'd308_977_779)
                    begin
                        en_x = 0;
                        dir_y = 0;
                        en_y = 1;     
                        next_count = counter + 1;
                        next_state =  C;
                        angle = 0;
                    end
                    else if(counter >= 30'd308_977_779 && counter < 30'd421_333_335)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state =  C;
                        angle = 5;
                    end
                    else if(counter >= 30'd421_333_335 && counter < 30'd449_422_224)
                    begin
                        en_x = 0;
                        en_y = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state =  C;
                        angle = 0;
                    end
                    else if(counter >= 30'd449_422_224 && counter < 30'd561_777_780)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 0;
                        next_count = counter + 1;
                        next_state =  C;
                        angle = 0;
                    end
                     else if(counter >= 30'd561_777_780 && counter < 30'd730_311_114)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1;
                        next_count = counter + 1;
                        next_state =  C;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            D:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                
                if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = D;
                        angle = 0;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd280_888_890)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state =  D;
                        angle = 0;
                    end
                    else if(counter >= 30'd280_888_890 && counter < 30'd308_977_779)
                    begin
                        en_x = 0;
                        dir_y = 0;
                        en_y = 0;     
                        next_count = counter + 1;
                        next_state =  D;
                        angle = 0;
                    end
                    else if(counter >= 30'd308_977_779 && counter < 30'd421_333_335)
                    begin
                        en_x = 0;
                        dir_y = 0;
                        en_y = 1;     
                        next_count = counter + 1;
                        next_state =  D;
                        angle = 0;
                    end
                    else if(counter >= 30'd421_333_335 && counter < 30'd533_688_891)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state =  D;
                        angle = 0;
                    end
                    else if(counter >= 30'd533_688_891 && counter < 30'd702_222_225)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1;
                        next_count = counter + 1;
                        next_state =  D;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            E:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                
               if(counter > 30'd112_355_556) begin //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333/2CM = 224_711_111
                   if(counter < 30'd224_711_111)begin // 224_711_111 = 2CM/112_355_556 = 1CM
                        angle = 0;
                        en_x = 1;
                        dir_x = 0;
                        en_y = 0;
                        next_state = E;
                        next_count = counter + 1;
                    end
                    else begin
                        if(counter < 30'd393_244_445)begin
                            angle = 0;
                            en_x = 0;
                            en_y = 1;
                            dir_y = 1;
                            next_count = counter + 1;
                            next_state = E;
                        end
                        else begin
                            if(counter < 30'd505_600_001)begin
                                angle = 0;
                                en_x = 1;
                                dir_x = 1;
                                en_y = 0;
                                next_count = counter + 1;
                                next_state = E;
                            end
                            else begin
                                if(counter < 30'd617_955_557)begin
                                    angle = 5;
                                    en_x = 1;
                                    dir_x = 0;
                                    en_y = 0;
                                    next_count = counter + 1;
                                    next_state = E;
                                end
                                else begin
                                    if(counter < 30'd709_722_224)begin
                                        angle = 5;
                                        en_x = 0; 
                                        en_y = 1;
                                        dir_y = 0;
                                        next_count = counter + 1;
                                        next_state = E;
                                    end
                                    else begin
                                        if(counter < 30'd822_077_780)begin
                                            angle = 0;
                                            en_x = 1; 
                                            en_y = 0;
                                            dir_x = 1;
                                            next_count = counter + 1;
                                            next_state = E;
                                        end
                                        else begin
                                            if(counter < 30'd883_255_558)begin
                                                angle = 5;
                                                en_x = 1; 
                                                en_y = 0;
                                                dir_x = 1;
                                                next_count = counter + 1;
                                                next_state = E;
                                            end
                                            else begin
                                                if(counter < 30'd967_522_225)begin
                                                    angle = 5;
                                                    en_x = 0; 
                                                    en_y = 1;
                                                    dir_y = 0;
                                                    next_count = counter + 1;
                                                    next_state = E;
                                                end
                                                else begin
                                                    next_state = Write;
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                else begin
                    en_y = 0;
                    en_x = 1;
                    dir_x = 1;
                    next_count = counter + 1;
                    next_state = E;
                    angle = 5;
                end 
            end
            F:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                
               if(counter > 30'd56_177_778) begin //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                   if(counter < 30'd224_711_111)begin // 224_711_111 = 2CM/112_355_556 = 1CM
                        angle = 0;
                        en_y = 1;
                        dir_y = 1;
                        en_x = 0;
                        next_state = F;
                        next_count = counter + 1;
                    end
                    else begin
                        if(counter < 30'd337_066_667)begin
                            angle = 0;
                            en_x = 1;
                            en_y = 0;
                            dir_x = 1;
                            next_count = counter + 1;
                            next_state = F;
                        end
                        else begin
                            if(counter < 30'd449_422_223)begin
                                angle = 5;
                                en_x = 1;
                                dir_x = 0;
                                en_y = 0;
                                next_count = counter + 1;
                                next_state = F;
                            end
                            else begin
                                if(counter < 30'd533_688_890)begin
                                    angle = 5;
                                    en_x = 0;
                                    dir_y = 0;
                                    en_y = 1;
                                    next_count = counter + 1;
                                    next_state = F;
                                end
                                else begin
                                    if(counter < 30'd646_044_446)begin
                                        angle = 0;
                                        en_x = 1; 
                                        en_y = 0;
                                        dir_x = 1;
                                        next_count = counter + 1;
                                        next_state = F;
                                    end
                                    else begin
                                        if(counter < 30'd702_222_225)begin
                                            angle = 5;
                                            en_x = 1; 
                                            en_y = 0;
                                            dir_x = 1;
                                            next_count = counter + 1;
                                            next_state = F;
                                        end
                                        else begin
                                            if(counter < 30'd793_988_891)begin
                                                angle = 5;
                                                en_x = 0; 
                                                en_y = 1;
                                                dir_y = 0;
                                                next_count = counter + 1;
                                                next_state = F;
                                            end
                                            else begin
                                                    next_state = Write;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                else begin
                    en_y = 0;
                    en_x = 0;
                    dir_x = 1;
                    next_count = counter + 1;
                    next_state = F;
                    angle = 5;
                end 
            end
            G:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1; 
                        next_count = counter + 1;
                        next_state = G;
                        angle = 5;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd280_888_890)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0; 
                        next_count = counter + 1;
                        next_state = G;
                        angle = 5;
                    end
                    else if(counter >= 30'd280_888_890 && counter < 30'd393_244_442)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = G;
                        angle = 0;
                    end
                    else if(counter >= 30'd393_244_442 && counter < 30'd561_777_780)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = G;
                        angle = 0;
                    end
                    else if(counter >= 30'd561_777_780 && counter < 30'd674_133_336)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = G;
                        angle = 0;
                    end
                    else if(counter >= 30'd674_133_336 && counter < 30'd730_311_114)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1;
                        next_count = counter + 1;
                        next_state = G;
                        angle = 0;
                    end
                    else if(counter >= 30'd730_311_114 && counter < 30'd786_488_892)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 0;
                        dir_y = 1;
                        next_count = counter + 1;
                        next_state = G;
                        angle = 0;
                    end
                    else if(counter >= 30'd786_488_892 && counter < 30'd898_844_448)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 1;
                        next_count = counter + 1;
                        next_state = G;
                        angle = 5;
                    end
                    else if(counter >= 30'd898_844_448 && counter < 30'd955_022_226)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = G;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            H:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd56_177_778) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_x = 1;
                        en_y = 0; 
                        next_count = counter + 1;
                        next_state = H;
                        angle = 5;       
                    end
                    else if(counter >= 30'd56_177_778 && counter < 30'd224_711_112)
                    begin
                        en_x = 0;
                        en_y = 1;
                        dir_y = 1; 
                        next_count = counter + 1;
                        next_state = H;
                        angle = 0;
                    end
                    else if(counter >= 30'd224_711_112 && counter < 30'd308_977_779)
                    begin
                        en_x = 0;
                        dir_y = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = H;
                        angle = 5;
                    end
                    else if(counter >= 30'd308_977_779 && counter < 30'd421_333_335)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = H;
                        angle = 0;
                    end
                    else if(counter >= 30'd421_333_335 && counter < 30'd505_600_002)
                    begin
                        en_x = 0;
                        en_y = 1;
                        dir_y = 1;
                        next_count = counter + 1;
                        next_state = H;
                        angle = 5;
                    end
                    else if(counter >= 30'd505_600_002 && counter < 30'd674_133_336)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = H;
                        angle = 0;
                    end
                    else if(counter >= 30'd674_133_336 && counter < 30'd730_311_114)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        next_count = counter + 1;
                        next_state = H;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            I:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd56_177_778) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_x = 1;
                        en_y = 0; 
                        next_count = counter + 1;
                        next_state = I;
                        angle = 5;       
                    end
                    else if(counter >= 30'd56_177_778 && counter < 30'd168_533_334)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1; 
                        next_count = counter + 1;
                        next_state = I;
                        angle = 0;
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd229_711_112)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 0;     
                        next_count = counter + 1;
                        next_state = I;
                        angle = 5;
                    end
                    else if(counter >= 30'd229_711_112 && counter < 30'd398_244_446)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = I;
                        angle = 0;
                    end
                    else if(counter >= 30'd398_244_446 && counter < 30'd454_422_224)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 0;
                        next_count = counter + 1;
                        next_state = I;
                        angle = 5;
                    end
                    else if(counter >= 330'd454_422_224 && counter < 30'd566_777_780)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = I;
                        angle = 0;
                    end
                    else if(counter >= 30'd566_777_780 && counter < 30'd622_955_558)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        next_count = counter + 1;
                        next_state = I;
                        angle = 5;
                    end
                    else if(counter >= 30'd622_955_558 && counter < 30'd791_488_892)
                    begin
                        en_x = 0;
                        dir_y = 0;
                        en_y = 1;
                        next_count = counter + 1;
                        next_state = I;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            J:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = J;
                        angle = 5;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd280_888_890)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1; 
                        next_count = counter + 1;
                        next_state = J;
                        angle = 0;
                    end
                    else if(counter >= 30'd280_888_890 && counter < 30'd308_977_779)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 0;     
                        next_count = counter + 1;
                        next_state = J;
                        angle = 5;
                    end
                    else if(counter >= 30'd308_977_779 && counter < 30'd477_511_113)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = J;
                        angle = 0;
                    end
                    else if(counter >= 30'd477_511_113 && counter < 30'd561_777_780)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 0;
                        next_count = counter + 1;
                        next_state = J;
                        angle = 0;
                    end
                    else if(counter >= 30'd561_777_780 && counter < 30'd589_866_669)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1;
                        next_count = counter + 1;
                        next_state = J;
                        angle = 0;
                    end
                    else if(counter >= 30'd589_866_669 && counter < 30'd758_400_003)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        next_count = counter + 1;
                        next_state = J;
                        angle = 5;
                    end
                    else if(counter >= 30'd758_400_003 && counter < 30'd786_488_892)
                    begin
                        en_x = 0;
                        dir_y = 0;
                        en_y = 1;
                        next_count = counter + 1;
                        next_state = J;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            K:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = K;
                        angle = 0;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd280_888_890)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1; 
                        next_count = counter + 1;
                        next_state = K;
                        angle = 5;
                    end
                    else if(counter >= 30'd280_888_890 && counter < 30'd365_155_557)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = K;
                        angle = 0;
                    end
                    else if(counter >= 30'd365_155_557 && counter < 30'd449_422_224)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = K;
                        angle = 0;
                    end
                    else if(counter >= 30'd449_422_224 && counter < 30'd505_600_002)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1;
                        next_count = counter + 1;
                        next_state = K;
                        angle = 5;
                    end
                    
                    else 
                    begin
                        next_state = Write;
                        en_x = 0;
                        dir_x = 0;
                        en_y = 0;
                        dir_y = 0;
                        angle = 5;
                    end
            end
            L:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = L;
                        angle = 0;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd337_066_668)
                    begin
                        en_x = 0;
                        en_y = 1;
                        dir_y = 0; 
                        next_count = counter + 1;
                        next_state = L;
                        angle = 5;
                    end
                    else if(counter >= 30'd337_066_668 && counter < 30'd449_422_224)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;     
                        next_count = counter + 1;
                        next_state = L;
                        angle = 0;
                    end
                    else if(counter >= 30'd449_422_224 && counter < 30'd505_600_002)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = L;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                    end
            end
            M:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = M;
                        angle = 0;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd224_711_112)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = M;
                        angle = 0;
                    end
                    else if(counter >= 30'd224_711_112 && counter < 30'd280_888_890)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        dir_y = 1;
                        en_y = 1;     
                        next_count = counter + 1;
                        next_state = M;
                        angle = 0;
                    end
                    else if(counter >= 30'd280_888_890 && counter < 30'd449_422_224)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = M;
                        angle = 0;
                    end
                    else if(counter >= 30'd449_422_224 && counter < 30'd505_600_002)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1;
                        next_count = counter + 1;
                        next_state = M;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            N:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = N;
                        angle = 0;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd337_066_668)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = N;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_668 && counter < 30'd505_600_002)
                    begin
                        en_x = 0;
                        dir_x = 1;
                        dir_y = 1;
                        en_y = 1;     
                        next_count = counter + 1;
                        next_state = N;
                        angle = 0;
                    end
                    else if(counter >= 30'd505_600_002 && counter < 30'd561_777_780)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = N;
                        angle = 5;
                    end
                    else if(counter >= 30'd561_777_780 && counter < 30'd730_311_114)
                    begin
                        en_x = 0;
                        dir_x = 1;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = N;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
             O:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd140_444_445) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = O;
                        angle = 0;       
                    end
                    else if(counter >= 30'd140_444_445 && counter < 30'd168_533_334)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 1;
                        next_count = counter + 1;
                        next_state = O;
                        angle = 0;
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd252_800_001)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        dir_y = 1;
                        en_y = 0;     
                        next_count = counter + 1;
                        next_state = O;
                        angle = 0;
                    end
                    else if(counter >= 30'd252_800_001 && counter < 30'd393_244_446)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = O;
                        angle = 0;
                    end
                    else if(counter >= 30'd393_244_446 && counter < 30'd421_333_335)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 0;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = O;
                        angle = 0;
                    end
                    else if(counter >= 30'd421_333_335 && counter < 30'd505_600_002)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 0;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = O;
                        angle = 0;
                    end
                    else if(counter >= 30'd505_600_002 && counter < 30'd674_133_336)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = O;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
             R:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = R;
                        angle = 0;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd280_888_890)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = R;
                        angle = 0;
                    end
                    else if(counter >= 30'd280_888_890 && counter < 30'd337_066_668)
                    begin
                        en_x = 0;
                        dir_x = 1;
                        dir_y = 0;
                        en_y = 1;     
                        next_count = counter + 1;
                        next_state = R;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_668 && counter < 30'd393_244_446)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = R;
                        angle = 0;
                    end
                    else if(counter >= 30'd393_244_446 && counter < 30'd421_333_335)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1;
                        dir_y = 1;
                        next_count = counter + 1;
                        next_state = R;
                        angle = 5;
                    end
                    else if(counter >= 30'd421_333_335 && counter < 30'd505_600_002)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = R;
                        angle = 0;
                    end
                    else if(counter >= 30'd505_600_002 && counter < 30'd561_777_780)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = R;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            P:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = P;
                        angle = 0;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd280_888_890)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = P;
                        angle = 0;
                    end
                    else if(counter >= 30'd280_888_890 && counter < 30'd337_066_668)
                    begin
                        en_x = 0;
                        dir_x = 1;
                        dir_y = 0;
                        en_y = 1;     
                        next_count = counter + 1;
                        next_state = P;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_668 && counter < 30'd393_244_446)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = P;
                        angle = 0;
                    end
                    else if(counter >= 30'd393_244_446 && counter < 30'd505_600_002)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1;
                        dir_y = 1;
                        next_count = counter + 1;
                        next_state = P;
                        angle = 5;
                    end
                    else if(counter >= 30'd505_600_002 && counter < 30'd561_777_780)
                    begin
                        en_x = 0;
                        en_y = 1;
                        dir_x = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = P;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            Q:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd140_444_445) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = Q;
                        angle = 0;       
                    end
                    else if(counter >= 30'd140_444_445 && counter < 30'd168_533_334)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 1;
                        next_count = counter + 1;
                        next_state = Q;
                        angle = 0;
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd252_800_001)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        dir_y = 1;
                        en_y = 0;     
                        next_count = counter + 1;
                        next_state = Q;
                        angle = 0;
                    end
                    else if(counter >= 30'd252_800_001 && counter < 30'd393_244_446)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = Q;
                        angle = 0;
                    end
                    else if(counter >= 30'd393_244_446 && counter < 30'd421_333_335)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 0;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = Q;
                        angle = 0;
                    end
                    else if(counter >= 30'd421_333_335 && counter < 30'd505_600_002)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 0;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = Q;
                        angle = 0;
                    end
                    else if(counter >= 30'd505_600_002 && counter < 30'd561_777_780)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1;
                        dir_y = 1;
                        next_count = counter + 1;
                        next_state = Q;
                        angle = 5;
                    end
                    else if(counter >= 30'd561_777_780 && counter < 30'd617_955_558)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = Q;
                        angle = 0;
                    end
                    else if(counter >= 30'd617_955_558 && counter < 30'd674_133_336)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = Q;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            S:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd56_177_778) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = S;
                        angle = 5;       
                    end
                    else if(counter >= 30'd56_177_778 && counter < 30'd112_355_556)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = S;
                        angle = 0;
                    end
                    else if(counter >= 30'd112_355_556 && counter < 30'd168_533_334)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        dir_y = 1;
                        en_y = 1;     
                        next_count = counter + 1;
                        next_state = S;
                        angle = 0;
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd280_888_890)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = S;
                        angle = 0;
                    end
                    else if(counter >= 30'd280_888_890 && counter < 30'd337_066_668)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1;
                        dir_y = 1;
                        next_count = counter + 1;
                        next_state = S;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_668 && counter < 30'd393_224_446)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = S;
                        angle = 0;
                    end
                    else if(counter >= 30'd393_224_446 && counter < 30'd449_422_224)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = S;
                        angle = 5;
                    end
                    else if(counter >= 30'd449_422_224 && counter < 30'd561_777_780)
                    begin
                        en_x = 0;
                        en_y = 1;
                        dir_x = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = S;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            T:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = T;
                        angle = 5;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd280_888_890)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = T;
                        angle = 0;
                    end
                    else if(counter >= 30'd280_888_890 && counter < 30'd337_066_668)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = T;
                        angle = 5;
                    end
                    else if(counter >= 30'd337_066_668 && counter < 30'd505_600_002)
                    begin
                        en_x = 0;
                        en_y = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = T;
                        angle = 0;
                    end
                    else if(counter >= 30'd505_600_002 && counter < 30'd617_955_558)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1;
                        next_count = counter + 1;
                        next_state = T;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            U:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = U;
                        angle = 5;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd337_066_668)
                    begin
                        en_x = 0;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = U;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_668 && counter < 30'd449_422_224)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        dir_y = 0;
                        en_y = 0;     
                        next_count = counter + 1;
                        next_state = U;
                        angle = 0;
                    end
                    else if(counter >= 30'd449_422_224 && counter < 30'd617_955_558)
                    begin
                        en_x = 0;
                        dir_x = 1;
                        en_y = 1;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = U;
                        angle = 0;
                    end
                    else if(counter >= 30'd617_955_558 && counter < 30'd674_133_336)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = U;
                        angle = 5;
                    end
                    else if(counter >= 30'd674_133_336 && counter < 30'd842_666_670)
                    begin
                        en_x = 0;
                        dir_x = 1;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = U;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            V:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                
                if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = V;
                        angle = 5;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd337_066_668)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = V;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_668 && counter < 30'd505_600_002)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        dir_y = 1;
                        en_y = 1;     
                        next_count = counter + 1;
                        next_state = V;
                        angle = 0;
                    end
                    else if(counter >= 30'd505_600_002 && counter < 30'd561_777_780)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = V;
                        angle = 5;
                    end
                    else if(counter >= 30'd561_777_780 && counter < 30'd730_311_114)
                    begin
                        en_x = 0;
                        dir_x = 1;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = V;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            W:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                   if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = W;
                        angle = 5;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd337_066_668)
                    begin
                        en_x = 0;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = W;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_668 && counter < 30'd393_224_446)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        dir_y = 1;
                        en_y = 1;     
                        next_count = counter + 1;
                        next_state = W;
                        angle = 0;
                    end
                    else if(counter >= 30'd393_224_446 && counter < 30'd449_422_224)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        dir_y = 0;
                        en_y = 1;     
                        next_count = counter + 1;
                        next_state = W;
                        angle = 0;
                    end
                    else if(counter >= 30'd449_422_224 && counter < 30'd617_955_558)
                    begin
                        en_x = 0;
                        dir_x = 1;
                        en_y = 1;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = W;
                        angle = 0;
                    end
                    else if(counter >= 30'd617_955_558 && counter < 30'd674_133_336)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = W;
                        angle = 5;
                    end
                    else if(counter >= 30'd674_133_336&& counter < 30'd842_666_670)
                    begin
                        en_x = 0;
                        dir_x = 1;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = W;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            X_:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = X_;
                        angle = 5;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd337_066_668)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = X_;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_668 && counter < 30'd505_600_002)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = X_;
                        angle = 5;
                    end
                    else if(counter >= 30'd505_600_002 && counter < 30'd674_133_336)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_y = 0;
                        dir_x = 0;
                        next_count = counter + 1;
                        next_state = X_;
                        angle = 0;
                    end
                    else if(counter >= 30'd674_133_336 && counter < 30'd867_735_559)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1;
                        next_count = counter + 1;
                        next_state = X_;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            Y:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = Y;
                        angle = 5;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd224_711_112)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = Y;
                        angle = 0;
                    end
                    else if(counter >= 30'd224_711_112 && counter < 30'd280_888_890)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_x = 1; 
                        dir_y = 1;
                        next_count = counter + 1;
                        next_state = Y;
                        angle = 0;
                    end
                    else if(counter >= 30'd280_888_890 && counter < 30'd337_066_668)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = Y;
                        angle = 5;
                    end
                    else if(counter >= 30'd337_066_668 && counter < 30'd449_422_224)
                    begin
                        en_x = 0;
                        en_y = 1;
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = Y;
                        angle = 0;
                    end
                    else if(counter >= 30'd449_422_224 && counter < 30'd561_777_780)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1;
                        next_count = counter + 1;
                        next_state = Y;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            Z_:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                 //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_334) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_y = 1;
                        dir_x = 1;
                        en_y = 1; 
                        next_count = counter + 1;
                        next_state = Z_;
                        angle = 5;       
                    end
                    else if(counter >= 30'd168_533_334 && counter < 30'd252_800_001)
                    begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1; 
                        dir_y = 0;
                        next_count = counter + 1;
                        next_state = Z_;
                        angle = 0;
                    end
                    else if(counter >= 30'd252_800_001 && counter < 30'd421_333_335)
                    begin
                        en_x = 1;
                        en_y = 1;
                        dir_y = 0;
                        dir_x = 0;
                        next_count = counter + 1;
                        next_state = Z_;
                        angle = 0;
                    end
                    else if(counter >= 30'd421_333_335 && counter < 30'd561_777_780)
                    begin
                        if(counter < 30'd505_600_002) angle = 0;
                        else angle = 5;
                        en_x = 1;
                        en_y = 0;
                        dir_x = 1;
                        next_count = counter + 1;
                        next_state = Z_;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            up:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                en_y = 1;
                dir_y = 1;
                en_x = 0;
                angle = 5;
                if(controll == up) next_state = up;
                else next_state = Get;
            end
            down:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                
                en_y = 1;
                dir_y = 0;
                en_x = 0;
                angle = 5;
                if(controll == down) next_state = down;
                else next_state = Get;
            end
            left:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                
                en_x = 1;
                dir_x = 0;
                en_y = 0;
                angle = 5; 
                if(controll == left) next_state = left;
                else next_state = Get;
            end
            right:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                
                en_x = 1;
                dir_x = 1;
                en_y = 0;
                angle = 5; 
                if(controll == right) next_state = right;
                else next_state = Get;
            end
            space:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                
                angle = 5;
                if(counter < 35'd112_355_556)begin
                    en_x = 1;
                    en_y = 0;
                    dir_x = 1;
                    next_count = counter + 1;
                    next_state = space;
                end
                else begin
                    next_state = Write;
                    en_x = 0;
                    en_y = 0;
                end
            end
            under_line:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x;
                
                
                if(counter >= 0 && counter < 30'd112_355_556)begin
                    en_x = 1;
                    en_y = 0;
                    dir_x = 1;
                    angle = 0;
                    next_count = counter + 1;
                    next_state = under_line;
                end
                else if(counter >= 30'd112_355_556 && counter < 30'd168_533_334)begin
                    en_x = 1;
                    en_y = 0;
                    dir_x = 1;
                    angle = 5;
                    next_count = counter + 1;
                    next_state = under_line;
                end
                else begin
                    next_state = Write;
                    en_x = 0;
                    en_y = 0;
                    angle = 5;
                end
            end
            ctrl:begin
                next_word_count = word_count;
                next_addr = addr;
                
                  if(counter < 30'd168_533_334*pos_x)begin
                        en_x = 1;
                        en_y = 0;
                        dir_x = 0;
                        next_pos_x = pos_x;
                        next_count = counter + 1;
                        next_state = ctrl;
                    end
                    else begin
                        if(counter < 30'd168_533_334*(pos_x+1))begin
                            en_x = 0;
                            en_y = 1;
                            dir_y = 0;
                            next_pos_x = pos_x;
                            next_count = counter + 1;
                            next_state = ctrl;
                        end
                        else begin
                            en_x = 0;
                            en_y = 0;
                            next_pos_x = 0;
                            next_state = Write;
                        end
                end
      
                led = 0;    
                angle = 5;
            end
            num_0:begin
                next_word_count = word_count;
                next_addr = addr;
                
                led = 0;
                next_pos_x = pos_x; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd84_266_666) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0; 
                        next_count = counter + 1;
                        next_state = num_0;
                        angle = 0;       
                    end
                    else if(counter >= 30'd84_266_666 && counter < 30'd252_799_998)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1; 
                        next_count = counter + 1;
                        next_state = num_0;
                        angle = 0;
                    end
                    else if(counter >= 30'd252_799_998 && counter < 30'd337_066_664)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_0;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_664 && counter < 30'd505_599_996)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_0;
                        angle = 0;
                    end
                    else if(counter >= 30'd505_599_996 && counter < 30'd646_044_439)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_0;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            num_1:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_332) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1; 
                        next_count = counter + 1;
                        next_state = num_1;
                        angle = 5;       
                    end
                    else if(counter >= 30'd168_533_332 && counter < 30'd252_799_998)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0; 
                        next_count = counter + 1;
                        next_state = num_1;
                        angle = 5;
                    end
                    else if(counter >= 30'd252_799_998 && counter < 30'd421_333_330)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_1;
                        angle = 0;
                    end
                    else if(counter >= 30'd421_333_330 && counter < 30'd477_511_107)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_1;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            num_2:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_332) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1; 
                        next_count = counter + 1;
                        next_state = num_2;
                        angle = 5;       
                    end
                    else if(counter >= 30'd168_533_332 && counter < 30'd252_799_998)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0; 
                        next_count = counter + 1;
                        next_state = num_2;
                        angle = 0;
                    end
                    else if(counter >= 30'd252_799_998 && counter < 30'd337_066_664)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_2;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_664 && counter < 30'd421_333_330)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_2;
                        angle = 0;
                    end
                    else if(counter >= 30'd421_333_330 && counter < 30'd505_599_996)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_2;
                        angle = 0;
                    end
                    else if(counter >= 30'd505_599_996 && counter < 30'd589_866_662)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_2;
                        angle = 0;
                    end
                    else if(counter >= 30'd589_866_662 && counter < 30'd646_044_439)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_2;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            num_3:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd84_266_666) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0; 
                        next_count = counter + 1;
                        next_state = num_3;
                        angle = 0;       
                    end
                    else if(counter >= 30'd84_266_666 && counter < 30'd252_799_998)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1; 
                        next_count = counter + 1;
                        next_state = num_3;
                        angle = 0;
                    end
                    else if(counter >= 30'd252_799_998 && counter < 30'd337_066_664)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_3;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_664 && counter < 30'd421_333_330)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_3;
                        angle = 5;
                    end
                    else if(counter >= 30'd421_333_330 && counter < 30'd505_599_996)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_3;
                        angle = 0;
                    end
                    else if(counter >= 30'd505_599_996 && counter < 30'd561_777_773)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_3;
                        angle = 5;
                    end
                    else if(counter >= 30'd561_777_773 && counter < 30'd646_044_439)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_3;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            num_4:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd168_533_332) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1; 
                        next_count = counter + 1;
                        next_state = num_4;
                        angle = 5;       
                    end
                    else if(counter >= 30'd168_533_332 && counter < 30'd252_799_998)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0; 
                        next_count = counter + 1;
                        next_state = num_4;
                        angle = 0;
                    end
                    else if(counter >= 30'd252_799_998 && counter < 30'd337_066_664)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_4;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_664 && counter < 30'd421_333_330)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = num_4;
                        angle = 5;
                    end
                    else if(counter >= 30'd421_333_330 && counter < 30'd589_866_662)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_4;
                        angle = 0;
                    end
                    else if(counter >= 30'd589_866_662 && counter < 30'd646_044_439)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_4;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            num_5:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd84_266_666) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0; 
                        next_count = counter + 1;
                        next_state = num_5;
                        angle = 0;       
                    end
                    else if(counter >= 30'd84_266_666 && counter < 30'd168_533_332)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1; 
                        next_count = counter + 1;
                        next_state = num_5;
                        angle = 0;
                    end
                    else if(counter >= 30'd168_533_332 && counter < 30'd252_799_998)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_5;
                        angle = 0;
                    end
                    else if(counter >= 30'd252_799_998 && counter < 30'd337_066_664)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = num_5;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_664 && counter < 30'd421_333_330)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_5;
                        angle = 0;
                    end
                    else if(counter >= 30'd421_333_330 && counter < 30'd477_511_107)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_5;
                        angle = 5;
                    end
                    else if(counter >= 30'd477_511_107 && counter < 30'd646_044_439)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_5;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            num_6:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd84_266_666) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1; 
                        next_count = counter + 1;
                        next_state = num_6;
                        angle = 5;       
                    end
                    else if(counter >= 30'd84_266_666 && counter < 30'd168_533_332)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0; 
                        next_count = counter + 1;
                        next_state = num_6;
                        angle = 0;
                    end
                    else if(counter >= 30'd168_533_332 && counter < 30'd252_799_998)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_6;
                        angle = 0;
                    end
                    else if(counter >= 30'd252_799_998 && counter < 30'd337_066_664)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_6;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_664 && counter < 30'd505_599_996)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = num_6;
                        angle = 0;
                    end
                    else if(counter >= 30'd505_599_996 && counter < 30'd589_866_662)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_6;
                        angle = 0;
                    end
                    else if(counter >= 30'd589_866_662 && counter < 30'd646_044_439)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_6;
                        angle = 5;
                    end
                    else if(counter >= 30'd646_044_439 && counter < 30'd814_577_771)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_6;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            num_7:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd84_266_666) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1; 
                        next_count = counter + 1;
                        next_state = num_7;
                        angle = 5;       
                    end
                    else if(counter >= 30'd84_266_666 && counter < 30'd168_533_332)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1; 
                        next_count = counter + 1;
                        next_state = num_7;
                        angle = 0;
                    end
                    else if(counter >= 30'd168_533_332 && counter < 30'd252_799_998)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_7;
                        angle = 0;
                    end
                    else if(counter >= 30'd252_799_998 && counter < 30'd421_333_330)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_7;
                        angle = 0;
                    end
                    else if(counter >= 30'd421_333_330 && counter < 30'd477_511_107)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_7;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            num_8:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd84_266_666) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0; 
                        next_count = counter + 1;
                        next_state = num_8;
                        angle = 0;       
                    end
                    else if(counter >= 30'd84_266_666 && counter < 30'd252_799_998)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1; 
                        next_count = counter + 1;
                        next_state = num_8;
                        angle = 0;
                    end
                    else if(counter >= 30'd252_799_998 && counter < 30'd337_066_664)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_8;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_664 && counter < 30'd505_599_996)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_8;
                        angle = 0;
                    end
                    else if(counter >= 30'd505_599_996 && counter < 30'd589_866_662)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1;     
                        next_count = counter + 1;
                        next_state = num_8;
                        angle = 5;
                    end
                    else if(counter >= 30'd589_866_662 && counter < 30'd674_133_328)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_8;
                        angle = 0;
                    end
                    else if(counter >= 30'd674_133_328 && counter < 30'd730_311_105)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_8;
                        angle = 5;
                    end
                    else if(counter >= 30'd730_311_105 && counter < 30'd814_577_771)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_8;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            num_9:begin
                next_word_count = word_count;
                next_addr = addr;
                led = 0;
                next_pos_x = pos_x; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
                    if(counter >= 30'd0 && counter < 30'd84_266_666) // 224_711_111 = 2CM/112_355_556 = 1CM
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0; 
                        next_count = counter + 1;
                        next_state = num_9;
                        angle = 0;       
                    end
                    else if(counter >= 30'd84_266_666 && counter < 30'd252_799_998)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 1; 
                        next_count = counter + 1;
                        next_state = num_9;
                        angle = 0;
                    end
                    else if(counter >= 30'd252_799_998 && counter < 30'd337_066_664)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_9;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_664 && counter < 30'd421_333_330)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_9;
                        angle = 0;
                    end
                    else if(counter >= 30'd421_333_330 && counter < 30'd505_599_996)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_9;
                        angle = 0;
                    end
                    else if(counter >= 30'd505_599_996 && counter < 30'd561_777_773)
                    begin
                        en_x = 1;
                        dir_x = 1;
                        en_y = 0;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_9;
                        angle = 5;
                    end
                    else if(counter >= 30'd561_777_773 && counter < 30'd646_044_439)
                    begin
                        en_x = 0;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state = num_9;
                        angle = 5;
                    end
                    else 
                    begin
                    next_state = Write;
                    en_x = 0;
                    dir_x = 0;
                    en_y = 0;
                    dir_y = 0;
                    angle = 5;
                end
            end
            default:begin
                
            end
        endcase
    end
    always @ (posedge clk_x, posedge rst)
    begin
        if (rst == 1'b1)begin
            dir_state_x <= sig0;
        end
        else begin
            dir_state_x <= next_dir_state_x;
        end
    end
    always @ (posedge clk_y, posedge rst)
    begin
        if (rst == 1'b1)begin
            dir_state_y <= sig0;
        end
        else begin
            dir_state_y <= next_dir_state_y;
        end
    end
    always@(posedge clk_div)begin
         if(rst) begin
            state <= Get ;
            addr <= 0;
            pos_x <= 0;
            word_count <= 0;
        end
        else  begin
            state <= next_state;
            addr <= next_addr;
            pos_x <= next_pos_x;
            word_count <= next_word_count;
        end
    end
    always@(posedge c)begin
        if(rst) begin
            counter <= 0;
        end
        else  begin
            counter <= next_count;
        end
    end
    always @ (posedge clk_x)
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
    always @ (posedge clk_y)
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
module clock_divisor(clk, clk22);
input clk;
output clk22;
reg [22:0] num;
wire [22:0] next_num;

always @(posedge clk) begin
  num <= next_num;
end

assign next_num = num + 1'b1;
assign clk22 = num[22];
endmodule
