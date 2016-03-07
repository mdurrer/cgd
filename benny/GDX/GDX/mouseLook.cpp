#include "mouseLook.h"
#include "math3d.h"
#include "timing.h"
#include "input.h"
#include "engine.h"

MouseLook::MouseLook()
{

}

void MouseLook::Input(GameObject* pGameObject)
{    
	static bool mouseLocked = false;

	const float ROTSPEEDX = 150.0f;
	const float ROTSPEEDY = 175.0f;

	const float MOVSPEED = 10.0f;
	const float STRAFESPEED = MOVSPEED;
	const float SENSITIVITY_X = 0.004f;	
	const float SENSITIVITY_Y = SENSITIVITY_X * 1.0f;

	double delta = Time::GetDelta();

	Camera* camera = Engine::GetRenderingEngine()->GetCamera();

	if(Input::GetKey(SDLK_UP))
		camera->Pitch(ToRadians(ROTSPEEDX * delta));
	if(Input::GetKey(SDLK_DOWN))
		camera->Pitch(ToRadians(-ROTSPEEDX * delta));
	if(Input::GetKey(SDLK_LEFT))
		camera->Yaw(ToRadians(ROTSPEEDY * delta));
	if(Input::GetKey(SDLK_RIGHT))
		camera->Yaw(ToRadians(-ROTSPEEDY * delta));

	if(Input::GetKey(SDLK_q))
		camera->Roll(ToRadians(-ROTSPEEDX * delta));
	if(Input::GetKey(SDLK_e))
		camera->Roll(ToRadians(ROTSPEEDX * delta));

	if(Input::GetKey(SDLK_w))
		camera->Move(camera->GetForward() * (float)(MOVSPEED * delta));
	if(Input::GetKey(SDLK_s))
		camera->Move(camera->GetBack() * (float)(MOVSPEED * delta));
	if(Input::GetKey(SDLK_a))
		camera->Move(camera->GetLeft() * (float)(STRAFESPEED * delta));
	if(Input::GetKey(SDLK_d))
		camera->Move(camera->GetRight() * (float)(STRAFESPEED * delta));

	Vector2f centerPos = Engine::GetDisplay()->GetCenter();

	if(mouseLocked)
	{
		Vector2f deltaPos = centerPos - Input::GetMousePos();

		bool rotX = (int)(deltaPos.GetY()) != 0;
		bool rotY = (int)(deltaPos.GetX()) != 0;

		if(rotY)
			camera->RotateY(deltaPos.GetX() * SENSITIVITY_X);
		if(rotX)
			camera->Pitch(deltaPos.GetY() * SENSITIVITY_Y);

		if(rotX || rotY)
			Engine::GetDisplay()->SetMousePos(centerPos);
	}

	if(Input::GetMouseDown(SDL_BUTTON_LEFT))
	{
		mouseLocked = true;
		Engine::GetDisplay()->ShowMouse(false);
		Engine::GetDisplay()->SetMousePos(centerPos);
	}

	if(Input::GetKeyDown(SDLK_ESCAPE))
	{
		mouseLocked = false;
		Engine::GetDisplay()->ShowMouse(true);
	}
}