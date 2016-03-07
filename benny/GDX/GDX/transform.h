#ifndef TRANSFORM_H_INCLUDED
#define TRANSFORM_H_INCLUDED

#include "math3d.h"
#include "camera.h"

class Transform
{
public:
	Vector3f			Pos;
	Quaternion			Rotation;
	Vector3f			Scale;
	
	Transform(const Vector3f& pos = Vector3f(0,0,0), const Quaternion& rotation = Quaternion(0,0,0,1), const Vector3f& scale = Vector3f(1,1,1));

	Matrix4f& GetModel(bool calcModel = true);
	Matrix4f& GetMVP(bool calcMVP = true, bool calcModel = true);

	void SetChildModel(const Matrix4f& childModel);

	static void CalcViewProjection();
	static void CalcViewProjection(const Camera* camera);
	static void CalcViewProjection(const Matrix4f& view, const Matrix4f& projection);
	
	static Vector3f GetEyePosition();
	static void SetView(const Matrix4f& view);
	static void SetProjection(const Matrix4f& projection);
protected:
private:
	static Vector3f EyePosition;
    static Matrix4f View;
	static Matrix4f Projection;
	static Matrix4f ViewProjection;
	void CalcModel();

	Matrix4f			m_Model;
	Matrix4f			m_MVP;
	Matrix4f			m_ChildModel;
};

#endif // TRANSFORM_H_INCLUDED
