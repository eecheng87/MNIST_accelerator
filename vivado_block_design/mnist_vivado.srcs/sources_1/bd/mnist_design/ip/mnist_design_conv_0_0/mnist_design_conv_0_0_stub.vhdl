-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Tue Jan 14 13:58:30 2020
-- Host        : LAPTOP-8LPHHTO8 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               D:/mnist_vivado/mnist_vivado.srcs/sources_1/bd/mnist_design/ip/mnist_design_conv_0_0/mnist_design_conv_0_0_stub.vhdl
-- Design      : mnist_design_conv_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mnist_design_conv_0_0 is
  Port ( 
    rst : in STD_LOGIC;
    clk : in STD_LOGIC;
    M0_R_req : out STD_LOGIC;
    M0_addr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M0_R_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M0_W_req : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M0_W_data : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M1_R_req : out STD_LOGIC;
    M1_addr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M1_R_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M1_W_req : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M1_W_data : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M2_R_req : out STD_LOGIC;
    M2_addr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M2_R_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M2_W_req : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M2_W_data : out STD_LOGIC_VECTOR ( 31 downto 0 );
    start : in STD_LOGIC;
    finish : out STD_LOGIC
  );

end mnist_design_conv_0_0;

architecture stub of mnist_design_conv_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "rst,clk,M0_R_req,M0_addr[31:0],M0_R_data[31:0],M0_W_req[3:0],M0_W_data[31:0],M1_R_req,M1_addr[31:0],M1_R_data[31:0],M1_W_req[3:0],M1_W_data[31:0],M2_R_req,M2_addr[31:0],M2_R_data[31:0],M2_W_req[3:0],M2_W_data[31:0],start,finish";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "conv,Vivado 2018.3";
begin
end;
