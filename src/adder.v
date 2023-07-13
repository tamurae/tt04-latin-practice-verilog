//***************************************************************************
//
//  adder.v -
//
//***************************************************************************

module adder
(
  input   [7:0]  dataa,  // Declare adder inputs
                 datab,
  output  [7:0]  sum     // Declare adder output
);

  assign
    sum = dataa + datab;

endmodule
