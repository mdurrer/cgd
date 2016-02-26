#include "cpu.h"
#define R8 
#define R16
#define PUSH16
#define POP16
#define PC
#define SP
tCPU::tCPU(tEnvironment &envExtern):env(envExtern)
{
    
    cout << "New Intel 8080 CPU created." << endl;
    tCPU::PCWord.word = 0x100;
    tCPU::SPWord.word =0x25;
    running=1;
    cycles=20;
 int OpcodeCycles[0x100]={
	4, 10,7, 5, 5, 5, 7, 4, 0, 10,7, 5, 5, 5, 7, 4,
	0, 10,7, 5, 5, 5, 7, 4, 0, 10,7, 5, 5, 5, 7, 4,
	0, 10,16,5, 5, 5, 7, 4, 0, 10,16,5, 5, 5, 7, 4,
	0, 10,13,5, 10,10,10,4, 0, 10,13,5, 5, 5, 7, 4,
	5, 5, 5, 5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 7, 5,
	5, 5, 5, 5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 7, 5,
	5, 5, 5, 5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 7, 5,
	7, 7, 7, 7, 7, 7, 7, 7, 5, 5, 5, 5, 5, 5, 7, 5,
	4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
	4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
	4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
	4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
	5, 10,10,10,11,11,7, 11,5, 10,10,0, 11,17,7, 11,
	5, 10,10,10,11,11,7, 11,5, 0, 10,10,11,0, 7, 11,
	5, 10,10,18,11,11,7, 11,5, 5, 10,4, 11,0, 7, 11,
	5, 10,10,4, 11,11,7, 11,5, 5, 10,4, 11,0, 7, 11
};
OpcodeInformation OpcodeList[256] = 
{
    
    {&tCPU::Opcode_00,4},
    {&tCPU::Opcode_01,4},
    {&tCPU::Opcode_02,4},
    {&tCPU::Opcode_03,4},
    {&tCPU::Opcode_04,4},
    {&tCPU::Opcode_05,4},
    {&tCPU::Opcode_06,4},
    {&tCPU::Opcode_07,4},
    {&tCPU::Opcode_08,4},
    {&tCPU::Opcode_09,4},
    {&tCPU::Opcode_0a,4},
    {&tCPU::Opcode_0b,4},
    {&tCPU::Opcode_0c,4},
    {&tCPU::Opcode_0d,4},
    {&tCPU::Opcode_0e,4},
    {&tCPU::Opcode_0f,4},
    //
    {&tCPU::Opcode_10,4},
    {&tCPU::Opcode_11,4},
    {&tCPU::Opcode_12,4},
    {&tCPU::Opcode_13,4},
    {&tCPU::Opcode_14,4},
    {&tCPU::Opcode_15,4},
    {&tCPU::Opcode_16,4},
    {&tCPU::Opcode_17,4},
    {&tCPU::Opcode_18,4},
    {&tCPU::Opcode_19,4},
    {&tCPU::Opcode_1a,4},
    {&tCPU::Opcode_1b,4},
    {&tCPU::Opcode_1c,4},
    {&tCPU::Opcode_1d,4},
    {&tCPU::Opcode_1e,4},
    {&tCPU::Opcode_1f,4},
    //
    {&tCPU::Opcode_20,4},
    {&tCPU::Opcode_21,4},
    {&tCPU::Opcode_22,4},
    {&tCPU::Opcode_23,4},
    {&tCPU::Opcode_24,4},
    {&tCPU::Opcode_25,4},
    {&tCPU::Opcode_26,4},
    {&tCPU::Opcode_27,4},
    {&tCPU::Opcode_28,4},
    {&tCPU::Opcode_29,4},
    {&tCPU::Opcode_2a,4},
    {&tCPU::Opcode_2b,4},
    {&tCPU::Opcode_2c,4},
    {&tCPU::Opcode_2d,4},
    {&tCPU::Opcode_2e,4},
    {&tCPU::Opcode_2f,4},
    //
    {&tCPU::Opcode_30,4},
    {&tCPU::Opcode_31,4},
    {&tCPU::Opcode_32,4},
    {&tCPU::Opcode_33,4},
    {&tCPU::Opcode_34,4},
    {&tCPU::Opcode_35,4},
    {&tCPU::Opcode_36,4},
    {&tCPU::Opcode_37,4},
    {&tCPU::Opcode_38,4},
    {&tCPU::Opcode_39,4},
    {&tCPU::Opcode_3a,4},
    {&tCPU::Opcode_3b,4},
    {&tCPU::Opcode_3c,4},
    {&tCPU::Opcode_3d,4},
    {&tCPU::Opcode_3e,4},
    {&tCPU::Opcode_3f,4},
    //
    {&tCPU::Opcode_40,4},
    {&tCPU::Opcode_41,4},
    {&tCPU::Opcode_42,4},
    {&tCPU::Opcode_43,4},
    {&tCPU::Opcode_44,4},
    {&tCPU::Opcode_45,4},
    {&tCPU::Opcode_46,4},
    {&tCPU::Opcode_47,4},
    {&tCPU::Opcode_48,4},
    {&tCPU::Opcode_49,4},
    {&tCPU::Opcode_4a,4},
    {&tCPU::Opcode_4b,4},
    {&tCPU::Opcode_4c,4},
    {&tCPU::Opcode_4d,4},
    {&tCPU::Opcode_4e,4},
    {&tCPU::Opcode_4f,4},
    //
    {&tCPU::Opcode_50,4},
    {&tCPU::Opcode_51,4},
    {&tCPU::Opcode_52,4},
    {&tCPU::Opcode_53,4},
    {&tCPU::Opcode_54,4},
    {&tCPU::Opcode_55,4},
    {&tCPU::Opcode_56,4},
    {&tCPU::Opcode_57,4},
    {&tCPU::Opcode_58,4},
    {&tCPU::Opcode_59,4},
    {&tCPU::Opcode_5a,4},
    {&tCPU::Opcode_5b,4},
    {&tCPU::Opcode_5c,4},
    {&tCPU::Opcode_5d,4},
    {&tCPU::Opcode_5e,4},
    {&tCPU::Opcode_5f,4},
    //
    {&tCPU::Opcode_60,4},
    {&tCPU::Opcode_61,4},
    {&tCPU::Opcode_62,4},
    {&tCPU::Opcode_63,4},
    {&tCPU::Opcode_64,4},
    {&tCPU::Opcode_65,4},
    {&tCPU::Opcode_66,4},
    {&tCPU::Opcode_67,4},
    {&tCPU::Opcode_68,4},
    {&tCPU::Opcode_69,4},
    {&tCPU::Opcode_6a,4},
    {&tCPU::Opcode_6b,4},
    {&tCPU::Opcode_6c,4},
    {&tCPU::Opcode_6d,4},
    {&tCPU::Opcode_6e,4},
    {&tCPU::Opcode_6f,4},
    //
    {&tCPU::Opcode_70,4},
    {&tCPU::Opcode_71,4},
    {&tCPU::Opcode_72,4},
    {&tCPU::Opcode_73,4},
    {&tCPU::Opcode_74,4},
    {&tCPU::Opcode_75,4},
    {&tCPU::Opcode_76,4},
    {&tCPU::Opcode_77,4},
    {&tCPU::Opcode_78,4},
    {&tCPU::Opcode_79,4},
    {&tCPU::Opcode_7a,4},
    {&tCPU::Opcode_7b,4},
    {&tCPU::Opcode_7c,4},
    {&tCPU::Opcode_7d,4},
    {&tCPU::Opcode_7e,4},
    {&tCPU::Opcode_7f,4},
    //
    {&tCPU::Opcode_80,4},
    {&tCPU::Opcode_81,4},
    {&tCPU::Opcode_82,4},
    {&tCPU::Opcode_83,4},
    {&tCPU::Opcode_84,4},
    {&tCPU::Opcode_85,4},
    {&tCPU::Opcode_86,4},
    {&tCPU::Opcode_87,4},
    {&tCPU::Opcode_88,4},
    {&tCPU::Opcode_89,4},
    {&tCPU::Opcode_8a,4},
    {&tCPU::Opcode_8b,4},
    {&tCPU::Opcode_8c,4},
    {&tCPU::Opcode_8d,4},
    {&tCPU::Opcode_8e,4},
    {&tCPU::Opcode_8f,4},
    //
    {&tCPU::Opcode_90,4},
    {&tCPU::Opcode_91,4},
    {&tCPU::Opcode_92,4},
    {&tCPU::Opcode_93,4},
    {&tCPU::Opcode_94,4},
    {&tCPU::Opcode_95,4},
    {&tCPU::Opcode_96,4},
    {&tCPU::Opcode_97,4},
    {&tCPU::Opcode_98,4},
    {&tCPU::Opcode_99,4},
    {&tCPU::Opcode_9a,4},
    {&tCPU::Opcode_9b,4},
    {&tCPU::Opcode_9c,4},
    {&tCPU::Opcode_9d,4},
    {&tCPU::Opcode_9e,4},
    {&tCPU::Opcode_9f,4},
    //
    {&tCPU::Opcode_a0,4},
    {&tCPU::Opcode_a1,4},
    {&tCPU::Opcode_a2,4},
    {&tCPU::Opcode_a3,4},
    {&tCPU::Opcode_a4,4},
    {&tCPU::Opcode_a5,4},
    {&tCPU::Opcode_a6,4},
    {&tCPU::Opcode_a7,4},
    {&tCPU::Opcode_a8,4},
    {&tCPU::Opcode_a9,4},
    {&tCPU::Opcode_aa,4},
    {&tCPU::Opcode_ab,4},
    {&tCPU::Opcode_ac,4},
    {&tCPU::Opcode_ad,4},
    {&tCPU::Opcode_ae,4},
    {&tCPU::Opcode_af,4},
    //
    {&tCPU::Opcode_b0,4},
    {&tCPU::Opcode_b1,4},
    {&tCPU::Opcode_b2,4},
    {&tCPU::Opcode_b3,4},
    {&tCPU::Opcode_b4,4},
    {&tCPU::Opcode_b5,4},
    {&tCPU::Opcode_b6,4},
    {&tCPU::Opcode_b7,4},
    {&tCPU::Opcode_b8,4},
    {&tCPU::Opcode_b9,4},
    {&tCPU::Opcode_ba,4},
    {&tCPU::Opcode_bb,4},
    {&tCPU::Opcode_bc,4},
    {&tCPU::Opcode_bd,4},
    {&tCPU::Opcode_be,4},
    {&tCPU::Opcode_bf,4},
    //
    {&tCPU::Opcode_c0,4},
    {&tCPU::Opcode_c1,4},
    {&tCPU::Opcode_c2,4},
    {&tCPU::Opcode_c3,4},
    {&tCPU::Opcode_c4,4},
    {&tCPU::Opcode_c5,4},
    {&tCPU::Opcode_c6,4},
    {&tCPU::Opcode_c7,4},
    {&tCPU::Opcode_c8,4},
    {&tCPU::Opcode_c9,4},
    {&tCPU::Opcode_ca,4},
    {&tCPU::Opcode_cb,4},
    {&tCPU::Opcode_cc,4},
    {&tCPU::Opcode_cd,4},
    {&tCPU::Opcode_ce,4},
    {&tCPU::Opcode_cf,4},
    //
    {&tCPU::Opcode_d0,4},
    {&tCPU::Opcode_d1,4},
    {&tCPU::Opcode_d2,4},
    {&tCPU::Opcode_d3,4},
    {&tCPU::Opcode_d4,4},
    {&tCPU::Opcode_d5,4},
    {&tCPU::Opcode_d6,4},
    {&tCPU::Opcode_d7,4},
    {&tCPU::Opcode_d8,4},
    {&tCPU::Opcode_d9,4},
    {&tCPU::Opcode_da,4},
    {&tCPU::Opcode_db,4},
    {&tCPU::Opcode_dc,4},
    {&tCPU::Opcode_dd,4},
    {&tCPU::Opcode_de,4},
    {&tCPU::Opcode_df,4},
    //
    {&tCPU::Opcode_e0,4},
    {&tCPU::Opcode_e1,4},
    {&tCPU::Opcode_e2,4},
    {&tCPU::Opcode_e3,4},
    {&tCPU::Opcode_e4,4},
    {&tCPU::Opcode_e5,4},
    {&tCPU::Opcode_e6,4},
    {&tCPU::Opcode_e7,4},
    {&tCPU::Opcode_e8,4},
    {&tCPU::Opcode_e9,4},
    {&tCPU::Opcode_ea,4},
    {&tCPU::Opcode_eb,4},
    {&tCPU::Opcode_ec,4},
    {&tCPU::Opcode_ed,4},
    {&tCPU::Opcode_ee,4},
    {&tCPU::Opcode_ef,4},
    //
    {&tCPU::Opcode_f0,4},
    {&tCPU::Opcode_f1,4},
    {&tCPU::Opcode_f2,4},
    {&tCPU::Opcode_f3,4},
    {&tCPU::Opcode_f4,4},
    {&tCPU::Opcode_f5,4},
    {&tCPU::Opcode_f6,4},
    {&tCPU::Opcode_f7,4},
    {&tCPU::Opcode_f8,4},
    {&tCPU::Opcode_f9,4},
    {&tCPU::Opcode_fa,4},
    {&tCPU::Opcode_fb,4},
    {&tCPU::Opcode_fc,4},
    {&tCPU::Opcode_fd,4},
    {&tCPU::Opcode_fe,4},
    {&tCPU::Opcode_ff,4}
};
for (int i=0;i!=0x100;i++)
{
    tCPU::OpcodeList[i].cycles = OpcodeCycles[i];
  // cout << "Opcode 0x"<<hex<<i<<":" << dec << OpcodeCycles[i] << endl;
}
}
tCPU::~tCPU()
{
    cout << "CPU destroyed." << endl;
    tCPU::PCWord.word = 0x100;
    running=0;
}

void tCPU::executeCycles(int cycles)
{
    int opcode;
    tCPU::cycles + cycles;
    while(tCPU::cycles > 0)
    {
        opcode = R8(tCPU::SPWord.word);
        tCPU::PCWord.word++;
        tCPU::cycles-=OpcodeList[opcode].cycles;
        //(tCPU::sp);
        //cout << "Opcode:" << opcode << endl;

    }
}
// NOP
void tCPU::Opcode_00()
{
    cout << "00 called" << endl;
    
}
// LXI B, Word
// BC <- Word
void tCPU::Opcode_01()
{
    
    
}
void tCPU::Opcode_02()
{
    
}
void tCPU::Opcode_03()
{
    
}
void tCPU::Opcode_04()
{
    
}
void tCPU::Opcode_05()
{
    
}
void tCPU::Opcode_06()
{
    
}
void tCPU::Opcode_07()
{
    
}
void tCPU::Opcode_08()
{
    
}
void tCPU::Opcode_09()
{
    
}
void tCPU::Opcode_0a()
{
    
}
void tCPU::Opcode_0b()
{
    
}
void tCPU::Opcode_0c()
{
    
}
void tCPU::Opcode_0d()
{
    
}
void tCPU::Opcode_0e()
{
    
}
void tCPU::Opcode_0f()
{
    
}
//
void tCPU::Opcode_10()
{
    
}
void tCPU::Opcode_11()
{
    
}
void tCPU::Opcode_12()
{
    
}
void tCPU::Opcode_13()
{
    
}
void tCPU::Opcode_14()
{
    
}
void tCPU::Opcode_15()
{
    
}
void tCPU::Opcode_16()
{
    
}
void tCPU::Opcode_17()
{
    
}
void tCPU::Opcode_18()
{
    
}
void tCPU::Opcode_19()
{
    
}
void tCPU::Opcode_1a()
{
    
}
void tCPU::Opcode_1b()
{
    
}
void tCPU::Opcode_1c()
{
    
}
void tCPU::Opcode_1d()
{
    
}
void tCPU::Opcode_1e()
{
    
}
void tCPU::Opcode_1f()
{
    
}
//
void tCPU::Opcode_20()
{
    
}
void tCPU::Opcode_21()
{
    
}
void tCPU::Opcode_22()
{
    
}
void tCPU::Opcode_23()
{
    
}
void tCPU::Opcode_24()
{
    
}
void tCPU::Opcode_25()
{
    
}
void tCPU::Opcode_26()
{
    
}
void tCPU::Opcode_27()
{
    
}
void tCPU::Opcode_28()
{
    
}
void tCPU::Opcode_29()
{
    
}
void tCPU::Opcode_2a()
{
    
}
void tCPU::Opcode_2b()
{
    
}
void tCPU::Opcode_2c()
{
    
}
void tCPU::Opcode_2d()
{
    
}
void tCPU::Opcode_2e()
{
    
}
void tCPU::Opcode_2f()
{
    
}
//
void tCPU::Opcode_30()
{
    
}
void tCPU::Opcode_31()
{
    
}
void tCPU::Opcode_32()
{
    
}
void tCPU::Opcode_33()
{
    
}
void tCPU::Opcode_34()
{
    
}
void tCPU::Opcode_35()
{
    
}
void tCPU::Opcode_36()
{
    
}
void tCPU::Opcode_37()
{
    
}
void tCPU::Opcode_38()
{
    
}
void tCPU::Opcode_39()
{
    
}
void tCPU::Opcode_3a()
{
    
}
void tCPU::Opcode_3b()
{
    
}
void tCPU::Opcode_3c()
{
    
}
void tCPU::Opcode_3d()
{
    
}
void tCPU::Opcode_3e()
{
    
}
void tCPU::Opcode_3f()
{
    
}
//
void tCPU::Opcode_40()
{
    
}
void tCPU::Opcode_41()
{
    
}
void tCPU::Opcode_42()
{
    
}
void tCPU::Opcode_43()
{
    
}
void tCPU::Opcode_44()
{
    
}
void tCPU::Opcode_45()
{
    
}
void tCPU::Opcode_46()
{
    
}
void tCPU::Opcode_47()
{
    
}
void tCPU::Opcode_48()
{
    
}
void tCPU::Opcode_49()
{
    
}
void tCPU::Opcode_4a()
{
    
}
void tCPU::Opcode_4b()
{
    
}
void tCPU::Opcode_4c()
{
    
}
void tCPU::Opcode_4d()
{
    
}
void tCPU::Opcode_4e()
{
    
}
void tCPU::Opcode_4f()
{
    
}
//
void tCPU::Opcode_50()
{
    
}
void tCPU::Opcode_51()
{
    
}
void tCPU::Opcode_52()
{
    
}
void tCPU::Opcode_53()
{
    
}
void tCPU::Opcode_54()
{
    
}
void tCPU::Opcode_55()
{
    
}
void tCPU::Opcode_56()
{
    
}
void tCPU::Opcode_57()
{
    
}
void tCPU::Opcode_58()
{
    
}
void tCPU::Opcode_59()
{
    
}
void tCPU::Opcode_5a()
{
    
}
void tCPU::Opcode_5b()
{
    
}
void tCPU::Opcode_5c()
{
    
}
void tCPU::Opcode_5d()
{
    
}
void tCPU::Opcode_5e()
{
    
}
void tCPU::Opcode_5f()
{
    
}
//
void tCPU::Opcode_60()
{
    
}
void tCPU::Opcode_61()
{
    
}
void tCPU::Opcode_62()
{
    
}
void tCPU::Opcode_63()
{
    
}
void tCPU::Opcode_64()
{
    
}
void tCPU::Opcode_65()
{
    
}
void tCPU::Opcode_66()
{
    
}
void tCPU::Opcode_67()
{
    
}
void tCPU::Opcode_68()
{
    
}
void tCPU::Opcode_69()
{
    
}
void tCPU::Opcode_6a()
{
    
}
void tCPU::Opcode_6b()
{
    
}
void tCPU::Opcode_6c()
{
    
}
void tCPU::Opcode_6d()
{
    
}
void tCPU::Opcode_6e()
{
    
}
void tCPU::Opcode_6f()
{
    
}
//
void tCPU::Opcode_70()
{
    
}
void tCPU::Opcode_71()
{
    
}
void tCPU::Opcode_72()
{
    
}
void tCPU::Opcode_73()
{
    
}
void tCPU::Opcode_74()
{
    
}
void tCPU::Opcode_75()
{
    
}
void tCPU::Opcode_76()
{
    
}
void tCPU::Opcode_77()
{
    
}
void tCPU::Opcode_78()
{
    
}
void tCPU::Opcode_79()
{
    
}
void tCPU::Opcode_7a()
{
    
}
void tCPU::Opcode_7b()
{
    
}
void tCPU::Opcode_7c()
{
    
}
void tCPU::Opcode_7d()
{
    
}
void tCPU::Opcode_7e()
{
    
}
void tCPU::Opcode_7f()
{
    
}
//
void tCPU::Opcode_80()
{
    
}
void tCPU::Opcode_81()
{
    
}
void tCPU::Opcode_82()
{
    
}
void tCPU::Opcode_83()
{
    
}
void tCPU::Opcode_84()
{
    
}
void tCPU::Opcode_85()
{
    
}
void tCPU::Opcode_86()
{
    
}
void tCPU::Opcode_87()
{
    
}
void tCPU::Opcode_88()
{
    
}
void tCPU::Opcode_89()
{
    
}
void tCPU::Opcode_8a()
{
    
}
void tCPU::Opcode_8b()
{
    
}
void tCPU::Opcode_8c()
{
    
}
void tCPU::Opcode_8d()
{
    
}
void tCPU::Opcode_8e()
{
    
}
void tCPU::Opcode_8f()
{
    
}
//
void tCPU::Opcode_90()
{
    
}
void tCPU::Opcode_91()
{
    
}
void tCPU::Opcode_92()
{
    
}
void tCPU::Opcode_93()
{
    
}
void tCPU::Opcode_94()
{
    
}
void tCPU::Opcode_95()
{
    
}
void tCPU::Opcode_96()
{
    
}
void tCPU::Opcode_97()
{
    
}
void tCPU::Opcode_98()
{
    
}
void tCPU::Opcode_99()
{
    
}
void tCPU::Opcode_9a()
{
    
}
void tCPU::Opcode_9b()
{
    
}
void tCPU::Opcode_9c()
{
    
}
void tCPU::Opcode_9d()
{
    
}
void tCPU::Opcode_9e()
{
    
}
void tCPU::Opcode_9f()
{
    
}
//
void tCPU::Opcode_a0()
{
    
}
void tCPU::Opcode_a1()
{
    
}
void tCPU::Opcode_a2()
{
    
}
void tCPU::Opcode_a3()
{
    
}
void tCPU::Opcode_a4()
{
    
}
void tCPU::Opcode_a5()
{
    
}
void tCPU::Opcode_a6()
{
    
}
void tCPU::Opcode_a7()
{
    
}
void tCPU::Opcode_a8()
{
    
}
void tCPU::Opcode_a9()
{
    
}
void tCPU::Opcode_aa()
{
    
}
void tCPU::Opcode_ab()
{
    
}
void tCPU::Opcode_ac()
{
    
}
void tCPU::Opcode_ad()
{
    
}
void tCPU::Opcode_ae()
{
    
}
void tCPU::Opcode_af()
{
    
}
//
void tCPU::Opcode_b0()
{
    
}
void tCPU::Opcode_b1()
{
    
}
void tCPU::Opcode_b2()
{
    
}
void tCPU::Opcode_b3()
{
    
}
void tCPU::Opcode_b4()
{
    
}
void tCPU::Opcode_b5()
{
    
}
void tCPU::Opcode_b6()
{
    
}
void tCPU::Opcode_b7()
{
    
}
void tCPU::Opcode_b8()
{
    
}
void tCPU::Opcode_b9()
{
    
}
void tCPU::Opcode_ba()
{
    
}
void tCPU::Opcode_bb()
{
    
}
void tCPU::Opcode_bc()
{
    
}
void tCPU::Opcode_bd()
{
    
}
void tCPU::Opcode_be()
{
    
}
void tCPU::Opcode_bf()
{
    
}
//
void tCPU::Opcode_c0()
{
    
}
void tCPU::Opcode_c1()
{
    
}
void tCPU::Opcode_c2()
{
    
}
void tCPU::Opcode_c3()
{
    
}
void tCPU::Opcode_c4()
{
    
}
void tCPU::Opcode_c5()
{
    
}
void tCPU::Opcode_c6()
{
    
}
void tCPU::Opcode_c7()
{
    
}
void tCPU::Opcode_c8()
{
    
}
void tCPU::Opcode_c9()
{
    
}
void tCPU::Opcode_ca()
{
    
}
void tCPU::Opcode_cb()
{
    
}
void tCPU::Opcode_cc()
{
    
}
void tCPU::Opcode_cd()
{
    
}
void tCPU::Opcode_ce()
{
    
}
void tCPU::Opcode_cf()
{
    
}
//
void tCPU::Opcode_d0()
{
    
}
void tCPU::Opcode_d1()
{
    
}
void tCPU::Opcode_d2()
{
    
}
void tCPU::Opcode_d3()
{
    
}
void tCPU::Opcode_d4()
{
    
}
void tCPU::Opcode_d5()
{
    
}
void tCPU::Opcode_d6()
{
    
}
void tCPU::Opcode_d7()
{
    
}
void tCPU::Opcode_d8()
{
    
}
void tCPU::Opcode_d9()
{
    
}
void tCPU::Opcode_da()
{
    
}
void tCPU::Opcode_db()
{
    
}
void tCPU::Opcode_dc()
{
    
}
void tCPU::Opcode_dd()
{
    
}
void tCPU::Opcode_de()
{
    
}
void tCPU::Opcode_df()
{
    
}
//
void tCPU::Opcode_e0()
{
    
}
void tCPU::Opcode_e1()
{
    
}
void tCPU::Opcode_e2()
{
    
}
void tCPU::Opcode_e3()
{
    
}
void tCPU::Opcode_e4()
{
    
}
void tCPU::Opcode_e5()
{
    
}
void tCPU::Opcode_e6()
{
    
}
void tCPU::Opcode_e7()
{
    
}
void tCPU::Opcode_e8()
{
    
}
void tCPU::Opcode_e9()
{
    
}
void tCPU::Opcode_ea()
{
    
}
void tCPU::Opcode_eb()
{
    
}
void tCPU::Opcode_ec()
{
    
}
void tCPU::Opcode_ed()
{
    
}
void tCPU::Opcode_ee()
{
    
}
void tCPU::Opcode_ef()
{
    
}
//
void tCPU::Opcode_f0()
{
    
}
void tCPU::Opcode_f1()
{
    
}
void tCPU::Opcode_f2()
{
    
}
void tCPU::Opcode_f3()
{
    
}
void tCPU::Opcode_f4()
{
    
}
void tCPU::Opcode_f5()
{
    
}
void tCPU::Opcode_f6()
{
    
}
void tCPU::Opcode_f7()
{
    
}
void tCPU::Opcode_f8()
{
    
}
void tCPU::Opcode_f9()
{
    
}
void tCPU::Opcode_fa()
{
    
}
void tCPU::Opcode_fb()
{
    
}
void tCPU::Opcode_fc()
{
    
}
void tCPU::Opcode_fd()
{
    
}
void tCPU::Opcode_fe()
{
    
}
void tCPU::Opcode_ff()
{
    
}
