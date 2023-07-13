//****************************************************************************
//
//  shifter.v -
//
//****************************************************************************

module shifter
(
  input [3:0]       inp,          // Declare data input
  input [1:0]       shift_cntrl,  // Declare control input
  output reg [7:0]  shift_out     // Declare data output
);

  always@(inp, shift_cntrl)
  begin
    if ( shift_cntrl == 2'b01 )
      shift_out = ( inp << 2 );
    else if ( shift_cntrl == 2'b10 )
      shift_out = ( inp << 4 );
    else
    shift_out = inp;
  end

endmodule
