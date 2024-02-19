----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:10:55 10/24/2021 
-- Design Name: 
-- Module Name:    Demultiplexor - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
ENTITY Demultiplexor IS
PORT(
	w0 	:	in  	STD_LOGIC_VECTOR (7 downto 0); 
	s   	: 	in 	STD_LOGIC ;
	f1, f2: 	out	STD_LOGIC_VECTOR (7 downto 0) 
	);
END Demultiplexor;

ARCHITECTURE Behavior OF Demultiplexor IS
BEGIN
	Process (s,w0)
	BEGIN
		If (s ='0') then
			f1<= w0;
		else
			f2<= w0;
		end if;
	End Process;
END Behavior ;

