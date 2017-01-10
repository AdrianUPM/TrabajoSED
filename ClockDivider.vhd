
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity ClockDivider is
generic(divisor: integer);-- factor reduccion frecuencia de salida 
port ( clk: in std_logic;--Reloj Entrada
		 clock_out: out std_logic);-- Reloj de Salida
end ClockDivider;
 
architecture bhv of ClockDivider is
 
signal count: integer:=0; 
signal tmp : std_logic := '1';--signal auxiliar por no poder leer la salida
 
begin
 
process(clk)
begin
if(clk'event and clk='1') then
count <=count+1;
if (count >= (divisor/2) ) then
tmp <= NOT tmp;
count <= 0;
end if;
end if;
clock_out <= tmp;
end process;
 
end bhv;