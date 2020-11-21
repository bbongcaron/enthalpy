# Enthalpy
***Author: Brenton Bongcaron***  

**Brief Description:** Calculate the enthalpy of a component using steam tables or a data spreadsheet of heat capacity coefficients  

**Details:**  
This program uses either steam tables (Tables 9.5-9.9) or heat capacity coefficients (Table 9.11) from zyBooks 14:155:201
and a user-inputted reference temperature, actual temperature, state, and possibly pressure (for water pressure tables) through
a GUI to determine the enthalpy of the component at the given conditions.  
  
The enthalpy is determined by 1 of 2 algorithms:  
  - If the component is water, reference temperature will be set to 0.01°C. Then using 2 of 3 given information variables  
    (tempertaure/pressure/state), enthalpy will be looked up in a steam table.
  - If the component is not water, heat capacity coefficients will be looked up in the given heat capacity spreadsheet.  
    Heat capacity is then integrated, with respect to temperature, from the reference temperature to the actual temperature.  
   
**Error Handling:**  
Heat capacity data in the spreadsheet is only valid within certain temperature ranges. Implementation of this check is coming soon.  

**Equations Used:**  
h = ∫Cp dT
  - Cp = heat capacity (at constant pressure)
  - h = specific enthalpy  
  - T = temperature  
  
Cp = a + bT + cT^2 + dT^3
  - a, b, c & d are coefficients according to the component
  - Cp = heat capacity (at constant pressure)
  - T = temperature
