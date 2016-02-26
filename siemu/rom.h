// 
// File:   rom.h
// Author: pixman
//
// Created on 27. Januar 2007, 02:49
//

#ifndef _rom_H
#define	_rom_H
#include <iostream>
#include <string>
#include <fstream>
#include "environment.h"
using namespace std;
class tEnvironment;
class tROM
{
    public:
        unsigned char *memory;
        char *loadTemp;
        char *filenames[];
        bool loadROM(int destination, const char *filename);
        tROM(tEnvironment &envExtern);
        tROM();
        ~tROM();
        tEnvironment &env;
    private:
};


#endif	/* _rom_H */

