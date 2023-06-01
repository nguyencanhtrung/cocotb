library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity counter is
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        counter     : out std_logic_vector(6 downto 0)
    );
end entity;

architecture rtl of counter is
    signal counter_int : unsigned(6 downto 0) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter_int <= (others => '0');
            else
                counter_int <= counter_int + 1;
            end if;
        end if;
    end process;

    counter <= std_logic_vector(counter_int);
end architecture;