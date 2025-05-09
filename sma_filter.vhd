----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.05.2025 17:11:16
-- Design Name: 
-- Module Name: sma_filter - Behavioral
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sma_filter is
    generic (
        N     : integer := 4;
        WIDTH : integer := 8
    );
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        din  : in  std_logic_vector(WIDTH-1 downto 0);
        load : in  std_logic;
        dout : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture rtl of sma_filter is
    type data_array is array (0 to N-1) of unsigned(WIDTH-1 downto 0);
    signal buff : data_array := (others => (others => '0'));
    signal sum    : unsigned(WIDTH+3 downto 0) := (others => '0');  -- extra bits para evitar overflow
    signal count  : integer range 0 to N := 0;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                buff <= (others => (others => '0'));
                sum    <= (others => '0');
                count  <= 0;
                dout   <= (others => '0');

            elsif load = '1' then
                -- Quitamos el valor más antiguo y añadimos el nuevo
                sum <= sum - buff(0) + unsigned(din);

                -- Desplazamos los valores hacia la izquierda
                for i in 0 to N-2 loop
                    buff(i) <= buff(i+1);
                end loop;
                buff(N-1) <= unsigned(din);

                -- Incrementamos el contador hasta N
                if count < N then
                    count <= count + 1;
                end if;

                -- Calculamos promedio si ya tenemos N muestras
                if count = N then
                    dout <= std_logic_vector(sum / to_unsigned(N, sum'length));
                end if;
            end if;
        end if;
    end process;

end architecture;