
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_textio.all;
    use ieee.std_logic_unsigned.all; 
    use work.user_types.all
    
library std;
    use std.textio.all;
    
    
entity tb_round is
end tb_round;
	
architecture tb of tb_round is

component round_fn
port (
    round_in     : in  k_state;
    signal_temp    : in std_logic_vector(63 downto 0);
    round_out    : out k_state);
end component;

component round_fn_constants_gen
port (
    round_number: in unsigned(4 downto 0);
    signal_out: out std_logic_vector(63 downto 0));
 end component;

    signal clk : std_logic;
    signal rst_n : std_logic;
    signal round_in,round_out,zero_state : k_state;
    signal counter : unsigned(4 downto 0);
    signal zero_lane: k_lane;
    signal zero_plane: k_plane;
    signal signal_temp: std_logic_vector(63 downto 0);
      
     
    type st_type is (st0,st1,STOP);
    signal st : st_type;
 
begin  

    round_map : round_fn port map(round_in,signal_temp,round_out);
    round_constants_gen: round_fn_constants_gen port map(counter,signal_temp);

    -- constants signals assingement
    zero_lane<= (others =>'0');

    i000: for x in 0 to 4 generate
        zero_plane(x)<= zero_lane;
    end generate;

    i001: for y in 0 to 4 generate
        zero_state(y)<= zero_plane;
    end generate;

    rst_n <= '0', '1' after 19 ns;

--main process
-- generate round number, read input value, write output value

tbgen : process(clk)
				
	variable line_in : line;
	variable line_out : line;
	
	variable datain0 : std_logic_vector(15 downto 0);
	variable temp: std_logic_vector(63 downto 0);			
	variable temp2: std_logic_vector(63 downto 0);			
	
	
	file filein : text open read_mode is "./round_fn_in.txt";
	file fileout : text open write_mode is "./round_fn_out.txt";
				
		begin
			if(rst_n='0') then
				st <= st0;
				--round_in <= (others=>'0');
				counter <= (others => '0');
					
			elsif(clk'event and clk='1') then
					
					----------------------
					case st is
						when st0 =>
						--continue to read up to the end of file marker.
							readline(filein,line_in);
							if(line_in(1)='.') then
								FILE_CLOSE(filein);
								FILE_CLOSE(fileout);
								assert false report "Simulation completed" severity failure;
								st <= STOP;
							else
								-- Write the header on output file if needed
								
								
								--read the input, 25 lines and apply to keccak
								--round_in<=zero_state;
								for row in 0 to 4 loop
								for col in 0 to 4 loop
									
									hread(line_in,temp);
										for i in 0 to 63 loop
											round_in(row)(col)(i)<= temp(i);
										end loop;
									readline(filein,line_in);
									end loop;	
								end loop;
								---...
								
								-- apply the round numbers
								counter <= (others => '0');
								st <= st1;
							end if;
						when st1 =>
							-- increment the counter in order of computing the rounds
							if (counter<23) then
								round_in<=round_out;
								counter<=counter+1;
								-- uncomment the following lines
								-- if you want to write
								-- round outputs


								-- for row in 0 to 4 loop
								--	for col in 0 to 4 loop
								--		for i IN 0 to 63 LOOP
								--			temp(i) := round_out(row)(col)(i);
								--		end loop;
								--		hwrite(line_out,temp);
								--		writeline(fileout,line_out);
								--	end loop;
								--end loop;
								--write(fileout,string'("-"));
								--writeline(fileout,line_out);


							else
								st<=st0;
								for row in 0 to 4 loop
									for col in 0 to 4 loop
										for i IN 0 to 63 LOOP
											temp(i) := round_out(row)(col)(i);
										end loop;
										hwrite(line_out,temp);
										writeline(fileout,line_out);
									end loop;
								end loop;
								write(fileout,string'("-"));
								writeline(fileout,line_out);

							end if;
							
							--if finished write output and go back to st0
							
						when STOP =>
							null;
					end case;
				end if;
			end process;


-- clock generation
clkgen : process
	begin
		clk <= '1';
		loop
				wait for 10 ns;
				clk<=not clk;
		end loop;
	end process;

end tb;    