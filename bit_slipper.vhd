------------------------------------------------------------------------------------
---- Company: AGH
---- Engineer: �ukasz Jele�
---- 
---- Create Date: 09.02.2017 15:51:39
---- 
---- Module Name: Bit slipper
---- Project Name: RobotEYE
---- Target Devices: Nexys Video
---- Description: 
----      This module generates 1 clock cycle output signal 
----      if error counter overflow
----
---- Additional Comments:
----      None 
------------------------------------------------------------------------------------

--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

--entity bit_slipper is
--    Port (         
--        signal clk_in           : in    STD_LOGIC;
--        signal err_in           : in    STD_LOGIC;
--        signal slip_bit_out     : out   STD_LOGIC;
--        signal sync_done_out    : out   STD_LOGIC;
--        signal reset_in         : in    STD_LOGIC
--    );
--end bit_slipper;


--architecture Behavioral of bit_slipper is
    
--begin

--    process(clk_in, reset_in)
--        variable error_counter    : unsigned(15 downto 0) := (others => '0');
--        variable no_error_cnt     : unsigned(15 downto 0) := (others => '0');
--    begin
--        if reset_in = '1' then
--            error_counter   := (others => '0');
--            no_error_cnt    := (others => '0');
--            sync_done_out   <= '0';
--            slip_bit_out    <= '0';
            
--        elsif rising_edge(clk_in) then
--            sync_done_out   <= '0';
--            slip_bit_out    <= '0';
            
--            --** err counter
--            if err_in = '1' then
--                error_counter := error_counter + 1;
--            end if;
            
--            if error_counter > x"1F" then
--                slip_bit_out    <= '1';
--                error_counter   := (others => '0');
--                no_error_cnt    := (others => '0');
--            end if;
            
--            if no_error_cnt < x"FFFF" then
--                no_error_cnt := no_error_cnt + 1;
--            else
--                sync_done_out   <= '1';
--            end if;
            
--        end if;
--    end process;
    
    
--end Behavioral;
