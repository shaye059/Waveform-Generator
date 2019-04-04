library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity counter is 
port(
	CC : in std_logic;
	clk : in std_logic;
	rst : in std_logic;
	P : in std_logic_vector(9 downto 0);
	addr : out std_logic_vector (9 downto 0);
	full : out std_logic
	);
end counter;

architecture arch of counter is
	signal temp : std_logic_vector(9 downto 0);	
begin		
	process (CC, clk, rst)
	begin
		if rst = '1' then	
			full <= '0';
			temp <= P;
		elsif (rising_edge(clk)) then
			if(cc = '1') then
				temp <= std_logic_vector(unsigned(temp) + "0000000001");
				if (temp(7 downto 0) = "11111111") then
					full <= '1';
						--delete this later
				end if;
			end if;
		end if;
		--addr <= P(9 downto 8) & temp;
	end process;
	addr <= temp;
end arch;