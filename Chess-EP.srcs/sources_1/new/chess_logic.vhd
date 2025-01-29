----------------------------------------------------------------------------------
-- Create Date: 11/21/2024 11:02:43 PM
-- Module Name: chess_logic - Behavioral
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY types_pkg;
USE types_pkg.types_pkg.ALL;

ENTITY chess_logic IS
    PORT (
        CLK : IN STD_LOGIC;
        RESET : IN STD_LOGIC;
        ps2d, ps2c : IN STD_LOGIC; -- ps2 data and clock for the keyboard
        BOARD_IN : IN board_input; -- input board state from chess top with the pieces in initial positions
        board_out_addr : OUT STD_LOGIC_VECTOR(5 DOWNTO 0); -- address of the piece to be written
        board_out_piece : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- piece to be written
        board_change_en_wire : OUT STD_LOGIC; -- Signal to enable board changes
        cursor_addr : OUT STD_LOGIC_VECTOR(5 DOWNTO 0); -- address of the cursor
        selected_addr : OUT STD_LOGIC_VECTOR(5 DOWNTO 0); -- address of the selected piece
        hilite_selected_square : OUT STD_LOGIC; -- signal to highlight the selected square
        state : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- current state of the state machine
        move_is_legal : BUFFER STD_LOGIC; -- signal to indicate if a move is legal
        is_in_initial_state : OUT STD_LOGIC; --  REMOVE?
        kb_leds : OUT STD_LOGIC_VECTOR(4 DOWNTO 0); -- keyboard LEDs for debugging
        debug_led : OUT STD_LOGIC; -- debug led used for many signals
        debug_led_piece_type : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- prints the piece type of the selected piece
        HIGHLIGHT_SQUARES : OUT STD_LOGIC_VECTOR(63 DOWNTO 0); -- highlights the legal moves
        checkmate : OUT STD_LOGIC; -- signal to indicate checkmate
        player_selected: OUT STD_LOGIC
    );
END chess_logic;

ARCHITECTURE Behavioral OF chess_logic IS

    -----------------------------piece definitions-------------------------------
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

    CONSTANT COLOR_WHITE : STD_LOGIC := '0';
    CONSTANT COLOR_BLACK : STD_LOGIC := '1';
    -----------------------------------------------------------------------------

    -----------------------------state machine states----------------------------
    CONSTANT INITIAL : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    CONSTANT PIECE_SEL : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    CONSTANT PIECE_MOVE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
    CONSTANT WRITE_NEW_PIECE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
    CONSTANT ERASE_OLD_PIECE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    ------------------------------------reg--------------------------------------
    SIGNAL current_state, next_state : STD_LOGIC_VECTOR(2 DOWNTO 0) := INITIAL;
    SIGNAL cursor_reg, selected_reg : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');

    SIGNAL next_selected_reg : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL player_to_move, next_player_to_move : STD_LOGIC := COLOR_WHITE;
    -----------------------------------------------------------------------------

    --TYPE board_array IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL board : board_input; -- board vector defined at package
    SIGNAL board_out_en : STD_LOGIC := '0'; -- signal to enable board changes
    SIGNAL cursor_contents, selected_contents : STD_LOGIC_VECTOR(3 DOWNTO 0); -- contents of the cursor and selected pieces
    SIGNAL h_delta, v_delta : unsigned(3 DOWNTO 0); -- horizontal and vertical difeerences between cursor and selected pieces
    SIGNAL move_is_legal_internal : STD_LOGIC; --internal move to check if the move is legal

    SIGNAL BtnU, BtnD, BtnL, BtnR, BtnC : STD_LOGIC; --not buttons, this was reproposed to work with the keyboard
    SIGNAL keyboard_up, keyboard_down, keyboard_left, keyboard_right, keyboard_center : STD_LOGIC;-- this is needed too for keyboard

    SIGNAL write_new_piece_en : STD_LOGIC := '0';
    SIGNAL erase_old_piece_en : STD_LOGIC := '0';
    SIGNAL write_addr : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL write_data : STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- this funtions check the squares between the start and end positions
    FUNCTION is_path_clear(
        start_x, start_y, end_x, end_y : INTEGER;
        board : board_input
    ) RETURN BOOLEAN IS
        VARIABLE delta_x, delta_y : INTEGER; -- diferences at x and y 
        VARIABLE step_x, step_y : INTEGER := 0; -- steps at x and y
        VARIABLE current_x, current_y : INTEGER; -- current x and y
        VARIABLE idx : INTEGER; -- index of the board (0-63)
    BEGIN
        delta_x := end_x - start_x; -- calculate the diferences in x
        delta_y := end_y - start_y; -- calculate the diferences in y

        -- calculate step direction for X
        IF delta_x /= 0 THEN -- if the diference in x is not 0
            step_x := delta_x / ABS(delta_x); -- +1 or -1
        END IF;

        -- calculate step direction for Y
        IF delta_y /= 0 THEN -- if the diference in y is not 0
            step_y := delta_y / ABS(delta_y); -- +1 or -1
        END IF;

        -- check all squares between start and end (exclusive)
        FOR i IN 1 TO 7 LOOP
            -- xxit if beyond required steps
            IF (ABS(delta_x) > 0 AND i >= ABS(delta_x)) OR
                (ABS(delta_y) > 0 AND i >= ABS(delta_y)) THEN
                EXIT;
            END IF;

            -- calculate current position
            current_x := start_x + step_x * i; -- calculate the current x
            current_y := start_y + step_y * i; -- calculate the current y
            idx := current_y * 8 + current_x; -- calculate the index of the board

            -- ccdheck if square is occupied
            IF board(idx) /= EMPTY THEN
                RETURN FALSE;
            END IF;
        END LOOP;

        RETURN TRUE;
    END FUNCTION;

    --
    FUNCTION is_move_legal(
        start_addr : STD_LOGIC_VECTOR(5 DOWNTO 0); -- initial position
        end_addr : STD_LOGIC_VECTOR(5 DOWNTO 0); -- final position
        board : board_input; -- board vector
        player_color : STD_LOGIC
    ) RETURN BOOLEAN IS
        VARIABLE start_x, start_y, end_x, end_y : INTEGER;
        VARIABLE h_delta, v_delta : INTEGER;
        VARIABLE start_piece, end_piece : STD_LOGIC_VECTOR(3 DOWNTO 0);
        VARIABLE piece_type : STD_LOGIC_VECTOR(2 DOWNTO 0);
        VARIABLE legal : BOOLEAN;
        VARIABLE intermediate_addr : STD_LOGIC_VECTOR(5 DOWNTO 0);
    BEGIN
        -- Extract coordinates from addresses
        start_x := to_integer(unsigned(start_addr(2 DOWNTO 0)));
        start_y := to_integer(unsigned(start_addr(5 DOWNTO 3)));
        end_x := to_integer(unsigned(end_addr(2 DOWNTO 0)));
        end_y := to_integer(unsigned(end_addr(5 DOWNTO 3)));
        h_delta := ABS(end_x - start_x); -- calculate x dif
        v_delta := ABS(end_y - start_y); -- calculate y dif

        -- Retrieve start and end pieces
        start_piece := board(to_integer(unsigned(start_addr))); -- get the piece at the start position
        end_piece := board(to_integer(unsigned(end_addr))); -- get the piece at the end position

        -- Check if start piece is valid and belongs to the current player
        IF start_piece = EMPTY OR start_piece(3) /= player_color THEN
            RETURN FALSE;
        END IF;

        -- Check if end square contains a friendly piece
        IF end_piece /= EMPTY AND end_piece(3) = player_color THEN
            RETURN FALSE;
        END IF;

        -- Determine piece type and check move legality
        piece_type := start_piece(2 DOWNTO 0);
        legal := FALSE;

        CASE piece_type IS
            WHEN "001" => -- Pawn
                IF start_piece(3) = COLOR_WHITE THEN
                    -- white pawn moves
                    IF (end_y = start_y + 1) AND (h_delta = 0) AND (end_piece = EMPTY) THEN
                        legal := TRUE;
                    ELSIF (start_y = 1) AND (end_y = start_y + 2) AND (h_delta = 0) AND (end_piece = EMPTY) THEN
                        intermediate_addr := STD_LOGIC_VECTOR(unsigned(start_addr) + 8);
                        IF board(to_integer(unsigned(intermediate_addr))) = EMPTY THEN
                            legal := TRUE;
                        END IF;
                    ELSIF (end_y = start_y + 1) AND (h_delta = 1) AND (end_piece /= EMPTY AND end_piece(3) = COLOR_BLACK) THEN
                        legal := TRUE;
                    END IF;
                ELSE
                    -- black pawn moves
                    IF (end_y = start_y - 1) AND (h_delta = 0) AND (end_piece = EMPTY) THEN
                        legal := TRUE;
                    ELSIF (start_y = 6) AND (end_y = start_y - 2) AND (h_delta = 0) AND (end_piece = EMPTY) THEN
                        intermediate_addr := STD_LOGIC_VECTOR(unsigned(start_addr) - 8);
                        IF board(to_integer(unsigned(intermediate_addr))) = EMPTY THEN
                            legal := TRUE;
                        END IF;
                    ELSIF (end_y = start_y - 1) AND (h_delta = 1) AND (end_piece /= EMPTY AND end_piece(3) = COLOR_WHITE) THEN
                        legal := TRUE;
                    END IF;
                END IF;

            WHEN "010" => -- knight
                IF (h_delta = 2 AND v_delta = 1) OR (h_delta = 1 AND v_delta = 2) THEN
                    legal := TRUE;
                END IF;

            WHEN "011" => -- bishop
                IF h_delta = v_delta AND h_delta > 0 THEN
                    legal := is_path_clear(start_x, start_y, end_x, end_y, board);
                END IF;

            WHEN "100" => -- rook
                IF (h_delta = 0 OR v_delta = 0) AND (h_delta + v_delta > 0) THEN
                    legal := is_path_clear(start_x, start_y, end_x, end_y, board);
                END IF;

            WHEN "101" => -- queen
                IF (h_delta = v_delta OR h_delta = 0 OR v_delta = 0) AND (h_delta + v_delta > 0) THEN
                    legal := is_path_clear(start_x, start_y, end_x, end_y, board);
                END IF;

            WHEN "110" => -- king
                IF h_delta <= 1 AND v_delta <= 1 THEN
                    legal := TRUE;
                END IF;

            WHEN OTHERS =>
                legal := FALSE;
        END CASE;

        RETURN legal;
    END FUNCTION;
BEGIN
    -- connect keyboard signals
    keyboard_interface : ENTITY work.kb_test(arch)
        PORT MAP(
            clk => CLK,
            reset => RESET,
            ps2d => ps2d,
            ps2c => ps2c,
            up => keyboard_up,
            down => keyboard_down,
            left => keyboard_left,
            right => keyboard_right,
            center => keyboard_center,
            leds => kb_leds
        );

    -- output assignments
    cursor_addr <= cursor_reg; -- assign the cursor register to the cursor address
    selected_addr <= selected_reg; -- assign the selected register to the selected address

    hilite_selected_square <= '1' WHEN current_state = PIECE_MOVE ELSE
        '0'; -- highlight the selected square when in PIECE_MOVE state

    is_in_initial_state <= '1' WHEN current_state = INITIAL ELSE
        '0'; -- check if the state machine is in the initial state

    board_change_en_wire <= board_out_en; -- assign the board change enable signal

    move_is_legal <= move_is_legal_internal; -- Assign the internal signal to the output port signal move_is_legal_internal : std_logic;
    debug_led <= move_is_legal_internal; -- debug LED not important 
    player_selected <= player_to_move; -- assign the player to move to the output port
    state <= current_state;

    ------------------------- cursor and selected contents-------------------------------------
    cursor_contents <= board(to_integer(unsigned(cursor_reg)));
    selected_contents <= board(to_integer(unsigned(selected_reg)));
    PROCESS (CLK)
        VARIABLE prev_up, prev_down, prev_left, prev_right, prev_center : STD_LOGIC;
    BEGIN
        IF rising_edge(CLK) THEN
            -- detect rising edges for pulses
            BtnU <= '0';
            BtnD <= '0';
            BtnL <= '0';
            BtnR <= '0';
            BtnC <= '0';

            IF keyboard_up = '1' AND prev_up = '0' THEN
                BtnU <= '1';
            END IF;
            IF keyboard_down = '1' AND prev_down = '0' THEN
                BtnD <= '1';
            END IF;
            IF keyboard_left = '1' AND prev_left = '0' THEN
                BtnL <= '1';
            END IF;
            IF keyboard_right = '1' AND prev_right = '0' THEN
                BtnR <= '1';
            END IF;
            IF keyboard_center = '1' AND prev_center = '0' THEN
                BtnC <= '1';
            END IF;

            -- update previous values
            prev_up := keyboard_up;
            prev_down := keyboard_down;
            prev_left := keyboard_left;
            prev_right := keyboard_right;
            prev_center := keyboard_center;
        END IF;
    END PROCESS;

    -------------------------state machine process-------------------------
    PROCESS (CLK, RESET)
    BEGIN
        IF RESET = '1' THEN
            ------------INITIALAL VALUES--------------
            current_state <= INITIAL;
            player_to_move <= COLOR_WHITE;
            cursor_reg <= "000011"; -- white s king pawn
            selected_reg <= (OTHERS => '0');
            player_to_move <= COLOR_WHITE;

            -- initialize board from input , without thsi the board is buggy
            FOR i IN 0 TO 63 LOOP
                board(i) <= BOARD_IN(i);
            END LOOP;

        ELSIF rising_edge(CLK) THEN
            selected_reg <= next_selected_reg; -- update selected_reg here

            --update state
            IF current_state = INITIAL THEN
                current_state <= PIECE_SEL; --out of INITIAL
            ELSE
                current_state <= next_state; -- update state
                player_to_move <= next_player_to_move; -- update player to move
            END IF;

            -- wroite new piece 
            IF write_new_piece_en = '1' THEN
                board(to_integer(unsigned(write_addr))) <= write_data;
            END IF;
            -- erase old piece
            IF erase_old_piece_en = '1' THEN
                board(to_integer(unsigned(selected_reg))) <= EMPTY;
            END IF;

            -- update cursor position
            IF BtnL = '1' AND cursor_reg(2 DOWNTO 0) /= "000" THEN --decrement x
                cursor_reg <= STD_LOGIC_VECTOR(unsigned(cursor_reg) - 1);
            ELSIF BtnR = '1' AND cursor_reg(2 DOWNTO 0) /= "111" THEN --increment x
                cursor_reg <= STD_LOGIC_VECTOR(unsigned(cursor_reg) + 1);
            ELSIF BtnU = '1' AND cursor_reg(5 DOWNTO 3) /= "000" THEN --decrement y
                cursor_reg <= STD_LOGIC_VECTOR(unsigned(cursor_reg) - 8);
            ELSIF BtnD = '1' AND cursor_reg(5 DOWNTO 3) /= "111" THEN --increment y
                cursor_reg <= STD_LOGIC_VECTOR(unsigned(cursor_reg) + 8);
            END IF;
        END IF;
    END PROCESS;

    -- next state logic and output logic
    PROCESS (current_state, BtnC, cursor_contents, selected_contents, player_to_move, cursor_reg, move_is_legal)
    BEGIN
        -- default values for all outputs
        next_state <= current_state;
        board_out_en <= '0'; -- Default to '0'
        next_selected_reg <= selected_reg;
        next_player_to_move <= player_to_move;
        write_new_piece_en <= '0';
        erase_old_piece_en <= '0';

        CASE current_state IS
            WHEN PIECE_SEL =>
                -- if  BtnC is pressed and the cursor is on a piece of the current player then move to PIECE_MOVE
                IF BtnC = '1' AND cursor_contents(3) = player_to_move AND cursor_contents /= EMPTY THEN
                    next_state <= PIECE_MOVE;
                    next_selected_reg <= cursor_reg; -- update next_selected_reg
                END IF;

            WHEN PIECE_MOVE =>
                -- if BtnC is pressed and the move is legal then move to WRITE_NEW_PIECE
                IF BtnC = '1' THEN
                    IF move_is_legal = '1' THEN
                        next_state <= WRITE_NEW_PIECE;
                    ELSIF cursor_contents(3) = player_to_move AND cursor_contents /= EMPTY THEN
                        next_selected_reg <= cursor_reg; -- select new piece
                    ELSE
                        next_state <= PIECE_SEL; -- cancel move
                    END IF;
                END IF;

            WHEN WRITE_NEW_PIECE =>
                -- write new piece to the board and erase the old piece
                board_out_addr <= cursor_reg;
                board_out_piece <= selected_contents;
                board_out_en <= '1';
                write_new_piece_en <= '1'; -- signal to write new piece
                write_addr <= cursor_reg;
                write_data <= selected_contents;
                next_state <= ERASE_OLD_PIECE;

            WHEN ERASE_OLD_PIECE =>
                -- erase the old piece 
                board_out_addr <= selected_reg;
                board_out_piece <= EMPTY;
                board_out_en <= '1';
                erase_old_piece_en <= '1'; -- signal to erase old piece
                next_player_to_move <= NOT player_to_move;
                next_selected_reg <= (OTHERS => '0');
                next_state <= PIECE_SEL;
            WHEN OTHERS =>
                next_state <= INITIAL;
        END CASE;
    END PROCESS;

    -----------------------move legality checks-------------------------------------
    PROCESS (cursor_reg, selected_reg, cursor_contents, selected_contents)
        VARIABLE h_delta : INTEGER; -- horizontal delta
        VARIABLE v_delta : INTEGER; -- vertical delta
        VARIABLE selected_piece_type : STD_LOGIC_VECTOR(2 DOWNTO 0);
        VARIABLE selected_piece_color : STD_LOGIC;

        VARIABLE selected_row, cursor_row : INTEGER;
        VARIABLE v_delta_pawn : INTEGER; -- vertical delta for pawns for 2 square move

        --i made a function for check the path between two squares
        --VARIABLE start_x, start_y : INTEGER; 
        --VARIABLE end_x, end_y : INTEGER;
        --VARIABLE step_x, step_y : INTEGER;
        --VARIABLE delta_x, delta_y : INTEGER;
        --VARIABLE current_x, current_y : INTEGER;
        --VARIABLE idx : INTEGER;

        VARIABLE king_count : INTEGER := 0;
    BEGIN
        -- calculate horizontal and vertical deltas
        h_delta := ABS(to_integer(unsigned(selected_reg(2 DOWNTO 0))) - to_integer(unsigned(cursor_reg(2 DOWNTO 0))));
        v_delta := ABS(to_integer(unsigned(selected_reg(5 DOWNTO 3))) - to_integer(unsigned(cursor_reg(5 DOWNTO 3))));

        -- extract rows
        selected_row := to_integer(unsigned(selected_reg(5 DOWNTO 3)));
        cursor_row := to_integer(unsigned(cursor_reg(5 DOWNTO 3)));

        -- extract piece type and color from selected_contents
        selected_piece_color := selected_contents(3); -- MSB for color
        selected_piece_type := selected_contents(2 DOWNTO 0); -- LSB for piece type

        move_is_legal_internal <= '0'; -- default to legal move

        -- Cceck move legality based on piece type
        CASE selected_piece_type IS
            WHEN "001" => -- PAWN 
                -- compute direction
                IF selected_piece_color = '0' THEN -- WHITE PAWN
                    v_delta_pawn := cursor_row - selected_row;
                ELSE -- BLACK PAWN
                    v_delta_pawn := selected_row - cursor_row;
                END IF;

                IF selected_piece_color = '0' THEN -- WHITE PAWN
                    -- forward move 1 sqare
                    IF (v_delta_pawn = 1 AND h_delta = 0 AND cursor_contents = EMPTY) THEN
                        move_is_legal_internal <= '1';
                        -- two squares from initial position on 1st row
                    ELSIF (selected_row = 1 AND v_delta_pawn = 2 AND h_delta = 0 AND cursor_contents = EMPTY) THEN
                        -- check intermediate square
                        IF board(to_integer(unsigned(selected_reg)) + 8) = EMPTY THEN
                            move_is_legal_internal <= '1';
                        END IF;
                        -- diagonal capture
                    ELSIF (v_delta_pawn = 1 AND h_delta = 1 AND cursor_contents(3) = '1') THEN
                        move_is_legal_internal <= '1';
                    END IF;
                ELSE -- BLACK PAWN
                    -- forward move 1 sqare
                    IF (v_delta_pawn = 1 AND h_delta = 0 AND cursor_contents = EMPTY) THEN
                        move_is_legal_internal <= '1';
                        -- two squares from initial position on 6th row
                    ELSIF (selected_row = 6 AND v_delta_pawn = 2 AND h_delta = 0 AND cursor_contents = EMPTY) THEN
                        -- check intermediate square
                        IF board(to_integer(unsigned(selected_reg)) - 8) = EMPTY THEN
                            move_is_legal_internal <= '1';
                        END IF;
                        -- diagonal capture
                    ELSIF (v_delta_pawn = 1 AND h_delta = 1 AND cursor_contents(3) = '0') THEN
                        move_is_legal_internal <= '1';
                    END IF;
                END IF;

            WHEN "010" => -- KNIGHT
                IF ((v_delta = 2 AND h_delta = 1) OR (v_delta = 1 AND h_delta = 2)) THEN
                    -- destination = empty or enemy
                    IF (cursor_contents = EMPTY OR cursor_contents(3) /= selected_piece_color) THEN
                        move_is_legal_internal <= '1';
                    END IF;
                END IF;

            WHEN "011" => -- BISHOP
                IF (v_delta = h_delta AND v_delta /= 0) THEN
                    IF is_path_clear(
                        start_x => to_integer(unsigned(selected_reg(2 DOWNTO 0))),
                        start_y => to_integer(unsigned(selected_reg(5 DOWNTO 3))),
                        end_x => to_integer(unsigned(cursor_reg(2 DOWNTO 0))),
                        end_y => to_integer(unsigned(cursor_reg(5 DOWNTO 3))),
                        board => board
                        ) AND (cursor_contents = EMPTY OR cursor_contents(3) /= selected_piece_color) THEN
                        move_is_legal_internal <= '1';
                    END IF;
                END IF;

            WHEN "100" => -- ROOK
                IF (v_delta = 0 OR h_delta = 0) AND (h_delta + v_delta /= 0) THEN
                    IF is_path_clear(
                        start_x => to_integer(unsigned(selected_reg(2 DOWNTO 0))),
                        start_y => to_integer(unsigned(selected_reg(5 DOWNTO 3))),
                        end_x => to_integer(unsigned(cursor_reg(2 DOWNTO 0))),
                        end_y => to_integer(unsigned(cursor_reg(5 DOWNTO 3))),
                        board => board
                        ) AND (cursor_contents = EMPTY OR cursor_contents(3) /= selected_piece_color) THEN
                        move_is_legal_internal <= '1';
                    END IF;
                END IF;

            WHEN "101" => -- QUEEN
                IF ((v_delta = h_delta AND v_delta /= 0) OR (v_delta = 0 AND h_delta /= 0) OR (h_delta = 0 AND v_delta /= 0)) THEN
                    IF is_path_clear(
                        start_x => to_integer(unsigned(selected_reg(2 DOWNTO 0))),
                        start_y => to_integer(unsigned(selected_reg(5 DOWNTO 3))),
                        end_x => to_integer(unsigned(cursor_reg(2 DOWNTO 0))),
                        end_y => to_integer(unsigned(cursor_reg(5 DOWNTO 3))),
                        board => board
                        ) AND (cursor_contents = EMPTY OR cursor_contents(3) /= selected_piece_color) THEN
                        move_is_legal_internal <= '1';
                    END IF;
                END IF;

            WHEN "110" => -- KING
                IF (v_delta <= 1 AND h_delta <= 1) THEN
                    -- destination = empty or enemy
                    IF (cursor_contents = EMPTY OR cursor_contents(3) /= selected_piece_color) THEN
                        move_is_legal_internal <= '1';
                    END IF;
                END IF;

            WHEN OTHERS =>
                move_is_legal_internal <= '0'; -- invalid piece
        END CASE;
    END PROCESS;

    PROCESS (selected_reg, board, player_to_move)
        VARIABLE local_king_count : INTEGER := 0;
    BEGIN
        HIGHLIGHT_SQUARES <= (OTHERS => '0');
        IF selected_reg /= (selected_reg'RANGE => '0') THEN -- check if a piece is selected
            FOR i IN 0 TO 63 LOOP
                -- HIGHIGHT LEGAL MOVES
                IF is_move_legal(selected_reg, STD_LOGIC_VECTOR(to_unsigned(i, 6)), board, player_to_move) THEN
                    HIGHLIGHT_SQUARES(i) <= '1';
                END IF;
                -- COUNT KINGS
                IF board(i)(2 DOWNTO 0) = "110" THEN
                    local_king_count := local_king_count + 1;
                END IF;

            END LOOP;
            -- check if fewer than two kings remain
            IF local_king_count < 2 THEN
                checkmate <= '1';
            ELSE
                checkmate <= '0';
            END IF;
        END IF;
    END PROCESS;

END Behavioral;