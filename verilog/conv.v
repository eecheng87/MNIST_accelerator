module conv(
    input rst,
    input clk, 
    output reg M0_R_req, 
    output reg [31:0]M0_addr, 
    input [31:0]M0_R_data, 
    output reg [3:0]M0_W_req, 
    output reg [31:0]M0_W_data,

    output reg M1_R_req, 
    output reg [31:0]M1_addr, 
    input [31:0]M1_R_data, 
    output reg [3:0]M1_W_req, 
    output reg [31:0]M1_W_data,

    output reg M2_R_req, 
    output reg [31:0]M2_addr, 
    input [31:0]M2_R_data, 
    output reg [3:0]M2_W_req, 
    output reg [31:0]M2_W_data,
    
    input start,
    output reg finish
);