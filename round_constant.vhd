	
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;	


entity round_constant is
port(

    round_number : in unsigned(4 downto 0);
    signal_out   : out std_logic_vector(63 downto 0));

end round_constant;

architecture rtl of round_constant is
 
  signal signal_temp: std_logic_vector(63 downto 0);
 
  
begin 

round_constants : process (round_number)

begin
	case round_number is
        when "00000" => signal_temp <= X"0000000000000001" ;
	    when "00001" => signal_temp <= X"0000000000008082" ;
	    when "00010" => signal_temp <= X"800000000000808A" ;
	    when "00011" => signal_temp <= X"8000000080008000" ;
	    when "00100" => signal_temp <= X"000000000000808B" ;
	    when "00101" => signal_temp <= X"0000000080000001" ;
	    when "00110" => signal_temp <= X"8000000080008081" ;
	    when "00111" => signal_temp <= X"8000000000008009" ;
	    when "01000" => signal_temp <= X"000000000000008A" ;
	    when "01001" => signal_temp <= X"0000000000000088" ;
	    when "01010" => signal_temp <= X"0000000080008009" ;
	    when "01011" => signal_temp <= X"000000008000000A" ;
	    when "01100" => signal_temp <= X"000000008000808B" ;
	    when "01101" => signal_temp <= X"800000000000008B" ;
	    when "01110" => signal_temp <= X"8000000000008089" ;
	    when "01111" => signal_temp <= X"8000000000008003" ;
	    when "10000" => signal_temp <= X"8000000000008002" ;
	    when "10001" => signal_temp <= X"8000000000000080" ;
	    when "10010" => signal_temp <= X"000000000000800A" ;
	    when "10011" => signal_temp <= X"800000008000000A" ;
	    when "10100" => signal_temp <= X"8000000080008081" ;
	    when "10101" => signal_temp <= X"8000000000008080" ;
	    when "10110" => signal_temp <= X"0000000080000001" ;
	    when "10111" => signal_temp <= X"8000000080008008" ;	    	    
	    when others => signal_temp <=(others => '0');
        end case;
end process round_constants;

signal_out <= signal_temp;
end rtl;
