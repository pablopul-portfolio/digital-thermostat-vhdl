
-- The thermostat works with a MUX

entity THERMO is
 port ( CURRENT_TEMP   : in bit_vector(6 downto 0);
	DESIRED_TEMP   : in bit_vector(6 downto 0);
	DISPLAY_SELECT : in bit; 
	COOL           : in bit;
	HEAT           : in bit;

	TEMP_DISPLAY   : out bit_vector (6 downto 0);
	A_C_ON         : out bit;
	FURNACE_ON     : out bit
 );
 end THERMO;

architecture RTL of THERMO is
begin
 
 DISPLAY_OUT: process(CURRENT_TEMP,DESIRED_TEMP,DISPLAY_SELECT)
  begin
    if DISPLAY_SELECT = '1' then
      TEMP_DISPLAY <= CURRENT_TEMP;
    else
      TEMP_DISPLAY <= DESIRED_TEMP;
    end if;
 end process DISPLAY_OUT;


 A_C: process(CURRENT_TEMP, DESIRED_TEMP, COOL)
  begin
    if COOL = '1' and CURRENT_TEMP > DESIRED_TEMP then
      A_C_ON <= '1';
    else
      A_C_ON <= '0';
    end if;
 end process A_C;


 FURNACE: process(CURRENT_TEMP, DESIRED_TEMP, HEAT)
  begin
    if HEAT = '1' and CURRENT_TEMP < DESIRED_TEMP then
      FURNACE_ON <= '1';
    else
      FURNACE_ON <= '0';
    end if;
 end process FURNACE;

end RTL;
