#ifndef DISPLAY_H_INCLUDED
#define DISPLAY_H_INCLUDED

#include <string>
#include "math3d.h"

class Display
{
public:
    virtual bool Init(int width = 800, int height = 600, const std::string& title = "3D Engine");
    virtual void Destroy();

    virtual void SetMousePos(const Vector2f& pos);
	virtual void SetTitle(const std::string& title);

	virtual void ShowMouse(bool show);
	virtual void SwapBuffers();

	virtual void Error(const std::string& message);

    virtual float GetAspect();
	virtual Vector2f GetSize();
	virtual Vector2f GetCenter();
	//bool IsResized();
};

#endif // DISPLAY_H_INCLUDED
