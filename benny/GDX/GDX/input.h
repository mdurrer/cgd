#ifndef INPUT_H_INCLUDED
#define INPUT_H_INCLUDED

//TODO: Replace with a list of key codes
#include <SDL/SDL.h>
#include "math3d.h"

typedef int KEY;

namespace Input
{
	void Update();

	bool GetKeyDown(KEY key);
	bool GetKeyUp(KEY key);
	bool GetKey(KEY key);
	bool GetMouseDown(KEY key);
	bool GetMouseUp(KEY key);
	bool GetMouse(KEY key);
	Vector2f GetMousePos();
};

#endif // INPUT_H_INCLUDED
