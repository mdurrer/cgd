#include "rom.h"

tROM::tROM(tEnvironment &envExtern):env(envExtern)
{
    cout << "ROM-object created." << endl;
}
tROM::~tROM()
{
    cout << "ROM-Object deleted." << endl;
}
bool tROM::loadROM(int destination, const char *filename)
{
    /* memory has to be set on variable mem[0x4000] in main.cpp ! */
    fstream romFile;
    int byteCount = 0x00;
    romFile.open(filename,ios::binary|ios::in);
    cout << romFile.is_open();
    if (romFile.is_open())
    {
            cout << "ROM file opened." <<endl;
    }
    else
    {
            cout << "Error while opening ROM file." << endl;
            return (1);
    }
    
    romFile.read(&env.memory->memory[destination],0x0800);
    romFile.close();
    cout << "Finished.";
    return false;
}
/*int LoadAt (const char *filename)
{
    ifstream omg("invaders.e",ios::binary);
    int length,cnt=0;
    omg.seekg(0,ios::end);
    length = omg.tellg();
    omg.seekg(0,ios::beg);
    omg.read(*mem[0x1800],length);

    omg.close();
    return(0);
}*/
