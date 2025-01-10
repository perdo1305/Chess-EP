----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/22/2024 09:39:49 PM
-- Design Name: 
-- Module Name: types_pkg - Behavioral
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

PACKAGE types_pkg IS
    -- Define the custom type
    TYPE board_input IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
END PACKAGE types_pkg;

PACKAGE BODY types_pkg IS
    -- If you need to define functions, procedures, or constants, add them here
END PACKAGE BODY types_pkg;


