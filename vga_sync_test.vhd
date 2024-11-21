LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY vga_test IS
   PORT (
      clk, reset : IN STD_LOGIC;
      sw : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      Hsync, Vsync : OUT STD_LOGIC;
      vgaRed : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      vgaGreen : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      vgaBlue : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
   );
END vga_test;

ARCHITECTURE arch OF vga_test IS
   SIGNAL rgb_reg : STD_LOGIC_VECTOR(11 DOWNTO 0);
   SIGNAL video_on, locked, clock : STD_LOGIC;
   SIGNAL pixel_x, pixel_y : STD_LOGIC_VECTOR(9 DOWNTO 0);

   COMPONENT clk_wiz_0
      PORT (
         clk_in1 : IN STD_LOGIC;
         reset : IN STD_LOGIC;
         locked : OUT STD_LOGIC;
         clk_out1 : OUT STD_LOGIC
      );
   END COMPONENT;

BEGIN

   -- Instantiate clock wizard circuit
   clock_unit : clk_wiz_0
   PORT MAP(
      clk_in1 => clk,
      reset => reset,
      locked => locked,
      clk_out1 => clock
   );

   -- Instantiate VGA sync circuit
   vga_sync_unit : ENTITY work.vga_sync
      PORT MAP(
         clk => clock, reset => reset, hsync => Hsync,
         vsync => Vsync, video_on => video_on,
         p_tick => OPEN, pixel_x => pixel_x, pixel_y => pixel_y
      );

   -- Chessboard pattern generation
   PROCESS (pixel_x, pixel_y, video_on)
      VARIABLE square_x, square_y : INTEGER;
      CONSTANT square_size : INTEGER := 60; -- Square size for both dimensions
      CONSTANT board_start_x : INTEGER := 80; -- (640 - 480) / 2 to center
      CONSTANT board_end_x : INTEGER := board_start_x + square_size * 8;
      CONSTANT board_start_y : INTEGER := 0;
      CONSTANT board_end_y : INTEGER := board_start_y + square_size * 8;
   BEGIN
      IF video_on = '1' THEN
         -- Check if pixel is within the chessboard area
         square_x := (TO_INTEGER(UNSIGNED(pixel_x)) - board_start_x) / square_size;
         square_y := (TO_INTEGER(UNSIGNED(pixel_y)) - board_start_y) / square_size;

         --check if pixel is out of the chessboard area
         IF (TO_INTEGER(UNSIGNED(pixel_x)) < board_start_x OR
            TO_INTEGER(UNSIGNED(pixel_x)) >= board_end_x OR
            TO_INTEGER(UNSIGNED(pixel_y)) < board_start_y OR
            TO_INTEGER(UNSIGNED(pixel_y)) >= board_end_y) THEN
            --cyan border
            rgb_reg <= "000000111111";
         ELSE
            IF (MOD(square_x, 2) = 0 AND MOD(square_y, 2) = 0) OR
               (MOD(square_x, 2) /= 0 AND MOD(square_y, 2) /= 0) THEN
               -- White square
               rgb_reg <= "111111111111";
            ELSE
               -- Black square
               rgb_reg <= "000000000000";
            END IF;
         END IF;
      ELSE
         rgb_reg <= "000000000000";
      END IF;

   END PROCESS;
END arch;