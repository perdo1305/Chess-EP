library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity kb_test is
   port (
        led: out std_logic; -- LED output
        clk, reset: in std_logic; -- Clock and Reset inputs
        ps2d, ps2c: in std_logic; -- PS/2 data and clock inputs
        up, down, left, right, center: out std_logic -- Directional outputs
   );
end kb_test;

architecture arch of kb_test is
   -- Internal signals
   signal scan_data, w_data: std_logic_vector(7 downto 0);
   signal kb_not_empty, kb_buf_empty: std_logic;
   signal key_code, ascii_code: std_logic_vector(7 downto 0);
   signal led_s: std_logic; -- Internal LED toggle signal
begin

   -- Keyboard Code Unit
   kb_code_unit: entity work.kb_code(arch)
      port map(
         clk => clk, 
         reset => reset, 
         ps2d => ps2d, 
         ps2c => ps2c,
         rd_key_code => kb_not_empty, 
         key_code => key_code,
         kb_buf_empty => kb_buf_empty
      );

   -- Key to ASCII Unit
   key2a_unit: entity work.key2ascii(arch)
      port map(
         key_code => key_code, 
         ascii_code => ascii_code
      );

   -- Map kb_not_empty signal
   kb_not_empty <= not kb_buf_empty;

   -- Decode Key Codes for Actions and LED Toggle
   process(clk, reset)
   begin
      if reset = '1' then
         -- Initialize outputs and internal states on reset
         up <= '0';
         down <= '0';
         left <= '0';
         right <= '0';
         center <= '0';
         led_s <= '0';
         led <= '0';
      elsif rising_edge(clk) then
         -- Default: Clear directional outputs on each clock cycle
         up <= '0';
         down <= '0';
         left <= '0';
         right <= '0';
         center <= '0';

         if kb_not_empty = '1' then
            -- Decode valid key codes
            case key_code is
               when x"75" => -- Scan code for 'Up Arrow'
                  up <= '1';
               when x"72" => -- Scan code for 'Down Arrow'
                  down <= '1';
               when x"6B" => -- Scan code for 'Left Arrow'
                  left <= '1';
               when x"74" => -- Scan code for 'Right Arrow'
                  right <= '1';
               when x"5A" => -- Scan code for 'Enter' (Center key)
                  center <= '1';
                  led_s <= not led_s; -- Toggle LED state
               when x"F0" =>
                  -- Ignore break codes (do nothing)
                  null;
               when others =>
                  -- Ignore other unrecognized scan codes
                  null;
            end case;
         end if;

         -- Map internal LED signal to output
         led <= led_s;
      end if;
   end process;
end arch;
