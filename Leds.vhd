
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity LED is
    Port ( planta : in  integer;--planta selecionada
			  vuelta_motor: in STD_LOGIC; --Se activa cada dos vueltas de los leds del motor
           bits_leds : out  STD_LOGIC_VECTOR (3 downto 0);--Leds plantas tarjeta
			  motor : out  STD_LOGIC;--activa el bloque que controla los leds del motor
           movimiento : out  STD_LOGIC;--"bloquea" el bloque del muestreo
			  sentido_giro: out STD_LOGIC);--Dependiendo si se sube o se baja los leds del motor giran en un sentido
end LED;

architecture Behavioral of LED is
signal leds_tmp: STD_LOGIC_VECTOR(bits_leds' range):="0000";
begin
process(planta,vuelta_motor)
	variable piso_actual: integer;
	begin  
		case leds_tmp is --logica de pisos en funcion del led encendido
			when "0000"=> piso_actual:=0;
			when "0011"=> piso_actual:=1;
			when "0110"=> piso_actual:=2;
			when "1001"=> piso_actual:=3;
			when "1100"=> piso_actual:=4;
			when "1111"=> piso_actual:=5;
			when others=> piso_actual:= piso_actual;--Entreplanta
		end case;
		--Cuando no se pulsa un boton(planta=10) o la planta deseada coincide con la actual apaga el motor y habilita el muestreo de botones
		if planta=10 or planta=piso_actual then 
				movimiento<='0';
				motor<='0';
		else  
				movimiento<='1';
				motor<='1';
			if(piso_actual >= planta)then
					sentido_giro<='1';
			else
					sentido_giro<='0';
			end if;
			--El bloque Motor manda un pulso cada dos vueltas del motor
			--Cuando se detecta se suma o resta 1 a los leds dependiendo si se sube o se baja
			if vuelta_motor' event AND vuelta_motor = '1' then
				if(piso_actual >= planta)then
					leds_tmp<=leds_tmp - 1;
				else
					leds_tmp<=leds_tmp + 1;
				end if;
			end if;
		
		end if;
end process;
bits_leds<=leds_tmp;
end Behavioral;

