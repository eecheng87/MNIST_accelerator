// (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:user:conv:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module mnist_design_conv_0_0 (
  rst,
  clk,
  M0_R_req,
  M0_addr,
  M0_R_data,
  M0_W_req,
  M0_W_data,
  M1_R_req,
  M1_addr,
  M1_R_data,
  M1_W_req,
  M1_W_data,
  M2_R_req,
  M2_addr,
  M2_R_data,
  M2_W_req,
  M2_W_data,
  start,
  finish
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst RST" *)
input wire rst;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_RESET rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN mnist_design_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
output wire M0_R_req;
output wire [31 : 0] M0_addr;
input wire [31 : 0] M0_R_data;
output wire [3 : 0] M0_W_req;
output wire [31 : 0] M0_W_data;
output wire M1_R_req;
output wire [31 : 0] M1_addr;
input wire [31 : 0] M1_R_data;
output wire [3 : 0] M1_W_req;
output wire [31 : 0] M1_W_data;
output wire M2_R_req;
output wire [31 : 0] M2_addr;
input wire [31 : 0] M2_R_data;
output wire [3 : 0] M2_W_req;
output wire [31 : 0] M2_W_data;
input wire start;
output wire finish;

  conv #(
    .k1_1('B00000111),
    .k1_2('B00000011),
    .k1_3('B00000101),
    .k1_4('B00000001),
    .k1_5('B00001010),
    .k1_6('B00000101),
    .k1_7('B00001000),
    .k1_8('B00001000),
    .k1_9('B11111101),
    .k2_1('B00000011),
    .k2_2('B00001101),
    .k2_3('B00001111),
    .k2_4('B11111110),
    .k2_5('B00000101),
    .k2_6('B00001000),
    .k2_7('B11101010),
    .k2_8('B11101001),
    .k2_9('B11100111),
    .bias('B11111111)
  ) inst (
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
    .finish(finish)
  );
endmodule
