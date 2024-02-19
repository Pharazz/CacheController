----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:49:02 10/24/2021 
-- Design Name: 
-- Module Name:    CacheController3 - Behavioral 
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

entity CacheController3 is
    Port ( clk : in  STD_LOGIC;
           Addr : in  STD_LOGIC_VECTOR (15 downto 0);
			  AddrDebug : out STD_LOGIC_VECTOR (15 downto 0);
           WR_RD : in  STD_LOGIC;
           CS : in  STD_LOGIC;
           RDY : out  STD_LOGIC := '0';
           AddSD : out  STD_LOGIC_VECTOR (15 downto 0);
           WR_RDSD : out  STD_LOGIC;
           MSTRB : out  STD_LOGIC := '0';
           SEL_OUT : out  STD_LOGIC;
           SEL_IN : out  STD_LOGIC;
           AddSR : out  STD_LOGIC_VECTOR (7 downto 0);
           WEN : out  STD_LOGIC;
			  yfsm : inout STD_LOGIC_VECTOR (1 downto 0) := "00";
			  Readcnt: inout STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
				FlagRd: inout STD_LOGIC := '0';--rdnum out
				Flag2 :inout STD_LOGIC := '0';
				Flag3 :inout STD_LOGIC := '0';
				Flag4 :inout STD_LOGIC := '0';
				Flag5 :inout STD_LOGIC := '0';
				Crdy: out STD_LOGIC := '0';
			  wrnum: out STD_LOGIC_VECTOR(4 downto 0) := (others => '0'));
			  
end CacheController3;

architecture Behavioral of CacheController3 is
type SRAMReg is array(7 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
type SRAMReg2 is array (7 downto 0) of STD_LOGIC;
signal TAG : SRAMReg := (others => (others => '0'));
signal Vbit : SRAMReg2 := (others => '0');
signal Dbit : SRAMReg2 := (others => '0');
signal Address : STD_LOGIC_VECTOR (15 downto 0);
signal BRepl: STD_LOGIC := '0';
signal init: STD_LOGIC := '0';
signal initflag: STD_LOGIC := '0';
signal Cacherdy: STD_LOGIC := '0';
--signal T : STD_LOGIC;
--signal yfsm : STD_LOGIC_VECTOR(1 downto 0);
--signal Readcnt : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
signal Writecnt: STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
signal count_reset : STD_LOGIC;
signal Rdystart: STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
 

--STATES---
--00 = WRITE
--01 = READ
--10 = Block Read
--11 = Block Write



begin
Process(clk, WR_RD, Addr, CS, BRepl)
begin
	if (clk'EVENT AND clk = '1') then
		if (Rdystart < "10") then
			RDY<= '1';
			Rdystart <= STD_LOGIC_VECTOR( unsigned(Rdystart) +1);
			initflag <= '0';
		elsif (Rdystart = "10") then
			initflag <= '1';
			Rdystart <= STD_LOGIC_VECTOR( unsigned(Rdystart) +1);
		end if;
		
--		if (initflag = '0') then
--			if (init = '1') then
--				initflag <= '1';
--				RDY <= '1';
--			end if;
--			init <= '1';
--		end if;
		--MSTRB <= '0';
		
	--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
		
		if (BRepl = '0' AND CS = '1') then --If CPU changes Address mid block replacement
			Address <= Addr;
			AddrDebug <= Addr;
			--Cacherdy <= '1';
			Crdy<= '1';
			if (Flag4 = '0')then
				Flag4 <= '1';
			else
				Flag4 <= '0';
			end if;
		elsif (BRepl = '0' AND CS = '0') then
			Rdy <= '1';
			Crdy <= '0';
			if (Flag5 = '0')then
					Flag5 <= '1';
				else
					Flag5 <= '0';
				end if;
		end if;
		
	--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
		
		if ((Address(15 downto 8) = TAG(to_integer(unsigned(Address(7 downto 5))))) AND ((CS ='1') OR (yfsm = "10"))) then
			if (Flag2 = '0')then
					Flag2 <= '1';
			else
					Flag2 <= '0';
			end if;
			--hit
			--RDY <= '0';
			if ((WR_RD = '1') AND (Vbit(to_integer(unsigned(Address (7 downto 5)))) = '1'))then-- AND (Cacherdy = '1'))then --AND CS = '1') then
				yfsm<= "00";
				--writehit
				--if (Vbit(to_integer(Address (7 downto 5))) = '1') then 
				AddSR <= STD_LOGIC_VECTOR(Address(7 downto 0)); 
				WEN <= '1';
				SEL_IN <= '0';
				Dbit(to_integer(unsigned(Address (7 downto 5)))) <= '1';
				RDY <= '0';
				Crdy <= '1';
				--T <= '1';
				--end if; 
			elsif ((WR_RD = '0') AND (Vbit(to_integer(unsigned(Address (7 downto 5)))) = '1')) then --CS = '1') then
				yfsm<= "01";
				AddSR <= STD_LOGIC_VECTOR(Address(7 downto 0)); 
				WEN <= '0';
				SEL_OUT <= '1';
				RDY <= '0';
				Crdy <= '1';
				--T <= '1';
				--readhit
			end if;
			
		elsif (Dbit(to_integer(unsigned(Address (7 downto 5)))) = '0') then
				--blockread and Write into cache
				yfsm<= "10";
				if (FlagRd = '0')then
					FlagRd <= '1';
				else
					FlagRd <= '0';
				end if;
				if ((BRepl = '0' AND CS ='1') OR (BRepl ='1')) then
					Crdy <= '1';
--					if (BRepl = '0') then
--						Address <= Addr;
--						--AddrDebug <= Addr;
--					end if;
					
					BRepl <= '1';
					MSTRB <= '1';
					RDY <= '0';
					
					WEN <= '1';
					WR_RDSD <= '0';
					--AddSD <= STD_LOGIC_VECTOR(Address(15 downto 5)) & Readcnt; --"00000";
					--AddSR<= STD_LOGIC_VECTOR(Address(7 downto 5)) & Readcnt;
					AddSD <= Address(15 downto 5) & Readcnt; --"00000";
					AddSR<= Address(7 downto 5) & Readcnt;
					--rdnum <= Readcnt;
					--add to_integer if broke
					SEL_IN <= '1';
					if (Readcnt = "11111") then
						Vbit(to_integer(unsigned(Address (7 downto 5)))) <= '1';
						TAG(to_integer(unsigned(Address(7 downto 5)))) <= Address(15 downto 8);
						Readcnt <= "00000"; 
						--RDY <= '0';
						MSTRB <= '0';
						BRepl <= '0';
						RDY <= '0';
						Crdy <= '1';
						--rdnum <= "00000";--Readcnt;
					else
						Readcnt <= STD_LOGIC_VECTOR( unsigned(Readcnt) +1);
					end if;
				end if;
				
		elsif	(Dbit(to_integer(unsigned(Address (7 downto 5)))) = '1') then
				yfsm<= "11";
				--flag 5
				if ((BRepl = '0' AND CS ='1') OR (BRepl ='1')) then
					Crdy <= '1';
					BRepl <= '1';
					MSTRB <= '1';
					RDY <= '0';
					WEN <= '0'; 
					WR_RDSD <= '1';
					AddSD <= TAG(to_integer(unsigned(Address(7 downto 5)))) & Address(7 downto 5) & Writecnt; --"00000";
					AddSR <= STD_LOGIC_VECTOR(Address(7 downto 5)) & Writecnt;
					--Writecnt <= STD_LOGIC_VECTOR( unsigned(Writecnt) +1);
					wrnum <= Writecnt;
					SEL_OUT <= '0';
					if (Writecnt = "11111") then
						Dbit(to_integer(unsigned(Address (7 downto 5)))) <= '0';
						Writecnt <= "00000"; 
						wrnum <= Writecnt;
						--RDY <= '0';
						--keep this one
						MSTRB <= '0';
					else
						Writecnt <= STD_LOGIC_VECTOR( unsigned(Writecnt) +1);
					end if;
				end if;
				--blockwrite
		else
				RDY<= '1';
				if (Flag3 = '0')then
					Flag3 <= '1';
				else
					Flag3 <= '0';
				end if;
		end if;
	
	end if;
	
end Process;

--Process(CS)
--Begin
--if (BRepl = '0' AND (CS = '1')) then --If CPU changes Address mid block replacement
--		if (clk = '1') then
--			Address <= Addr;
--			AddrDebug <= Addr;
--		end if;
--		if (Flag4 = '0')then
--			Flag4 <= '1';
--		else
--			Flag4 <= '0';
--		end if;
--elsif (BRepl = '0' AND CS = '0') then
--		if (Flag5 = '0')then
--			Flag5 <= '1';
--		else
--			Flag5 <= '0';
--		end if;
--end if;
--		
--end process;


end Behavioral;

