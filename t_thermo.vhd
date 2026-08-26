entity T_THERMO is

end T_THERMO;

architecture TEST of T_THERMO is

 component THERMO is
   port ( CURRENT_TEMP : in bit_vector(6 downto 0);
	DESIRED_TEMP   : in bit_vector(6 downto 0);
	DISPLAY_SELECT : in bit; 
	COOL           : in bit;
	HEAT           : in bit;

	TEMP_DISPLAY   : out bit_vector (6 downto 0);
	A_C_ON         : out bit;
	FURNACE_ON     : out bit
   );
 end component;

signal CURRENT_TEMP, DESIRED_TEMP     : bit_vector(6 downto 0);
signal DISPLAY_SELECT                 : bit;
signal TEMP_DISPLAY                   : bit_vector(6 downto 0);
signal COOL, HEAT, A_C_ON, FURNACE_ON : bit;


begin
 UUT: THERMO port map ( CURRENT_TEMP => CURRENT_TEMP,
		   DESIRED_TEMP => DESIRED_TEMP,
		   DISPLAY_SELECT => DISPLAY_SELECT,
		   TEMP_DISPLAY => TEMP_DISPLAY,
		   A_C_ON => A_C_ON,
		   HEAT => HEAT,
		   COOL => COOL,
		   FURNACE_ON => FURNACE_ON);

process
 begin
 
 CURRENT_TEMP <= "0000000";
 DESIRED_TEMP <= "1111111";
 DISPLAY_SELECT <= '0';
 wait for 10 ns;
 DISPLAY_SELECT <= '1';
 wait for 10 ns;
 HEAT <= '1';
 wait for 10 ns;
 HEAT <= '0';
 wait for 10 ns;
 CURRENT_TEMP <= "1000000";
 DESIRED_TEMP <= "0100000";
 wait for 10 ns;
 COOL <= '1';
 wait for 10 ns;
 COOL <= '0';
 wait for 10 ns;

 wait;
 end process;

end TEST;


