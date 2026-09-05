Library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity T_THERMO is

end T_THERMO;

architecture TEST of T_THERMO is

 component THERMO is
   port ( CURRENT_TEMP   : in std_logic_vector(6 downto 0);
	DESIRED_TEMP   : in std_logic_vector(6 downto 0);
	DISPLAY_SELECT : in std_logic; 
	COOL           : in std_logic;
	HEAT           : in std_logic;
	CLK	       : in std_logic;
	FURNACE_HOT    : in std_logic;
	AC_READY       : in std_logic;

	TEMP_DISPLAY   : out std_logic_vector (6 downto 0);
	AC_ON          : out std_logic;
	FURNACE_ON     : out std_logic;
	FAN_ON         : out std_logic	
 );
 end component;

signal CURRENT_TEMP, DESIRED_TEMP     : std_logic_vector(6 downto 0);
signal DISPLAY_SELECT                 : std_logic;
signal TEMP_DISPLAY                   : std_logic_vector(6 downto 0);
signal COOL, HEAT, AC_ON, FURNACE_ON : std_logic;
signal FURNACE_HOT, AC_READY, FAN_ON  : std_logic;
signal CLK                            : std_logic := '0';


begin

 CLK <= not CLK after 5 ns;

 UUT: THERMO port map ( CURRENT_TEMP => CURRENT_TEMP,
		   DESIRED_TEMP => DESIRED_TEMP,
		   DISPLAY_SELECT => DISPLAY_SELECT,
		   TEMP_DISPLAY => TEMP_DISPLAY,
		   AC_ON => AC_ON,
		   HEAT => HEAT,
		   COOL => COOL,
		   FURNACE_ON => FURNACE_ON,
		   FURNACE_HOT => FURNACE_HOT,
		   AC_READY => AC_READY,
		   FAN_ON => FAN_ON,
		   CLK => CLK);

process
 begin
 
 CURRENT_TEMP <= "0000000";
 DESIRED_TEMP <= "1111111";
 DISPLAY_SELECT <= '0';
 wait for 50 ns;
 DISPLAY_SELECT <= '1';
 wait for 50 ns;
 HEAT <= '1';
 wait for 50 ns;  -- should stay in HEATON
 FURNACE_HOT <= '1';
 wait for 50 ns;  -- changes to FURNACEHOTNOW
 HEAT <= '0';
 wait for 50 ns;
 FURNACE_HOT <= '0';  -- Should go back to IDLE state
 wait for 50 ns; 
 CURRENT_TEMP <= "1000000";
 DESIRED_TEMP <= "0100000";
 wait for 50 ns;
 COOL <= '1';
 wait for 50 ns; -- Changes to COOLON
 AC_READY <= '1';
 wait for 50 ns;
 COOL <= '0';
 wait for 50 ns;
 AC_READY <= '0';  -- back to IDLE
 wait for 50 ns;

 wait;
 end process;

end TEST;


