----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:58:08 10/28/2021 
-- Design Name: 
-- Module Name:    SRAM - Behavioral 
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

entity SRAM is
Port (     Addr : in  STD_LOGIC_VECTOR (7 downto 0);
           WR_RD : in  STD_LOGIC;
           Crdy : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk : in STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (7 downto 0));
end SRAM;

architecture Behavioral of SRAM is
type SRAMData is array (255 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
signal SRAM : SRAMData;

begin
process(clk,Crdy)
begin
if (Crdy = '1' AND rising_edge(clk)) then
		if (WR_RD = '0') then
				--Dout <= SDRAM((to_integer(unsigned(Addr(15 downto 8)))), (to_integer(unsigned(Addr(7 downto 0)))));
			Dout <= SRAM(to_integer(unsigned(Addr)));
			--Read whole block
		else
			--write whole block
				--SDRAM((to_integer(unsigned(Addr(15 downto 8)))), (to_integer(unsigned(Addr(7 downto 0))))) <= Din;
			SRAM(to_integer(unsigned(Addr))) <=Din;
		end if;
end if;
end process;

end Behavioral;

