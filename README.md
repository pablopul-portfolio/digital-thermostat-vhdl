# Digital Thermostat — VHDL

A simple VHDL implementation of a digital thermostat, built as a synchronous state machine that controls the furnace, AC, and fan based on the current temperature, desired temperature, and selected mode (heat/cool).

## Features

- Heating and cooling control based on comparing current vs. desired temperature
- Synchronous, clock-driven finite state machine (FSM)
- Automatic fan run-on period after heating/cooling stops
- 10-cycle furnace cooldown and 20-cycle AC cooldown
- Selectable temperature display (current or desired)
- Includes a testbench for simulation

## Files

- `thermo.vhd` - the thermostat design
- `t_thermo.vhd` - testbench for simulation

## How it works

The design compares the current temperature to the desired temperature and, depending on whether `HEAT` or `COOL` is active, activates the furnace or AC.

Once the temperature demand is no longer present, the system does not immediately return to `IDLE`. Instead, the fan continues running for a predefined cooldown period:

- **Heating:** 10 clock cycles
- **Cooling:** 20 clock cycles

The design also includes a temperature display that shows either the current or desired temperature, selected through `DISPLAY_SELECT`.

## The State Machine

The thermostat remains in `IDLE` until heating or cooling is required.

### Heating path

`IDLE → HEATON → FURNACENOWHOT → FURNACECOOL → IDLE`

- `HEATON` — waits for the furnace to become hot
- `FURNACENOWHOT` — furnace and fan are running while heating is required
- `FURNACECOOL` — furnace is off, but the fan continues running for 10 clock cycles

### Cooling path

`IDLE → COOLON → ACNOWREADY → ACDONE → IDLE`

- `COOLON` — waits for the AC to become ready
- `ACNOWREADY` — AC and fan are running while cooling is required
- `ACDONE` — AC is off, but the fan continues running for 20 clock cycles

The state machine ensures that the furnace and AC cannot be immediately restarted during their respective cooldown periods.