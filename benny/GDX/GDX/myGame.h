#ifndef MYGAME_H_INCLUDED
#define MYGAME_H_INCLUDED

#include "component.h"

class MyGame : public GameComponent
{
public:
	MyGame();
	~MyGame();
	
	virtual void Input(GameObject* pGameObject);
	virtual void Update(GameObject* pGameObject);
	virtual void Render(GameObject* pGameObject);
protected:
private:
    MyGame(const MyGame& game) {} //Don't Implement
	void operator=(const MyGame& game) {} //Don't Implement
};

#endif // MYGAME_H_INCLUDED
