library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_latch_logic is
port(
		d_in		: in std_logic_vector(7 downto 0);
		lp		: in std_logic;
		d_out		: out std_logic_vector(7 downto 0)
);
end data_latch_logic;

architecture data_latch_logic_top of data_latch_logic is
	
begin
	
	process(lp, d_in)
	begin
	
		if(lp = '1') then
			d_out <= d_in;
		end if;
		
	end process;

end data_latch_logic_top;

