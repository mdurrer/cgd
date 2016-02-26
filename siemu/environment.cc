#include "environment.h"

tEnvironment::tEnvironment()
{
    cout << "Environment created."<<endl;
    cpu = new tCPU(*this);
    memory = new tMemory(*this);
    rom = new tROM(*this);
    memory->memory = new char[0x4000];
   // cpu->PCWord.word = 0xffdd;
    /*rom->memory = &(*mem); // Pointing the memory of the classes 
    cpu->memory = &(*mem);
    cpu->memory[20] = 0x41;
    printf("%c",mem[20]);
    cpu->memory[0] = 0x41;*/
}
tEnvironment::~tEnvironment()
{
    cout << "Environment destroyed." << endl;
}
char tEnvironment::readByte(unsigned int addr)
{
    return memory->memory[addr];
}

char tEnvironment::writeByte(unsigned int addr, unsigned int value)
{
    if(addr >= 2000 && addr < 4000)
        {
            memory->memory[addr] = value;
        }
            
    return value;
}
unsigned int tEnvironment::readWord(unsigned int addr)
{
    return readByte(addr) | (readByte(addr+1)<<8);
}
unsigned int tEnvironment::writeWord(unsigned int addr, unsigned int value)
{
    writeByte(addr, value) & 0xFF;
    writeByte(addr+1,(value>>8)&0xFF);
}
