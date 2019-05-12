--Senior Design 2019: Pulse Gauntlet- Octave Circuit Simulation
--University of Texas at Arlington
--Quinton Webb, 1000849036

--The code seen here is written in VHDL and is used for simulation purposes;
--this could be synthesizable, but a microcontroller will be used instead of
--an FPGA to cut costs and due to them being smaller.

--This code simulates the behavior of the SIPO w/ latch circuit that will
--serve as the octaves of our gauntlet. The final design will use 5 of these 
--circuits, but simulating more than one is unnecessary since they all behave
--the same way while having a synchronous clock and latch enable signals.

--The system will take in a "note code" which is a seven bit code with its MSB
--corresponding to note A and the LSB corresponding to note G for a particular
--octave. SIPO refers to serial input, parallel output in which a code is
--serially shifted into the flip-flops and output in parallel through the
--d latches. The flip-flops act as a sort of buffer: after seven rising edges
--of the clock, all flip-flops will have a single bit from the note code stored
-- in them and the latches are triggered to capture and hold them for the motors.

--A testbench and associated test vectors will be provided to generate a waveform
--to show how the system functions and to highlight how the bits are shifted out.
--It'll be titled "senior_design_tb" and should be placed in the same directory
--folder as this file. The program used to develop this code is Altera Quartus
--Prime Lite and the simulation was done in ModelSim

-----------------------------------------------------------------------
	---------------------------------------------
			--Library & Package Declaration--
	---------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------------------------------
	-----------------------------------
			--SIPO Shift Register--
	-----------------------------------
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
	-----------------------------
			--Gated D Latch--
	-----------------------------
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
	-------------------------
			--Main Code--
	-------------------------
entity senior_design is

	--Constant Declarations--
	generic(
		N: integer := 6
	);
	
	--I/O Signal Declaration--
	port(
		--User Input & Output Signals--
		clk, en: in bit;	--clock & enable signals for the SR and latches respectively
		ser_in: in bit_vector(N downto 0);	--User-defined note code
		par_out: out bit_vector(N downto 0);	--Note code output; would go to the motors
		
		--Testbench Display Signals--
		--These I/O Declarations are here to aid in visualizing bit-shifting in the testbench waveform
		par_bits: in bit_vector(N downto 0);	--Mirrors the ser_in signal
		bit_disp: buffer bit_vector(N downto 0)	--Output signal for the bit-shift display
	);
end entity;
-----------------------------------------------------------------------
architecture motor_array of senior_design is
	-------------------------------------
			--Signals And Variables--
	-------------------------------------
	signal curr_bit: bit := ser_in(N);	--Looks at the current bit to be shifted
	signal SIPO_out: bit_vector(N downto 0);	--Buffer between the SIPO SR and the latches
	signal bit_sel: bit := '0';	--
	-------------------------------------
			--Component Declaration--
	-------------------------------------
	
	--SIPO Shift Register--
	component SIPO is
		PORT(
			clk, d: in bit;
			q: buffer bit_vector(N downto 0)
		);
	end component;
	
	--Gated D Latch--
	component d_latch is
		port(
			d, ena: in bit;
			q: out bit
		);
	end component;	
-------------------------------------------------------
begin
	---------------------------------------
			--Component Instantiation--
	---------------------------------------
	
	--SIPO Shift Register--
	SIPO_reg: SIPO port map (clk => clk, 
									d => curr_bit, 
									q => SIPO_out);
	
	--D_latch--
	latch: for i in N downto 0 generate
		shift_latch: d_latch port map (d => SIPO_out(i),
												 ena => en,
												 q => par_out(i));
	end generate latch;
	----------------------------------------------------
	--------------------------------
			--Internal Processes--
	--------------------------------
	
	--Circular SIPO Shifter--
	--Checks the status of the variable count at every rising edge and exhibits
	--one of two behaviors:
	
	--		1. Increment if count<6
	--		2. Set count = 0 if count = 6
	
	--The reset causes the system to return to the initial state of the FSM and
	--causes curr_bit to observe the MSB of curr_bit. This causes the SIPO 
	--component to circularly shift out note codes.
	
	serial_shift: process(clk)
		variable count: natural range 0 to N := 0;
	begin
		if (clk'event and clk='1' and count = 0) then
			curr_bit <= ser_in(N);
			count := count + 1;
		elsif (clk'event and clk='1' and count = 1) then
			curr_bit <= ser_in(5);
			count := count + 1;
		elsif (clk'event and clk='1' and count = 2) then
			curr_bit <= ser_in(4);
			count := count + 1;
		elsif (clk'event and clk='1' and count = 3) then
			curr_bit <= ser_in(2);
			count := count + 1;
		elsif (clk'event and clk='1' and count = 4) then
			curr_bit <= ser_in(1);
			count := count + 1;
		elsif (clk'event and clk='1' and count = 5) then
			curr_bit <= ser_in(1);
			count := count + 1;
		elsif (clk'event and clk='1' and count = 6) then
			curr_bit <= ser_in(0);
			count := 0;
		end if;
	end process serial_shift;
	
	--Testbench Display Aid--
	--Another simple FSM designed to make observing the bit-shifting
	--easier. You'll be able to see each bit within the register change
	--before the latches capture them.
	
	--This is strictly for the testbench generated waveform and does not
	--affect the behavior of the octave circuitry.
	
	bit_wise: process(clk)
		variable counter1: natural range 0 to N := 0;
	begin
		if (clk'event and clk = '1') then
			bit_sel <= par_bits(counter1);
			bit_disp(0) <= bit_sel;
			bit_disp(N downto 1) <= bit_disp(5 downto 0);
			if (counter1 < N) then
				counter1 := counter1 + 1;
			elsif (counter1 >= N) then
				counter1 := 0;
			end if;
		end if;
	end process bit_wise;
	----------------------------------------------------
end architecture;
-----------------------------------------------------------------------


















