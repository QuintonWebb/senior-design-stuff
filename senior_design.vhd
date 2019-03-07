-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------------------------------
entity SIPO is
	generic(
		N: integer := 6
	);
	PORT(
		clk, d: in bit;
		q: buffer bit_vector(N downto 0)
	);
end entity;
-----------------------------------------------------------------------
architecture flip_flop of SIPO is
begin
	process(clk)
	begin
		if (clk'event and clk='1') then
			q(N downto 1) <= q(N-1 downto 0);
			q(0) <= d;
		end if;
	end process;
end architecture;
-----------------------------------------------------------------------
entity d_latch is
	port(
		d, ena: in bit;
		q: out bit
	);
end entity;
-----------------------------------------------------------------------
architecture latch_en of d_latch is
begin
	process(ena)
	begin
		if (ena'event and ena='1') then
			q <= d;
		end if;
	end process;
end architecture;
-----------------------------------------------------------------------
entity senior_design is
	generic(
		N: integer := 6
	);
	port(
		clk, en: in bit;
		ser_in: in bit_vector(N downto 0);
		par_out: out bit_vector(N downto 0)
	);
end entity;
-----------------------------------------------------------------------
architecture motor_array of senior_design is
	-------------------------------------
			--Signals And Variables--
	-------------------------------------
	signal curr_bit: bit;
	signal SIPO_out: bit_vector(6 downto 0);
	-------------------------------------
			--Component Declaration--
	-------------------------------------
	--SIPO Shift R
	component SIPO is
		PORT(
			clk, d: in bit;
			q: buffer bit_vector(N downto 0)
		);
	end component;
	-----------------------------------
	component d_latch is
		port(
			d, ena: in bit;
			q: out bit
		);
	end component;
	-----------------------------------
	
	------------------------------------
			--Function Declaration--
	------------------------------------
	--Rising Edge Function
	function r_edge (signal s: bit) return boolean is
	begin
		return(s'event and s='1');
	end function r_edge;
	-------------------------------------------------
	--Falling Edge Function
	function f_edge (signal s: bit) return boolean is
	begin
		return(s'event and s='0');
	end function f_edge;
	-------------------------------------------------
begin
	---------------------------------------
			--Component Instantiation--
	---------------------------------------
	--SIPO Shift Register Instantiation
	SIPO_reg: SIPO port map (clk => clk, 
									d => curr_bit, 
									q => SIPO_out);
	----------------------------------------------------
	--D_latch Instantiation
	latch: for i in N downto 0 generate
		shift_latch: d_latch port map (d => SIPO_out(i),
												  ena => en,
												  q => par_out(i));
	end generate latch;
	----------------------------------------------------
	serial_shift: process(clk)
		variable count: natural range 0 to 7 := 0;
	begin
		if (r_edge(clk)) then
			curr_bit <= ser_in(count);
			count := count + 1;
			if (count = 7) then
				count := 0;
			end if;
		end if;
	end process serial_shift;
end architecture;
-----------------------------------------------------------------------


















