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
      VARIABLE adjusted_x, adjusted_y : INTEGER;
      CONSTANT square_size : INTEGER := 60; -- Square size of 60x60 pixels
      -- Screen and board dimensions
      CONSTANT screen_width : INTEGER := 640;
      CONSTANT screen_height : INTEGER := 480;
      CONSTANT squares_count : INTEGER := 8; -- 8 squares per row/column
      CONSTANT board_size : INTEGER := square_size * squares_count;
      CONSTANT board_start_x : INTEGER := (screen_width - board_size) / 2; -- Center horizontally
      CONSTANT board_start_y : INTEGER := (screen_height - board_size) / 2; -- Center vertically
   BEGIN
      IF video_on = '1' THEN
         -- Adjust pixel positions relative to the board's start position
         adjusted_x := to_integer(unsigned(pixel_x)) - board_start_x;
         adjusted_y := to_integer(unsigned(pixel_y)) - board_start_y;
         -- Check if the pixel is within the chessboard area
         IF adjusted_x >= 0 AND adjusted_x < board_size AND
            adjusted_y >= 0 AND adjusted_y < board_size THEN
            -- Determine which square the pixel is in
            square_x := adjusted_x / square_size;
            square_y := adjusted_y / square_size;
            -- Draw the chessboard pattern without border
            IF (square_x + square_y) MOD 2 = 0 THEN
               rgb_reg <= (OTHERS => '1'); -- White square
            ELSE
               rgb_reg <= (OTHERS => '0'); -- Black square
            END IF;
         ELSE
            rgb_reg <= "100110000100"; -- Brown border color color
         END IF;
      ELSE
         rgb_reg <= (OTHERS => '0');
      END IF;
   END PROCESS;

   vgaRed <= rgb_reg(11 DOWNTO 8);
   vgaGreen <= rgb_reg(7 DOWNTO 4);
   vgaBlue <= rgb_reg(3 DOWNTO 0);

END arch;