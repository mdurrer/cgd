#include "memory.h"

tMemory::tMemory(tEnvironment &envExtern):env(envExtern)
{
    memory = new char[0x4000];
    cout << "Memory [0x4000 Bytes] allocated/created."<<endl;
}
tMemory::~tMemory()
{
    cout << "Memory destroyed."<<endl;
    delete[] memory;
}
