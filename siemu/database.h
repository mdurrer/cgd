// 
// File:   database.h
// Author: pixman
//
// Created on 9. Mai 2007, 21:48
//

#ifndef _database_H
#define	_database_H
#include <iostream>
#include <string>
#include <sqlite3.h>
using namespace std;
class tDatabase
{
    public:
    tDatabase();
    ~tDatabase();
    int open(string dbName);
    private:
        sqlite3 *db;
};


#endif	/* _database_H */

