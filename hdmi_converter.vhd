------------------------------------------------------------------------------------
---- Company: AGH
---- Engineer: �ukasz Jele�
---- 
---- Create Date: 09.02.2017 16:43:07
----
---- Module Name: DVI_decoder
---- Project Name: RobotEYE
---- Target Devices: Nexys Video
---- Description: 
----      Module converts decodes HDMI/DVI to vga
---- 
---- Additional Comments:
---- 
------------------------------------------------------------------------------------


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if using
---- arithmetic functions with Signed or Unsigned values
----use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx leaf cells in this code.
----library UNISIM;
----use UNISIM.VComponents.all;

--entity hdmi_converter is
--    Port ( 
--        DVI_clk         : in    STD_LOGIC;
--        DVI_ch_b        : in    STD_LOGIC_VECTOR(9 downto 0);
--        DVI_ch_g        : in    STD_LOGIC_VECTOR(9 downto 0);
--        DVI_ch_r        : in    STD_LOGIC_VECTOR(9 downto 0);
--        err_b           : out   STD_LOGIC;
--        err_g           : out   STD_LOGIC;
--        err_r           : out   STD_LOGIC;
        
--        VGA_red         : out   STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
--        VGA_green       : out   STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
--        VGA_blue        : out   STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
--        VGA_hsync       : out   STD_LOGIC := '0';
--        VGA_vsync       : out   STD_LOGIC := '0';
--        VGA_blank       : out   STD_LOGIC := '0';
--        HCNT            : out   STD_LOGIC_VECTOR(11 downto 0);
--        VCNT            : out   STD_LOGIC_VECTOR(11 downto 0);
        
--        reset_in        : in    STD_LOGIC
--    );
--end hdmi_converter;

--architecture Behavioral of hdmi_converter is

----##--##--##--##--## TMDS Decoder ##--##--##--##--##--
--    component tmds_decoder is
--        Port ( 
--            clk_1x_in        : in    STD_LOGIC;
--            reset_in         : in    STD_LOGIC := '0';
--            deser_data     : in    STD_LOGIC_VECTOR(9 downto 0);
--            de               : in    STD_LOGIC := '0';
--            tmds_data_out     : out   STD_LOGIC_VECTOR(7 downto 0);
--            hsync            : in    STD_LOGIC := '0';
--            vsync            : in    STD_LOGIC := '0'
--        );
--    end component tmds_decoder;
    
 
-- --##--##--##--##--## Functions ##--##--##--##--##--
    
    
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
----**--      (0) =>  HSYNC
----**--      (1) =>  VSYNC
----**--      (2) =>  Is CTL? 

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
--            when others => return b"00000";
--        end case;
--    end TERC4;
    
--    component error_detector is
--        Port ( 
--            clk_in              : in    STD_LOGIC;
--            reset_in            : in    STD_LOGIC;
--            data_in             : in    STD_LOGIC_VECTOR(9 downto 0);
--            data_pre            : in    STD_LOGIC;
--            blank               : out   STD_LOGIC;
--            CTL_period          : out   STD_LOGIC;
--            TERC4_period        : out   STD_LOGIC;
--            DATA_out            : out   STD_LOGIC_VECTOR(9 downto 0);
--            error               : out   STD_LOGIC
--        );
--    end component error_detector;
 
--    constant VID_PREAMBLE   : STD_LOGIC_VECTOR(3 downto 0) := b"0001";
--    constant DAT_PREAMBLE   : STD_LOGIC_VECTOR(3 downto 0) := b"0101";

--    signal l_VGA_red        : STD_LOGIC_VECTOR(7 downto 0);
--    signal l_VGA_green      : STD_LOGIC_VECTOR(7 downto 0);
--    signal l_VGA_blue       : STD_LOGIC_VECTOR(7 downto 0);
--    signal w_VGA_red        : STD_LOGIC_VECTOR(7 downto 0);
--    signal w_VGA_green      : STD_LOGIC_VECTOR(7 downto 0);
--    signal w_VGA_blue       : STD_LOGIC_VECTOR(7 downto 0);
    
--    signal l_VGA_hsync      : STD_LOGIC;
--    signal l_VGA_vsync      : STD_LOGIC;
--    signal l_VGA_blank      : STD_LOGIC;
    

    
--    --##--##--##-- Preamble_detect --##--##--##--
--    signal data_pre         : STD_LOGIC;
    
--    --##--##--##-- Ctrl signals --##--##--##--
--    signal blank_b,
--            blank_g,
--            blank_r         : STD_LOGIC;
            
--    signal ctlp_b,
--            ctlp_g,
--            ctlp_r          : STD_LOGIC;
            
--    signal terc4p_b,
--            terc4p_g,
--            terc4p_r        : STD_LOGIC;
            
--    signal blue_out,
--            green_out,
--            red_out         : STD_LOGIC_VECTOR(9 downto 0);
    
--    signal THSC, TVSC       : STD_LOGIC;
--    signal CHSC, CVSC       : STD_LOGIC;
    
   
    
--begin

    
--    --blue_out --10
--    --THSC,TVSC --2
--    --CHSC,CVSC --2
--    --data_pre --1
--    --ctlp_b --1
--    --blank_b --1
--    --terc4p_b --1
    
    
--    VGA_blank       <= l_VGA_blank;
--    VGA_vsync       <= l_VGA_vsync;
--    VGA_hsync       <= l_VGA_hsync;
--    VGA_blue        <= l_VGA_blue;
--    VGA_green       <= l_VGA_green;
--    VGA_red         <= l_VGA_red;
----    HCNT            <= l_hcounter;
----    VCNT            <= l_vcounter;

--    (THSC, TVSC)    <= TERC4(blue_out)(0 to 1);
--    (CHSC, CVSC)    <= HDMI_dec(blue_out)(0 to 1);

--    --##--##--##-- Preamble_detect --##--##--##--
--    process(DVI_clk)
--        variable    counter         : STD_LOGIC_VECTOR(3 downto 0);
--    begin
--        if rising_edge(DVI_clk) then
--            if DVI_ch_g = b"0010101011" and DVI_ch_r = b"0010101011" then
--                counter := counter + 1;
--            elsif counter > 7 then
--                counter := counter + 1;
--                data_pre <= '1';
--            end if;
            
--            l_VGA_hsync <= '0';
--            l_VGA_vsync <= '0';
--            l_VGA_blank <= blank_b;
--            l_VGA_blue  <= (others => '0');
--            l_VGA_green <= (others => '0');
--            l_VGA_red   <= (others => '0');
            
--            if blank_b = '0' then
--                l_VGA_blue  <= w_VGA_blue;
--                l_VGA_green <= w_VGA_green;
--                l_VGA_red   <= w_VGA_red;
                
--            elsif ctlp_b = '1' and data_pre = '0' then
--                l_VGA_hsync <= CHSC;
--                l_VGA_vsync <= CVSC;
                
--            elsif terc4p_b = '1' then
--                l_VGA_hsync <= THSC;
--                l_VGA_vsync <= TVSC;
--                data_pre <= '0';

--            end if;
            
--        end if;
--    end process;


--detect_err_b: error_detector Port map( 
--        clk_in              => DVI_clk,
--        reset_in            => '0',
--        data_in             => DVI_ch_b,
--        data_pre            => data_pre,
--        blank               => blank_b,
--        CTL_period          => ctlp_b,
--        TERC4_period        => terc4p_b,
--        DATA_out            => blue_out,
--        error               => err_b
--    );
    
--detect_err_g: error_detector Port map( 
--        clk_in              => DVI_clk,
--        reset_in            => '0',
--        data_in             => DVI_ch_g,
--        data_pre            => data_pre,
--        blank               => blank_g,
--        CTL_period          => ctlp_g,
--        TERC4_period        => terc4p_g,
--        DATA_out            => green_out,
--        error               => err_g
--    );
    
--detect_err_r: error_detector Port map( 
--        clk_in              => DVI_clk,
--        reset_in            => '0',
--        data_in             => DVI_ch_r,
--        data_pre            => data_pre,
--        blank               => blank_r,
--        CTL_period          => ctlp_r,
--        TERC4_period        => terc4p_r,
--        DATA_out            => red_out,
--        error               => err_r
--    );
        

----##--##--##--##--## TMDS Decoder ##--##--##--##--##--
--decode_b: tmds_decoder Port map ( 
--        clk_1x_in           => DVI_clk,
--        reset_in            => open,
--        deser_data          => blue_out,
--        de                  => open,
--        tmds_data_out       => w_VGA_blue,
--        hsync               => open,
--        vsync               => open
--    );
    
--decode_g: tmds_decoder Port map ( 
--        clk_1x_in           => DVI_clk,
--        reset_in            => open,
--        deser_data          => green_out,
--        de                  => open,
--        tmds_data_out       => w_VGA_green,
--        hsync               => open,
--        vsync               => open
--    );
    
--decode_r: tmds_decoder Port map ( 
--        clk_1x_in           => DVI_clk,
--        reset_in            => open,
--        deser_data          => red_out,
--        de                  => open,
--        tmds_data_out       => w_VGA_red,
--        hsync               => open,
--        vsync               => open
--    );
    
    
--end Behavioral;