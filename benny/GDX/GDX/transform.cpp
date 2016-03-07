#include "transform.h"

Vector3f Transform::EyePosition = Vector3f(0,0,0);
Matrix4f Transform::View = Matrix4f();
Matrix4f Transform::Projection = Matrix4f();
Matrix4f Transform::ViewProjection = Matrix4f();

Transform::Transform(const Vector3f& pos, const Quaternion& rotation, const Vector3f& scale)
{
	Pos = pos;
	Rotation = rotation;
	Scale = scale;
	m_Model = Matrix4f();//Matrix4f::IDENTITY;
	m_MVP = Matrix4f();//Matrix4f::IDENTITY;
	m_ChildModel = Matrix4f();//Matrix4f::IDENTITY;
}

Matrix4f& Transform::GetModel(bool calcModel)
{
	if(calcModel)
		CalcModel();

	return m_Model;
}

Matrix4f& Transform::GetMVP(bool calcMVP, bool calcModel)
{
	if(calcModel)
		CalcModel();
	if(calcMVP || calcModel)
		m_MVP = ViewProjection * m_Model;

	return m_MVP;
}

void Transform::SetChildModel(const Matrix4f& childModel)
{
	m_ChildModel = childModel;
}

void Transform::CalcModel()
{
	Matrix4f translation = Matrix4f::InitTranslation(Pos);
	Matrix4f scale = Matrix4f::InitScale(Scale);

	m_Model = m_ChildModel * translation * Rotation.ToMatrix() * scale;
}

void Transform::CalcViewProjection()
{
	ViewProjection = Transform::Projection * Transform::View;
}

void Transform::CalcViewProjection(const Camera* camera)
{
    CalcViewProjection(camera->GetPositionRotation(), camera->GetProjection());
}

void Transform::CalcViewProjection(const Matrix4f& view, const Matrix4f& projection)
{
    SetView(view);
    SetProjection(projection);
    CalcViewProjection();
}

Vector3f Transform::GetEyePosition()
{
	return Transform::EyePosition;
}

void Transform::SetView(const Matrix4f& view)
{
    Transform::View = view;
	EyePosition = view.GetPositionFromUnscaledMatrix();
}

void Transform::SetProjection(const Matrix4f& projection)
{
    Transform::Projection = projection;
}

