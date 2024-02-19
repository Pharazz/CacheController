----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:19:19 10/24/2021 
-- Design Name: 
-- Module Name:    SDRAMController2 - Behavioral 
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
use ieee.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SDRAMController2 is
    Port ( clk : in  STD_LOGIC;
           Addr : in  STD_LOGIC_VECTOR (15 downto 0);
           WR_RD : in  STD_LOGIC;
           MEMSTRB : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (7 downto 0);
           Dout : out  STD_LOGIC_VECTOR (7 downto 0));
end SDRAMController2;

architecture Behavioral of SDRAMController2 is
--type SDRAMData is array (1023 downto 0, 31 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
type SDRAMData is array (65535 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
--type SDRAMMem is array (15 downto 0) of SDRAMData;
signal SDRAM : SDRAMData; 
--signal Readcnt : STD_LOGIC_VECTOR(4 downto 0);
--signal Writecnt: STD_LOGIC_VECTOR(4 downto 0);

begin
Process(clk, WR_RD, Addr)
begin
	if (clk'EVENT AND clk = '1' AND MEMSTRB ='1') then
		if (WR_RD = '0') then
				--Dout <= SDRAM((to_integer(unsigned(Addr(15 downto 8)))), (to_integer(unsigned(Addr(7 downto 0)))));
				Dout <= SDRAM(to_integer(unsigned(Addr)));
			--Read whole block
		else
			--write whole block
				--SDRAM((to_integer(unsigned(Addr(15 downto 8)))), (to_integer(unsigned(Addr(7 downto 0))))) <= Din;
				SDRAM(to_integer(unsigned(Addr))) <=Din;
		end if;
	end if;
	
end Process;

end Behavioral;

