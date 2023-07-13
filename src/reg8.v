//****************************************************************************
//
//  reg8.v -
//
//****************************************************************************

module reg8
(
  input [7:0]       datain,   // Declare data input
  input             clk,      // Declare control inputs: clock
                    clk_ena,  //    clock enable
                    sclr_n,   //    synchronous clear (active low)
  output reg [7:0]  reg_out   // Declare data output
);

  always@(posedge clk)
  begin
    if ( clk_ena )
    begin
      if ( sclr_n == 1'b0 )
        reg_out <= 8'B0;
      else
        reg_out <= datain;
    end
  end

endmodule
