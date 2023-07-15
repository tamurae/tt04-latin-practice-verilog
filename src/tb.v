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
  wire start;
  assign uio_in[0:0] = start;
  wire [3:0] dataa;
  assign ui_in[7:4] = dataa;
  wire [3:0] datab;
  assign ui_in[3:0] = datab;
  wire done_flag;
  assign done_flag= uio_out[7:7];
  wire [7:0] product4x4_out;
  assign product4x4_out = uo_out[7:0];

  // Instantiate DUT
  tt_um_mult4x4 mult4x4
  (
    `ifdef GL_TEST
        .vccd1( 1'b1),
        .vssd1( 1'b0),
    `endif
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_in(uio_in),
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .ena(ena),
    .clk(clk),
    .rst_n(rst_n)
  );

endmodule
