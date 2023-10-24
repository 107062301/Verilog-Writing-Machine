module step_controller (
  input clk,
  input rst,
  output reg orange,
  output reg yellow,
  output reg pink,
  output reg blue
  );

    reg [29:0]delay;
  
  always @(*) begin
        if(delay <= 30'd1000000) orange = 1;
        else orange = 0;
        if(delay > 30'd1000000)begin
            if(delay <= 30'd2000000)
                yellow = 1;
            else
                yellow = 0;
        end 
        else yellow = 0;
        if(delay > 30'd2000000)begin
            if(delay <= 30'd3000000)
                pink = 1;
            else
                pink = 0;
        end
        else pink = 0;
        if(delay > 30'd3000000)begin
            if(delay <= 30'd4000000)
                blue = 1;
            else
                blue = 0;
        end
        else blue = 0;
  end
	
  always @(posedge clk) begin
    if (rst) begin
        delay <= 1'b0;
    end
    else begin
        delay <= (delay == 30'd4000000) ? 0 : delay + 1;
    end
  end
endmodule