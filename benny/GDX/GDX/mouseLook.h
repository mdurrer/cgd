#ifndef MOUSELOOK_H
#define MOUSELOOK_H

#include "component.h"

class MouseLook : public GameComponent
{
public:
	MouseLook();
	
	virtual void Input(GameObject* pGameObject);
protected:
private:
};

#endif