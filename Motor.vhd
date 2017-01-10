
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity Motor is
	 Generic(num_vueltas:positive:=2);--numero de vueltas para aumentar un led del ascensor
    Port ( encendido : in  STD_LOGIC;--motor ON/OFF
           clk : in  STD_LOGIC;--clk auxiliar para poder funcionar el bloque
           vuelta_completa : out  STD_LOGIC;--pulso para aumentar 1 los leds del ascensor
           pulso_motor : out  STD_LOGIC);--frecuencia de cambio leds del motor("velocidad")
end Motor;

architecture Behavioral of Motor is

begin
process(clk,encendido)
variable contador: integer:=0;
begin
		if encendido='0' then
			pulso_motor<='0';
			vuelta_completa<='0';
			contador:=0;
		else
			pulso_motor<=clk;
			if clk' event and clk='0' then
				contador:=contador+1;
				if contador>=(8*num_vueltas) then
					vuelta_completa<='1';
					contador:=0;
				else
					vuelta_completa<='0';
				end if;
			end if;
		end if;
end process;
end Behavioral;

