library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity kb_test is
   port (
        leds: out std_logic_vector(4 downto 0);  -- Debug LEDs [Up, Down, Left, Right, Center]
        clk, reset: in std_logic;
        ps2d, ps2c: in std_logic;
        up, down, left, right, center: out std_logic
   );
end kb_test;

architecture arch of kb_test is
   -- Internal signals
   signal scan_data, w_data: std_logic_vector(7 downto 0);
   signal kb_not_empty, kb_buf_empty: std_logic;
   signal key_code, ascii_code: std_logic_vector(7 downto 0);
   signal up_signal, down_signal, left_signal, right_signal, center_signal: std_logic;
   
      -- LED Timer Signals (adjust COUNT_MAX for visibility)
   constant COUNT_MAX : integer := 50_000_000; -- 0.5 sec at 100 MHz clock
   type timer_array is array (0 to 4) of integer range 0 to COUNT_MAX;
   signal led_timer : timer_array := (others => 0);
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
-- Decode Key Codes for Actions
   process(clk, reset)
   begin
      if reset = '1' then
         -- Initialize all outputs
         up_signal <= '0';
         down_signal <= '0';
         left_signal <= '0';
         right_signal <= '0';
         center_signal <= '0';
         led_timer <= (others => 0);
         
      elsif rising_edge(clk) then
         -- Default: Clear signals unless updated
         up_signal <= '0';
         down_signal <= '0';
         left_signal <= '0';
         right_signal <= '0';
         center_signal <= '0';

         if kb_not_empty = '1' then
            case key_code is
               -- Original arrow keys and Enter
               when x"75" => up_signal <= '1';      -- Up Arrow
               when x"72" => down_signal <= '1';    -- Down Arrow
               when x"6B" => left_signal <= '1';    -- Left Arrow
               when x"74" => right_signal <= '1';   -- Right Arrow
               when x"5A" => center_signal <= '1';  -- Enter

               -- New mappings (W, A, S, D, Space)
               when x"1D" => up_signal <= '1';      -- W (Up)
               when x"1C" => left_signal <= '1';    -- A (Left)
               when x"1B" => down_signal <= '1';    -- S (Down)
               when x"23" => right_signal <= '1';   -- D (Right)
               when x"29" => center_signal <= '1';  -- Space (Enter)

               when others => null;  -- Ignore other keys
            end case;
         end if;
            
         -- Drive outputs
         up <= up_signal;
         down <= down_signal;
         left <= left_signal;
         right <= right_signal;
         center <= center_signal;
         
         for i in 0 to 4 loop
            if (i = 0 and up_signal = '1') or
               (i = 1 and down_signal = '1') or
               (i = 2 and left_signal = '1') or
               (i = 3 and right_signal = '1') or
               (i = 4 and center_signal = '1') then
               led_timer(i) <= COUNT_MAX;  -- Reset timer on key press
            elsif led_timer(i) > 0 then
               led_timer(i) <= led_timer(i) - 1;  -- Decrement timer
            end if;
         end loop;

         -- Drive LEDs based on timers
         leds <= (others => '0');  -- Default: LEDs off
         for i in 0 to 4 loop
            if led_timer(i) > 0 then
               leds(i) <= '1';     -- Turn on LED if timer active
            end if;
         end loop;
      end if;
   end process;
end arch;
