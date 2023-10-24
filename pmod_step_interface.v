`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Kaitlyn Franz
// 
// Create Date: 01/23/2016 03:44:35 PM
// Design Name: Claw
// Module Name: pmod_step_interface
// Project Name: Claw_game
// Target Devices: Basys3
// Tool Versions: 2015.4
// Description: This module is the top module for a stepper motor controller
// using the PmodSTEP. It operates in Full Step mode and encludes an enable signal
// as well as direction control. The Enable signal is connected to switch one and 
// the direction signal is connected to switch zero. 
// 
// Dependencies: 
// 
// Revision: 1
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pmod_step_interface(
    input clk,
    input rst,
    //input [5:0]controll,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    output reg get,
    output reg write,
    output [3:0] signal_out_x,
    output [3:0] signal_out_y,
    output [3:0] signal_out_y2,
    output PWM_z,
    output [5:0] led
    );
    
    localparam define_speed = 26'd125000;
    localparam define_speed_slow = 26'd250000;
    parameter A = 1;
    parameter B = 2;
    parameter D = 4;
    parameter V = 22;
    parameter X_ = 24;
    parameter S = 19;
    parameter N = 14;
    parameter Z_ = 26;
    parameter Write = 35;
    parameter Get = 34;

    
    
    reg [34:0] counter,next_count;
    reg [7:0] controll;
    wire [7:0] state;
    wire [19:0] A_net;
    wire [19:0] value_z_net;
    reg [25:0] speed_x,speed_y;
    wire [2:0] angle_z_net;
    wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
    // Wire to connect the clock signal 
    // that controls the speed that the motor
    // steps from the clock divider to the 
    // state machine.
    wire ade,bde,cde,dde,ede,fde,gde,hde,ide,jde,kde,lde,mde,nde,ode,pde,qde,rde,sde,tde,ude,vde,wde,xde,yde,zde,spade,unde,ende,ctde;
    wire [9:0] digit_de,digit_o;
    wire ao,bo,co,do,eo,fo,go,ho,io,jo,ko,lo,mo,no,oo,po,qo,ro,so,to,uo,vo,wo,xo,yo,zo,spao,uno,eno,cto; 
    wire new_clk_net_x,new_clk_net_y,clk_22;
    clock_divisor clk_wiz_0_inst(
      .clk(clk),
      .clk22(clk_22)
    );
    wire [8:0] KEY_CODES [0:43] = {
		key_down[9'h14],	// 0 => 45
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
        key_down[9'h5A], //enter
        key_down[9'h45],	// 0
		key_down[9'h16],	//1
		key_down[9'h1E],	// 2
		key_down[9'h26],	// 3
		key_down[9'h25],	// 4
		key_down[9'h2E],	// 5
		key_down[9'h36],	// 6
		key_down[9'h3D],	// 7
		key_down[9'h3E],	// 8
		key_down[9'h46] // 9
	};
    onepulse o1 (ade, clk_22, ao);
    debounce d1 (ade, KEY_CODES[01], clk);
    onepulse o2 (bde, clk_22, bo);
    debounce d2 (bde, KEY_CODES[02], clk);
    onepulse o3 (cde, clk_22, co);
    debounce d3 (cde, KEY_CODES[03], clk);
    onepulse o4 (dde, clk_22, do);
    debounce d4 (dde, KEY_CODES[04], clk);
    onepulse o5 (ede, clk_22, eo);
    debounce d5 (ede, KEY_CODES[05], clk);
    onepulse o6 (fde, clk_22, fo);
    debounce d6 (fde, KEY_CODES[06], clk);
    onepulse o7 (gde, clk_22, go);
    debounce d7 (gde, KEY_CODES[07], clk);
    onepulse o8 (hde, clk_22, ho);
    debounce d8 (hde, KEY_CODES[08], clk);
    onepulse o9 (ide, clk_22, io);
    debounce d9 (ide, KEY_CODES[09], clk);
    onepulse o10 (jde, clk_22, jo);
    debounce d10 (jde, KEY_CODES[10], clk);
    onepulse o11 (kde, clk_22, ko);
    debounce d11 (kde, KEY_CODES[11], clk);
    onepulse o12 (lde, clk_22, lo);
    debounce d12 (lde, KEY_CODES[12], clk);
    onepulse o13 (mde, clk_22, mo);
    debounce d13 (mde, KEY_CODES[13], clk);
    onepulse o14 (nde, clk_22, no);
    debounce d14 (nde, KEY_CODES[14], clk);
    onepulse o15 (ode, clk_22, oo);
    debounce d15 (ode, KEY_CODES[15], clk);
    onepulse o16 (pde, clk_22, po);
    debounce d16 (pde, KEY_CODES[16], clk);
    onepulse o17 (qde, clk_22, qo);
    debounce d17 (qde, KEY_CODES[17], clk);
    onepulse o18 (rde, clk_22, ro);
    debounce d18 (rde, KEY_CODES[18], clk);
    onepulse o19 (sde, clk_22, so);
    debounce d19 (sde, KEY_CODES[19], clk);
    onepulse o20 (tde, clk_22, to);
    debounce d20 (tde, KEY_CODES[20], clk);
    onepulse o21 (ude, clk_22, uo);
    debounce d21 (ude, KEY_CODES[21], clk);
    onepulse o22 (vde, clk_22, vo);
    debounce d22 (vde, KEY_CODES[22], clk);
    onepulse o23 (wde, clk_22, wo);
    debounce d23 (wde, KEY_CODES[23], clk);
    onepulse o24 (xde, clk_22, xo);
    debounce d24 (xde, KEY_CODES[24], clk);
    onepulse o25 (yde, clk_22, yo);
    debounce d25 (yde, KEY_CODES[25], clk);
    onepulse o26 (zde, clk_22, zo);
    debounce d26 (zde, KEY_CODES[26], clk);
    onepulse o27 (spade, clk_22, spao);
    debounce d27 (spade, KEY_CODES[31], clk);
    onepulse o28 (unde, clk_22, uno);
    debounce d28 (unde, KEY_CODES[32], clk);
    onepulse o29 (ende, clk_22, eno);
    debounce d29 (ende, KEY_CODES[33], clk);
    onepulse o30 (digit_de[0], clk_22, digit_o[0]);
    debounce d30 (digit_de[0], KEY_CODES[34], clk);
    onepulse o31 (digit_de[1], clk_22, digit_o[1]);
    debounce d31 (digit_de[1], KEY_CODES[35], clk);
    onepulse o32 (digit_de[2], clk_22, digit_o[2]);
    debounce d32 (digit_de[2], KEY_CODES[36], clk);
    onepulse o33 (digit_de[3], clk_22, digit_o[3]);
    debounce d33 (digit_de[3], KEY_CODES[37], clk);
    onepulse o53 (digit_de[4], clk_22, digit_o[4]);
    debounce d34 (digit_de[4], KEY_CODES[38], clk);
    onepulse o63 (digit_de[5], clk_22, digit_o[5]);
    debounce d35 (digit_de[5], KEY_CODES[39], clk);
    onepulse o73 (digit_de[6], clk_22, digit_o[6]);
    debounce d36 (digit_de[6], KEY_CODES[40], clk);
    onepulse o83 (digit_de[7], clk_22, digit_o[7]);
    debounce d37 (digit_de[7], KEY_CODES[41], clk);
    onepulse o93 (digit_de[8], clk_22, digit_o[8]);
    debounce d38 (digit_de[8], KEY_CODES[42], clk);
    onepulse o103 (digit_de[9], clk_22, digit_o[9]);
    debounce d39 (digit_de[9], KEY_CODES[43], clk);
    onepulse o104 (ctde, clk_22, cto);
    debounce d345 (ctde, KEY_CODES[00], clk);
   
     always @(*)begin
        case(state)
            A:begin
                get = 0;
                write = 0;
                if(counter < 30'd421_333_335 && counter >= 0) begin //// 224_711_111 = 2CM/112_355_556 = 1CM
                    speed_x = define_speed_slow;
                    speed_y = define_speed;
                end
                else begin
                    speed_x = define_speed;
                    speed_y = define_speed;
                end
                next_count = counter + 1;
            end
            B:begin
                get = 0;
                write = 0;
                if(counter >= 30'd168_533_334 && counter < 30'd505_600_002)
                    begin
                    speed_y = define_speed_slow;
                    speed_x = define_speed;
                end
                else begin
                    speed_x = define_speed;
                    speed_y = define_speed;
                end
                next_count = counter + 1; 
            end
            D:begin
                get = 0;
                write = 0;
                if((counter >= 30'd168_533_334 && counter < 30'd280_888_890) | (counter >= 30'd421_333_335 && counter < 30'd533_688_891))
                    begin
                    speed_y= define_speed_slow;
                    speed_x = define_speed;
                end
                else begin
                    speed_x = define_speed;
                    speed_y = define_speed;
                end
                next_count = counter + 1;   
            end
            N:begin
                get = 0;
                write = 0;
                if(counter >= 30'd168_533_334 && counter < 30'd337_066_668)
                    begin
                    speed_x = define_speed_slow;
                    speed_y = define_speed;
                end
                else begin
                    speed_x = define_speed;
                    speed_y = define_speed;
                end
                next_count = counter + 1;
            end
            V:begin
                get = 0;
                write = 0;
                    if(counter >= 30'd168_533_334 && counter < 30'd505_600_000)
                        begin
                        speed_x = define_speed_slow;
                        speed_y = define_speed;
                    end
                    else begin
                        speed_x = define_speed;
                        speed_y = define_speed;
                    end
                    next_count = counter + 1;
            end
            S:begin
                get = 0;
                write = 0;
                    if(counter >= 30'd168_533_334 && counter < 30'd280_888_890)
                        begin
                        speed_y = define_speed;
                        speed_x = define_speed;
                    end
                    else begin
                        speed_x = define_speed;
                        speed_y = define_speed;
                    end
                    next_count = counter + 1;
            end
            X_:begin
                get = 0;
                write = 0;
                    if((counter >= 30'd168_533_334 && counter < 30'd337_066_668) | (counter >= 30'd505_600_002 && counter < 30'd674_133_336))
                        begin
                        speed_x = define_speed_slow;
                        speed_y = define_speed;
                    end
                    else begin
                        speed_x = define_speed;
                        speed_y = define_speed;
                    end
                    next_count = counter + 1;
            end
            Z_:begin
                get = 0;
                write = 0;
                    if(counter >= 30'd252_800_001 && counter < 30'd421_333_335)
                        begin
                        speed_x = define_speed_slow;
                        speed_y = define_speed;
                    end
                    else begin
                        speed_x = define_speed;
                        speed_y = define_speed;
                    end
                    next_count = counter + 1;
            end
            Get:begin
                get = 1;
                write = 0;
                speed_x = define_speed;
                speed_y = define_speed;
                next_count = 0;
            end
            Write: begin
                get = 0;
                write = 1;
                speed_x = define_speed;
                speed_y = define_speed;
                next_count = 0;
            end
            default:begin
                get = 1;
                write = 1;
                speed_x = define_speed;
                speed_y = define_speed;
                next_count = 0;
            end
        endcase
    end

    always@(posedge clk)begin
        if(rst) begin
            counter <= 0;
        end
        else  begin
            counter <= next_count;
        end
    end

    angle_decoder decode(
        .angle_z(angle_z_net),
        .value_z(value_z_net)
        );

     comparator compare(
        .A(A_net),
        .B(value_z_net),
        .PWM_z(PWM_z)
        );

    counter count(
        .clr(rst),
        .clk(clk),
        .count(A_net)
        );
    // Clock Divider to take the on-board clock
    // to the desired frequency.
    clock_div clock_Div(
        .clk(clk),
        .rst(rst),
        .speed_x(speed_x),
        .speed_y(speed_y),
        .new_clk_x(new_clk_net_x),
        .new_clk_y(new_clk_net_y)
        );

    KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
    // The state machine that controls which 
    // signal on the stepper motor is high.      
    pmod_step_driver control(
        .rst(rst),
        .c(clk),
        .enter(eno),
        .controll(controll),
        .clk_x(new_clk_net_x),
        .clk_y(new_clk_net_y),
        .signal_x(signal_out_x),
        .signal_y(signal_out_y),
        .angle(angle_z_net),
        .state(state),
        .led(led)
        );
    
    always @ (*) begin
		
			if(cto == 1) controll = 6'd46;
			else if(ao == 1) controll = 4'b0001; //A
			else if(bo == 1) controll = 4'b0010; //B
			else if(co == 1) controll = 4'b0011; //C
			else if(do == 1) controll = 4'b0100; //D
			else if(eo == 1) controll = 4'b0101; //E
			else if(fo == 1) controll = 4'b0110; //F
			else if(go == 1) controll = 4'b0111; //G
			else if(ho == 1) controll = 4'b1000; //H
			else if(io == 1) controll = 4'b1001; //I
			else if(jo == 1) controll = 4'b1010; //J
			else if(ko == 1) controll = 4'b1011; //K
			else if(lo == 1) controll = 4'b1100; //L
			else if(mo == 1) controll = 4'b1101; //M
			else if(no == 1)  controll = 4'b1110; //N
			else if(oo == 1)  controll = 4'b1111; //O
			else if(po == 1)  controll = 5'b10000; //P
			else if(qo == 1)  controll = 5'b10001; //Q
			else if(ro == 1)  controll = 5'b10010; //R
			else if(so == 1)  controll = 5'b10011; //S
			else if(to == 1)  controll = 5'b10100; //T
            else if(uo == 1)  controll = 5'b10101; //U
			else if(vo == 1)  controll = 5'b10110; //V
			else if(wo == 1)  controll = 5'b10111; //W
			else if(xo == 1)  controll = 5'b11000; //X
            else if(yo == 1)  controll = 5'b11001; //Y
			else if(zo == 1)  controll = 5'b11010; //Z
            else if(KEY_CODES[27] == 1)  controll = 5'd29; //up
			else if(KEY_CODES[28] == 1)  controll = 5'd30; //down
			else if(KEY_CODES[29] == 1)  controll = 5'd31; //left
			else if(KEY_CODES[30] == 1)  controll = 6'd32; //right
            else if(spao == 1)  controll = 5'd27; //space
			else if(uno == 1)  controll = 5'd28; //underline
			else if(eno == 1)   controll = 6'd34;//enter
            else if(digit_o[0] == 1)   controll = 6'd36;//0
            else if(digit_o[1] == 1)   controll = 6'd37;//0
            else if(digit_o[2] == 1)   controll = 6'd38;//0
            else if(digit_o[3] == 1)   controll = 6'd39;//0
            else if(digit_o[4] == 1)   controll = 6'd40;//0
            else if(digit_o[5] == 1)   controll = 6'd41;//0
            else if(digit_o[6] == 1)   controll = 6'd42;//0
            else if(digit_o[7] == 1)   controll = 6'd43;//0
            else if(digit_o[8] == 1)   controll = 6'd44;//0
            else if(digit_o[9] == 1)   controll = 6'd45;//0
            else controll = 6'd34;
	end
    assign signal_out_y2 = signal_out_y;
    
endmodule
module angle_decoder(
    input [2:0] angle_z,
    output reg [19:0] value_z
    );
    
    // Run when angle changes
    always @ (*)
    begin
        // The angle gets converted to the 
        // constant value. This equation
        // depends on the servo motor you are 
        // using. To get this equation I used 
        // trial and error to get the 0
        // and 360 values and created an equation
        // based on those two points. 
        value_z = (10'd944)*(angle_z)+ 16'd60000;
    end
endmodule
module counter (
	input clr,
	input clk,
	output reg [19:0]count
);

    // Run on the positive edge of the clock
	always @ (posedge clk)
	begin
	    // If the clear button is being pressed or the count
	    // value has been reached, set count to 0.
	    // This constant depends on the refresh rate required by the
	    // servo motor you are using. This creates a refresh rate
	    // of 10ms. 100MHz/(1/10ms) or (system clock)/(1/(Refresh Rate)).
		if (clr == 1'b1 || count == 20'd1000000)
			begin
			count <= 20'b0;
			end
		// If clear is not being pressed and the 
		// count value is not reached, continue to increment
		// count. 
		else
			begin
			count <= count + 1'b1;
			end
	end
endmodule
module comparator (
	input [19:0] A,
	input [19:0] B,
	output reg PWM_z
);
    // Run when A or B change
	always @ (A,B)
	begin
	// If A is less than B
	// output is 1.
	if (A < B)
		begin
		PWM_z <= 1'b1;
		end
	// If A is greater than B
	// output is 0.
	else 
		begin
		PWM_z <= 1'b0;
		end
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
