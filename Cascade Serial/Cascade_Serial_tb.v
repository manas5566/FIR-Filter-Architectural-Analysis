`timescale 1 ns / 1 ns 

module Cascade_Serial_tb;

// Function definitions
   function signed [32:0] abs;
   input signed [32:0] arg;
   begin
     abs = arg > 0 ? arg : -arg;
   end
   endfunction // function abs

  task filter_in_data_log_task; 
    input         clk;
    input         reset;
    input         rdenb;
    inout  [3:0]  addr;
    output        done;
  begin

    // Counter to generate the address
    if (reset == 1) 
      addr = 0;
    else begin
      if (rdenb == 1) begin
        if (addr == 15)
          addr = addr; 
        else
          addr =  addr + 1; 
      end
    end

    // Done Signal generation.
    if (reset == 1)
      done = 0; 
    else if (addr == 15)
      done = 1; 
    else
      done = 0; 

  end
  endtask // filter_in_data_log_task

  task filter_out_task; 
    input         clk;
    input         reset;
    input         rdenb;
    inout  [3:0]  addr;
    output        done;
  begin

    // Counter to generate the address
    if (reset == 1) 
      addr = 0;
    else begin
      if (rdenb == 1) begin
        if (addr == 15)
          addr = addr; 
        else
          addr = #1  addr + 1; 
      end
    end

    // Done Signal generation.
    if (reset == 1)
      done = 0; 
    else if (addr == 15)
      done = 1; 
    else
      done = 0; 

  end
  endtask // filter_out_task

 // Constants
 parameter clk_high                         = 5;
 parameter clk_low                          = 5;
 parameter clk_period                       = 10;
 parameter clk_hold                         = 2;
// -------------------------------------------------------------
//
// Module: Cascade_Serial_tb_data
// Generated by MATLAB(R) 9.14 and Filter Design HDL Coder 3.1.13.
// Generated on: 2024-05-20 21:24:20
// -------------------------------------------------------------

 reg  signed [15:0] filter_in_data_log_force [0:15];
 reg  signed [32:0] filter_out_expected [0:15];


// **************************************
 initial //Input & Output data
 begin

 // Input data for filter_in_data_log
 filter_in_data_log_force[ 0] <= 16'h7fff;
 filter_in_data_log_force[ 1] <= 16'h0000;
 filter_in_data_log_force[ 2] <= 16'h0000;
 filter_in_data_log_force[ 3] <= 16'h0000;
 filter_in_data_log_force[ 4] <= 16'h0000;
 filter_in_data_log_force[ 5] <= 16'h0000;
 filter_in_data_log_force[ 6] <= 16'h0000;
 filter_in_data_log_force[ 7] <= 16'h0000;
 filter_in_data_log_force[ 8] <= 16'h0000;
 filter_in_data_log_force[ 9] <= 16'h0000;
 filter_in_data_log_force[10] <= 16'h0000;
 filter_in_data_log_force[11] <= 16'h0000;
 filter_in_data_log_force[12] <= 16'h0000;
 filter_in_data_log_force[13] <= 16'h0000;
 filter_in_data_log_force[14] <= 16'h0000;
 filter_in_data_log_force[15] <= 16'h0000;

 // Output data for filter_out
 filter_out_expected[ 0] <= 33'h1eedda245;
 filter_out_expected[ 1] <= 33'h1f5471572;
 filter_out_expected[ 2] <= 33'h019ed4c25;
 filter_out_expected[ 3] <= 33'h0340397f8;
 filter_out_expected[ 4] <= 33'h0340397f8;
 filter_out_expected[ 5] <= 33'h019ed4c25;
 filter_out_expected[ 6] <= 33'h1f5471572;
 filter_out_expected[ 7] <= 33'h1eedda245;
 filter_out_expected[ 8] <= 33'h000000000;
 filter_out_expected[ 9] <= 33'h000000000;
 filter_out_expected[10] <= 33'h000000000;
 filter_out_expected[11] <= 33'h000000000;
 filter_out_expected[12] <= 33'h000000000;
 filter_out_expected[13] <= 33'h000000000;
 filter_out_expected[14] <= 33'h000000000;
 filter_out_expected[15] <= 33'h000000000;

 end // Input & Output data
//************************************


  parameter MAX_ERROR_COUNT = 16; //uint32


 // Signals
  reg  clk; // boolean
  reg  clk_enable; // boolean
  reg  reset; // boolean
  reg  signed [15:0] filter_in; // sfix16_En15
  wire signed [32:0] filter_out; // sfix33_En31

  reg  tb_enb; // boolean
  wire srcDone; // boolean
  wire snkDone; // boolean
  wire testFailure; // boolean
  reg  tbenb_dly; // boolean
  reg  [2:0] counter; // ufix3
  wire phase_1; // boolean
  wire rdEnb_phase_1; // boolean
  wire filter_in_data_log_rdenb; // boolean
  reg  [3:0] filter_in_data_log_addr; // ufix4
  reg  filter_in_data_log_done; // boolean
  wire   signed [15:0] rawData_filter_in; // sfix16_En15
  reg  signed [15:0] holdData_filter_in; // sfix16_En15
  reg  filter_out_testFailure; // boolean
  integer filter_out_errCnt; // uint32
  wire delayLine_out; // boolean
  wire expected_ce_out; // boolean
  reg  int_delay_pipe [0:10] ; // boolean
  wire filter_out_rdenb; // boolean
  reg  [3:0] filter_out_addr; // ufix4
  reg  filter_out_done; // boolean
  wire signed [32:0] filter_out_ref; // sfix33_En31
  wire signed [32:0] filter_out_dataTable; // sfix33_En31
  wire signed [32:0] filter_out_refTmp; // sfix33_En31
  reg  signed [32:0] regout; // sfix33_En31
  reg  check1_Done; // boolean

 // Module Instances
  Cascade_Serial u_Cascade_Serial
    (
    .clk(clk),
    .clk_enable(clk_enable),
    .reset(reset),
    .filter_in(filter_in),
    .filter_out(filter_out)
    );


 // Block Statements
  // -------------------------------------------------------------
  // Driving the test bench enable
  // -------------------------------------------------------------

  always @(reset, snkDone)
  begin
    if (reset == 1'b1)
      tb_enb <= 1'b0;
    else if (snkDone == 1'b0 )
      tb_enb <= 1'b1;
    else begin
    # (clk_period * 2);
      tb_enb <= 1'b0;
    end
  end

  always @(posedge clk or posedge reset) // completed_msg
  begin
    if (reset) begin 
       // Nothing to reset.
    end 
    else begin 
      if (snkDone == 1) begin
        if (testFailure == 0)
              $display("**************TEST COMPLETED (PASSED)**************");
        else
              $display("**************TEST COMPLETED (FAILED)**************");
      end
    end
  end // completed_msg;

  // -------------------------------------------------------------
  // System Clock (fast clock) and reset
  // -------------------------------------------------------------

  always  // clock generation
  begin // clk_gen
    clk <= 1'b1;
    # clk_high;
    clk <= 1'b0;
    # clk_low;
    if (snkDone == 1) begin
      clk <= 1'b1;
      # clk_high;
      clk <= 1'b0;
      # clk_low;
      $stop;
    end
  end  // clk_gen

  initial  // reset block
  begin // reset_gen
    reset <= 1'b1;
    # (clk_period * 2);
    @ (posedge clk);
    # (clk_hold);
    reset <= 1'b0;
  end  // reset_gen

  // -------------------------------------------------------------
  // Testbench clock enable
  // -------------------------------------------------------------

  always @ (posedge clk or posedge reset)
    begin: tb_enb_delay
      if (reset == 1'b1) begin
        tbenb_dly <= 1'b0;
      end
      else begin
        if (tb_enb == 1'b1) begin
          tbenb_dly <= tb_enb;
        end
      end
    end // tb_enb_delay

  // -------------------------------------------------------------
  // Slow Clock (clkenb)
  // -------------------------------------------------------------

  always @ (posedge clk or posedge reset)
    begin: slow_clock_enable
      if (reset == 1'b1) begin
        counter <= 3'b001;
      end
      else begin
        if (tbenb_dly == 1'b1) begin
          if (counter >= 3'b100) begin
            counter <= 3'b000;
          end
          else begin
            counter <= counter + 3'b001;
          end
        end
      end
    end // slow_clock_enable

  assign  phase_1 = (counter == 3'b001 && tbenb_dly == 1'b1) ? 1'b1 : 1'b0;

      assign rdEnb_phase_1 = phase_1;

  // -------------------------------------------------------------
  // Read the data and transmit it to the DUT
  // -------------------------------------------------------------

  always @(posedge clk or posedge reset)
  begin
    filter_in_data_log_task(clk,reset,
                            filter_in_data_log_rdenb,filter_in_data_log_addr,
                            filter_in_data_log_done);
  end

  assign filter_in_data_log_rdenb = rdEnb_phase_1;

  assign rawData_filter_in = filter_in_data_log_force[filter_in_data_log_addr];

  always @ (posedge clk or posedge reset)
  begin // stimuli_filter_in_data_log_filter_in_reg
    if (reset) begin 
      holdData_filter_in <=  16'bx;
    end
    else begin
      holdData_filter_in <= rawData_filter_in;
    end
  end

  always @ (filter_in_data_log_rdenb, filter_in_data_log_addr)
  begin // stimuli_filter_in_data_log_filter_in
    if (filter_in_data_log_rdenb == 1) begin
      filter_in <= # clk_hold rawData_filter_in;
    end
    else begin 
      filter_in <= # clk_hold holdData_filter_in;
    end
  end // stimuli_filter_in_data_log_filter_in

  // -------------------------------------------------------------
  // Create done signal for Input data
  // -------------------------------------------------------------

  assign srcDone = filter_in_data_log_done;


  always @( posedge clk or posedge reset)
    begin: ceout_delayLine
      if (reset == 1'b1) begin
        int_delay_pipe[0] <= 1'b0;
        int_delay_pipe[1] <= 1'b0;
        int_delay_pipe[2] <= 1'b0;
        int_delay_pipe[3] <= 1'b0;
        int_delay_pipe[4] <= 1'b0;
        int_delay_pipe[5] <= 1'b0;
        int_delay_pipe[6] <= 1'b0;
        int_delay_pipe[7] <= 1'b0;
        int_delay_pipe[8] <= 1'b0;
        int_delay_pipe[9] <= 1'b0;
        int_delay_pipe[10] <= 1'b0;
      end
      else begin
        if (clk_enable == 1'b1) begin
        int_delay_pipe[0] <= rdEnb_phase_1;
        int_delay_pipe[1] <= int_delay_pipe[0];
        int_delay_pipe[2] <= int_delay_pipe[1];
        int_delay_pipe[3] <= int_delay_pipe[2];
        int_delay_pipe[4] <= int_delay_pipe[3];
        int_delay_pipe[5] <= int_delay_pipe[4];
        int_delay_pipe[6] <= int_delay_pipe[5];
        int_delay_pipe[7] <= int_delay_pipe[6];
        int_delay_pipe[8] <= int_delay_pipe[7];
        int_delay_pipe[9] <= int_delay_pipe[8];
        int_delay_pipe[10] <= int_delay_pipe[9];
        end
      end
    end // ceout_delayLine

  assign delayLine_out = int_delay_pipe[10];

  assign expected_ce_out =  delayLine_out & clk_enable;

  // -------------------------------------------------------------
  //  Checker: Checking the data received from the DUT.
  // -------------------------------------------------------------

  always @(posedge clk or posedge reset)
  begin
    filter_out_task(clk,reset,
                    filter_out_rdenb,filter_out_addr,
                    filter_out_done);
  end

  assign filter_out_rdenb = expected_ce_out;

  assign # clk_hold filter_out_dataTable = filter_out_expected[filter_out_addr];

// ---- Bypass Register ----
  always @ (posedge clk or posedge reset)
    begin: DataHoldRegister_temp_process2
      if (reset == 1'b1) begin
        regout <= 0;
      end
      else begin
        if (expected_ce_out == 1'b1) begin
          regout <= filter_out_dataTable;
        end
      end
    end // DataHoldRegister_temp_process2

  assign filter_out_refTmp = (expected_ce_out == 1'b1) ? filter_out_dataTable :
                       regout;


  assign filter_out_ref = filter_out_refTmp;



  always @ (posedge clk or posedge reset) // checker_filter_out
  begin
    if (reset == 1) begin
      filter_out_testFailure <= 0;
      filter_out_errCnt <= 0;
    end 
    else begin 
      if (filter_out_rdenb == 1 ) begin 
        if (((abs(filter_out - filter_out_expected[filter_out_addr]) > 15) !== 0 )) begin
           filter_out_errCnt <= filter_out_errCnt + 1;
           filter_out_testFailure <= 1;
                   $display("ERROR  in filter_out at time %t : Expected '%h' Actual '%h'", 
                        $time, filter_out_expected[filter_out_addr], filter_out);
           if (filter_out_errCnt >= MAX_ERROR_COUNT) 
             $display("Warning: Number of errors for filter_out have exceeded the maximum error limit");
        end

      end
    end
  end // checker_filter_out

  always @ (posedge clk or posedge reset) // checkDone_1
  begin
    if (reset == 1)
      check1_Done <= 0;
    else if ((check1_Done == 0) && (filter_out_done == 1) && (filter_out_rdenb == 1))
      check1_Done <= 1;
  end

  // -------------------------------------------------------------
  // Create done and test failure signal for output data
  // -------------------------------------------------------------

  assign snkDone = check1_Done;

  assign testFailure = filter_out_testFailure;

  // -------------------------------------------------------------
  // Global clock enable
  // -------------------------------------------------------------
  always @(snkDone, tbenb_dly)
  begin
    if (snkDone == 0)
      # clk_hold clk_enable <= tbenb_dly;
    else
      # clk_hold clk_enable <= 0;
  end

 // Assignment Statements



endmodule // Cascade_Serial_tb
