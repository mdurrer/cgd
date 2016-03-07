#include "math3d.h"

const Vector3f Vector3f::UP(0,1,0);
const Vector3f Vector3f::DOWN(0,-1,0);
const Vector3f Vector3f::LEFT(-1,0,0);
const Vector3f Vector3f::RIGHT(1,0,0);
const Vector3f Vector3f::FORWARD(0,0,1);
const Vector3f Vector3f::BACK(0,0,-1);
const Vector3f Vector3f::ONE(1,1,1);
const Vector3f Vector3f::ZERO(0,0,0);

Vector3f::Vector3f(float x, float y, float z)
{
    this->x = x;
    this->y = y;
    this->z = z;
}

float Vector3f::Length() const
{
    return sqrtf(x * x + y * y + z * z);
}

float Vector3f::Dot(const Vector3f& v) const
{
    return x * v.x + y * v.y + z * v.z;
}

Vector3f Vector3f::Cross(const Vector3f& v) const
{
    const float _x = y * v.z - z * v.y;
    const float _y = z * v.x - x * v.z;
    const float _z = x * v.y - y * v.x;

    return Vector3f(_x, _y, _z);
}

Vector3f Vector3f::Normalized() const
{
    return *this/Length();
}

Vector3f Vector3f::Rotate(const Vector3f& axis, float angle) const
{
    float sinAngle = sinf(angle);
	float cosAngle = cosf(angle);

	return this->Cross(axis * sinAngle) +           //Rotation on local X
		   (*this * cosAngle) +                     //Rotation on local Z
		   axis * this->Dot(axis * (1 - cosAngle)); //Rotation on local Y
}

Vector3f Vector3f::Rotate(const Quaternion& rotation) const
{
    Quaternion rotatedVector = rotation * *this * rotation.Conjugate();
    
    return Vector3f(rotatedVector.GetX(), rotatedVector.GetY(), rotatedVector.GetZ());
}

///////////////////////////////////////////////////////////////////////////////
//Vector2f SECTION
///////////////////////////////////////////////////////////////////////////////

float Vector2f::Length() const
{
    return sqrtf(x * x + y * y);
}

Vector2f Vector2f::Normalized() const
{
    return *this/Length();
}

///////////////////////////////////////////////////////////////////////////////
//MATRIX SECTION
///////////////////////////////////////////////////////////////////////////////
//const Matrix4f Matrix4f::IDENTITY =  Matrix4f();

Matrix4f Matrix4f::InitTranslation(const Vector3f& translation)
{
    Matrix4f r;
    
	r.m[0][0] = 1.0f; r.m[0][1] = 0.0f; r.m[0][2] = 0.0f; r.m[0][3] = translation.GetX();
    r.m[1][0] = 0.0f; r.m[1][1] = 1.0f; r.m[1][2] = 0.0f; r.m[1][3] = translation.GetY();
    r.m[2][0] = 0.0f; r.m[2][1] = 0.0f; r.m[2][2] = 1.0f; r.m[2][3] = translation.GetZ();
    r.m[3][0] = 0.0f; r.m[3][1] = 0.0f; r.m[3][2] = 0.0f; r.m[3][3] = 1.0f;
    
    return r;
}

Matrix4f Matrix4f::InitRotation(const Vector3f& eulerAngles)
{
	Matrix4f rx, ry, rz;

    const float x = ToRadians(eulerAngles.GetX());
    const float y = ToRadians(eulerAngles.GetY());
    const float z = ToRadians(eulerAngles.GetZ());

    rx.m[0][0] = 1.0f; rx.m[0][1] = 0.0f   ; rx.m[0][2] = 0.0f    ; rx.m[0][3] = 0.0f;
    rx.m[1][0] = 0.0f; rx.m[1][1] = cosf(x); rx.m[1][2] = -sinf(x); rx.m[1][3] = 0.0f;
    rx.m[2][0] = 0.0f; rx.m[2][1] = sinf(x); rx.m[2][2] = cosf(x) ; rx.m[2][3] = 0.0f;
    rx.m[3][0] = 0.0f; rx.m[3][1] = 0.0f   ; rx.m[3][2] = 0.0f    ; rx.m[3][3] = 1.0f;

    ry.m[0][0] = cosf(y); ry.m[0][1] = 0.0f; ry.m[0][2] = -sinf(y); ry.m[0][3] = 0.0f;
    ry.m[1][0] = 0.0f   ; ry.m[1][1] = 1.0f; ry.m[1][2] = 0.0f    ; ry.m[1][3] = 0.0f;
    ry.m[2][0] = sinf(y); ry.m[2][1] = 0.0f; ry.m[2][2] = cosf(y) ; ry.m[2][3] = 0.0f;
    ry.m[3][0] = 0.0f   ; ry.m[3][1] = 0.0f; ry.m[3][2] = 0.0f    ; ry.m[3][3] = 1.0f;

    rz.m[0][0] = cosf(z); rz.m[0][1] = -sinf(z); rz.m[0][2] = 0.0f; rz.m[0][3] = 0.0f;
    rz.m[1][0] = sinf(z); rz.m[1][1] = cosf(z) ; rz.m[1][2] = 0.0f; rz.m[1][3] = 0.0f;
    rz.m[2][0] = 0.0f   ; rz.m[2][1] = 0.0f    ; rz.m[2][2] = 1.0f; rz.m[2][3] = 0.0f;
    rz.m[3][0] = 0.0f   ; rz.m[3][1] = 0.0f    ; rz.m[3][2] = 0.0f; rz.m[3][3] = 1.0f;

    return rz * ry * rx;
}

//Matrix4f Matrix4f::InitRotation(const Vector3f& axis, float angle)
//{
//	return Matrix4f(DirectX::XMMatrixRotationAxis(DirectX::XMVectorSet(axis.x, axis.y, axis.z, 0), angle));
//}

Matrix4f Matrix4f::InitRotation(const Vector3f& forward, const Vector3f& up)
{
	Vector3f n = forward.Normalized();
    Vector3f u = up.Normalized().Cross(n);
    Vector3f v = n.Cross(u);
      
    return Matrix4f::InitRotation(n,v,u);
}

Matrix4f Matrix4f::InitRotation(const Vector3f& n, const Vector3f& v, const Vector3f& u)
{
    Matrix4f r;
    
    r.m[0][0] = u.GetX();   r.m[0][1] = u.GetY();   r.m[0][2] = u.GetZ();   r.m[0][3] = 0.0f;
    r.m[1][0] = v.GetX();   r.m[1][1] = v.GetY();   r.m[1][2] = v.GetZ();   r.m[1][3] = 0.0f;
    r.m[2][0] = n.GetX();   r.m[2][1] = n.GetY();   r.m[2][2] = n.GetZ();   r.m[2][3] = 0.0f;
    r.m[3][0] = 0.0f;       r.m[3][1] = 0.0f;       r.m[3][2] = 0.0f;       r.m[3][3] = 1.0f; 
    
    return r;
}

Matrix4f Matrix4f::InitScale(const Vector3f& scale)
{
    Matrix4f r;
    
	r.m[0][0] = scale.GetX(); r.m[0][1] = 0.0f;         r.m[0][2] = 0.0f;         r.m[0][3] = 0.0f;
    r.m[1][0] = 0.0f;         r.m[1][1] = scale.GetY(); r.m[1][2] = 0.0f;         r.m[1][3] = 0.0f;
    r.m[2][0] = 0.0f;         r.m[2][1] = 0.0f;         r.m[2][2] = scale.GetZ(); r.m[2][3] = 0.0f;
    r.m[3][0] = 0.0f;         r.m[3][1] = 0.0f;         r.m[3][2] = 0.0f;         r.m[3][3] = 1.0f;
    
    return r;
}

Matrix4f Matrix4f::InitLookAt(const Vector3f& eye, const Vector3f& at, const Vector3f& up)
{
	return InitLookTo(eye, eye - at, up);
}

Matrix4f Matrix4f::InitLookTo(const Vector3f& eye, const Vector3f& direction, const Vector3f& up)
{
    Matrix4f rotation = InitRotation(direction, up);
    Matrix4f position = InitTranslation(eye);
    return rotation * position;
}

Matrix4f Matrix4f::InitPerspective(float angle, float aspect, float zNear, float zFar)
{
    Matrix4f r;
    
	const float ar         = aspect;
    const float zRange     = zNear - zFar;
    const float tanHalfFOV = tanf(angle / 2.0f);

    r.m[0][0] = 1.0f/(tanHalfFOV * ar); r.m[0][1] = 0.0f;            r.m[0][2] = 0.0f;            r.m[0][3] = 0.0;
    r.m[1][0] = 0.0f;                   r.m[1][1] = 1.0f/tanHalfFOV; r.m[1][2] = 0.0f;            r.m[1][3] = 0.0;
    r.m[2][0] = 0.0f;                   r.m[2][1] = 0.0f;            r.m[2][2] = (-zNear - zFar)/zRange ; r.m[2][3] = 2.0f*zFar*zNear/zRange;
    r.m[3][0] = 0.0f;                   r.m[3][1] = 0.0f;            r.m[3][2] = 1.0f;            r.m[3][3] = 0.0;    
    
    return r;
}

Matrix4f Matrix4f::InitOrthographic(float left, float right, float bottom, float top, float near, float far)
{
    Matrix4f m;
    
    m[0][0] = 2/(right - left);					m[0][1] = 0;								m[0][2] = 0;					m[0][3] = 0;
    m[1][0] = 0;								m[1][1] = 2/(top - bottom);					m[1][2] = 0;					m[1][3] = 0;
    m[2][0] = 0;								m[2][1] = 0;								m[2][2] = -2/(far - near);		m[2][3] = 0;
    m[3][0] = -(right + left)/(right - left);	m[3][1] = -(top + bottom)/(top - bottom);	m[3][2] = -(far + near)/(far - near);	m[3][3] = 1;
    
    return m;
}

Matrix4f::Matrix4f()
{
	m[0][0] = 1.0f; m[0][1] = 0.0f; m[0][2] = 0.0f; m[0][3] = 0.0f;
    m[1][0] = 0.0f; m[1][1] = 1.0f; m[1][2] = 0.0f; m[1][3] = 0.0f;
    m[2][0] = 0.0f; m[2][1] = 0.0f; m[2][2] = 1.0f; m[2][3] = 0.0f;     
    m[3][0] = 0.0f; m[3][1] = 0.0f; m[3][2] = 0.0f; m[3][3] = 1.0f;
}

Vector3f Matrix4f::GetTranslation() const
{
	return Vector3f(m[0][3], m[1][3], m[2][3]);
}

Vector3f Matrix4f::Transform(const Vector3f& r, float w) const
{
	//float x = r.GetX() * m[0][0] + r.GetY() * m[0][1] + r.GetZ() * m[0][2] + w * m[0][3];
	//float y = r.GetX() * m[1][0] + r.GetY() * m[1][1] + r.GetZ() * m[1][2] + w * m[1][3];
	//float z = r.GetX() * m[2][0] + r.GetY() * m[2][1] + r.GetZ() * m[2][2] + w * m[2][3];

	float x = r.GetX() * m[0][0] + r.GetY() * m[1][0] + r.GetZ() * m[2][0] + w * m[3][0];
	float y = r.GetX() * m[0][1] + r.GetY() * m[1][1] + r.GetZ() * m[2][1] + w * m[3][1];
	float z = r.GetX() * m[0][2] + r.GetY() * m[1][2] + r.GetZ() * m[2][2] + w * m[3][2];

	return Vector3f(x,y,z);
}

/*
ToQuaternion() reference implementation, in Java
public Quaternion toQuaternion()
	{
		float trace = m[0][0] + m[1][1] + m[2][2];
		
		float w = 1;
		float x = 0;
		float y = 0;
		float z = 0;
		  if( trace > 0 ) 
		  {// I changed M_EPSILON to 0
		    float s = 0.5f / (float)Math.sqrt(trace+ 1.0f);
		    w = 0.25f / s;
		    x = ( m[1][2] - m[2][1] ) * s;
		    y = ( m[2][0] - m[0][2] ) * s;
		    z = ( m[0][1] - m[1][0] ) * s;
		  } 
		  else 
		  {
		    if ( m[0][0] > m[1][1] && m[0][0] > m[2][2] ) 
		    {
		      float s = 2.0f * (float)Math.sqrt( 1.0f + m[0][0] - m[1][1] - m[2][2]);
		      w = (m[1][2] - m[2][1] ) / s;
		      x = 0.25f * s;
		      y = (m[1][0] + m[0][1] ) / s;
		     z = (m[2][0] + m[0][2] ) / s;
		    } 
		    else if (m[1][1] > m[2][2]) 
		    {
		      float s = 2.0f * (float)Math.sqrt( 1.0f + m[1][1] - m[0][0] - m[2][2]);
		      w = (m[2][0] - m[0][2] ) / s;
		      x = (m[1][0] + m[0][1] ) / s;
		      y = 0.25f * s;
		      z = (m[2][1] + m[1][2] ) / s;
		    } 
		    else 
		    {
		      float s = 2.0f * (float)Math.sqrt( 1.0f + m[2][2] - m[0][0] - m[1][1] );
		      w = (m[0][1] - m[1][0] ) / s;
		      x = (m[2][0] + m[0][2] ) / s;
		      y = (m[1][2] + m[2][1] ) / s;
		      z = 0.25f * s;
		    }
		  }
		  
		  return new Quaternion(x,y,z,w);
	}
*/
///////////////////////////////////////////////////////////////////////////////
//QUATERNION SECTION
///////////////////////////////////////////////////////////////////////////////

Quaternion Quaternion::RotationBetween(const Vector3f& from, const Vector3f& to)
{
    Vector3f H = (from + to).Normalized();

    float w = from.Dot(H);
    float x = from.GetY()*H.GetZ() - from.GetZ()*H.GetY();
    float y = from.GetZ()*H.GetX() - from.GetX()*H.GetZ();
    float z = from.GetX()*H.GetY() - from.GetY()*H.GetX();
    
    return Quaternion(x,y,z,w);
}

Quaternion::Quaternion(float _x, float _y, float _z, float _w)
{
    x = _x;
    y = _y;
    z = _z;
    w = _w;
}

Quaternion::Quaternion(const Vector3f& axis, float angle)
{
    float sinHalfAngle = sinf(angle / 2);
	float cosHalfAngle = cosf(angle / 2);

    x = axis.GetX() * sinHalfAngle;
    y = axis.GetY() * sinHalfAngle;
    z = axis.GetZ() * sinHalfAngle;
    w = cosHalfAngle;
}

Quaternion Quaternion::Normalized() const
{
    return *this/Length();
}


Quaternion Quaternion::Conjugate() const
{
    Quaternion ret(-x, -y, -z, w);
    return ret;
}

float Quaternion::Length() const
{
    return sqrtf(x * x + y * y + z * z + w * w);
}

float Quaternion::LengthSq() const
{
    return x * x + y * y + z * z + w * w;
}

float Quaternion::Dot(const Quaternion& r) const
{
    return x * r.x + y * r.y + z * r.z + w * r.w;
}

Quaternion Quaternion::NLerp(const Quaternion& dest, float amt) const
{	
    return *this + ((dest - *this) * amt).Normalized();
}

Quaternion Quaternion::SLerp(const Quaternion& dest, float amt) const
{
    Quaternion r2 = dest;
		
    float dot = this->Dot(r2);
		
    if(dot < 0)
    {
        r2 = r2 * -1;
        dot *= -1;
    }
		
    if(dot > 0.9995f) //Too close for accurate slerp
        return this->NLerp(r2, amt);
		
//	float theta = (float) (Math.acos(dot) * amt);
//	
//	float sininvamttheta = (float)Math.sin((1.0f - amt) * theta);
//	float sinamttheta = (float)(Math.sin(theta * amt));
//	float sintheta = (float)Math.sin(theta);
//	
//	Quaternion factor2 = r2.mul(sinamttheta).div(sintheta);
//	
//	return this.mul(sininvamttheta).add(factor2).normalized();
		
    if(dot > 1.0f)
        dot = 1.0f;
    if(dot < -1.0f)
        dot = -1.0f;
    
    float theta = (float)(acos(dot) * amt);
    float cosTheta = cos(theta);
    float sinTheta = sin(theta);
    
    Quaternion res = dest - (*this * dot).Normalized();
    
    return ((*this * cosTheta) + (res * sinTheta)).Normalized();
    //return this.mul((float)Math.cos(theta)).add(res.mul((float)Math.sin(theta))).normalized();
}
