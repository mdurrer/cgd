#include "cart.h"

tCart::tCart()
{
	Japanese = 0;
};
tCart::~tCart()
{
}
UINT16 tCart::checkROMsize(const char *filename)
{
	char temp;
	cartROM.open(filename,ios::binary|ios::in);
	cartROM.seekg(0x148,ios::beg);
	cartROM.get(temp);
	switch ((UINT16)temp)
	{
		case 0:
		cout << "32KB ROM Memory allocated"<<endl;
		romMemory = (UINT8*) malloc(0x8000);
		break;
		case 1:
		cout << "64KB ROM Memory allocated"<<endl;
		romMemory = (UINT8*) malloc(0x10000);
		break;
		case 2:
		cout << "128KB ROM Memory allocated"<<endl;
		romMemory = (UINT8*) malloc(0x20000);
		break;
		case 3:
		cout << "256KB ROM Memory allocated"<<endl;
		romMemory = (UINT8*) malloc(0x40000);
		break;
		case 4:
		cout << "512KB ROM Memory allocated"<<endl;
		romMemory = (UINT8*) malloc(0x80000);
		break;
		default:
		cout << "Couldn't find a correct value for the ROM Size" << endl;
		break;
	}
	cartROM.close();
	return (UINT16)temp;
}
UINT8 tCart::loadLogo()
{
	UINT8 nintendoLogo[] = { 0xCE, 0xED, 0x66, 0x66, 0xCC, 0x0D, 0x00, 0x0B, 0x03, 0x73, 0x00, 0x83, 0x00, 0x0C, 0x00, 0x0D,\
  	0x00, 0x08, 0x11, 0x1F, 0x88, 0x89, 0x00, 0x0E, 0xDC, 0xCC, 0x6E, 0xE6, 0xDD, 0xDD, 0xD9, 0x99, \
 	0xBB, 0xBB, 0x67, 0x63, 0x6E, 0x0E, 0xEC, 0xCC, 0xDD, 0xDC, 0x99, 0x9F, 0xBB, 0xB9, 0x33, 0x3E};
 	for(int byteCount=0;byteCount!=0x2f;byteCount++)
 	{
		romMemory[0x104+byteCount] = nintendoLogo[byteCount];
 	}
 	cout << "Logo loaded." << endl;
}
UINT8 tCart::loadROM(const char *filename)
{
	
	char temp;
	cartROM.open(filename,ios::binary|ios::in);
	cartROM.seekg(0,ios::beg);
	
	for(UINT32 byteCount=0;byteCount!=0xFFFF;byteCount++)
	{
		cartROM.get(temp);
		romMemory[byteCount] = (UINT8) temp;
	}
	cout << "ROM loaded from " << filename <<endl;	
	cartROM.seekg(0x014A,ios::beg);
	cartROM.get(temp);
	switch((UINT32)temp)
	{
		case 0:
		cout << "Game is Japanese" << endl;
		Japanese = 1;
		break;
		case 1:
		cout << "Game is Non-Japanese" << endl;
		Japanese = 0;
		break;
		default:
		break;
	}
	cartROM.close();
	return (0);
}
void tCart::printProgramName()
{
	char name[0x10];
	for(int byteCount=0;byteCount!=0x0F;byteCount++)
	{
		name[byteCount] =  romMemory[0x134+byteCount];
	}
	cout << "The Program Name is: " << name << endl;
}