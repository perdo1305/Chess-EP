----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/21/2024 11:02:43 PM
-- Design Name: 
-- Module Name: chess_top - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity chess_top is
    Port (
        clk : in STD_LOGIC;          -- Clock signal
        reset : in STD_LOGIC;        -- Reset signal
        sw : in STD_LOGIC;           -- Input switch signal
        db_level : out STD_LOGIC;    -- Debounced switch level
        db_tick : out STD_LOGIC      -- Debounced switch tick
    );
end chess_top;

architecture Behavioral of chess_top is

    -- Internal signals for debounce connection
    signal sw_deb_level : STD_LOGIC;
    signal sw_deb_tick : STD_LOGIC;

    -- Component declaration
    component debounce
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            sw : in STD_LOGIC;
            db_level : out STD_LOGIC;
            db_tick : out STD_LOGIC
        );
    end component;

begin

    -- Instantiate debounce
    debounce_inst : debounce
        Port map (
            clk => clk,
            reset => reset,
            sw => sw,
            db_level => sw_deb_level,
            db_tick => sw_deb_tick
        );

    -- Assign internal signals to top-level ports
    db_level <= sw_deb_level;
    db_tick <= sw_deb_tick;

end Behavioral;