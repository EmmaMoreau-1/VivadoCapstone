------------------------------------------------------------------------------------
---- Company: AGH
---- Engineer: �ukasz Jele�
---- 
---- Create Date: 11.02.2017 11:17:15
----
---- Module Name: DVI_HDMI decoder
---- Project Name: RobotEYE
---- Target Devices: Nexys Video
---- Description: 
----      Module docede each colour
---- 
---- Additional Comments:
---- 
------------------------------------------------------------------------------------


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


--entity error_detector is
--    Port ( 
--        clk_in              : in    STD_LOGIC;
--        reset_in            : in    STD_LOGIC;
--        data_in             : in    STD_LOGIC_VECTOR(9 downto 0);
--        data_pre            : in    STD_LOGIC;
--        blank               : out   STD_LOGIC;
--        CTL_period          : out   STD_LOGIC;
--        TERC4_period        : out   STD_LOGIC;
--        DATA_out            : out   STD_LOGIC_VECTOR(9 downto 0);
--        error               : out   STD_LOGIC
--    );
--end error_detector;

--architecture Behavioral of error_detector is


----##--##--##--##--## Functions ##--##--##--##--##--
    
----##--##--##--##--##--##--##--
----**-- DVI CTL DECODER
----##--##--##--##--##--##--##--
----**-- IN:
----**--      D => TMDS     
----**-- OUT:
----**--      (0) =>  HSYNC
----**--      (1) =>  VSYNC
----**--      (2) =>  Is CTL? 

--    function HDMI_dec (D : STD_LOGIC_VECTOR(9 downto 0)) return STD_LOGIC_VECTOR is
--    begin
--        case D is
--            when "1101010100"   => return b"001";
--            when "0010101011"   => return b"101";
--            when "0101010100"   => return b"011";
--            when "1010101011"   => return b"111";
--            when others => return b"000";
--        end case;
--    end HDMI_dec;
    
    
----##--##--##--##--##--##--##--
----**-- DVI TERC DECODER
----##--##--##--##--##--##--##--
----**-- IN:
----**--      D => TMDS     
----**-- OUT:
----**--      (0 to 3)    =>  TERC4
----**--      (4)         =>  Is TERC4? 
    
--    function TERC4 (D : STD_LOGIC_VECTOR(9 downto 0)) return STD_LOGIC_VECTOR is
--    begin
--        case D is
--            when "1010011100"   => return b"00001";
--            when "1001100011"   => return b"10001";
--            when "1011100100"   => return b"01001";
--            when "1011100010"   => return b"11001";
--            when "0101110001"   => return b"00101";
--            when "0100011110"   => return b"10101";
--            when "0110001110"   => return b"01101";
--            when "0100111100"   => return b"11101";
--            when "1011001100"   => return b"00011";
--            when "0100111001"   => return b"10011";
--            when "0110011100"   => return b"01011";
--            when "1011000110"   => return b"11011";
--            when "1010001110"   => return b"00111";
--            when "1001110001"   => return b"10111";
--            when "0101100011"   => return b"01111";
--            when "1011000011"   => return b"11111";
--            when "0100110011"   => return b"00001"; --guard
--            when others => return b"00000";
--        end case;
--    end TERC4;

--    --## HDMI Constant ##--
--    CONSTANT BR_VID_GUARD_C         : STD_LOGIC_VECTOR(9 downto 0) := b"1011001100";
--    CONSTANT G_VID_GUARD_C          : STD_LOGIC_VECTOR(9 downto 0) := b"0100110011";


--    signal is_terc4             : STD_LOGIC;
--    signal is_CTL               : STD_LOGIC;
    
--    signal vid_cnt              : unsigned(15 downto 0);
--    signal nxt_vid_cnt          : unsigned(15 downto 0);
    
--    signal terc4_cnt            : unsigned(4 downto 0) := (others => '0');
--    signal nxt_terc4_cnt        : unsigned(4 downto 0) := (others => '0');
    
--    --## counter for finding vid_guard ##--
--    signal vid_guard_cnt        : unsigned(1 downto 0) := (others => '0');
--    signal nxt_vid_guard_cnt    : unsigned(1 downto 0) := (others => '0');
    
--    signal last_data            : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
        
--    signal error_i              : std_logic;    
        
        
--    --## STATE MACHINE ##--
--    type HDMI_state is (ST_CTL, ST_TERC, ST_VID);
--    signal state, next_state : HDMI_state;
    
----    -----------------------------------------------------------------------------------
    
--begin
    
--    blank           <= '0' when state = ST_VID  else '1';
--    CTL_period      <= '1' when state = ST_CTL  else '0';
--    TERC4_period    <= '1' when state = ST_TERC else '0';
--    DATA_out        <= last_data;
    


--    -----------------------------------------------------------------------------------
    
--    is_terc4    <= TERC4(data_in)(4);
--    is_CTL      <= HDMI_dec(data_in)(2);
    
----Insert the following in the architecture after the begin keyword
--SYNC_PROC: process (clk_in)
--    begin
--        if rising_edge(clk_in) then
--            if (reset_in = '1') then
--                state <= ST_VID;
--                error <= '0';
--            else
--                state       <= next_state;
--                error       <= error_i;
--                last_data   <= data_in;
--            end if;
--        end if;
--    end process;


--NEXT_STATE_DECODE: process (state, data_in, is_terc4, is_CTL)
    
--    begin
    
--        next_state          <= state;  --default is to stay in current state
--        nxt_vid_cnt         <= (others => '0');
--        nxt_terc4_cnt       <= (others => '0');
--        nxt_vid_guard_cnt   <= (others => '0');
--        error_i             <= '0';
        
--        case (state) is
--            when ST_CTL =>
--                if is_terc4 = '1' then
--                    next_state <= ST_TERC;
--                    if data_in = BR_VID_GUARD_C or data_in = G_VID_GUARD_C then
--                        nxt_vid_guard_cnt <= vid_guard_cnt + 1;
--                    end if;
--                elsif is_CTL = '0' then
--                    next_state <= ST_VID;
--                end if;
                
--                --## Err - num of data packet ##--
--                if terc4_cnt /= 0 and terc4_cnt /= 4 then
--                    error_i <= '1';
--                end if;
                
--            when ST_TERC =>
--                nxt_terc4_cnt <= terc4_cnt + 1;

--                if is_CTL = '1' then
--                    next_state <= ST_CTL;
--                end if;
                
--                --## video_guard ##--
--                if data_in = BR_VID_GUARD_C or data_in = G_VID_GUARD_C then
--                    nxt_vid_guard_cnt <= vid_guard_cnt + 1;
--                end if;
                
--                if is_CTL = '0' and (is_TERC4 = '0' or data_pre = '0') and terc4_cnt = 1 and vid_guard_cnt = 2 then
--                    next_state <= ST_VID;
--                end if;
                
--            when ST_VID =>
--                if is_CTL = '1' then
--                    next_state <= ST_CTL;
--                end if;
--                nxt_vid_cnt <= vid_cnt + 1;
                
--                --## Err - no sync packet ##--
--                if vid_cnt = x"1FFF" then
--                    error_i <= '1';
--                    nxt_vid_cnt <= (others => '0');
--                end if;
                
--            when others =>
--                next_state <= ST_VID;
--        end case;
--    end process;

--counter_update: process (clk_in)
--    begin
--        if rising_edge(clk_in) then
--            if (reset_in = '1') then
--                vid_cnt             <= (others => '0');
--                terc4_cnt           <= (others => '0');
--                vid_guard_cnt       <= (others => '0');
--            else
--                vid_cnt             <= nxt_vid_cnt;
--                terc4_cnt           <= nxt_terc4_cnt;
--                vid_guard_cnt       <= nxt_vid_guard_cnt;
--            end if;
--        end if;
--    end process;
    
--end Behavioral;
