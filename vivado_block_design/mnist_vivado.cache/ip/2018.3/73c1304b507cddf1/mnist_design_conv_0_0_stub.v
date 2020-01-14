// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Tue Jan 14 13:58:28 2020
// Host        : LAPTOP-8LPHHTO8 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ mnist_design_conv_0_0_stub.v
// Design      : mnist_design_conv_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "conv,Vivado 2018.3" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(rst, clk, M0_R_req, M0_addr, M0_R_data, M0_W_req, 
  M0_W_data, M1_R_req, M1_addr, M1_R_data, M1_W_req, M1_W_data, M2_R_req, M2_addr, M2_R_data, 
  M2_W_req, M2_W_data, start, finish)
/* synthesis syn_black_box black_box_pad_pin="rst,clk,M0_R_req,M0_addr[31:0],M0_R_data[31:0],M0_W_req[3:0],M0_W_data[31:0],M1_R_req,M1_addr[31:0],M1_R_data[31:0],M1_W_req[3:0],M1_W_data[31:0],M2_R_req,M2_addr[31:0],M2_R_data[31:0],M2_W_req[3:0],M2_W_data[31:0],start,finish" */;
  input rst;
  input clk;
  output M0_R_req;
  output [31:0]M0_addr;
  input [31:0]M0_R_data;
  output [3:0]M0_W_req;
  output [31:0]M0_W_data;
  output M1_R_req;
  output [31:0]M1_addr;
  input [31:0]M1_R_data;
  output [3:0]M1_W_req;
  output [31:0]M1_W_data;
  output M2_R_req;
  output [31:0]M2_addr;
  input [31:0]M2_R_data;
  output [3:0]M2_W_req;
  output [31:0]M2_W_data;
  input start;
  output finish;
endmodule
