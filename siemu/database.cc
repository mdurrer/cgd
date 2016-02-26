#include "database.h"

tDatabase::tDatabase()
{
    cout << "Database created."<< endl;
}
tDatabase::~tDatabase()
{
    cout << "Database destroyed." << endl;
}
int tDatabase::open(string dbName)
{
    return sqlite3_open(dbName.c_str(),&db);
}
