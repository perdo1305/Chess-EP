----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/21/2024 11:02:43 PM
-- Design Name: 
-- Module Name: chess_logic - Behavioral
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

ENTITY chess_logic IS
    PORT (
        CLK : IN STD_LOGIC;
        RESET : IN STD_LOGIC;
        BtnL, BtnU, BtnR, BtnD, BtnC : IN STD_LOGIC;
        board_input : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
        board_out_addr : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        board_out_piece : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        board_change_en_wire : OUT STD_LOGIC;
        cursor_addr : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        selected_addr : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        hilite_selected_square : OUT STD_LOGIC;
        state : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        move_is_legal : BUFFER STD_LOGIC;
        is_in_initial_state : OUT STD_LOGIC
    );
END chess_logic;

ARCHITECTURE Behavioral OF chess_logic IS

    -- Constants for piece definitions
    -- Combined Piece Type and Color Definitions
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

    -- State machine states
    CONSTANT INITIAL : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    CONSTANT PIECE_SEL : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    CONSTANT PIECE_MOVE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
    CONSTANT WRITE_NEW_PIECE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
    CONSTANT ERASE_OLD_PIECE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";

    CONSTANT COLOR_WHITE : STD_LOGIC := '0';
    CONSTANT COLOR_BLACK : STD_LOGIC := '1';

    -- Internal signals
    SIGNAL current_state, next_state : STD_LOGIC_VECTOR(2 DOWNTO 0) := INITIAL;
    SIGNAL player_to_move : STD_LOGIC := COLOR_WHITE;
    SIGNAL cursor_reg, selected_reg : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
    TYPE board_array IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL board : board_array;
    SIGNAL board_out_en : STD_LOGIC := '0';
    SIGNAL cursor_contents, selected_contents : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL h_delta, v_delta : unsigned(3 DOWNTO 0);
    SIGNAL move_is_legal_internal : STD_LOGIC;

BEGIN

    -- Output assignments
    cursor_addr <= cursor_reg;
    selected_addr <= selected_reg;
    hilite_selected_square <= '1' WHEN current_state = PIECE_MOVE ELSE
        '0';
    is_in_initial_state <= '1' WHEN current_state = INITIAL ELSE
        '0';
    board_change_en_wire <= board_out_en;

    move_is_legal <= move_is_legal_internal; -- Assign the internal signal to the output port signal move_is_legal_internal : std_logic;

    -- Decode board input into 64 squares
    PROCESS (board_input)
    BEGIN
        FOR i IN 0 TO 63 LOOP
            board(i) <= board_input((i + 1) * 4 - 1 DOWNTO i * 4);
        END LOOP;
    END PROCESS;

    -- Cursor and selected contents
    cursor_contents <= board(to_integer(unsigned(cursor_reg)));
    selected_contents <= board(to_integer(unsigned(selected_reg)));

    -- State machine process
    PROCESS (CLK, RESET)
    BEGIN
        IF RESET = '1' THEN
            current_state <= INITIAL;
            player_to_move <= COLOR_WHITE;
            cursor_reg <= "110100"; -- White's king pawn
            selected_reg <= (OTHERS => '0');
            board_out_en <= '0';
        ELSIF rising_edge(CLK) THEN
            current_state <= next_state;

            IF BtnL = '1' AND cursor_reg(2 DOWNTO 0) /= "000" THEN
                cursor_reg <= STD_LOGIC_VECTOR(unsigned(cursor_reg) - 1);
            ELSIF BtnR = '1' AND cursor_reg(2 DOWNTO 0) /= "111" THEN
                cursor_reg <= STD_LOGIC_VECTOR(unsigned(cursor_reg) + 1);
            ELSIF BtnU = '1' AND cursor_reg(5 DOWNTO 3) /= "000" THEN
                cursor_reg <= STD_LOGIC_VECTOR(unsigned(cursor_reg) - 8);
            ELSIF BtnD = '1' AND cursor_reg(5 DOWNTO 3) /= "111" THEN
                cursor_reg <= STD_LOGIC_VECTOR(unsigned(cursor_reg) + 8);
            END IF;
        END IF;
    END PROCESS;

    -- Next state logic and output logic
    PROCESS (current_state, BtnC, cursor_contents, selected_contents, player_to_move)
    BEGIN
        next_state <= current_state;
        board_out_en <= '0';

        CASE current_state IS
            WHEN INITIAL =>
                next_state <= PIECE_SEL;

            WHEN PIECE_SEL =>
                IF BtnC = '1' AND cursor_contents(3) = player_to_move AND cursor_contents(2 DOWNTO 0) /= EMPTY THEN
                    next_state <= PIECE_MOVE;
                    selected_reg <= cursor_reg;
                END IF;

            WHEN PIECE_MOVE =>
                IF BtnC = '1' THEN
                    IF (cursor_contents(3) /= player_to_move OR cursor_contents(2 DOWNTO 0) = EMPTY) AND move_is_legal = '1' THEN
                        next_state <= WRITE_NEW_PIECE;
                    ELSIF cursor_contents(3) = player_to_move AND cursor_contents(2 DOWNTO 0) /= EMPTY THEN
                        selected_reg <= cursor_reg;
                    ELSE
                        next_state <= PIECE_SEL;
                    END IF;
                END IF;

            WHEN WRITE_NEW_PIECE =>
                next_state <= ERASE_OLD_PIECE;
                board_out_en <= '1';

            WHEN ERASE_OLD_PIECE =>
                next_state <= PIECE_SEL;
                IF player_to_move = '1' THEN
                    player_to_move <= '0';
                ELSE
                    player_to_move <= '1';
                END IF;

            WHEN OTHERS =>
                next_state <= INITIAL;
        END CASE;
    END PROCESS;

    -- Move Legality Checks
    PROCESS (cursor_reg, selected_reg, cursor_contents, selected_contents)
        VARIABLE h_delta : INTEGER;
        VARIABLE v_delta : INTEGER;
        VARIABLE selected_piece_type : STD_LOGIC_VECTOR(2 DOWNTO 0);
        VARIABLE selected_piece_color : STD_LOGIC;
    BEGIN
        -- Calculate horizontal and vertical deltas
        h_delta := ABS(to_integer(unsigned(selected_reg(2 DOWNTO 0))) - to_integer(unsigned(cursor_reg(2 DOWNTO 0))));
        v_delta := ABS(to_integer(unsigned(selected_reg(5 DOWNTO 3))) - to_integer(unsigned(cursor_reg(5 DOWNTO 3))));

        -- Extract piece type and color from selected_contents
        selected_piece_color := selected_contents(3); -- MSB for color
        selected_piece_type := selected_contents(2 DOWNTO 0); -- LSB for piece type

        -- Initialize move_is_legal_internal to '0'
        move_is_legal_internal <= '0';

        -- Check move legality based on piece type
        CASE selected_piece_type IS
            WHEN "001" => -- PAWN
                IF selected_piece_color = '0' THEN -- WHITE
                    -- Example: White pawn moves forward
                    IF (v_delta = 1 AND h_delta = 0 AND cursor_contents = EMPTY) THEN
                        move_is_legal_internal <= '1';
                    END IF;
                ELSIF selected_piece_color = '1' THEN -- BLACK
                    -- Example: Black pawn moves forward
                    IF (v_delta = 1 AND h_delta = 0 AND cursor_contents = EMPTY) THEN
                        move_is_legal_internal <= '1';
                    END IF;
                END IF;

            WHEN "010" => -- KNIGHT
                -- Implement knight move logic
                IF ((v_delta = 2 AND h_delta = 1) OR (v_delta = 1 AND h_delta = 2)) THEN
                    move_is_legal_internal <= '1';
                END IF;

            WHEN "011" => -- BISHOP
                -- Implement bishop move logic (e.g., diagonal movement)
                IF (v_delta = h_delta AND v_delta /= 0) THEN
                    move_is_legal_internal <= '1';
                END IF;

            WHEN "100" => -- ROOK
                -- Implement rook move logic (horizontal or vertical)
                IF ((v_delta = 0 AND h_delta /= 0) OR (h_delta = 0 AND v_delta /= 0)) THEN
                    move_is_legal_internal <= '1';
                END IF;

            WHEN "101" => -- QUEEN
                -- Implement queen move logic (combination of rook and bishop)
                IF ((v_delta = h_delta AND v_delta /= 0) OR
                    (v_delta = 0 AND h_delta /= 0) OR
                    (h_delta = 0 AND v_delta /= 0)) THEN
                    move_is_legal_internal <= '1';
                END IF;

            WHEN "110" => -- KING
                -- Implement king move logic (one square in any direction)
                IF (v_delta <= 1 AND h_delta <= 1) THEN
                    move_is_legal_internal <= '1';
                END IF;

            WHEN OTHERS =>
                -- For EMPTY or undefined pieces
                move_is_legal_internal <= '0';
        END CASE;
    END PROCESS;

END Behavioral;