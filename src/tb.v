//****************************************************************************
//
//  tb.v - Testbench file for mult4x4.v (TinyTapeout)
//
//****************************************************************************

`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

// testbench is controlled by test.py
module tb ();

  // this part dumps the trace to a vcd file that can be viewed with GTKWave
  initial begin
      $dumpfile ("tb.vcd");
      $dumpvars (0, tb);
      #1;
  end

  // TinyTapeout 4 pinout
  wire [7:0] ui_in;    // Dedicated inputs - connected to the input switches
  wire [7:0] uo_out;   // Dedicated outputs - connected to the 7 segment display
  wire [7:0] uio_in;   // IOs: Bidirectional Input path
  wire [7:0] uio_out;  // IOs: Bidirectional Output path
  wire [7:0] uio_oe;   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
  wire       ena;      // will go high when the design is enabled
  wire       clk;      // clock
  wire       rst_n;    // reset_n - low to reset

  // Wires to connect to DUT
  wire start = uio_in[0:0];
  wire reset_a = !rst_n;
  wire [3:0] dataa = ui_in[7:4];
  wire [3:0] datab = ui_in[3:0];
  wire done_flag = uio_out[7:7];
  wire [7:0] product4x4_out = uo_out[7:0];

  // bidirectionals: set bit 7 as output and the others as inputs
  assign uio_oe = 8'b1000000;

  // Instantiate DUT
  mult4x4 mult4x4_1
  (
    `ifdef GL_TEST
        .vccd1( 1'b1),
        .vssd1( 1'b0),
    `endif
    .start(start),
    .reset_a(reset_a),
    .clk(clk),
    .dataa(dataa),
    .datab(datab),
    .done_flag(done_flag),
    .product4x4_out(product4x4_out)
  );

endmodule
