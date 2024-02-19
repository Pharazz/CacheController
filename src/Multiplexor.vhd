----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:08:39 10/24/2021 
-- Design Name: 
-- Module Name:    Multiplexor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
ENTITY Multiplexor IS
PORT ( 
	w0, w1   : in  STD_LOGIC_VECTOR (7 downto 0) ;
	s			: in	STD_LOGIC;
	f			: out  STD_LOGIC_VECTOR (7 downto 0)
	);
END Multiplexor;

ARCHITECTURE Behavior OF Multiplexor IS
BEGIN
	WITH s SELECT
		f<=w0 WHEN '0',
		w1 WHEN OTHERS ;
END Behavior ;