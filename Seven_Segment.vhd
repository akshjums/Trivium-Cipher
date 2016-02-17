LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
-- Hexadecimal to 7 Segment Decoder for LED Display
ENTITY hex_7seg IS
PORT(hex_digit : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
segment_a, segment_b, segment_c, segment_d, segment_e,
segment_f, segment_g : OUT std_logic);
END hex_7seg;
ARCHITECTURE behavioral OF hex_7seg IS
SIGNAL segment_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
PROCESS (Hex_digit)
-- HEX to 7 Segment Decoder for LED Display
BEGIN
-- Hex-digit is the four bit binary value to display in hexadecimal
CASE Hex_digit IS
WHEN "0000" =>
segment_data <= "00000001";
WHEN "0001" =>
segment_data <= "01001111";
WHEN "0010" =>
segment_data <= "00010010";
WHEN "0011" =>
segment_data <= "00000110";
WHEN "0100" =>
segment_data <= "01001100";
WHEN "0101" =>
segment_data <= "00100100";
WHEN "0110" =>
segment_data <= "00100000";
WHEN "0111" =>
segment_data <= "00001111";
WHEN "1000" =>
segment_data <= "00000000";
WHEN "1001" =>
segment_data <= "00000100";
WHEN "1010" =>
segment_data <= "00001000";
WHEN "1011" =>
segment_data <= "01100000";
WHEN "1100" =>
segment_data <= "00110001";
WHEN "1101" =>
segment_data <= "01000010";
WHEN "1110" =>
segment_data <= "00110000";
WHEN "1111" =>
segment_data <= "00111000";
WHEN OTHERS =>
segment_data <= "11111111";
END CASE;
END PROCESS;
-- extract segment data bits
-- LED driver circuit
segment_a <= segment_data(6);
segment_b <= segment_data(5);
segment_c <= segment_data(4);
segment_d <= segment_data(3);
segment_e <= segment_data(2);
segment_f <= segment_data(1);
segment_g <= segment_data(0);
END behavioral;
