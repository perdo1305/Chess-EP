-- filepath: /path/to/chess_top.vhd
-- Company: 
-- Engineer: 
-- 
-- Create Date: [Date]
-- Design Name: 
-- Module Name: chess_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      Converted from Verilog chess_top.v to VHDL.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY types_pkg;
USE types_pkg.types_pkg.ALL;

ENTITY chess_top IS
    PORT (
        -- Clock and Reset
        ClkPort : IN STD_LOGIC; -- Board's 100MHz clock
        sw : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- For reset

        -- Buttons
        --btnL : IN STD_LOGIC; -- Left
        --btnU : IN STD_LOGIC; -- Up
        --btnD : IN STD_LOGIC; -- Down
        --btnR : IN STD_LOGIC; -- Right
        --btnC : IN STD_LOGIC; -- Center

        -- PS2
        ps2d : IN STD_LOGIC; -- PS2 Data
        ps2c : IN STD_LOGIC; -- PS2 Clock

        -- VGA Signals
        Hsync : OUT STD_LOGIC;
        Vsync : OUT STD_LOGIC;

        R : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        G : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        B : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

        -- LEDs
        led : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        kb_leds : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        debug_led : OUT STD_LOGIC;
        debug_led_piece_type : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)

    );
END ENTITY chess_top;

ARCHITECTURE Behavioral OF chess_top IS

    SIGNAL board : board_input;
    SIGNAL Reset : STD_LOGIC;
    SIGNAL board_out_addr : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL board_out_piece : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL board_change_en : STD_LOGIC;
    SIGNAL cursor_addr : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL selected_addr : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL hilite_selected : STD_LOGIC;
    SIGNAL state : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL move_is_legal : STD_LOGIC;
    SIGNAL is_initial : STD_LOGIC;

    -- VGA Signals
    SIGNAL vga_R : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL vga_G : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL vga_B : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    -- Assign reset signal
    Reset <= sw(0);

    -- Chess Logic Module
    chess_logic_inst : ENTITY work.chess_logic
        PORT MAP(
            CLK => ClkPort, -- clock signal to synchronize
            RESET => Reset, -- reset signal
            ps2d => ps2d, -- PS2 data signal
            ps2c => ps2c, -- PS2 clock signal
            BOARD_IN => board, -- pass the current board state (INPUT)

            board_out_addr => board_out_addr, -- address of the piece to be updated (OUTPUT)
            board_out_piece => board_out_piece, -- piece that is being moved to the board_out_addr (OUTPUT) 
            board_change_en_wire => board_change_en, -- enable signal for updating the board (OUTPUT)
            cursor_addr => cursor_addr, -- address of the cursor position (OUTPUT)
            selected_addr => selected_addr, -- represents the current selected piece (OUTPUT)
            hilite_selected_square => hilite_selected, -- highlight the selected square (OUTPUT)
            state => state, -- current state of the state machine 0101(OUTPUT)
            move_is_legal => move_is_legal, -- signal to indicate if the move is legal (OUTPUT)
            is_in_initial_state => is_initial, -- signal to indicate if the state machine is in the initial state (OUTPUT)
            kb_leds => kb_leds,
            debug_led => debug_led,
            debug_led_piece_type => debug_led_piece_type
        );

    -- Display Interface Module
    display_interface_inst : ENTITY work.display_interface
        PORT MAP(
            clk => ClkPort,
            reset => Reset,
            BOARD => board,
            CURSOR_ADDR => cursor_addr,
            SELECT_ADDR => selected_addr,
            SELECT_EN => hilite_selected,

            Hsync => Hsync,
            Vsync => Vsync,
            R => R,
            G => G,
            B => B
        );

    PROCESS (ClkPort, Reset)
    BEGIN
        IF rising_edge(ClkPort) THEN
            IF Reset = '1' THEN
                IF is_initial = '1' THEN

                    -- WHITE PIECES
                    board(0) <= "0100"; -- White Rook
                    board(1) <= "0010"; -- White Knight
                    board(2) <= "0011"; -- White Bishop
                    board(3) <= "0110"; -- White King
                    board(4) <= "0101"; -- White Queen
                    board(5) <= "0011"; -- White Bishop
                    board(6) <= "0010"; -- White Knight
                    board(7) <= "0100"; -- White Rook

                    board(8) <= "0001"; -- White Pawn
                    board(9) <= "0001"; -- White Pawn
                    board(10) <= "0001"; -- White Pawn
                    board(11) <= "0001"; -- White Pawn
                    board(12) <= "0001"; -- White Pawn
                    board(13) <= "0001"; -- White Pawn
                    board(14) <= "0001"; -- White Pawn
                    board(15) <= "0001"; -- White Pawn

                    board(16 TO 47) <= (OTHERS => "0000"); -- for empty Squares

                    -- BLACK PIECES
                    board(48) <= "1001"; -- Black Pawn
                    board(49) <= "1001"; -- Black Pawn
                    board(50) <= "1001"; -- Black Pawn
                    board(51) <= "1001"; -- Black Pawn
                    board(52) <= "1001"; -- Black Pawn
                    board(53) <= "1001"; -- Black Pawn
                    board(54) <= "1001"; -- Black Pawn
                    board(55) <= "1001"; -- Black Pawn

                    board(56) <= "1100"; -- Black Rook
                    board(57) <= "1010"; -- Black Knight
                    board(58) <= "1011"; -- Black Bishop
                    board(59) <= "1110"; -- Black King
                    board(60) <= "1101"; -- Black Queen
                    board(61) <= "1011"; -- Black Bishop
                    board(62) <= "1010"; -- Black Knight
                    board(63) <= "1100"; -- Black Rook
                END IF;
            ELSE
                IF board_change_en = '1' THEN
                    board(to_integer(unsigned(board_out_addr))) <= board_out_piece;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- Map RGB signals to VGA outputs
    R <= vga_R;
    G <= vga_G;
    B <= vga_B;

    -- debug LEDs
    led(0) <= is_initial;
    led(1) <= move_is_legal;
    led(2) <= state(0);
    led(3) <= state(1);
    led(4) <= state(2);

END ARCHITECTURE Behavioral;