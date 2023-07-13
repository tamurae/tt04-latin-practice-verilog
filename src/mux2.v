//****************************************************************************
//
//  mux2.v -
//
//****************************************************************************

module mux2
(
  input       [1:0] mux_in_a, // Declare mux data inputs
                    mux_in_b,
  input             mux_sel,  // Declare mux select input
  output reg  [1:0] mux_out   // Declare mux output
);

  always@(mux_in_a, mux_in_b, mux_sel)
  begin
    if ( mux_sel == 1'b0 )
      mux_out = mux_in_a;
    else
      mux_out = mux_in_b;
  end

endmodule
