-- Copyright (C) 2016  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions
-- and other software and tools, and its AMPP partner logic
-- functions, and any output files from any of the foregoing
-- (including device programming or simulation files), and any
-- associated documentation or information are expressly subject
-- to the terms and conditions of the Intel Program License
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other
-- applicable license agreement, including, without limitation,
-- that your use is for the sole purpose of programming logic
-- devices manufactured by Intel and sold by Intel or its
-- authorized distributors.  Please refer to the applicable
-- agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to
-- suit user's needs .Comments are provided in each section to help the user
-- fill out necessary details.
-- ***************************************************************************
-- Generated on "03/26/2021 22:23:04"

-- Vhdl Test Bench template for design  :  g06_Sine
--
-- Simulation tool : ModelSim-Altera (VHDL)
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY g06_Sine_vhd_tst IS
END g06_Sine_vhd_tst;
ARCHITECTURE g06_Sine_arch OF g06_Sine_vhd_tst IS
-- constants
-- signals
SIGNAL clock : STD_LOGIC := '0';
constant clk_period : time := 1 ns;
SIGNAL i : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL result : STD_LOGIC_VECTOR(15 DOWNTO 0);
--signal recursion: std_logic_vector(31 downto 0);
COMPONENT g06_Sine
	PORT (
	clock : IN STD_LOGIC;
	i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  --recursion: OUT std_logic_vector(31 downto 0)
	);
END COMPONENT;
BEGIN
	i1 : g06_Sine
	PORT MAP (
-- list connections between master ports and signals
	clock => clock,
	i => i,
	result => result
  --recursion => recursion
	);
--init : PROCESS
-- variable declarations
--BEGIN
        -- code that executes only once
--WAIT;
--END PROCESS init;
clk_process : process
begin
  clock <= '0';
  wait for clk_period/2;
  clock <= '1';
  wait for clk_period/2;
end process;
always : PROCESS
-- optional sensitivity list
-- (        )
-- variable declarations
BEGIN
-- input Full Scale (FS): 8192
-- pi/4 => 4096
i<="0001000000000000";
wait for 5 * clk_period;
-- pi/3 => 5461.3333
i<="0000010101010101";
wait for 5 * clk_period;
-- pi/2 => 8192
i<="0010000000000000";
wait for 5 * clk_period;
-- pi/6 => 2730.6667
i<="0000101010101011";
wait;


        -- code executes for every event on sensitivity list
END PROCESS always;
END g06_Sine_arch;
