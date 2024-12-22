----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/19/2024 10:51:46 AM
-- Design Name: 
-- Module Name: display_interface - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY display_interface IS
    PORT (
        clk, reset : IN STD_LOGIC;
        BOARD : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
        CURSOR_ADDR : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        SELECT_ADDR : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        SELECT_EN : IN STD_LOGIC;

        Hsync : OUT STD_LOGIC;
        Vsync : OUT STD_LOGIC;
        R : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        G : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        B : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)

    );
END display_interface;

ARCHITECTURE Behavioral OF display_interface IS

    SIGNAL pixel_color : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL video_on_signal : STD_LOGIC;
    SIGNAL clock, locked : STD_LOGIC;

    SIGNAL pixel_x, pixel_y : STD_LOGIC_VECTOR(9 DOWNTO 0);

    CONSTANT EMPTY : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    CONSTANT WHITE_PAWN : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
    CONSTANT WHITE_KNIGHT : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
    CONSTANT WHITE_BISHOP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
    CONSTANT WHITE_ROOK : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
    CONSTANT WHITE_QUEEN : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
    CONSTANT WHITE_KING : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";

    CONSTANT BLACK_PAWN : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";
    CONSTANT BLACK_KNIGHT : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";
    CONSTANT BLACK_BISHOP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011";
    CONSTANT BLACK_ROOK : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";
    CONSTANT BLACK_QUEEN : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101";
    CONSTANT BLACK_KING : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";

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

    -- Instantiate vga_sync
    vga_sync_unit : ENTITY work.vga_sync
        PORT MAP(
            clk => clock, reset => reset, hsync => Hsync,
            vsync => Vsync, video_on => video_on_signal,
            p_tick => OPEN, pixel_x => pixel_x, pixel_y => pixel_y
        );

    -- Drawing process
    PROCESS (pixel_x, pixel_y, video_on_signal)
        VARIABLE square_x, square_y : INTEGER;
        VARIABLE adjusted_x, adjusted_y : INTEGER;
        VARIABLE piece_x, piece_y : INTEGER;
        CONSTANT square_size : INTEGER := 60;
        CONSTANT screen_width : INTEGER := 640;
        CONSTANT screen_height : INTEGER := 480;
        CONSTANT squares_count : INTEGER := 8;
        CONSTANT board_size : INTEGER := square_size * squares_count;
        CONSTANT board_start_x : INTEGER := (screen_width - board_size) / 2;
        CONSTANT board_start_y : INTEGER := (screen_height - board_size) / 2;
    BEGIN
        IF video_on_signal = '1' THEN
            -- Adjust pixel positions relative to the board's start position
            adjusted_x := to_integer(unsigned(pixel_x)) - board_start_x;
            adjusted_y := to_integer(unsigned(pixel_y)) - board_start_y;
            -- Check if the pixel is within the chessboard area
            IF adjusted_x >= 0 AND adjusted_x < board_size AND
                adjusted_y >= 0 AND adjusted_y < board_size THEN
                -- Determine which square the pixel is in
                square_x := adjusted_x / square_size;
                square_y := adjusted_y / square_size;

                IF (square_x + square_y) MOD 2 = 0 THEN
                    pixel_color <= (OTHERS => '1'); -- White square
                ELSE
                    pixel_color <= (OTHERS => '0'); -- Black square
                END IF;
                
                -- Draw pieces on the board
                piece_x := adjusted_x MOD square_size;
                piece_y := adjusted_y MOD square_size;

            ELSE
                pixel_color <= "100110000100"; -- Brown border color color
            END IF;
        ELSE
            pixel_color <= (OTHERS => '0');
        END IF;
    END PROCESS;

    R <= pixel_color(11 DOWNTO 8);
    G <= pixel_color(7 DOWNTO 4);
    B <= pixel_color(3 DOWNTO 0);

END Behavioral;