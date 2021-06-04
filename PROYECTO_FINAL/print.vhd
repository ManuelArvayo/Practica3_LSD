LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY lcd_example IS
  PORT(
      clk       : IN  STD_LOGIC;  --system clock
      rw, rs, e : OUT STD_LOGIC;  --read/write, setup/data, and enable for lcd
      lcd_data  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); --data signals for lcd
END lcd_example;

ARCHITECTURE behavior OF lcd_example IS
  SIGNAL   lcd_enable : STD_LOGIC;
  SIGNAL   lcd_bus    : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL   lcd_busy   : STD_LOGIC;
  COMPONENT lcd_controller IS
    PORT(
       clk        : IN  STD_LOGIC; --system clock
       reset_n    : IN  STD_LOGIC; --active low reinitializes lcd
       lcd_enable : IN  STD_LOGIC; --latches data into lcd controller
       lcd_bus    : IN  STD_LOGIC_VECTOR(9 DOWNTO 0); --data and control signals
       busy       : OUT STD_LOGIC; --lcd controller busy/idle feedback
       rw, rs, e  : OUT STD_LOGIC; --read/write, setup/data, and enable for lcd
       lcd_data   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); --data signals for lcd
  END COMPONENT;

component sistema_rom is  
port (
      address: in std_logic_vector(5 downto 0);
      lcd_data: out std_logic_vector (7 downto 0)
);
end component;
    
signal add: std_logic_vector (5 downto 0);
BEGIN

  --instantiate the lcd controller
  dut: lcd_controller
    PORT MAP(clk => clk, reset_n => '1', lcd_enable => lcd_enable, lcd_bus => lcd_bus, 
             busy => lcd_busy, rw => rw, rs => rs, e => e, lcd_data => lcd_data);
  
    
lcd_out: sistema_rom port map (address=>add, lcd_data=>lcd_data);
  PROCESS(clk)
    VARIABLE char  :  INTEGER:= 0;
  BEGIN
      IF(rising_edge(clk)) THEN
  
          IF(clk_count < (5000000 * freq)) THEN    -- 5s cycle
            --LINE 1: MODO: MAN/AUT
            --LINE 2: DIA/NOCHE
              add<="01001101";--M
              add<="01001111"; --O
              add<="01000100"; --D
              add<="01001111"; --O
              add<="00111010"; --:
              if (modo ='1') then
                add<="01000001"; --A
                add<="01010101"; --U
                add<="01010100"; --T
              elsif(modo='0') then
                add<="01001101";--M
                add<="01000001"; --A
                add<="01001110"; --N
              end if;
              WHEN 7 => add <= "100101"; -- salto de linea
              if(Dia_Noche = '0') then
              add<="01000100"; --D
              add<="01001001"; --I    
              add<="01000001"; --A
              elsif(Dia_Noche='1') then
              add<="01001110"; --N
              add<="01001111"; --O
              add<="01000011"; --C  
              add<="01001000"; --H  
              add<="01000101"; --E
              end if;
          ELSIF(clk_count < (10000000 * freq)) THEN
            --LINE 1: # DE FOCOS: 
            --LINE 2: TIME F1:
            
              add<="";--#
              add<="";--
              add<="";--D
              add<="";--E
              add<="";--
              add<="";--F
              add<="";--O
              add<="";--C
              add<="";--O
              add<="";--S
              add<="";--:
              WHEN 7 => add <= "100101"; -- salto de linea
              add<="";--T
              add<="";--I
              add<="";--M
              add<="";--E
              add<="";--
              add<="";--F
              add<="";--1
              add<="";--:
            
          ELSIF(clk_count < (15000000 * freq)) THEN
            --LINE 1: TIME F2: 
            --LINE 2: TIME F3:
              add<="";--T
              add<="";--I
              add<="";--M
              add<="";--E
              add<="";--
              add<="";--F
              add<="";--2
              add<="";--:
              WHEN 7 => add <= "100101"; -- salto de linea
              add<="";--T
              add<="";--I
              add<="";--M
              add<="";--E
              add<="";--
              add<="";--F
              add<="";--3
              add<="";--:
          ELSIF(clk_count < (20000000 * freq)) THEN
            --LINE 1: NIVEL: ALTO/MEDIO/BAJO
            --LINE 2: GASTO APROX: $
              add<="";--N
              add<="";--I
              add<="";--V
              add<="";--E
              add<="";--L
              add<="";--:
              WHEN 7 => add <= "100101"; -- salto de linea
              add<="";--G
              add<="";--T
              add<="";--O
              add<="";--
              add<="";--A
              add<="";--P
              add<="";--R
              add<="";--O
              add<="";--X
              add<="";--:

  END PROCESS;  
END behavior;
