// 
// File:   memory.h
// Author: pixman
//
// Created on 23. Januar 2007, 21:22
//

#ifndef _memory_H
#define	_memory_H
#include <iostream>
#include <string>
#include "environment.h"
using namespace std;
class tEnvironment;
class tMemory
{
    public:
        unsigned char *screen;
        char *memory;
        tMemory();
        tMemory(tEnvironment &envExtern);
        ~tMemory();
        tEnvironment &env;
    private:
        
};


#endif	/* _memory_H */

