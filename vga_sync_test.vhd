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
   PROCESS (clock, reset)
      VARIABLE row : INTEGER;
      VARIABLE col : INTEGER;
   BEGIN
      IF reset = '1' THEN
         rgb_reg <= (OTHERS => '0');
      ELSIF rising_edge(clock) THEN
         IF video_on = '1' THEN
            -- Convert pixel_x and pixel_y to integers before division
            row := to_integer(unsigned(pixel_y)) / 64;
            col := to_integer(unsigned(pixel_x)) / 64;
            IF (row MOD 2) = (col MOD 2) THEN
               rgb_reg <= x"FFF"; -- White color
            ELSE
               rgb_reg <= x"000"; -- Black color
            END IF;
         ELSE
            rgb_reg <= (OTHERS => '0');
         END IF;
      END IF;
   END PROCESS;
   vgaRed <= rgb_reg(11 DOWNTO 8);
   vgaGreen <= rgb_reg(7 DOWNTO 4);
   vgaBlue <= rgb_reg(3 DOWNTO 0);

END arch;