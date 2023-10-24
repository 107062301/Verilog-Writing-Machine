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
    output reg [5:0] state
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
    parameter Write = 1;
    parameter normal = 0;
    
    reg en_x,dir_x,en_y,dir_y,ren,wen;
    reg [2:0] dir_state_x, next_dir_state_x,dir_state_y, next_dir_state_y;
    reg [5:0] next_state,data_in;
    reg write_state,next_write;
    wire [5:0] data_out;
    reg [34:0] counter,next_count;
    reg [5:0] word_count,next_word_count,addr,next_addr;

    Memory m1(c, ren, wen, addr, controll, data_out);
    
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
                if(controll != 34)begin
                    next_word_count = word_count + 1;
                    next_addr = addr + 1;
                    wen = 1;
                    ren = 0;
                    next_state = Get;
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
                    next_word_count = word_count - 1;
                    next_addr = addr + 1;
                    ren = 1;
                    wen = 0;
                    next_state = data_out;
                    led = data_out;
                end
                else begin
                    next_word_count = 0;
                    next_state = Get;
                    ren = 0;
                    wen = 0;
                    next_addr = 0;
                    led = 0;
                end
            end
            A:begin
                next_addr = addr;
                next_word_count = word_count;
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
                    else if(counter >= 30'd421_233_335 && counter < 30'd505_600_002)
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
                next_addr = addr;
                next_word_count = word_count;
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
                next_addr = addr;
                next_word_count = word_count;
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
                next_addr = addr;
                next_word_count = word_count;
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
                    else if(counter >= 30'd280_888_890 && counter < 30'd337_066_668)
                    begin
                        en_x = 0;
                        dir_y = 0;
                        en_y = 1;     
                        next_count = counter + 1;
                        next_state =  D;
                        angle = 0;
                    end
                    else if(counter >= 30'd337_066_668 && counter < 30'd449_422_224)
                    begin
                        en_x = 1;
                        dir_x = 0;
                        en_y = 1;
                        dir_y = 0;     
                        next_count = counter + 1;
                        next_state =  D;
                        angle = 0;
                    end
                    else if(counter >= 30'd449_422_224 && counter < 30'd617_955_557)
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
                next_addr = addr;
                next_word_count = word_count;
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
                next_addr = addr;
                next_word_count = word_count;
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count;
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count; //505_600_000 ONE CIRCLE/90 DEGREE = 126_400_000/180 DEGREE = 252_800_000/60 DEGREE = 84_266_667/30 DEGREE = 42_133_333
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
                next_addr = addr;
                next_word_count = word_count;
                en_y = 1;
                dir_y = 1;
                en_x = 0;
                angle = 5;
                if(controll == up) next_state = up;
                else next_state = Wait;
            end
            down:begin
                next_addr = addr;
                next_word_count = word_count;
                en_y = 1;
                dir_y = 0;
                en_x = 0;
                angle = 5;
                if(controll == down) next_state = down;
                else next_state = Wait;
            end
            left:begin
                next_addr = addr;
                next_word_count = word_count;
                en_x = 1;
                dir_x = 0;
                en_y = 0;
                angle = 5; 
                if(controll == left) next_state = left;
                else next_state = Wait;
            end
            right:begin
                next_addr = addr;
                next_word_count = word_count;
                en_x = 1;
                dir_x = 1;
                en_y = 0;
                angle = 5; 
                if(controll == right) next_state = right;
                else next_state = Wait;
            end
            space:begin
                next_addr = addr;
                next_word_count = word_count;
                angle = 5;
                if(counter < 35'd112_355_556)begin
                    en_x = 1;
                    en_y = 0;
                    dir_x = 1;
                    next_count = counter + 1;
                    next_state = space;
                end
                else begin
                    next_state = Wait;
                    en_x = 0;
                    en_y = 0;
                end
            end
            under_line:begin
                next_addr = addr;
                next_word_count = word_count;
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
                    next_state = Wait;
                    en_x = 0;
                    en_y = 0;
                    angle = 5;
                end
            end
            Wait:begin
                next_addr = addr;
                next_word_count = word_count;
                next_count = 0;
                angle = 5;
                en_x = 0;
                en_y = 0;
                if(controll == A) next_state = A;
                else if (controll == B) next_state = B;
                else if (controll == C) next_state = C;
                else if (controll == D) next_state = D;
                else if (controll == E) next_state = E;
                else if (controll == F) next_state = F;
                else if (controll == G) next_state = G;
                else if (controll == H) next_state = H;
                else if (controll == I) next_state = I;
                else if (controll == J) next_state = J;
                else if (controll == K) next_state = K;
                else if (controll == L) next_state = L;
                else if (controll == M) next_state = M;
                else if (controll == N) next_state = N;
                else if (controll == O) next_state = O;
                else if (controll == P) next_state = P;
                else if (controll == Q) next_state = Q;
                else if (controll == R) next_state = R;
                else if (controll == S) next_state = S;
                else if (controll == T) next_state = T;
                else if (controll == U) next_state = U;
                else if (controll == V) next_state = V;
                else if (controll == W) next_state = W;
                else if (controll == X_) next_state = X_;
                else if (controll == Y) next_state = Y;
                else if (controll == Z_) next_state = Z_;
                else if (controll == up) next_state = up;
                else if (controll == down) next_state = down;
                else if (controll == left) next_state = left;
                else if (controll == right) next_state = right;
                else if (controll == space) next_state = space;
                else if (controll == under_line) next_state = under_line;
                else next_state = Wait;
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
    always@(posedge c)begin
        if(rst) begin
            counter <= 0;
            addr <= 0;
            word_count <= 0;
            state <= Get;
        end
        else  begin
            counter <= next_count;
            word_count <= next_word_count;
            addr <= next_addr;
            state <= next_state;
        end
    end
    always@(posedge c)begin
        if(rst) begin
            counter <= 0;
            addr <= 0;
            word_count <= 0;
            state <= Get;
        end
        else  begin
            counter <= next_count;
            word_count <= next_word_count;
            addr <= next_addr;
            state <= next_state;
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
