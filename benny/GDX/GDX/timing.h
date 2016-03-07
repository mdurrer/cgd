#ifndef TIMING_H_INCLUDED
#define TIMING_H_INCLUDED

namespace Time
{
    void Init();
    double GetTime();
    
    void Update(double delta);
    
    double GetDelta();
    double GetElapsedTime();
};

#endif // TIMING_H_INCLUDED
