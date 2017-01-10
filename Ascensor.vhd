----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:02:43 01/07/2017 
-- Design Name: 
-- Module Name:    Ascensor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Ascensor is --Este modulo es el interfaz que encapsula a los otros modulos
    Port ( clk : in  STD_LOGIC;
			  deteccion: in  STD_LOGIC;
           bits_botones : out  STD_LOGIC_VECTOR (3 downto 0);
           b_leds : out  STD_LOGIC_VECTOR (3 downto 0);
           pulsos_motor : out  STD_LOGIC;
           Sent_Giro : out  STD_LOGIC);
end Ascensor;

architecture Behavior of Ascensor is
COMPONENT Botonera PORT(clk : in  STD_LOGIC;
			  movimiento : in  STD_LOGIC;
           detector_llamada : in  STD_LOGIC;
           planta_selecionada : out  INTEGER;
           botones  : out  STD_LOGIC_VECTOR (3 downto 0)
           ); END COMPONENT;
			  
COMPONENT LED PORT(planta : in  integer:=10;
			  vuelta_motor: in STD_LOGIC; 
           bits_leds : out  STD_LOGIC_VECTOR (3 downto 0);
			  motor : out  STD_LOGIC;
           movimiento : out  STD_LOGIC;
			  sentido_giro: out STD_LOGIC);END COMPONENT;
			  
COMPONENT Motor GENERIC(num_vueltas:positive:=2);
				PORT(encendido : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           vuelta_completa : out  STD_LOGIC;
           pulso_motor : out  STD_LOGIC);END COMPONENT;
			  
COMPONENT ClockDivider GENERIC(divisor: integer ); 
							   PORT ( clk: in std_logic; clock_out: out std_logic);END COMPONENT;
constant divisor_motor: integer:=500000;--100Hz como frecuencia del motor
constant divisor_botones: integer:=50000;--1Khz como frecuencia de muestreo
signal clk_motor,clk_botones : std_logic;
signal vueltamotor_i,SentidoGiro_i,PulsosMotor_i: std_logic;-- señales auxiliares
signal planta_elegida: integer:=0;
signal botones_i: std_logic_vector(3 downto 0):="0000";
signal leds_i:std_logic_vector(3 downto 0):="0000";

signal movimiento_i: std_logic :='0';
signal motor_i: std_logic:= '0';
begin
DivisorMotor: ClockDivider generic map(divisor=>divisor_motor)port map(clk,clk_motor);
DivisorBotones: ClockDivider generic map(divisor=>divisor_botones)port map(clk,clk_botones);

MuestreoBotones: Botonera  port map(clk=>clk_botones,
												movimiento=>movimiento_i,
												detector_llamada=>deteccion,
												planta_selecionada=>planta_elegida,
												botones=>botones_i);
												
EncendidoLeds: LED port map(planta=>planta_elegida,
									 vuelta_motor=>vueltamotor_i,
									 bits_leds=>leds_i,
									 motor=>motor_i,movimiento=>movimiento_i,
									 sentido_giro=>SentidoGiro_i);
									 
MotorAscensor: Motor port map(encendido=>motor_i,
										clk=>clk_motor,
										vuelta_completa=>vueltamotor_i,
										pulso_motor=>PulsosMotor_i);
										
bits_botones<=botones_i;
b_leds<=leds_i;
pulsos_motor<=PulsosMotor_i;
Sent_Giro<=SentidoGiro_i;

end Behavior;

