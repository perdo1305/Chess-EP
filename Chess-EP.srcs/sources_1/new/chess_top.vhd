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

ENTITY chess_top IS
    PORT (
        -- Clock and Reset
        ClkPort : IN STD_LOGIC; -- Board's 100MHz clock
        sw : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- For reset

        -- Buttons
        btnL : IN STD_LOGIC; -- Left
        btnU : IN STD_LOGIC; -- Up
        btnD : IN STD_LOGIC; -- Down
        btnR : IN STD_LOGIC; -- Right
        btnC : IN STD_LOGIC; -- Center

        -- VGA Signals
        vga_hsync : OUT STD_LOGIC;
        vga_vsync : OUT STD_LOGIC;

        vga_r : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        vga_g : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        vga_b : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

        -- LEDs
        led : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
END ENTITY chess_top;

ARCHITECTURE Behavioral OF chess_top IS

    -- Internal Signals
    SIGNAL Reset : STD_LOGIC;
    SIGNAL board_input : STD_LOGIC_VECTOR(255 DOWNTO 0);
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
    SIGNAL R : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL G : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL B : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    -- Assign reset signal
    Reset <= sw(0);

    -- Chess Logic Module
    chess_logic_inst : ENTITY work.chess_logic
        PORT MAP(
            CLK => ClkPort,
            RESET => Reset,
            BtnL => BtnL,
            BtnU => BtnU,
            BtnD => BtnD,
            BtnR => BtnR,
            BtnC => BtnC,
            board_input => board_input,
            board_out_addr => board_out_addr,
            board_out_piece => board_out_piece,
            board_change_en_wire => board_change_en,
            cursor_addr => cursor_addr,
            selected_addr => selected_addr,
            hilite_selected_square => hilite_selected,
            state => state,
            move_is_legal => move_is_legal,
            is_in_initial_state => is_initial
        );

    -- Display Interface Module
    display_interface_inst : ENTITY work.display_interface
        PORT MAP(
            clk => ClkPort,
            reset => Reset,
            BOARD => board_input,
            CURSOR_ADDR => cursor_addr,
            SELECT_ADDR => selected_addr,
            SELECT_EN => board_change_en,

            Hsync => vga_hsync,
            Vsync => vga_vsync,
            R => R,
            G => G,
            B => B
        );

    -- Map RGB signals to VGA outputs
    vga_r <= R(0) & R(1) & R(2) & R(3);
    vga_g <= G(0) & G(1) & G(2) & G(3);
    vga_b <= B(0) & B(1) & B(2) & B(3);

    -- debug LEDs
    led(0) <= is_initial;
    led(1) <= move_is_legal;
    led(2) <= state(0);
    led(3) <= state(1);
    led(4) <= state(2);

    -- place pieces on the board on initial state
    PROCESS (Clock, Reset)
    BEGIN
        IF Reset = '1' THEN
            board_input <= (OTHERS => '0');
        ELSE
            IF board_change_en = '1' THEN
                board_input(unsigned(board_out_addr)) <= board_out_piece;
            END IF;
            IF is_initial = '1' THEN
                --hardcoded initial board state
                board_input(63 DOWNTO 56) <= "0000"; -- Black
                board_input(55 DOWNTO 48) <= "0001"; -- Black
                board_input(47 DOWNTO 40) <= "0000"; -- Empty
                board_input(39 DOWNTO 32) <= "0000"; -- Empty
                board_input(31 DOWNTO 24) <= "0000"; -- Empty
                board_input(23 DOWNTO 16) <= "0000"; -- Empty
                board_input(15 DOWNTO 8) <= "1001"; -- White
                board_input(7 DOWNTO 0) <= "0000"; -- White
                
                END IF;
            END PROCESS;
        END ARCHITECTURE Behavioral;