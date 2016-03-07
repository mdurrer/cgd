#ifndef CAMERA_H_INCLUDED
#define CAMERA_H_INCLUDED

#include "math3d.h"

class Camera
{
public:
	Camera(const Vector3f& pos = Vector3f(0,0,0), const Vector3f& forward = Vector3f(0,0,1), const Vector3f& up = Vector3f(0,1,0));

	void Move(const Vector3f& amt);
	void RotateX(float angle);
	void RotateY(float angle);
	void RotateZ(float angle);

	void Roll(float angle);
	void Pitch(float angle);
	void Yaw(float angle);

	Matrix4f GetPositionRotation() const;
	virtual Matrix4f GetProjection() const;

	Vector3f GetForward() const;
	Vector3f GetBack() const;
	Vector3f GetRight() const;
	Vector3f GetLeft() const;
	Vector3f GetUp() const;
	Vector3f GetDown() const;
	Vector3f GetPos() const;
protected:
private:
	Vector3f m_Pos;
	Vector3f m_Forward;
	Vector3f m_Up;
};

class PerspectiveCamera : public Camera
{
public:
    PerspectiveCamera(const Vector3f& pos = Vector3f(0,0,0), const Vector3f& forward = Vector3f(0,0,1), const Vector3f& up = Vector3f(0,1,0),
                      float fov = ToRadians(70.0f), float zNear = 0.01f, float zFar = 1000.0f);
                      
    virtual Matrix4f GetProjection() const;
    
    inline float GetFOV() const {return m_Fov;}
	inline float GetZNear() const {return m_ZNear;}
	inline float GetZFar() const {return m_ZFar;}
private:
    float m_Fov;
    float m_ZNear;
    float m_ZFar;
};

#endif // CAMERA_H_INCLUDED
