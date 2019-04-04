library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM_ctrl is
port(
		clk	:	in std_logic;
		rst	:	in std_logic;
		st	:	in std_logic;
		ch_WF	:	in std_logic_vector(1 downto 0);
		ch_P	:	in std_logic_vector(9 downto 0);
		ch_SR	:	in std_logic_vector(7 downto 0);
		full	:	in std_logic;
		
		p		:	out std_logic_vector(9 downto 0);	--starting WF address for counter
		cc		:	out std_logic;				--counter enable, tells counter which clock cycles to increment on
		cs		:	out std_logic;
		en		:	out std_logic;
		lp		:	out std_logic;	--chosen SR for D-Latch controller
		r		:	out std_logic				--resets counter
	);	
end FSM_ctrl;



architecture fsm_ctrl_top of FSM_ctrl is
type state is (IDLE, SINE, SQUARE, TRIANGLE, SAW, COUNT);
	signal curr_state, next_state	:	state;
	signal counter	:	std_logic_vector(19 downto 0);
	signal counter_max	: std_logic_vector(19 downto 0);
	signal n_skip, sample_num : std_logic_vector(7 downto 0);
	alias c_max is counter_max(7 downto 0);
	
begin
	process(clk, rst)
	begin
		
		if(rst = '1') then
			next_state <= IDLE;
		
		elsif(rising_edge(clk)) then
		
			case curr_state is
			
				when IDLE =>
					lp <= '0';
					en <= '0';
					cs <= '0';
					r <= '1';
					
					if(st = '1') then
						if(ch_WF = "00") then
							next_state <= SINE;
						elsif(ch_WF = "01") then
							next_state <= SQUARE;
						elsif(ch_WF = "10") then
							next_state <= TRIANGLE;
						elsif(ch_WF = "11") then
							next_state <= SAW;
						end if;
					elsif(st = '0') then
						next_state <= IDLE;
					end if;
					
				when SINE =>
					r <= '1';
					counter <= "00000000000000000000";
					en <= '1';
					p <= "0000000000";			--ENTER VALUE FOR 1st LOCATION OF SINE WAVE MEM ADDRESS
					counter_max <= std_logic_vector(("1111101000" * unsigned(ch_P)) / "10000000"); --count to N value and output to match the chosen period
					n_skip <= std_logic_vector("11111111" / unsigned(ch_sr));
					sample_num <= "00000000";
										
					if(st = '1') then
						if(ch_WF = "00") then
							next_state <= COUNT;
						elsif(ch_WF = "01") then
							next_state <= SQUARE;
						elsif(ch_WF = "10") then
							next_state <= TRIANGLE;
						elsif(ch_WF = "11") then
							next_state <= SAW;
						end if;
					elsif(st = '0') then
						next_state <= IDLE;
					end if;
				
				when SQUARE =>
					r <= '1';
					counter <= "00000000000000000000";
					en <= '1';
					p <= "0100000000";			--ENTER VALUE FOR 1st LOCATION OF SQUARE WAVE MEM ADDRESS
					counter_max <= std_logic_vector(("1111101000" * unsigned(ch_P)) / "10000000");
					n_skip <= std_logic_vector("11111111" / unsigned(ch_sr));
					sample_num <= "00000000";
					
					if(st = '1') then
						if(ch_WF = "00") then
							next_state <= SINE;
						elsif(ch_WF = "01") then
							next_state <= COUNT;
						elsif(ch_WF = "10") then
							next_state <= TRIANGLE;
						elsif(ch_WF = "11") then
							next_state <= SAW;
						end if;
					elsif(st = '0') then
						next_state <= IDLE;
					end if;
				
				when TRIANGLE =>
					r <= '1';
					counter <= "00000000000000000000";
					en <= '1';
					p <= "1000000000";			--ENTER VALUE FOR 1st LOCATION OF TRIANGLE WAVE MEM ADDRESS
					counter_max <= std_logic_vector(("1111101000" * unsigned(ch_P)) / "10000000");
					n_skip <= std_logic_vector("11111111" / unsigned(ch_sr));
					sample_num <= "00000000";
					
					if(st = '1') then
						if(ch_WF = "00") then
							next_state <= SINE;
						elsif(ch_WF = "01") then
							next_state <= SQUARE;
						elsif(ch_WF = "10") then
							next_state <= COUNT;
						elsif(ch_WF = "11") then
							next_state <= SAW;
						end if;
					elsif(st = '0') then
						next_state <= IDLE;
					end if;
					
				when SAW =>
					r <= '1';
					counter <= "00000000000000000000";
					en <= '1';
					p <= "1100000000";			--ENTER VALUE FOR 1st LOCATION OF SAW WAVE MEM ADDRESS
					counter_max <= std_logic_vector(("1111101000" * unsigned(ch_P)) / "10000000");
					n_skip <= std_logic_vector("11111111" / unsigned(ch_sr));
					sample_num <= "00000000";
					
					if(st = '1') then
						if(ch_WF = "00") then
							next_state <= SINE;
						elsif(ch_WF = "01") then
							next_state <= SQUARE;
						elsif(ch_WF = "10") then
							next_state <= TRIANGLE;
						elsif(ch_WF = "11") then
							next_state <= COUNT;
						end if;
					elsif(st = '0') then
						next_state <= IDLE;
					end if;
				
				when COUNT =>
					cs <= '0';
					cc <= '0';
					lp <= '0';
					r <= '0';
					
					counter <= std_logic_vector(unsigned(counter) + "00000000000000000001");
					if(counter = counter_max) then
						cs <= '1';
						cc <= '1';
						sample_num <= std_logic_vector(unsigned(sample_num) + "00000001");
						if (sample_num = n_skip) then
							lp <= '1';
							sample_num <= "00000000";
						end if;
						if(full = '1') then
							r <= '1';
							if(ch_WF = "00") then
								next_state <= SINE;
							elsif(ch_WF = "01") then
								next_state <= SQUARE;
							elsif(ch_WF = "10") then
								next_state <= TRIANGLE;
							elsif(ch_WF = "11") then
								next_state <= SAW;
							end if;
						elsif(full = '0') then
							next_state <= COUNT;
							counter <= "00000000000000000000";
						end if;
					else 
						next_state <= COUNT;
					end if;
					
				when others =>
					next_state <= IDLE;
				
				end case;
				
		end if;
		
	end process;
	
	curr_state <= next_state;
	
end fsm_ctrl_top;
	