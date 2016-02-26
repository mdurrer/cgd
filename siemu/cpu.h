// 
// File:   cpu.h
// Author: pixman
//
// Created on 22. Januar 2007, 19:58
//

#ifndef _cpu_H
#define	_cpu_H
#include <iostream>
#include <string>
#include "environment.h"

using namespace std;
class tEnvironment;
class tCPU
{   
    public:
    tCPU();
    tCPU(tEnvironment &envExtern);
    ~tCPU();
    enum Flags 
    {
        Carry     = 0x01,
        Parity    = 0x04, Overflow = Parity,
        HalfCarry = 0x10, AuxCarry = HalfCarry,
        Zero      = 0x40,
        Sign      = 0x80
    };
    union tWord
    {
       // unsigned short pc;
        struct
        {
            unsigned char hi,lo;
        }byte;
        unsigned short word;
    
    };
    tWord PCWord;
    tWord SPWord;
     union
    {   
            unsigned short af,bc,de,hl;    
        struct
      {
            unsigned char flags,a,c,b,e,d,l,h;  
        };
          
    }reg;
    
    int cycles;
    int running;
    unsigned short result;
    unsigned char irq;
    unsigned char irqpending;
    unsigned char aux;
    int OpcodeCycles[0x100];
    void executeCycles(int cycles);
    tEnvironment &env;
    typedef void (tCPU::* OpcodeHandler)();
    typedef struct 
    {
        OpcodeHandler OpcodeMethod;
        int cycles;
    }OpcodeInformation;
    OpcodeInformation OpcodeList[256];
    void Opcode_00();
    void Opcode_01();
    void Opcode_02();
    void Opcode_03();
    void Opcode_04();
    void Opcode_05();
    void Opcode_06();
    void Opcode_07();
    void Opcode_08();
    void Opcode_09();
    void Opcode_0a();
    void Opcode_0b();
    void Opcode_0c();
    void Opcode_0d();
    void Opcode_0e();
    void Opcode_0f();
    //
    void Opcode_10();
    void Opcode_11();
    void Opcode_12();
    void Opcode_13();
    void Opcode_14();
    void Opcode_15();
    void Opcode_16();
    void Opcode_17();
    void Opcode_18();
    void Opcode_19();
    void Opcode_1a();
    void Opcode_1b();
    void Opcode_1c();
    void Opcode_1d();
    void Opcode_1e();
    void Opcode_1f();
    //
    void Opcode_20();
    void Opcode_21();
    void Opcode_22();
    void Opcode_23();
    void Opcode_24();
    void Opcode_25();
    void Opcode_26();
    void Opcode_27();
    void Opcode_28();
    void Opcode_29();
    void Opcode_2a();
    void Opcode_2b();
    void Opcode_2c();
    void Opcode_2d();
    void Opcode_2e();
    void Opcode_2f();
    //
    void Opcode_30();
    void Opcode_31();
    void Opcode_32();
    void Opcode_33();
    void Opcode_34();
    void Opcode_35();
    void Opcode_36();
    void Opcode_37();
    void Opcode_38();
    void Opcode_39();
    void Opcode_3a();
    void Opcode_3b();
    void Opcode_3c();
    void Opcode_3d();
    void Opcode_3e();
    void Opcode_3f();
    //
    void Opcode_40();
    void Opcode_41();
    void Opcode_42();
    void Opcode_43();
    void Opcode_44();
    void Opcode_45();
    void Opcode_46();
    void Opcode_47();
    void Opcode_48();
    void Opcode_49();
    void Opcode_4a();
    void Opcode_4b();
    void Opcode_4c();
    void Opcode_4d();
    void Opcode_4e();
    void Opcode_4f();
    //
    void Opcode_50();
    void Opcode_51();
    void Opcode_52();
    void Opcode_53();
    void Opcode_54();
    void Opcode_55();
    void Opcode_56();
    void Opcode_57();
    void Opcode_58();
    void Opcode_59();
    void Opcode_5a();
    void Opcode_5b();
    void Opcode_5c();
    void Opcode_5d();
    void Opcode_5e();
    void Opcode_5f();
    //
    void Opcode_60();
    void Opcode_61();
    void Opcode_62();
    void Opcode_63();
    void Opcode_64();
    void Opcode_65();
    void Opcode_66();
    void Opcode_67();
    void Opcode_68();
    void Opcode_69();
    void Opcode_6a();
    void Opcode_6b();
    void Opcode_6c();
    void Opcode_6d();
    void Opcode_6e();
    void Opcode_6f();
    //
    void Opcode_70();
    void Opcode_71();
    void Opcode_72();
    void Opcode_73();
    void Opcode_74();
    void Opcode_75();
    void Opcode_76();
    void Opcode_77();
    void Opcode_78();
    void Opcode_79();
    void Opcode_7a();
    void Opcode_7b();
    void Opcode_7c();
    void Opcode_7d();
    void Opcode_7e();
    void Opcode_7f();
    //
    void Opcode_80();
    void Opcode_81();
    void Opcode_82();
    void Opcode_83();
    void Opcode_84();
    void Opcode_85();
    void Opcode_86();
    void Opcode_87();
    void Opcode_88();
    void Opcode_89();
    void Opcode_8a();
    void Opcode_8b();
    void Opcode_8c();
    void Opcode_8d();
    void Opcode_8e();
    void Opcode_8f();
    //
    void Opcode_90();
    void Opcode_91();
    void Opcode_92();
    void Opcode_93();
    void Opcode_94();
    void Opcode_95();
    void Opcode_96();
    void Opcode_97();
    void Opcode_98();
    void Opcode_99();
    void Opcode_9a();
    void Opcode_9b();
    void Opcode_9c();
    void Opcode_9d();
    void Opcode_9e();
    void Opcode_9f();
    //
    void Opcode_a0();
    void Opcode_a1();
    void Opcode_a2();
    void Opcode_a3();
    void Opcode_a4();
    void Opcode_a5();
    void Opcode_a6();
    void Opcode_a7();
    void Opcode_a8();
    void Opcode_a9();
    void Opcode_aa();
    void Opcode_ab();
    void Opcode_ac();
    void Opcode_ad();
    void Opcode_ae();
    void Opcode_af();
    //
    void Opcode_b0();
    void Opcode_b1();
    void Opcode_b2();
    void Opcode_b3();
    void Opcode_b4();
    void Opcode_b5();
    void Opcode_b6();
    void Opcode_b7();
    void Opcode_b8();
    void Opcode_b9();
    void Opcode_ba();
    void Opcode_bb();
    void Opcode_bc();
    void Opcode_bd();
    void Opcode_be();
    void Opcode_bf();
    //
    void Opcode_c0();
    void Opcode_c1();
    void Opcode_c2();
    void Opcode_c3();
    void Opcode_c4();
    void Opcode_c5();
    void Opcode_c6();
    void Opcode_c7();
    void Opcode_c8();
    void Opcode_c9();
    void Opcode_ca();
    void Opcode_cb();
    void Opcode_cc();
    void Opcode_cd();
    void Opcode_ce();
    void Opcode_cf();
    //
    void Opcode_d0();
    void Opcode_d1();
    void Opcode_d2();
    void Opcode_d3();
    void Opcode_d4();
    void Opcode_d5();
    void Opcode_d6();
    void Opcode_d7();
    void Opcode_d8();
    void Opcode_d9();
    void Opcode_da();
    void Opcode_db();
    void Opcode_dc();
    void Opcode_dd();
    void Opcode_de();
    void Opcode_df();
    //
    void Opcode_e0();
    void Opcode_e1();
    void Opcode_e2();
    void Opcode_e3();
    void Opcode_e4();
    void Opcode_e5();
    void Opcode_e6();
    void Opcode_e7();
    void Opcode_e8();
    void Opcode_e9();
    void Opcode_ea();
    void Opcode_eb();
    void Opcode_ec();
    void Opcode_ed();
    void Opcode_ee();
    void Opcode_ef();
    //
    void Opcode_f0();
    void Opcode_f1();
    void Opcode_f2();
    void Opcode_f3();
    void Opcode_f4();
    void Opcode_f5();
    void Opcode_f6();
    void Opcode_f7();
    void Opcode_f8();
    void Opcode_f9();
    void Opcode_fa();
    void Opcode_fb();
    void Opcode_fc();
    void Opcode_fd();
    void Opcode_fe();
    void Opcode_ff();
    //
    
    
    private:
};


#endif	/* _cpu_H */

