#ifndef CART_H
#define CART_H
#include <iostream>
#include <fstream>
#include "stdtypes.h"
using namespace std;

class tCart
{
	private:
	protected:
	ifstream cartROM;
	public:
	UINT16 ROMSize;
	UINT16 Japanese;
	UINT8 *romMemory;
	tCart();
	~tCart();
	UINT8 loadLogo();
	UINT8 loadROM(const char *filename);
	void printProgramName();
	UINT16 checkROMsize(const char *filename);
};
#endif