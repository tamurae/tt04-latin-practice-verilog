//****************************************************************************
//
//  mult2x2.v -
//
//****************************************************************************

module mult2x2
(
  input   [1:0] dataa,    // Declare multiplier inputs
                datab,
  output  [3:0] product   // Declare multiplier output
);

  assign
    product = dataa * datab;

endmodule
