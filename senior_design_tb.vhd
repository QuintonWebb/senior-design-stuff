-------------------------------------------------------------------------
	---------------------------------------------
			--Library & Package Declaration--
	---------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------
entity senior_design_tb is
	generic(
		sclk: time := 50 ns	--This will be the period of our clock
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
			par_out: buffer bit_vector(N downto 0);
			par_bits: in bit_vector(N downto 0);
			bit_disp: out bit_vector(N downto 0)
		);
	end component;
	----------------------------------
			--Signal Declaration--
	----------------------------------
	signal clk: bit := '0';	--clock bit
	signal serial_in: bit_vector(6 downto 0); --input data
	signal parralel_out: bit_vector(6 downto 0);	--output data
	signal parralel_mirror: bit_vector(6 downto 0); --input mirror
	signal enable: bit := '0'; --enable bit
	signal bit_0: bit := '0';
	signal bit_1: bit := '0';
	signal bit_2: bit := '0';
	signal bit_3: bit := '0';
	signal bit_4: bit := '0';
	signal bit_5: bit := '0';
	signal bit_6: bit := '0';
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
		clk => clk,
		ser_in => serial_in,
		bit_disp(0) => bit_6,
		bit_disp(1) => bit_5,
		bit_disp(2) => bit_4,
		bit_disp(3) => bit_3,
		bit_disp(4) => bit_2,
		bit_disp(5) => bit_1,
		bit_disp(6) => bit_0,
		par_bits => parralel_mirror,
		par_out => parralel_out,
		en => enable
	);
	--------------------------------
			--Clock Generation--
	--------------------------------
	process
	begin
		clk <= '0';
		wait for sclk/2;
		clk <= '1';
		wait for sclk/2;
	end process;
	----------------------------------
			--Stimuli Generation--
	----------------------------------
	serial_in <= "1011001";
	parralel_mirror <= "1011001";
	enable <= '0',
		  '1' after 385 ns,
		  '0' after 395 ns;
end architecture;




















