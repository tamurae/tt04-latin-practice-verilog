//****************************************************************************
//
//  counter.v -
//
//****************************************************************************

module counter
(
  input             clk,        // Declare control inputs: clock
                    aclr_n,     //    asynchronous clear (active low)
  output reg [1:0]  count_out   // Declare counter output
);

  always@(posedge clk, negedge aclr_n)
  begin
    if ( aclr_n == 1'b0 )
      count_out <= 2'b0;
    else
      count_out <= count_out + 1'b1;
  end

endmodule
