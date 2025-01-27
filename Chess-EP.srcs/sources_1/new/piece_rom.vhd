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
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00011000",
        "00111100",
        "01111110",
        "01111110",

        -- Knight (010)
        "00011000",
        "01111100",
        "11111110",
        "11101111",
        "00000111",
        "00011111",
        "00111111",
        "01111110",

        -- Bishop (011)
        "00000000",
        "00011000",
        "00111100",
        "00111100",
        "00011000",
        "00011000",
        "00111100",
        "11100111",

        -- Rook (100)
        "00000000",
        "01011010",
        "01111110",
        "00111100",
        "00011000",
        "00011000",
        "00111100",
        "01111110",

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