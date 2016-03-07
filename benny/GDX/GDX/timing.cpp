#include "timing.h"
#include "engine.h"

#ifdef WIN32
#define OS_WINDOWS
#else
#define OS_LINUX
#endif

#ifdef OS_LINUX
#include <sys/time.h>
#endif

#ifdef OS_WINDOWS
#include <Windows.h>
#endif

static const long NANOSECONDS_PER_SECOND = 1000000000L;

#ifdef OS_WINDOWS
static double g_freq;
#endif
static double g_Delta;
static double g_ElapsedTime;

void Time::Init()
{
#ifdef OS_WINDOWS
    LARGE_INTEGER li;
    if(!QueryPerformanceFrequency(&li))
		Engine::GetDisplay()->Error("QueryPerformanceFrequency failed in timer initialization");
    
    g_freq = double(li.QuadPart);
#endif
    g_Delta = 0;
    g_ElapsedTime = 0.0f;
}

void Time::Update(double delta)
{
    g_Delta = delta;
    g_ElapsedTime += delta;
}

double Time::GetTime()
{
#ifdef OS_WINDOWS
    LARGE_INTEGER li;
    if(!QueryPerformanceCounter(&li))
		Engine::GetDisplay()->Error("QueryPerformanceCounter failed in get time!");
    
    return double(li.QuadPart)/g_freq;
#endif
#ifdef OS_LINUX
    timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    return (double)(((long) ts.tv_sec * NANOSECONDS_PER_SECOND) + ts.tv_nsec)/((double)(NANOSECONDS_PER_SECOND));
#endif
}

double Time::GetDelta()
{
    return g_Delta;
}

double Time::GetElapsedTime()
{
    return g_ElapsedTime;
}
