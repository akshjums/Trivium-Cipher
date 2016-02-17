--This software is provided 'as-is', without any express or implied warranty.
--In no event will the authors be held liable for any damages arising from the use of this software.

--Permission is granted to anyone to use this software for any purpose,
--excluding commercial applications, and to alter it and redistribute
--it freely except for commercial applications. 
--File:         trivium.vhd
--Author:       Richard Stern (rstern01@utopia.poly.edu)
--Organization: Polytechnic University
--------------------------------------------------------
--Description: Trivium encryption algorithm
--------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;   

entity nutrivium is
	port(	clk_25, rst	: in std_logic; 
		
                segment_a_i       : OUT STD_LOGIC;
                segment_b_i       : OUT STD_LOGIC;
                segment_c_i       : OUT STD_LOGIC;
                segment_d_i       : OUT STD_LOGIC;
                segment_e_i       : OUT STD_LOGIC;
                segment_f_i       : OUT STD_LOGIC;
                segment_g_i       : OUT STD_LOGIC;
                AN                : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		o_vld	 : out std_logic);
end nutrivium;


architecture do_it of nutrivium is

type state_type is (setup, run);
signal key	 : std_logic_vector(79 downto 0);
signal IV	    : std_logic_vector(79 downto 0);
signal keystream : std_logic_vector(7 downto 0);
signal state : state_type;
signal s_reg : std_logic_vector(288 downto 1);
signal s: std_logic_vector(288 downto 1);
signal count : integer;
signal stream   : std_logic_vector(7 downto 0);
signal j : integer :=0;
signal h : std_logic_vector(3 downto 0);
signal l : std_logic_vector(3 downto 0);
signal hex_digit_i   :STD_LOGIC_VECTOR(3 DOWNTO 0);
signal led_flash_cnt :STD_LOGIC_VECTOR(2 DOWNTO 0);


begin
key <= X"00000000000000000000" ;
IV <= X"00000000000000000000" ;
	

	s(93 downto 1) <= s_reg(92 downto 1) & (s_reg(243) xor s_reg(288) xor (s_reg(286) and s_reg(287)) xor s_reg(69));
	s(177 downto 94) <= s_reg(176 downto 94) & (s_reg(66) xor s_reg(93) xor (s_reg(91) and s_reg(92)) xor s_reg(171));
	s(288 downto 178) <= s_reg(287 downto 178) & (s_reg(162) xor s_reg(177) xor (s_reg(175) and s_reg(176)) xor s_reg(264));  

--s_reg
process(rst, clk_25)
begin
if(rst = '1') then
	s_reg(80 downto 1) <= key(79 downto 0);
	s_reg(93 downto 81) <= (others => '0');
	s_reg(173 downto 94) <= IV(79 downto 0);
	s_reg(285 downto 174) <= (others => '0');
	s_reg(288 downto 286) <= "111";
elsif(clk_25'event and clk_25='1') then
	s_reg <= s;
end if;

end process;
--state machine
process(rst, clk_25)
begin
if (rst = '1') then
	state <= setup;
	count <= 0;
	o_vld <= '0';
        
elsif(clk_25'event and clk_25='1') then
	case state is
		when setup =>
			if(count = 1151) then
				state <= run;
				o_vld <= '1';
			else
				count <= count + 1;
				state <= setup;
				o_vld <= '0';
			end if;
		when run =>
	end case;

end if;
end process;
process(rst, clk_25)
begin
if (rst ='1') then
stream <= "00000000";

elsif(clk_25'event and clk_25 ='1') then
case state is
when run =>
stream(j) <= s_reg(66) xor s_reg(93) xor s_reg(162) xor s_reg(177) xor s_reg(243) xor s_reg(288);
when setup =>
end case;
end if;
end process;
process(rst, clk_25)
begin
if (rst = '1') then
       j <= 0;
		
elsif(clk_25'event and clk_25 ='1') then
     	
	  case state is
             when run =>
             
               if(j = 0) then
                 keystream <= stream;
                  j <= 1;
              elsif(j < 7) then
               j <= j+1;
               elsif(j =7) then
              j <= 0;
               
					 
               
                end if;

             when setup =>
                j <= 0;
      end case;
end if;
end process;
h <= keystream(7 downto 4);
l <= keystream(3 downto 0);



hex2_7seg: entity work.hex_7seg
    port map (
       hex_digit => hex_digit_i,
       segment_a => segment_a_i,
       segment_b => segment_b_i,
       segment_c => segment_c_i,
       segment_d => segment_d_i,
       segment_e => segment_e_i,
       segment_f => segment_f_i,
       segment_g => segment_g_i) ;
		 
process (state , clk_25)
begin
   if(state = setup) then
     hex_digit_i   <= (others => '0');
     led_flash_cnt <= (OTHERS =>'0');
     AN            <= (others => '1');
   elsif (clk_25'event and clk_25 = '1') then
   led_flash_cnt <= led_flash_cnt + '1';
	case led_flash_cnt(2) is
	when '0' =>
      hex_digit_i <= h;
      AN          <= "0111";
    when '1' =>
      hex_digit_i <= l;
      AN          <= "1011";
    when others => null;
	 end case;

     
    end if;
   end process;



	
end do_it;
