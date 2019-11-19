`timescale 1ns/10ps
`define CYCLE 10.0 // Cycle time
`define MAX 300000 // Max cycle number

`include "conv.v"
`include "bram_sim.v"
`define FSDB_ALL
module top_tb;

  reg clk;
  reg rst;
  wire fin;
  reg start;
  wire qst;
  reg [7:0] GOLDEN1[4096:0];
  reg [7:0] GOLDEN2[4096:0]; 
  reg  [31:0] in_data[4096:0];

  wire  M0_R_req;
  wire  [31:0]M0_addr;
  wire  [31:0]M0_R_data;
  wire  [3:0]M0_W_req;
  wire  [31:0]M0_W_data;
  
  wire  M1_R_req;
  wire  [31:0]M1_addr;
  wire  [31:0]M1_R_data;
  wire  [3:0]M1_W_req;
  wire  [31:0]M1_W_data;
  
  wire  M2_R_req;
  wire  [31:0]M2_addr;
  wire  [31:0]M2_R_data;
  wire  [3:0]M2_W_req;
  wire  [31:0]M2_W_data;

  integer gf1, gf2 , i, num1, num2;
  integer img;
  wire [31:0] temp;
  integer err;
  always #(`CYCLE/2) clk = ~clk;

  conv TOP(
    .rst(rst),
    .clk(clk),
    
    .M0_R_req(M0_R_req), 
    .M0_addr(M0_addr), 
    .M0_R_data(M0_R_data), 
    .M0_W_req(M0_W_req), 
    .M0_W_data(M0_W_data),
    
    .M1_R_req(M1_R_req), 
    .M1_addr(M1_addr), 
    .M1_R_data(M1_R_data), 
    .M1_W_req(M1_W_req), 
    .M1_W_data(M1_W_data),

    .M2_R_req(M2_R_req), 
    .M2_addr(M2_addr), 
    .M2_R_data(M2_R_data), 
    .M2_W_req(M2_W_req), 
    .M2_W_data(M2_W_data),
    
    .start(start),
    .finish(fin)
  );
  // bram for `fix_input_0.hex`
  bram_sim M0(
    .rst(rst),
    .clk(clk),
    
    .R_req(M0_R_req), 
    .addr(M0_addr), 
    .R_data(M0_R_data), 
    .W_req(M0_W_req), 
    .W_data(M0_W_data)

  );
  
  // bram for `frlu1_golden.hex`
  bram_sim M1(
    .rst(rst),
    .clk(clk),
    
    .R_req(M1_R_req), 
    .addr(M1_addr), 
    .R_data(M1_R_data), 
    .W_req(M1_W_req), 
    .W_data(M1_W_data)

  );
  // bram for `frlu2_golden.hex`
    bram_sim M2(
    .rst(rst),
    .clk(clk),
    
    .R_req(M2_R_req), 
    .addr(M2_addr), 
    .R_data(M2_R_data), 
    .W_req(M2_W_req), 
    .W_data(M2_W_data)

  );

  initial
  begin
    clk = 0; rst = 1;
    start =0;
    #1 rst = 0;
    #(`CYCLE) rst = 1;
    
    
    $readmemh("./fix_input_0.hex", in_data);
    for (i = 0; i < 784; i=i+4)
    begin
      M0.bram[i/4] = {in_data[i],in_data[i+1],in_data[i+2],in_data[i+3]};
    end
    num1 = 0;
    gf1 = $fopen( "./frlu1_golden.hex", "r");
    while (!$feof(gf1))
    begin
      $fscanf(gf1, "%h \n", GOLDEN1[num1]);
      num1 = num1 + 1;
    end
    $fclose(gf1);

    num2 = 0;
    gf2 = $fopen( "./frlu2_golden.hex", "r");
    while (!$feof(gf2))
    begin
      $fscanf(gf2, "%h \n", GOLDEN2[num2]);
      num2 = num2 + 1;
    end
    $fclose(gf1);

    #20
    start =1;
    #(`CYCLE)
    start =0;
    wait(fin);
    #(`CYCLE*2)
    #20 
    $display("\nDone\n");
    err = 0;

    for (i = 0; i < num1; i=i+4)
    begin
      if(M1.bram[i/4] !== {GOLDEN1[i],GOLDEN1[i+1],GOLDEN1[i+2],GOLDEN1[i+3]})begin
        $display("DM1[%4d] = %h, expect = %h", i/4, M1.bram[i/4], {GOLDEN1[i],GOLDEN1[i+1],GOLDEN1[i+2],GOLDEN1[i+3]});
        err = err + 1;
      end else begin
        $display("DM1[%4d] = %h, pass",  i/4, M1.bram[i/4]);
      end
      if(M2.bram[i/4] !== {GOLDEN2[i],GOLDEN2[i+1],GOLDEN2[i+2],GOLDEN2[i+3]})begin
        $display("DM2[%4d] = %h, expect = %h", i/4, M2.bram[i/4], {GOLDEN2[i],GOLDEN2[i+1],GOLDEN2[i+2],GOLDEN2[i+3]});
        err = err + 1;
      end else begin
        $display("DM2[%4d] = %h, pass",  i/4, M2.bram[i/4]);
      end      
    end
    result(err, num1+num2);
    $finish;
  end
 
  
  task result;
    input integer err;
    input integer num;
    integer rf;
    begin     
      if (err === 0)
      begin
        $display("\n");
        $display("\n");
        $display("        ****************************               ");
        $display("        **                        **       |\__||  ");
        $display("        **  Congratulations !!    **      / ^.^  | ");
        $display("        **                        **    /_____   | ");
        $display("        **  Simulation PASS!!     **   /^ ^ ^ \\  |");
        $display("        **                        **  |^ ^ ^ ^ |w| ");
        $display("        ****************************   \\m___m__|_|");
        $display("\n");
      end
      else
      begin
        $display("\n");
        $display("\n");
        $display("        ****************************               ");
        $display("        **                        **       |\__||  ");
        $display("        **  OOPS!!                **      / X,X  | ");
        $display("        **                        **    /_____   | ");
        $display("        **  Simulation Failed!!   **   /^ ^ ^ \\  |");
        $display("        **                        **  |^ ^ ^ ^ |w| ");
        $display("        ****************************   \\m___m__|_|");
        $display("         Totally has %d errors                     ", err); 
        $display("\n");
      end
    end
  endtask

endmodule