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

LIBRARY types_pkg;
USE types_pkg.types_pkg.ALL;

ENTITY display_interface IS

    PORT (
        clk, reset : IN STD_LOGIC;
        BOARD : IN board_input;
        CURSOR_ADDR : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        SELECT_ADDR : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        SELECT_EN : IN STD_LOGIC;

        Hsync : OUT STD_LOGIC;
        Vsync : OUT STD_LOGIC;
        R : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        G : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        B : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

        HIGHLIGHT_SQUARES : IN STD_LOGIC_VECTOR(63 DOWNTO 0)

    );
END display_interface;

ARCHITECTURE Behavioral OF display_interface IS

    --TYPE board_input IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL BOARD_ARRAY : board_input;

    SIGNAL board_vector : STD_LOGIC_VECTOR(255 DOWNTO 0);
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

    -- Color definitions
    CONSTANT RGB_OUTSIDE : STD_LOGIC_VECTOR(11 DOWNTO 0) := "100110000100"; -- dark green
    CONSTANT RGB_CURSOR : STD_LOGIC_VECTOR(11 DOWNTO 0) := "111110100000"; -- orange
    CONSTANT RGB_SELECTED : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000011110000"; -- bright green
    CONSTANT RGB_DARK_SQ : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
    CONSTANT RGB_LIGHT_SQ : STD_LOGIC_VECTOR(11 DOWNTO 0) := "111111111111";
    CONSTANT RGB_BLACK_PIECE : STD_LOGIC_VECTOR(11 DOWNTO 0) := "100110011001"; -- grey
    CONSTANT RGB_WHITE_PIECE : STD_LOGIC_VECTOR(11 DOWNTO 0) := "111111111011"; -- yellowish white
    CONSTANT RGB_HIGHLIGHT : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000011111111"; -- Cyan

    SIGNAL piece_type : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL piece_color : STD_LOGIC; -- 0-white, 1-black
    SIGNAL rom_row : STD_LOGIC_VECTOR(2 DOWNTO 0); -- 0-7
    SIGNAL piece_pixels : STD_LOGIC_VECTOR(7 DOWNTO 0); -- 8 pixels/row  

    SIGNAL art_x_delayed : INTEGER;
    SIGNAL art_y_delayed : INTEGER;

    SIGNAL counter_row, counter_col : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL art_x, art_y : INTEGER;
    COMPONENT clk_wiz_0
        PORT (
            clk_in1 : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            locked : OUT STD_LOGIC;
            clk_out1 : OUT STD_LOGIC
        );
    END COMPONENT;

    --converts a flat vector to a 2D array
    FUNCTION to_board_array(flat_vector : STD_LOGIC_VECTOR(255 DOWNTO 0)) RETURN board_input IS
        VARIABLE result : board_input;
    BEGIN
        FOR i IN 0 TO 63 LOOP
            result(i) := flat_vector(i * 4 + 3 DOWNTO i * 4);
        END LOOP;
        RETURN result;
    END FUNCTION;

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

    -- Connect to ROM
    piece_rom_unit : ENTITY work.piece_rom
        PORT MAP(
            clk => clock,
            piece_type => piece_type,
            row_addr => rom_row,
            pixel_data => piece_pixels
        );
    BOARD_ARRAY <= BOARD;
    PROCESS (clock)
        VARIABLE square_x, square_y : INTEGER;
        VARIABLE adjusted_x, adjusted_y : INTEGER;
        VARIABLE local_piece_type : STD_LOGIC_VECTOR(3 DOWNTO 0);
        CONSTANT square_size : INTEGER := 60;
        CONSTANT board_size : INTEGER := 480; -- 8x60
        VARIABLE square_index : INTEGER;
    BEGIN
        IF rising_edge(clock) THEN
            IF reset = '1' THEN
                pixel_color <= RGB_OUTSIDE;
            ELSE
                IF video_on_signal = '1' THEN

                    -- Adjust pixel positions to board origin (80, 0)
                    adjusted_x := to_integer(unsigned(pixel_x)) - 80;
                    adjusted_y := to_integer(unsigned(pixel_y)) - 0;

                    -- Inside board area?
                    IF adjusted_x >= 0 AND adjusted_x < 480 AND
                        adjusted_y >= 0 AND adjusted_y < 480 THEN

                        -- Calculate square indices (0-7)
                        square_x := adjusted_x / square_size;
                        square_y := adjusted_y / square_size;
                        square_index := square_y * 8 + square_x; --for highlighting
                        -- Background color (light/dark square)
                        IF (square_x + square_y) MOD 2 = 0 THEN
                            pixel_color <= RGB_LIGHT_SQ;
                        ELSE
                            pixel_color <= RGB_DARK_SQ;
                        END IF;

                        art_x_delayed <= art_x;
                        art_y_delayed <= art_y;

                        -- Calculate ROM row/column
                        art_x <= ((adjusted_x MOD square_size) * 8) / square_size;
                        art_y <= ((adjusted_y MOD square_size) * 8) / square_size;

                        --update rom inputs
                        rom_row <= STD_LOGIC_VECTOR(to_unsigned(art_y, 3));
                        local_piece_type := BOARD_ARRAY(square_y * 8 + square_x);
                        IF local_piece_type /= EMPTY THEN
                            piece_type <= STD_LOGIC_VECTOR(unsigned(local_piece_type(2 DOWNTO 0)) - 1);
                        ELSE
                            piece_type <= (OTHERS => '0');
                        END IF;

                        -- Highlight legal moves
                        IF HIGHLIGHT_SQUARES(square_index) = '1' THEN
                            pixel_color <= RGB_HIGHLIGHT;
                        END IF;

                        -- Highlight cursor/selected square
                        IF (to_unsigned(square_y, 3) & to_unsigned(square_x, 3) = unsigned(CURSOR_ADDR)) THEN
                            pixel_color <= RGB_CURSOR;

                        ELSIF (to_unsigned(square_y, 3) & to_unsigned(square_x, 3) = unsigned(SELECT_ADDR) AND SELECT_EN = '1') THEN
                            --ELSIF (to_unsigned(square_y, 3) & to_unsigned(square_x, 3) = unsigned(SELECT_ADDR)) THEN
                            pixel_color <= RGB_SELECTED;
                        END IF;

                        IF local_piece_type /= EMPTY THEN -- Only draw if square is not empty
                            --Draw piece pixels (USE delayed art_x due TO ROM latency)
                            IF piece_pixels(7 - art_x_delayed) = '1' THEN
                                IF local_piece_type(3) = '1' THEN -- Black piece
                                    pixel_color <= RGB_BLACK_PIECE;
                                ELSE -- White piece
                                    pixel_color <= RGB_WHITE_PIECE;
                                END IF;
                            END IF;
                        END IF;
                    ELSE
                        pixel_color <= RGB_OUTSIDE; -- Outside board
                    END IF;
                ELSE
                    pixel_color <= (OTHERS => '0'); -- Blanking period
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- ...existing code for assigning R, G, B...

    R <= pixel_color(11 DOWNTO 8);
    G <= pixel_color(7 DOWNTO 4);
    B <= pixel_color(3 DOWNTO 0);

END Behavioral;