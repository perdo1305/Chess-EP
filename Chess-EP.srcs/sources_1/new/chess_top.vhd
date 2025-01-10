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

library types_pkg;
use types_pkg.types_pkg.all;

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
        Hsync : OUT STD_LOGIC;
        Vsync : OUT STD_LOGIC;

        R : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        G : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        B : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

        -- LEDs
        led : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
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
            CLK => ClkPort,
            RESET => Reset,
            BtnL => BtnL,
            BtnU => BtnU,
            BtnD => BtnD,
            BtnR => BtnR,
            BtnC => BtnC,
            board_input => board,
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
            BOARD => board,
            CURSOR_ADDR => cursor_addr,
            SELECT_ADDR => selected_addr,
            SELECT_EN => board_change_en,

            Hsync => Hsync,
            Vsync => Vsync,
            R => R,
            G => G,
            B => B
        );

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