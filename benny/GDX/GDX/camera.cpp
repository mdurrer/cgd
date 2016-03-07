#include "camera.h"
#include "engine.h"

Camera::Camera(const Vector3f& pos, const Vector3f& forward, const Vector3f& up)
{
	m_Pos = pos;
	m_Forward = forward.Normalized();
	m_Up = up.Normalized();
}

void Camera::Move(const Vector3f& amt)
{
	m_Pos += amt;
}

void Camera::RotateX(float angle)
{
	m_Forward = m_Forward.Rotate(Vector3f::RIGHT, angle).Normalized();
	m_Up = m_Up.Rotate(Vector3f::RIGHT, angle).Normalized();
}

void Camera::RotateY(float angle)
{
	m_Forward = m_Forward.Rotate(Vector3f::UP, angle).Normalized();
	m_Up = m_Up.Rotate(Vector3f::UP, angle).Normalized();
}

void Camera::RotateZ(float angle)
{
	m_Forward = m_Forward.Rotate(Vector3f::FORWARD, angle).Normalized();
	m_Up = m_Up.Rotate(Vector3f::FORWARD, angle).Normalized();
}

void Camera::Roll(float angle)
{
	m_Up = m_Up.Rotate(m_Forward, angle).Normalized();
};

void Camera::Pitch(float angle)
{
	Vector3f right = m_Up.Cross(m_Forward).Normalized();

	m_Forward = m_Forward.Rotate(right, angle).Normalized();
	m_Up = m_Forward.Cross(right).Normalized();
};

void Camera::Yaw(float angle)
{
	m_Forward = m_Forward.Rotate(m_Up, angle).Normalized();
};

Matrix4f Camera::GetPositionRotation() const
{
	return Matrix4f::InitLookTo(m_Pos * -1, m_Forward, m_Up);
}

Matrix4f Camera::GetProjection() const
{
    return Matrix4f();//Matrix4f::IDENTITY;
}

Vector3f Camera::GetForward() const
{
	return m_Forward;
}

Vector3f Camera::GetBack() const
{
	return m_Forward * -1;
}

Vector3f Camera::GetRight() const
{
	return m_Up.Cross(m_Forward).Normalized();
}

Vector3f Camera::GetLeft() const
{
	return m_Forward.Cross(m_Up).Normalized();
}

Vector3f Camera::GetUp() const
{
	return m_Up;
}

Vector3f Camera::GetDown() const
{
	return m_Up * -1;
}

Vector3f Camera::GetPos() const
{
	return m_Pos;
}

//Perspective Camera
PerspectiveCamera::PerspectiveCamera(const Vector3f& pos, const Vector3f& forward, const Vector3f& up,
                                     float fov, float zNear, float zFar) : Camera(pos, forward, up)
{
    m_Fov = fov;
    m_ZNear = zNear;
    m_ZFar = zFar;
}

Matrix4f PerspectiveCamera::GetProjection() const
{
    return Matrix4f::InitPerspective(m_Fov, Engine::GetDisplay()->GetAspect(), m_ZNear, m_ZFar);
}
