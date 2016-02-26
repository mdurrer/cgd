#include "cpu.h"
tCPU::tCPU()
{
	setActive(1);
	cout << "CPU gestartet."<<endl;
	// initCPU();
}
tCPU::~tCPU()
{
	cout << "CPU beendet."<<endl;
}

void tCPU::setAF(UINT8 h,UINT8 l)
{

			AF.b.l = l;
			AF.b.h = h;

}
Z80Reg tCPU::getAF()
{
	return AF;
}
int tCPU::initCPU()
{
	memset(mainMemory,0,0x2000);
	AF.w = BC.w = DE.w = HL.w = 0;
	PSW = 0x0;
	PC.w = 0x0100;
	return(0);
}
int tCPU::resetCPU()
{
	return(0);
}
int tCPU::stopCPU()
{
	active=0;
	return(0);
}
bool tCPU::setActive(bool Value)
{
	active = Value;
}
bool tCPU::getActive()
{
	return active;
}
void tCPU::execCycles(int cycles)
{
	cycleCount += cycles;
}
/*
	Z80 CPU instructions
*/
void tCPU::ADC_HLss (UINT16 Value)
{
	mainMemory[HL.w] += mainMemory[Value];
	execCycles(15);
}
void tCPU::ADC_As (UINT8 Value)
{
	AF.b.h += mainMemory[Value];
	//execCycles(15);
}

void tCPU::ADD_An (UINT8 Value)
{
	AF.b.h += Value;
	execCycles(7);
}
// 0x00
void tCPU::NOP()
{
	execCycles(4);
}
// 0x01
void tCPU::LD_BCnn(UINT16 Value) 
{
	BC.w = Value;
	execCycles(10);
}
void tCPU::LD_BCA()
{
	mainMemory[BC.w] = AF.b.h;
	execCycles(7);
}