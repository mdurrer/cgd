#ifndef MY_GLOBAL_DATA_HACK_CLASS_H
#define MY_GLOBAL_DATA_HACK_CLASS_H

class GlobalData
{
public:
	static unsigned int g_numRaysCast;
	static unsigned int g_numTriangles;
	static unsigned int g_numTriangleIntersectionTest;
	static unsigned int g_numTrianglesIntersected;
	static unsigned int g_numAABBIntersectionTests;
	static unsigned int g_numAABBIntersected;
};

#endif