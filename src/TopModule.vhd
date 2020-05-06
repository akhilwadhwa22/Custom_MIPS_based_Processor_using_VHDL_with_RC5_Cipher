library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.state_pkg.all;

entity TopModule is
    Port (  clk : in std_logic;
            reset : in std_logic;

        din : in std_logic_vector(127 downto 0);
        din_vld :in  std_logic;
        --key_vld :in std_logic;
        d_out : out std_logic_vector(63 downto 0);
        d_out1 : out std_logic_vector(63 downto 0);
        d_out2 : out std_logic_vector(127 downto 0);
      --  key_in : in std_logic_vector(127 downto 0);
        again : in std_logic;
        enc : in std_logic;
        state_temp : out s_type;
        key_rdy : out std_logic
           );
end TopModule;

architecture Behavioral of TopModule is

component ALU
    Port ( 
        SrcA : in STD_LOGIC_VECTOR(31 DOWNTO 0);
        SrcB : in STD_LOGIC_VECTOR(31 DOWNTO 0);
        CU_output : in STD_LOGIC_VECTOR(3 DOWNTO 0);
        rot_amt : in STD_LOGIC_VECTOR(3 DOWNTO 0);
        ALUResult : out STD_LOGIC_VECTOR(31 DOWNTO 0);
        BranchTaken : out STD_LOGIC:= '0'
);
end component ALU;

component DecodeUnit
    Port ( opcode : in STD_LOGIC_VECTOR(5 downto 0);
		   func : in STD_LOGIC_VECTOR(5 downto 0);
           MemtoReg : out  STD_LOGIC;
           MemWrite : out  STD_LOGIC;
           Branch : out  STD_LOGIC;
           ALUControl : out  STD_LOGIC_VECTOR(3 downto 0);
	       ALUsrc : out  STD_LOGIC;
           RegDst : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           jmp : out std_logic;
           halt : out std_logic
);
end component DecodeUnit;

component data_memory
  Port (clk: in STD_LOGIC;
        ALUResult: in STD_LOGIC_VECTOR(31 DOWNTO 0);
        WriteData: in STD_LOGIC_VECTOR(31 DOWNTO 0);
        MemWrite: in STD_LOGIC;
        ReadData: out STD_LOGIC_VECTOR(31 DOWNTO 0);
        data_in: in STD_LOGIC_VECTOR(127 downto 0);
        data_out : out STD_LOGIC_VECTOR(63 downto 0);
        data_out1 : out STD_LOGIC_VECTOR(63 downto 0);
        data_out2 : out STD_LOGIC_VECTOR(127 downto 0);
        state: s_type 
);
end component data_memory;

component RAM
 PORT  (clk: IN STD_LOGIC;
--readEN: in STD_LOGIC; --read =0; write =1
writeEN: in STD_LOGIC; --read =0; write =1
rs: IN STD_LOGIC_VECTOR(4 DOWNTO 0);--5-bit address
rt: IN STD_LOGIC_VECTOR(4 DOWNTO 0);--5-bit address
rd: IN STD_LOGIC_VECTOR(4 DOWNTO 0);--5-bit address
datain: in STD_LOGIC_VECTOR(31 DOWNTO 0) ;--32-bit datain
dataout1: OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --32-bit data out);
dataout2: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
regfile1 : OUT STD_LOGIC_VECTOR(31 downto 0);
regfile2 : OUT STD_LOGIC_VECTOR(31 downto 0)); --32-bit data out);
END component RAM;


component InstrMem is
  Port (

  a : in STD_LOGIC_VECTOR(31 downto 0);
  rd : out STD_LOGIC_VECTOR(31 downto 0);
  state : s_type
  );

end component InstrMem;

component mux_alu
port(x,y : in STD_LOGIC_VECTOR(31 downto 0);
s: in STD_LOGIC;
z: out STD_LOGIC_VECTOR(31 downto 0));
end component mux_alu ;

component SignExtend
   Port ( 
  
  SignImm : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  SignImm_left : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  SignIn : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  BranchCtrl : in STD_LOGIC;
  JumpCtrl : in STD_LOGIC
  );
end component SignExtend;

component PCBranch
  Port ( SignImm_left: in std_logic_vector(31 downto 0);
  pcplus4: in std_logic_vector(31 downto 0);
  PCBranch_sign : out std_logic_vector(31 downto 0)
  );
end component PCBranch;

component mux_rf
port(x,y : in STD_LOGIC_VECTOR(4 downto 0);
s: in STD_LOGIC;
z: out STD_LOGIC_VECTOR(4 downto 0));
end component mux_rf ;

component mux_dm
port(x,y : in STD_LOGIC_VECTOR(31 downto 0);
s: in STD_LOGIC;
z: out STD_LOGIC_VECTOR(31 downto 0));
end component mux_dm ;

component buff
  Port (clk: IN STD_LOGIC;  -- Clock/enable signal
  reset : IN STD_LOGIC;
  	  din: IN STD_LOGIC_VECTOR(31 downto 0);--1-bit input
  	  dout: OUT STD_LOGIC_VECTOR(31 downto 0); --1-bit output
  	  state: s_type
  	  
 );
end component buff;

component PCPlus4
  Port ( PC: in std_logic_vector(31 downto 0);
  pcplus4: out std_logic_vector(31 downto 0)
  
  );
end component PCPlus4;

component program_counter
  Port ( reset: in std_logic;
  pcbranch_pc,pcplus4_pc : in std_logic_vector(31 downto 0);
  isjump,isbranch,ishalt : in std_logic;
  pcdash : out std_logic_vector(31 downto 0)
  --state: s_type
  
  );
end component program_counter;

component SevenSeg_Top is
    Port ( 
           CLK 			: in  STD_LOGIC; -- system clock
--           data_in      : in   STD_LOGIC_VECTOR (31 downto 0); --For nexsys4-DDR, datato be displayed on 7Seg
           data_in      : in   STD_LOGIC_VECTOR (15 downto 0); --For Basys3, datato be displayed on 7Seg
           SSEG_CA 		: out  STD_LOGIC_VECTOR (7 downto 0); -- 7Segment cathode.
--           SSEG_AN 		: out  STD_LOGIC_VECTOR (7 downto 0) --For nexsys4-DDR, 7Segment Anode.
           SSEG_AN      : out  STD_LOGIC_VECTOR (3 downto 0) --For Basys3, 7Segment Anode.
			);
end component;



signal ALUSrc_temp : std_logic;
signal ALUControl_temp : std_logic_vector(3 downto 0);
signal dataout1_temp : std_logic_vector(31 downto 0);
signal dataout2_temp : std_logic_vector(31 downto 0);
signal ALUResult_temp : std_logic_vector(31 downto 0);
signal rd_temp : std_logic_vector(31 downto 0);
signal MemWrite_temp : std_logic;
signal MemtoReg_temp : std_logic;
signal RegDst_temp : std_logic;
signal RegWrite_temp : std_logic;
signal Branch_temp : std_logic;
signal BranchTaken_temp : std_logic;
signal ReadData_temp : std_logic_vector(31 downto 0);
signal z_alu_temp : std_logic_vector(31 downto 0);
signal z_rf_temp : std_logic_vector(4 downto 0);
signal z_dm_temp : std_logic_vector(31 downto 0);
signal SignImm_temp : std_logic_vector(31 downto 0);
signal SignImm_left_temp : std_logic_vector(31 downto 0);
signal PCSrc : std_logic;
signal jmp_temp : std_logic;
signal halt_temp : std_logic;
signal PC_temp : std_logic_vector(31 downto 0);
signal pcplus4_temp : std_logic_vector(31 downto 0);
signal PCBranch_temp : std_logic_vector(31 downto 0);
signal pcdash_temp : std_logic_vector(31 downto 0);
signal out_RAM1_S : std_logic_vector(31 downto 0);
signal out_RAM2_S : std_logic_vector(31 downto 0);
signal key_ready : std_logic;


signal state: s_type;
--signal display : std_logic_vector(15 downto 0);
--signal key_vld : std_logic;
--signal key_rdy_temp : std_logic;
--signal display : std_logic_vector(15 downto 0);

begin
state_temp <= state;

PCSrc <= Branch_temp AND BranchTaken_temp;
--out_ALU <= ALUResult_temp;
--out_RAM1 <= out_RAM1_S;
--out_RAM2 <= out_RAM2_S;

mux_pc : program_counter
port map(
    reset       => reset,
    pcbranch_pc => PCBranch_temp,
    pcplus4_pc  => pcplus4_temp,
    isjump      => jmp_temp,
    isbranch    => PCSrc,
    ishalt      => halt_temp,
    pcdash      => pcdash_temp
   -- state => state
);

adder_PC : PCPlus4
port map (
    PC          => PC_temp,
    pcplus4     => pcplus4_temp
);

buffer_PC : buff
port map (
    clk         => clk,
    reset       => reset,
    din         => pcdash_temp,
    dout        => PC_temp,
    state => state
);

ALU_i : ALU
port map (
  SrcA           => dataout1_temp,
  SrcB           => z_alu_temp,
  CU_output      => ALUControl_temp,
  rot_amt        => rd_temp(10 downto 7),
  ALUResult      => ALUResult_temp,
  BranchTaken    => BranchTaken_temp
);

DecodeUnit_i : DecodeUnit
port map (
  opcode        => rd_temp(31 downto 26),
  func          => rd_temp(5 downto 0),
  MemtoReg      => MemtoReg_temp,
  MemWrite      => MemWrite_temp,
  Branch        => Branch_temp,
  ALUControl    => ALUControl_temp,
  ALUsrc        => ALUSrc_temp,
  RegDst        => RegDst_temp,
  RegWrite      => RegWrite_temp,
  jmp           => jmp_temp,
  halt          => halt_temp
);

RAM_i : RAM
port map (
    clk         => clk,
    writeEN     => RegWrite_temp,
    rs          => rd_temp(25 downto 21),
    rt          => rd_temp(20 downto 16),
    rd          => z_rf_temp,
    datain      => z_dm_temp,
    dataout1    => dataout1_temp,
    dataout2    => dataout2_temp,
    regfile1    => out_RAM1_S,
    regfile2    => out_RAM2_S
    
);

InstrMem_i : InstrMem 
port map(
    a           => PC_temp,
    rd          => rd_temp,
    state       => state
);

data_memory_i : data_memory
port map (
    clk         => clk,
    ALUResult   => ALUResult_temp,
    WriteData   => dataout2_temp,
    MemWrite    => MemWrite_temp,
    ReadData    => ReadData_temp,
    data_in     => din,
    data_out    => d_out,
    data_out1   => d_out1,
    data_out2   => d_out2,
    state       => state
    
);

mux_alu_i : mux_alu
port map (
    x           => dataout2_temp,
    y           => SignImm_temp,
    s           => ALUSrc_temp,
    z           => z_alu_temp
);

mux_rf_i : mux_rf
port map (
    x           => rd_temp(20 downto 16),
    y           => rd_temp(15 downto 11),
    s           => RegDst_temp,
    z           => z_rf_temp
);

mux_dm_i : mux_dm
port map (
    x           => ALUResult_temp,
    y           => ReadData_temp,
    s           => MemtoReg_temp,
    z           => z_dm_temp
);

SignExtend_i : SignExtend
port map (
    SignImm         => SignImm_temp,
    SignImm_left    => SignImm_left_temp,
    BranchCtrl        => Branch_temp,
    JumpCtrl        => jmp_temp,
    SignIn          => rd_temp(31 downto 0)
);

PCBranch_i : PCBranch
port map (
    SignImm_left    => SignImm_left_temp,
    pcplus4         => pcplus4_temp,
    PCBranch_sign        => PCBranch_temp
);

process(state,clk)
begin
    if(clk'event and clk='1') then
        if(reset='1') then state <= PKG;
        else
            case state is
                when PKG=> if din_vld='1' then state<=KG; end if;
                when KG=> if PC_temp = x"000000EC" then state <= IRC;  end if;
                when IRC => key_rdy <='0'; if din_vld = '1' then state <= IRD;  end if;
                when IRD => if enc = '1' then state <=  ENCRYPT; elsif enc = '0' then state <= DECRYPT; end if;
                when ENCRYPT => if PC_temp = x"00000088" and again = '1' then state <= IRC; key_rdy <='1'; end if;
                when DECRYPT => if PC_temp = x"0000008C" and again = '1' then state <= IRC; key_rdy <='1'; end if;
            end case;
        end if;
    end if;
end process;

--with state select
--display <= x"8888" when PKG,
--           x"8881" when KG,
--           x"8810" when IRC,
--           x"8101" when IRD,
--           x"1010" when ENCRYPT,
--           x"1011" when DECRYPT;
           

end Behavioral;
