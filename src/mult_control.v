//****************************************************************************
//
//  mult_control.v -
//
//****************************************************************************

module mult_control
(
  input             clk,        // Declare control inputs: clock
                    reset_a,    //    asynchronous reset
                    start,      //    start
  input [1:0]       count,      //    count
  output reg [1:0]  input_sel,  // Declare output control signals: input selection
                    shift_sel,  //    shift selection
  output reg        done,       //    done flag
                    clk_ena,    //    clock eable
                    sclr_n      //    synchronous clear (active low)
);

  // Declare parameters: six states:
  parameter idle = 0, lsb = 1, mid = 2, msb = 3, calc_done = 4, err = 5;

  // Declare two variables named "current_state" and "next_state" to be state variables
  reg [2:0] current_state,
            next_state;

  // Registered logic for current_state (rising edge transitions); asynchronous reset
  always @(posedge clk, posedge reset_a)
  begin
    if ( reset_a == 1'b1  )
      current_state <= idle;
    else
      current_state <= next_state;
  end

  // Logic for next_state based on current state and inputs
  always @(count, start)
    case ( current_state )
      idle :
        if ( start == 1'b1  )
          next_state = lsb;
        else
          next_state = idle;
      lsb :
        if ( count == 0 && start == 0 )
          next_state = mid;
        else
          next_state = err;
      mid :
        if ( count == 1 && start == 0  )
          next_state = mid;
        else if ( count == 2 && start == 0 )
          next_state = msb;
        else
          next_state = err;
      msb :
        if ( count == 3 && start == 0 )
          next_state = calc_done;
        else
          next_state = err;
      calc_done :
        if ( start == 1'b0  )
          next_state = idle;
        else
          next_state = err;
      err :
        if ( start == 1'b1  )
          next_state = lsb;
        else
          next_state = err;
    endcase

  // Mealy output logic  (outputs function of inputs and current_state)
  //  for input_sel, shift_sel, done, clk_ena and sclr_n
  always @(count, start)
  begin
    // Initialise outputs to default values so case only covers when they change
    input_sel = 2'bxx;
    shift_sel = 2'bxx;
    done      = 1'b0;
    clk_ena   = 1'b0;
    sclr_n    = 1'b1;
    case ( current_state )
      idle :
        if ( start == 1'b1  )
        begin
          clk_ena = 1'b1;
          sclr_n  = 1'b0;
        end
      lsb :
        if ( count == 0 && start == 0 )
        begin
          input_sel = 2'd0;
          shift_sel = 2'd0;
          clk_ena   = 1'b1;
        end
      mid :
        if ( count == 1 && start == 0 )
        begin
          input_sel = 2'd1;
          shift_sel = 2'd1;
          clk_ena   = 1'b1;
        end
        else if ( count == 2 && start == 0 )
        begin
          input_sel = 2'd2;
          shift_sel = 2'd1;
          clk_ena   = 1'b1;
        end
      msb :
        if ( count == 3 && start == 0 )
        begin
          input_sel = 2'd3;
          shift_sel = 2'd2;
          clk_ena   = 1'b1;
        end
      calc_done :
        if ( start == 1'b0  )
          done = 1'b1;
      err :
        if ( start == 1'b1  )
        begin
          clk_ena = 1'b1;
          sclr_n  = 1'b0;
        end
    endcase
  end

endmodule
