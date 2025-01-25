LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY piece_rom IS
    PORT (
        clk : IN STD_LOGIC;
        piece_type : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3-bit piece type
        row_addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- 0-7 (8 rows)
        pixel_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- 8 pixels/row
    );
END piece_rom;

ARCHITECTURE arch OF piece_rom IS
    CONSTANT ADDR_WIDTH : INTEGER := 6; -- 64 entries (8 types x 8 rows)
    TYPE rom_type IS ARRAY (0 TO 2 ** ADDR_WIDTH - 1)
    OF STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- Universal piece patterns (color-agnostic)
    CONSTANT ROM : rom_type := (
        -- Pawn (001)
        "00111100", -- 0:   ****  
        "01111110", -- 1:  ******
        "01111110", -- 2:  ******
        "00111100", -- 3:   ****  
        "00111100", -- 4:   ****  
        "01111110", -- 5:  ******
        "11111111", -- 6: ********
        "01111110", -- 7:  ******

        -- Knight (010)
        "00011100", -- 0:    ***
        "00111110", -- 1:   *****
        "01111111", -- 2:  *******
        "11111111", -- 3: ********
        "11111100", -- 4: ******  
        "11111000", -- 5: *****   
        "01111100", -- 6:  ***** 
        "00111100", -- 7:   ****

        -- Bishop (011)
        "00111100", -- 0:   ****
        "01111110", -- 1:  ******
        "01111110", -- 2:  ******
        "00111100", -- 3:   ****
        "00111100", -- 4:   ****
        "01111110", -- 5:  ******
        "01111110", -- 6:  ******
        "00111100", -- 7:   ****

        -- Rook (100)
        "11100111", -- 0: ***  ***
        "11111111", -- 1: ********
        "11111111", -- 2: ********
        "01100110", -- 3:  **  **
        "01100110", -- 4:  **  **
        "11111111", -- 5: ********
        "11111111", -- 6: ********
        "11100111", -- 7: ***  ***

        -- Queen (101)
        "00011000", -- 0:    **
        "00111100", -- 1:   ****
        "01111110", -- 2:  ******
        "11111111", -- 3: ********
        "11111111", -- 4: ********
        "01111110", -- 5:  ******
        "00111100", -- 6:   ****
        "00011000", -- 7:    **

        -- King (110)
        "00011000", -- 0:    **
        "00111100", -- 1:   ****
        "01111110", -- 2:  ******
        "11111111", -- 3: ********
        "11111111", -- 4: ********
        "00111100", -- 5:   ****
        "00111100", -- 6:   ****
        "00011000", -- 7:    **

        OTHERS => (OTHERS => '0')
    );

    SIGNAL addr_reg : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            addr_reg <= piece_type & row_addr;
        END IF;
    END PROCESS;

    pixel_data <= ROM(to_integer(unsigned(addr_reg)));
END arch;