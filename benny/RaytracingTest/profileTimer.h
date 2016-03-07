#ifndef PROFILETIMER_H
#define PROFILETIMER_H

//#include <time.h>
#include <sys/time.h>
static const long NANOSECONDS_PER_SECOND = 1000000000L;

class ProfileTimer
{
public:
	void Start()
	{
		//startTime = clock();
		startTime = GetTime();
	}
	
	double End()
	{
		return GetTime() - startTime;
		//return (clock() - startTime)/((double)(CLOCKS_PER_SEC));
	}
	
	double GetTime()
	{
		timespec ts;
		clock_gettime(CLOCK_REALTIME, &ts);
		return (double)(((long) ts.tv_sec * NANOSECONDS_PER_SECOND) + ts.tv_nsec)/((double)(NANOSECONDS_PER_SECOND));
	}
protected:
private:
	

	double startTime;
	//clock_t startTime;
};

#endif // PROFILETIMER_H
