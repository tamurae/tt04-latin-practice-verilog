//****************************************************************************
//
//  tt_um_mult4x4.v -
//
//****************************************************************************

module mult4x4
(
  input         start,          // Declare control inputs: start
                reset_a,        //    asynchronous reset
                clk,            //    clock
  input [3:0]   dataa,          // Declare data inputs (factors)
                datab,
  output        done_flag,      // Declare done_flag output
  output [7:0]  product4x4_out  // Declare multiplier output "product4x4_out"
);

  // Declare internal wires to connect modules
  wire [1:0]  aout,       // u1 (mux2) output
              bout;       // u2 (mux2) output
  wire [3:0]  product;    // u3 (mult2x2) output
  wire [7:0]  shift_out,  // u4 (shifter) output
              sum;        // u5 (adder) output
  wire [1:0]  sel,        // u6 (mult_control) outputs
              shift;
  wire        clk_ena,
              sclr_n;
  wire [1:0]  count;      // u7 (counter) output

  // Connect modules as per schematic
  mux2 u1
  (
    .mux_in_a(dataa[1:0]),
    .mux_in_b(dataa[3:2]),
    .mux_sel(sel[1]),
    .mux_out(aout)
  );

  mux2 u2
  (
    .mux_in_a(datab[1:0]),
    .mux_in_b(datab[3:2]),
    .mux_sel(sel[0]),
    .mux_out(bout)
  );

  mult2x2 u3
  (
    .dataa(aout),
    .datab(bout),
    .product(product)
  );

  shifter u4
  (
    .inp(product),
    .shift_cntrl(shift),
    .shift_out(shift_out)
  );

  adder u5
  (
    .dataa(shift_out),
    .datab(product4x4_out),
    .sum(sum)
  );

  mult_control u6
  (
    .clk(clk),
    .reset_a(reset_a),
    .start(start),
    .count(count),
    .input_sel(sel),
    .shift_sel(shift),
    .done(done_flag),
    .clk_ena(clk_ena),
    .sclr_n(sclr_n)
  );

  counter u7
  (
    .clk(clk),
    .aclr_n(!start),
    .count_out(count)
  );

  reg8 u8
  (
    .clk(clk),
    .sclr_n(sclr_n),
    .clk_ena(clk_ena),
    .datain(sum),
    .reg_out(product4x4_out)
  );

endmodule
