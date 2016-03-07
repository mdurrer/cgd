#include "myGame.h"
#include "input.h"
#include "engine.h"
#include "transform.h"
#include "mesh.h"
#include "shader.h"
#include "timing.h"
#include "material.h"
#include "input.h"
#include "camera.h"
#include "gameObject.h"
#include "texture.h"

//--------------------------------------------------------------------------------------
// Global Variables
//--------------------------------------------------------------------------------------
static PerspectiveCamera	g_Camera;
static GameObject			g_GameObject1;
static GameObject			g_GameObject2;

//--------------------------------------------------------------------------------------
// Forward declarations
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Class methods
//--------------------------------------------------------------------------------------
MyGame::MyGame()
{
	//Vertex vertices[] = {Vertex(Vector3f(-1.0f, -1.0f, 0.5773f), Vector2f(0.0f, 0.0f)),
	//					 Vertex(Vector3f(0.0f, -1.0f, -1.15475f), Vector2f(0.5f, 0.0f)),
	//					 Vertex(Vector3f(1.0f, -1.0f, 0.5773f), Vector2f(1.0f, 0.0f)),
	//					 Vertex(Vector3f(0.0f, 1.0f, 0.0f), Vector2f(0.5f, 1.0f))};

	//INDEX indices[] = { 0, 3, 1,
	//					1, 3, 2,
	//					2, 3, 0,
	//					1, 2, 0};

	//Mesh::Create("pyramid", vertices, sizeof(vertices)/sizeof(Vertex), indices, sizeof(indices)/sizeof(INDEX));

	g_GameObject1 = GameObject(Transform(), RenderingComponent::Create("ShadedEgg", Mesh::Get("egg1.obj"), Material::Create("brick", Texture::Get("bricks.jpg")), Shader::Get("phongShader")));
	g_GameObject2 = GameObject(Transform(Vector3f(), Quaternion(), Vector3f(0.3f, 0.3f, 0.3f)), RenderingComponent::Get("ShadedEgg"));
	g_Camera = PerspectiveCamera(Vector3f(0, 1, -5), Vector3f::FORWARD, Vector3f::UP, ToRadians(70.0f), 0.01f, 1000.0f);

	Material::Get("brick")->AddFloat("specularIntensity", 2.0f);
	Material::Get("brick")->AddFloat("specularPower", 32.0f);
}

MyGame::~MyGame()
{

}

void MyGame::Input(GameObject* pGameObject)
{    
	static bool mouseLocked = false;

	const float ROTSPEEDX = 150.0f;
	const float ROTSPEEDY = 175.0f;

	const float MOVSPEED = 10.0f;
	const float STRAFESPEED = MOVSPEED;
	const float SENSITIVITY_X = 0.004f;	
	const float SENSITIVITY_Y = SENSITIVITY_X * 1.0f;

	double delta = Time::GetDelta();

	if(Input::GetKey(SDLK_UP))
		g_Camera.Pitch(ToRadians(ROTSPEEDX * delta));
	if(Input::GetKey(SDLK_DOWN))
		g_Camera.Pitch(ToRadians(-ROTSPEEDX * delta));
	if(Input::GetKey(SDLK_LEFT))
		g_Camera.Yaw(ToRadians(ROTSPEEDY * delta));
	if(Input::GetKey(SDLK_RIGHT))
		g_Camera.Yaw(ToRadians(-ROTSPEEDY * delta));

	if(Input::GetKey(SDLK_q))
		g_Camera.Roll(ToRadians(-ROTSPEEDX * delta));
	if(Input::GetKey(SDLK_e))
		g_Camera.Roll(ToRadians(ROTSPEEDX * delta));

	if(Input::GetKey(SDLK_w))
		g_Camera.Move(g_Camera.GetForward() * (float)(MOVSPEED * delta));
	if(Input::GetKey(SDLK_s))
		g_Camera.Move(g_Camera.GetBack() * (float)(MOVSPEED * delta));
	if(Input::GetKey(SDLK_a))
		g_Camera.Move(g_Camera.GetLeft() * (float)(STRAFESPEED * delta));
	if(Input::GetKey(SDLK_d))
		g_Camera.Move(g_Camera.GetRight() * (float)(STRAFESPEED * delta));

	Vector2f centerPos = Engine::GetDisplay()->GetCenter();

	if(mouseLocked)
	{
		Vector2f deltaPos = centerPos - Input::GetMousePos();

		bool rotX = (int)(deltaPos.GetY()) != 0;
		bool rotY = (int)(deltaPos.GetX()) != 0;

		if(rotY)
			g_Camera.RotateY(deltaPos.GetX() * SENSITIVITY_X);
		if(rotX)
			g_Camera.Pitch(deltaPos.GetY() * SENSITIVITY_Y);

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

void MyGame::Update(GameObject* pGameObject)
{
	g_GameObject1.GetTransform().Rotation = Quaternion(Vector3f::UP, (float)Time::GetElapsedTime());

	g_GameObject2.GetTransform().Pos = Vector3f(-4.0f, 0.0f, 0.0f).Rotate(Quaternion(Vector3f::UP, (float)Time::GetElapsedTime() * 2.0f));
	g_GameObject2.GetTransform().Rotation = Quaternion(Vector3f::FORWARD, -(float)Time::GetElapsedTime());
}

void MyGame::Render(GameObject* pGameObject)
{
    Transform::CalcViewProjection(&g_Camera);

	g_GameObject1.Render();
	g_GameObject2.Render();
}
