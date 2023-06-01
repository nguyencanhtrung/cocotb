library ieee;
    use ieee.std_logic_1164.all;

entity counter_wrapper is
    port(
        clk : in std_logic;
        rst : in std_logic;
        count : out std_logic_vector(6 downto 0)
    );
end counter_wrapper;

architecture rtl of counter_wrapper is
    component counter is
        port(
            clk : in std_logic;
            rst : in std_logic;
            count : out std_logic_vector(6 downto 0)
        );
    end component;
begin 
    counter_inst : counter
        port map(
            clk => clk,
            rst => rst,
            count => count
        );
end architecture;