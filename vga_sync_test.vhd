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
      CONSTANT square_size : INTEGER := 64; -- Adjust square size as needed
   BEGIN
      IF video_on = '1' THEN
         square_x := to_integer(unsigned(pixel_x)) / square_size;
         square_y := to_integer(unsigned(pixel_y)) / square_size;
         IF square_x < 8 AND square_y < 8 THEN
            IF (square_x + square_y) MOD 2 = 0 THEN
               rgb_reg <= (OTHERS => '1'); -- White square
            ELSE
               rgb_reg <= (OTHERS => '0'); -- Black square
            END IF;
         ELSE
            rgb_reg <= (OTHERS => '0'); -- Background color (black)
         END IF;
      ELSE
         rgb_reg <= (OTHERS => '0');
      END IF;
   END PROCESS;
   END arch;