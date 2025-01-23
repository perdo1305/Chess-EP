library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity kb_test is
   port (
      clk, reset: in  std_logic;
      ps2d, ps2c: in  std_logic;
      tx: out  std_logic;
      up, down, left, right, center: out std_logic -- Output actions
   );
end kb_test;

architecture arch of kb_test is
   signal scan_data, w_data: std_logic_vector(7 downto 0);
   signal kb_not_empty, kb_buf_empty: std_logic;
   signal key_code, ascii_code: std_logic_vector(7 downto 0);
begin
   -- Keyboard Code Unit
   kb_code_unit: entity work.kb_code(arch)
      port map(clk => clk, reset => reset, ps2d => ps2d, ps2c => ps2c,
               rd_key_code => kb_not_empty, key_code => key_code,
               kb_buf_empty => kb_buf_empty);

   -- UART Unit
   uart_unit: entity work.uart(str_arch)
      port map(clk => clk, reset => reset, rd_uart => '0',
               wr_uart => kb_not_empty, rx => '1',
               w_data => ascii_code, tx_full => open,
               rx_empty => open, r_data => open, tx => tx);

   -- Key to ASCII Unit
   key2a_unit: entity work.key2ascii(arch)
      port map(key_code => key_code, ascii_code => ascii_code);

   -- Map kb_not_empty signal
   kb_not_empty <= not kb_buf_empty;

   -- Decode Key Codes for Actions
   process(clk, reset)
   begin
      if reset = '1' then
         up <= '0';
         down <= '0';
         left <= '0';
         right <= '0';
         center <= '0';
      elsif rising_edge(clk) then
         up <= '0';
         down <= '0';
         left <= '0';
         right <= '0';
         center <= '0';
         
         case key_code is
            when x"75" => -- Example scan code for 'Up Arrow'
               up <= '1';
            when x"72" => -- Example scan code for 'Down Arrow'
               down <= '1';
            when x"6B" => -- Example scan code for 'Left Arrow'
               left <= '1';
            when x"74" => -- Example scan code for 'Right Arrow'
               right <= '1';
            when x"5A" => -- Example scan code for 'Enter' (Center)
               center <= '1';
            when others =>
               -- Do nothing for unrecognized keys
               null;
         end case;
      end if;
   end process;
end arch;
