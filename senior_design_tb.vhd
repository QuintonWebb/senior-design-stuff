-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------
entity senior_design_tb is
	generic(
		sclk: time := 50 ns;
		epulse: time := 25 ns
	);
end entity;
-------------------------------------------------------------------------
architecture testbench of senior_design_tb is
	-------------------------------
			--DUT Declaration--
	-------------------------------
	component senior_design is
		generic(
			N: integer := 6
		);
		port(
			clk, en: in bit;
			ser_in: in bit_vector(N downto 0);
			par_out: out bit_vector(N downto 0)
		);
	end component;
	----------------------------------
			--Signal Declaration--
	----------------------------------
	signal a: bit := '0';	--clock bit
	signal b: bit := '0';	--enable bit
	signal c: bit_vector(6 downto 0);	--serial data
	signal d: bit_vector(6 downto 0);	--output string
	------------------------------------
			--Constant Declaration--
	------------------------------------
	constant N: integer := 6;
	------------------------------------
begin
	---------------------------------
			--DUT Instantiation--
	---------------------------------
	assignment: senior_design
	port map(
		clk => a,
		en => b,
		ser_in => c,
		par_out => d
	);
	--------------------------------
			--Clock Generation--
	--------------------------------
	process
	begin
		a <= '0';
		wait for sclk/2;
		a <= '1';
		wait for sclk/2;
	end process;
	---------------------------------
			--Enable Generation--
	---------------------------------
	process
	begin 
		wait for 350 ns;
		b <= '1';
		wait for epulse;
		b <= '0';
	end process;
	----------------------------------
			--Stimuli Generation--
	----------------------------------
	c <= "1010101",
		  "0101010" after 350 ns,
		  "1010101" after 350 ns,
		  "0101010" after 350 ns,
		  "1010101" after 350 ns,
		  "0101010" after 350 ns,
		  "0000000" after 350 ns,
		  "1000000" after 350 ns,
		  "1100000" after 350 ns,
		  "1110000" after 350 ns,
		  "0111000" after 350 ns,
		  "0011100" after 350 ns,
		  "0001110" after 350 ns,
		  "0000111" after 350 ns,
		  "0000011" after 350 ns,
		  "0000001" after 350 ns,
		  "0000000" after 350 ns,
		  "1010101" after 350 ns,
		  "0101010" after 350 ns,
		  "1010101" after 350 ns,
		  "0101010" after 350 ns,
		  "1010101" after 350 ns,
		  "0101010" after 350 ns;
end architecture;










---1n4148












