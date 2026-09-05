Library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity THERMO is
 port ( CURRENT_TEMP   : in std_logic_vector(6 downto 0);
	DESIRED_TEMP   : in std_logic_vector(6 downto 0);
	DISPLAY_SELECT : in std_logic; 
	COOL           : in std_logic;
	HEAT           : in std_logic;
	CLK	       : in std_logic;

	TEMP_DISPLAY   : out std_logic_vector (6 downto 0);
	A_C_ON         : out std_logic;
	FURNACE_ON     : out std_logic;
	
 );
 end THERMO;

architecture RTL of THERMO is

 signal CURRENT_TEMP_REG   : std_logic_vector(6 downto 0);
 signal DESIRED_TEMP_REG   : std_logic_vector(6 downto 0);
 signal DISPLAY_SELECT_REG : std_logic; 
 signal COOL_REG           : std_logic;
 signal HEAT_REG           : std_logic;
 signal TEMP_DISPLAY_REG   : std_logic_vector(6 downto 0);
 signal A_C_ON_REG         : std_logic;
 signal FURNACE_ON_REG     : std_logic;

begin
 
 DISPLAY_OUT: process(CURRENT_TEMP_REG, DESIRED_TEMP_REG, DISPLAY_SELECT_REG)
  begin
    if DISPLAY_SELECT_REG = '1' then
      TEMP_DISPLAY_REG <= CURRENT_TEMP_REG;
    else
      TEMP_DISPLAY_REG <= DESIRED_TEMP_REG;
    end if;
 end process DISPLAY_OUT;


 A_C: process(CURRENT_TEMP_REG, DESIRED_TEMP_REG, COOL_REG)
  begin
    if COOL_REG = '1' and CURRENT_TEMP_REG > DESIRED_TEMP_REG then
      A_C_ON_REG <= '1';
    else
      A_C_ON_REG <= '0';
    end if;
 end process A_C;


 FURNACE: process(CURRENT_TEMP_REG, DESIRED_TEMP_REG, HEAT_REG)
  begin
    if HEAT_REG = '1' and CURRENT_TEMP_REG < DESIRED_TEMP_REG then
      FURNACE_ON_REG <= '1';
    else
      FURNACE_ON_REG <= '0';
    end if;
 end process FURNACE;

IN_REG: process(CLK)
 begin
   if CLK'event and CLK = '1' then
     CURRENT_TEMP_REG <= CURRENT_TEMP;  
     DESIRED_TEMP_REG <= DESIRED_TEMP;
     DISPLAY_SELECT_REG <= DISPLAY_SELECT; 
     COOL_REG <= COOL;
     HEAT_REG <= HEAT;
   end if; 
 end process;

OUT_REG: process(CLK)
 begin
   if CLK'event and CLK = '1' then
     TEMP_DISPLAY <= TEMP_DISPLAY_REG;
     A_C_ON <= A_C_ON_REG;
     FURNACE_ON <= FURNACE_ON_REG;
   end if;
 end process;

end RTL;
