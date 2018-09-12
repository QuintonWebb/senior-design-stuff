------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
------------------------------------------------------------------------------------
ENTITY decoder IS
	PORT(
		addr_in: IN BIT_VECTOR (2 DOWNTO 0);
		x: OUT BIT_VECTOR(7 DOWNTO 0)
	);
END ENTITY;
------------------------------------------------------------------------------------
ARCHITECTURE decoder OF decoder IS
BEGIN
	PROCESS (addr_in)
	BEGIN
		CASE addr_in IS
			WHEN "111" => x<="10000000";
			WHEN "110" => x<="01000000";
			WHEN "101" => x<="00100000";
			WHEN "100" => x<="00010000";
			WHEN "011" => x<="00001000";
			WHEN "010" => x<="00000100";
			WHEN "001" => x<="00000010";
			WHEN "000" => x<="00000001";
		END CASE;
	END PROCESS;
END ARCHITECTURE;
------------------------------------------------------------------------------------
ENTITY flip_flop IS
	PORT(
		d: IN BIT_VECTOR (2 DOWNTO 0);
		clk: IN BIT;
		q: OUT BIT_VECTOR (2 DOWNTO 0)
	);
END ENTITY;
------------------------------------------------------------------------------------
ARCHITECTURE ff_comp OF flip_flop IS
BEGIN
	PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk='1') THEN
			q <= d;
		END IF;
	END PROCESS;
END ARCHITECTURE;
------------------------------------------------------------------------------------
ENTITY soundless_headphones IS
	GENERIC(
		N: INTEGER := 2;
		M: INTEGER := 4
	);
	PORT(
		clk: IN BIT;
		bit_in: IN BIT_VECTOR (14 DOWNTO 0);
		note_1, note_2, note_3, note_4, note_5: OUT BIT_VECTOR (7 DOWNTO 0)
	);
END ENTITY;
------------------------------------------------------------------------------------
ARCHITECTURE circuit OF soundless_headphones IS
	-------------------------------------------------
	SIGNAL octave_1, octave_2, octave_3, octave_4, octave_5: BIT_VECTOR(2 DOWNTO 0);
	-------------------------------------------------
	COMPONENT decoder IS
		PORT(
			addr_in: IN BIT_VECTOR (2 DOWNTO 0);
			x: OUT BIT_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;
	-------------------------------------------------
	COMPONENT flip_flop IS
		PORT(
			d: IN BIT_VECTOR (2 DOWNTO 0);
			clk: IN BIT;
			q: OUT BIT_VECTOR (2 DOWNTO 0)
		);
	END COMPONENT;
	-------------------------------------------------
BEGIN
	------------------------------------------------------------------------------
	motor_driver_1: decoder PORT MAP (octave_1, note_1);
	motor_driver_2: decoder PORT MAP (octave_2, note_2);
	motor_driver_3: decoder PORT MAP (octave_3, note_3);
	motor_driver_4: decoder PORT MAP (octave_4, note_4);
	motor_driver_5: decoder PORT MAP (octave_5, note_5);
	------------------------------------------------------------------------------
	parallel_shift_1: flip_flop PORT MAP (bit_in(2 DOWNTO 0), clk, octave_1);
	parallel_shift_2: flip_flop PORT MAP (bit_in(5 DOWNTO 3), clk, octave_2);
	parallel_shift_3: flip_flop PORT MAP (bit_in(8 DOWNTO 6), clk, octave_3);
	parallel_shift_4: flip_flop PORT MAP (bit_in(11 DOWNTO 9), clk, octave_4);
	parallel_shift_5: flip_flop PORT MAP (bit_in(14 DOWNTO 12), clk, octave_5);
	------------------------------------------------------------------------------
END ARCHITECTURE;
------------------------------------------------------------------------------------

















