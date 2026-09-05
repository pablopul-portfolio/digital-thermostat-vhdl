Library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity THERMO is
 port ( CURRENT_TEMP   : in std_logic_vector(6 downto 0);
	DESIRED_TEMP   : in std_logic_vector(6 downto 0);
	DISPLAY_SELECT : in std_logic; 
	COOL           : in std_logic;
	HEAT           : in std_logic;
	CLK	       : in std_logic;
	FURNACE_HOT    : in std_logic;
	AC_READY       : in std_logic;

	TEMP_DISPLAY   : out std_logic_vector (6 downto 0);
	AC_ON         : out std_logic;
	FURNACE_ON     : out std_logic;
	FAN_ON         : out std_logic	
 );

 end THERMO;

architecture RTL of THERMO is
 type STATE_TYPE is (IDLE, HEATON, FURNACENOWHOT, FURNACECOOL, COOLON, ACNOWREADY, ACDONE);

 signal CURRENT_STATE : STATE_TYPE;
 signal NEXT_STATE : STATE_TYPE;

 signal CURRENT_TEMP_REG   : std_logic_vector(6 downto 0);
 signal DESIRED_TEMP_REG   : std_logic_vector(6 downto 0);
 signal DISPLAY_SELECT_REG : std_logic; 
 signal COOL_REG           : std_logic;
 signal HEAT_REG           : std_logic;
 signal TEMP_DISPLAY_REG   : std_logic_vector(6 downto 0);
 signal AC_ON_REG          : std_logic;
 signal FURNACE_ON_REG     : std_logic;
 signal FURNACE_HOT_REG    : std_logic;
 signal AC_READY_REG       : std_logic;
 signal FAN_ON_REG         : std_logic;

begin
 
 DISPLAY_OUT: process(CURRENT_TEMP_REG, DESIRED_TEMP_REG, DISPLAY_SELECT_REG)
  begin
    if DISPLAY_SELECT_REG = '1' then
      TEMP_DISPLAY_REG <= CURRENT_TEMP_REG;
    else
      TEMP_DISPLAY_REG <= DESIRED_TEMP_REG;
    end if;
 end process DISPLAY_OUT;


IN_REG: process(CLK)
 begin
   if CLK'event and CLK = '1' then
     CURRENT_TEMP_REG <= CURRENT_TEMP;  
     DESIRED_TEMP_REG <= DESIRED_TEMP;
     DISPLAY_SELECT_REG <= DISPLAY_SELECT; 
     COOL_REG <= COOL;
     HEAT_REG <= HEAT;
     FURNACE_HOT_REG <= FURNACE_HOT;
     AC_READY_REG <= AC_READY;
   end if; 
 end process;

OUT_REG: process(CLK)
 begin
   if CLK'event and CLK = '1' then
     TEMP_DISPLAY <= TEMP_DISPLAY_REG;
     AC_ON <= AC_ON_REG;
     FURNACE_ON <= FURNACE_ON_REG;
     FAN_ON <= FAN_ON_REG;
   end if;
 end process;

STM_CLK: process(CLK)
 begin
   if CLK'event and CLK = '1' then
     CURRENT_STATE <= NEXT_STATE;
   end if;
 end process;

STM_LOGIC: process(CURRENT_STATE, HEAT_REG, COOL_REG, CURRENT_TEMP_REG, DESIRED_TEMP_REG, FURNACE_HOT_REG, AC_READY_REG)    -- process for the logic of the state machine
 begin
   case CURRENT_STATE is
     when IDLE =>
       if HEAT_REG = '1' and CURRENT_TEMP_REG < DESIRED_TEMP_REG then
         NEXT_STATE <= HEATON;
       elsif COOL_REG = '1' and CURRENT_TEMP_REG > DESIRED_TEMP_REG then
         NEXT_STATE <= COOLON;
       else 
	 NEXT_STATE <= IDLE;
       end if;

     when HEATON =>
       if FURNACE_HOT_REG = '1' then
	 NEXT_STATE <= FURNACENOWHOT;
       else
	 NEXT_STATE <= HEATON; 
       end if;

     when FURNACENOWHOT =>
       if not(HEAT_REG = '1' and CURRENT_TEMP_REG < DESIRED_TEMP_REG) then
         NEXT_STATE <= FURNACECOOL;
       else 
	 NEXT_STATE <= FURNACENOWHOT;
       end if;

     when FURNACECOOL =>
       if FURNACE_HOT_REG = '0' then 
         NEXT_STATE <= IDLE;
       else
	 NEXT_STATE <= FURNACECOOL;
       end if;

     when COOLON =>
       if AC_READY_REG = '1' then
	 NEXT_STATE <= ACNOWREADY;
       else
	 NEXT_STATE <= COOLON;
       end if;

     when ACNOWREADY =>
       if not(COOL_REG = '1' and CURRENT_TEMP_REG > DESIRED_TEMP_REG) then
	 NEXT_STATE <= ACDONE;
       else
	 NEXT_STATE <= ACNOWREADY;
       end if;

     when ACDONE =>
       if AC_READY_REG = '0' then
	 NEXT_STATE <= IDLE;
       else
	 NEXT_STATE <= ACDONE;
       end if;

     when others =>
       NEXT_STATE <= IDLE;
   end case;
 end process;

STATES_OUTPUT: process(CURRENT_STATE)
 begin
 
 case CURRENT_STATE is
   when IDLE =>
     FURNACE_ON_REG <= '0';
     AC_ON_REG <= '0';
     FAN_ON_REG <= '0';

   when HEATON =>
     FURNACE_ON_REG <= '1';
     AC_ON_REG <= '0';
     FAN_ON_REG <= '0';

   when FURNACENOWHOT =>
     FURNACE_ON_REG <= '1';
     AC_ON_REG <= '0';
     FAN_ON_REG <= '1';

   when FURNACECOOL =>
     FURNACE_ON_REG <= '0';
     AC_ON_REG <= '0';
     FAN_ON_REG <= '1';

   when COOLON =>
     FURNACE_ON_REG <= '0';
     AC_ON_REG <= '1';
     FAN_ON_REG <= '0';

   when ACNOWREADY =>
     FURNACE_ON_REG <= '0';
     AC_ON_REG <= '1';
     FAN_ON_REG <= '1';

   when ACDONE =>
     FURNACE_ON_REG <= '0';
     AC_ON_REG <= '0';
     FAN_ON_REG <= '1';

   when others =>
     FURNACE_ON_REG <= '0';
     AC_ON_REG <= '0';
     FAN_ON_REG <= '0';

   end case;
end process;


end RTL;
