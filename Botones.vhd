
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Botonera is -- Este componente se encarga de muestrear los botones y de mandar el piso selecionado.
    Port ( clk : in  STD_LOGIC; --Frecuencia de muestreo
			  movimiento : in  STD_LOGIC; -- si esta en movimiento el ascensor deja de muestrear botones
           detector_llamada : in  STD_LOGIC;--Salida de la tarjeta, vale 0 cuando se pulsa un boton y coincide con el valor enviado en los botones
           planta_selecionada : out  INTEGER;--Planta seleccionada del 0 al 5
           botones  : out  STD_LOGIC_VECTOR (3 downto 0)
           );
end Botonera;

architecture Behavioral of Botonera is
signal botones_tmp: STD_LOGIC_VECTOR(botones' range):= "0000";--signal auxiliar
signal planta_aux: INTEGER:=10;
--El valor 10 es un valor basura, significa que no se ha detectado planta
begin

process(clk,detector_llamada,movimiento)
begin
	if movimiento='0' then
		if detector_llamada = '0'  then
			case botones_tmp is -- logica de las plantas de la tarjeta
				when "0000" => planta_aux <= 5;
				when "0010" => planta_aux <= 4;
				when "0001" => planta_aux <= 4;
				when "0100" => planta_aux <= 3; 
				when "0011" => planta_aux <= 3; 
				when "0110" => planta_aux <= 2;
				when "0101" => planta_aux <= 2;
				when "1000" => planta_aux <= 1;
				when "0111" => planta_aux <= 1;
				when "1001" => planta_aux <=0;
				when others => planta_aux <=10; 
			end case;

		elsif clk' event AND clk = '1' then
			if botones_tmp >="1001" then -- solo muestrea de 0-9 para optimizar
				botones_tmp<= (others =>'0');
			else
				botones_tmp <= botones_tmp + 1;
			end if;	
		end if;
	else 
	-- si movimiento ='1' bits_botones="1111" que es un valor que nunca puede coincidir con los pulsadores de la tarjeta
	-- Conseguimos dejar de muestrear y evitamos que detector llamada pueda valor 0. 
	-- Es una cuestion estética porque una vez que esta en movimiento ignora la variable detector_llamada
		botones_tmp<=(others =>'1');
	end if;	
end process;
planta_selecionada<=planta_aux;
botones <= botones_tmp;
end Behavioral;

