#ifndef RENDERINGENGINE_H_INCLUDED
#define RENDERINGENGINE_H_INCLUDED

#include "gameObject.h"
struct UniformData;

class RenderingEngine
{
public:
	RenderingEngine(Camera* camera = &DefaultCamera);
    virtual void Render(GameObject* pGameObject);
	virtual void UpdateUniform(UniformData* uniform, Transform& transform, Material& material);

	Camera* GetCamera();
	void SetCamera(Camera* pCamera);
	
protected:
private:
	static PerspectiveCamera DefaultCamera;
	Camera* m_pCamera;
};

#endif