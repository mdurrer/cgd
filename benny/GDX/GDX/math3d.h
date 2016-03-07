#ifndef MATH3D_H_INCLUDED
#define MATH3D_H_INCLUDED

#define PI 3.1415926536f
#define DEG2RAD PI/ 180.0f
#define RAD2DEG 180.0f / PI

#define ToRadians(x) (float)(((x) * DEG2RAD))
#define ToDegrees(x) (float)(((x) * RAD2DEG))


#include <math.h>

class Quaternion;

class Vector3f
{
public:
    static const Vector3f UP;
    static const Vector3f DOWN;
    static const Vector3f LEFT;
    static const Vector3f RIGHT;
    static const Vector3f FORWARD;
    static const Vector3f BACK;
    static const Vector3f ONE;
    static const Vector3f ZERO;

    Vector3f(float x = 0.0f, float y = 0.0f, float z = 0.0f);
        
    float Length() const;
    float Dot(const Vector3f& v) const;
    Vector3f Cross(const Vector3f& v) const;
    Vector3f Rotate(const Vector3f& axis, float angle) const;
    Vector3f Rotate(const Quaternion& rotation) const;
    Vector3f Normalized() const;

    inline Vector3f operator+=(const Vector3f& r)
    {
        x += r.x; 
        y += r.y;
        z += r.z;
        return *this;
    }
        
    inline Vector3f operator-=(const Vector3f& r)
    {
        x -= r.x;
        y -= r.y;
        z -= r.z;

        return *this;
    }
        
    inline Vector3f operator*=(float f)
    {
        x *= f;
        y *= f;
        z *= f;

        return *this;
    }
        
    inline Vector3f operator/=(float f)
    {
        x /= f;
        y /= f;
        z /= f;

        return *this;
    }

    inline Vector3f operator+(const Vector3f& r) const {return Vector3f(x + r.x, y + r.y, z + r.z);}
    inline Vector3f operator-(const Vector3f& r) const {return Vector3f(x - r.x, y - r.y, z - r.z);}
    inline Vector3f operator*(float f) const {return Vector3f(x * f, y * f, z * f);}
    inline Vector3f operator/(float f) const {return Vector3f(x / f, y / f, z / f);}

    inline bool operator==(const Vector3f& r) const {return x == r.x && y == r.y && z == r.z;}
    inline bool operator!=(const Vector3f& r) const {return !operator==(r);}
        
    inline float GetX() const {return x;}
    inline float GetY() const {return y;}
    inline float GetZ() const {return z;}
        
    inline void SetX(float X) {x = X;}
    inline void SetY(float Y) {y = Y;}
    inline void SetZ(float Z) {z = Z;}
private:
    float x,y,z;
};

class Vector2f
{
public:
    Vector2f(float x = 0.0f, float y = 0.0f)
    {
        this->x = x;
        this->y = y;
    }

    //TODO: Functions!
	float Length() const;
	Vector2f Normalized() const;

    inline Vector2f operator+=(const Vector2f& r)
    {
        x += r.x;
        y += r.y;

        return *this;
    }
    
    inline Vector2f operator-=(const Vector2f& r)
    {
        x -= r.x;
        y -= r.y;

        return *this;
    }
    
    inline Vector2f operator*=(float f)
    {
        x *= f;
        y *= f;

        return *this;
    }

    inline Vector2f operator/=(float f)
    {
        x /= f;
        y /= f;

        return *this;
    }

    inline Vector2f operator+(const Vector2f& r) const {return Vector2f(x + r.x, y + r.y);}
    inline Vector2f operator-(const Vector2f& r) const {return Vector2f(x - r.x, y - r.y);}
    inline Vector2f operator*(float f) const {return Vector2f(x * f, y * f);}
    inline Vector2f operator/(float f) const {return Vector2f(x / f, y / f);}

    inline bool operator==(const Vector2f& r) const {return x == r.x && y == r.y;}
    inline bool operator!=(const Vector2f& r) const {return !operator==(r);}
    
    inline float GetX() const {return x;}
    inline float GetY() const {return y;}
        
    inline void SetX(float X) {x = X;}
    inline void SetY(float Y) {y = Y;}
private:
    float x;
    float y;

};

//TODO: Finish implementing matrix class!
class Matrix4f 
{
public:
    //static const Matrix4f IDENTITY;

	static Matrix4f InitTranslation(const Vector3f& translation);
	static Matrix4f InitRotation(const Vector3f& eulerAngles);
	static Matrix4f InitRotation(const Vector3f& axis, float angle); //TODO: Implement!
	static Matrix4f InitRotation(const Vector3f& forward, const Vector3f& up);
	static Matrix4f InitRotation(const Vector3f& forward, const Vector3f& up, const Vector3f& right);
	static Matrix4f InitScale(const Vector3f& scale);

	static Matrix4f InitLookAt(const Vector3f& eye, const Vector3f& at, const Vector3f& up);
	static Matrix4f InitLookTo(const Vector3f& eye, const Vector3f& direction, const Vector3f& up);
	static Matrix4f InitPerspective(float angle, float aspect, float zNear, float zFar);
	static Matrix4f InitOrthographic(float left, float right, float bottom, float top, float near, float far);

    Matrix4f();
    
    Matrix4f Transpose() const;             //TODO: Implement!
    //Quaternion ToQuaternion() const;      //Possible future method!
	Vector3f GetTranslation() const;
	Vector3f Transform(const Vector3f& right, float w = 1.0f) const;
	Vector3f GetPositionFromUnscaledMatrix() const {return this->Transform(this->GetTranslation() * -1, 0.0f);}
    
    inline Matrix4f operator*(const Matrix4f& right) const
    {
        Matrix4f ret;
        for (unsigned int i = 0 ; i < 4 ; i++) 
        {
            for (unsigned int j = 0 ; j < 4 ; j++)
            {
                ret.m[i][j] = m[i][0] * right.m[0][j] +
                              m[i][1] * right.m[1][j] +
                              m[i][2] * right.m[2][j] +
                              m[i][3] * right.m[3][j];
            }
        }
        return ret;
    }
    
    const float* operator[](int index) const {return m[index];}
    float* operator[](int index) {return m[index];}

protected:
private:
    float m[4][4];
        
};

class Quaternion
{
public:
    static Quaternion RotationBetween(const Vector3f& from, const Vector3f& to);
    
    Quaternion(float _x = 0.0f, float _y = 0.0f, float _z = 0.0f, float _w = 0.0f);
    Quaternion(const Vector3f& axis, float angle);

    float Length() const;
	float LengthSq() const;
	float Dot(const Quaternion& r) const;

    Quaternion Normalized() const;
    Quaternion Conjugate() const; 
    Quaternion NLerp(const Quaternion& dest, float amt) const;
    Quaternion SLerp(const Quaternion& dest, float amt) const;

    inline Vector3f GetRight() const   {return Vector3f(1.0f - 2.0f * (y * y + z * z), 2.0f * (x * y - w * z), 2.0f * (x * z + w * y));}
    inline Vector3f GetUp() const      {return Vector3f(2.0f * (x * y + w * z), 1.0f - 2.0f * (x * x + z * z), 2.0f * (y * z - w * x));}
    inline Vector3f GetForward() const {return Vector3f(2.0f * (x * z - w * y), 2.0f * (y * z + w * x), 1.0f - 2.0f * (x * x + y * y));}
    
    inline Vector3f GetLeft() const    {return Vector3f(-(1.0f - 2.0f * (y * y + z * z)), -2.0f * (x * y - w * z), -2.0f * (x * z + w * y));}
    inline Vector3f GetDown() const    {return Vector3f(-2.0f * (x * y + w * z), -(1.0f - 2.0f * (x * x + z * z)), -2.0f * (y * z - w * x));}
    inline Vector3f GetBack() const    {return Vector3f(-2.0f * (x * z - w * y), -2.0f * (y * z + w * x), -(1.0f - 2.0f * (x * x + y * y)));}

    inline Matrix4f ToMatrix() const   {return Matrix4f::InitRotation(GetForward(), GetUp(), GetRight());}

    inline Vector3f ToEulerAngles() const
    {
        float sqx = x * x;
		float sqy = y * y;
		float sqz = z * z;
		float sqw = w * w;
		float unit = sqx + sqy + sqz + sqw;
		float test = x * y + z * w;
		
		float heading = 0;
		float attitude = 0;
		float bank = 0;
		
		if (test > 0.499f * unit)
		{ // singularity at north pole
			heading = 2.0f * (float)atan2(x, w);
			attitude = (float)PI / 2.0f;
			bank = 0.0f;
		}
		else if (test < -0.499 * unit)
		{ // singularity at south pole
			heading = -2.0f * (float)atan2(x, w);
			attitude = -(float)PI / 2.0f;
			bank = 0.0f;
		}
		else
		{
			heading = (float)atan2(2.0f * y * w - 2.0f * x * z, sqx - sqy - sqz + sqw);
			attitude = (float)asin(2.0f * test / unit);
			bank = (float)atan2(2.0f * x * w - 2.0f * y * z, -sqx + sqy - sqz + sqw);
		}
		
		return Vector3f((float)ToDegrees(bank), (float)ToDegrees(heading), (float)ToDegrees(attitude));
    }

    inline Quaternion operator+(const Quaternion& r) const {return Quaternion(x + r.x, y + r.y, z + r.z, w + r.w);}
    inline Quaternion operator-(const Quaternion& r) const {return Quaternion(x - r.x, y - r.y, z - r.z, w - r.w);}
    inline Quaternion operator*(const Quaternion& r) const
    {
        const float _w = (w * r.w) - (x * r.x) - (y * r.y) - (z * r.z);
        const float _x = (x * r.w) + (w * r.x) + (y * r.z) - (z * r.y);
        const float _y = (y * r.w) + (w * r.y) + (z * r.x) - (x * r.z);
        const float _z = (z * r.w) + (w * r.z) + (x * r.y) - (y * r.x);

        return Quaternion(_x, _y, _z, _w);     
    }
    
    inline Quaternion operator*(const Vector3f& v) const
    {
        const float _w = - (x * v.GetX()) - (y * v.GetY()) - (z * v.GetZ());
        const float _x =   (w * v.GetX()) + (y * v.GetZ()) - (z * v.GetY());
        const float _y =   (w * v.GetY()) + (z * v.GetX()) - (x * v.GetZ());
        const float _z =   (w * v.GetZ()) + (x * v.GetY()) - (y * v.GetX());

        return Quaternion(_x, _y, _z, _w);
    }
    
    inline Quaternion operator*(const float r) const {return Quaternion(x * r, y  * r, z * r, w * r);}
    inline Quaternion operator/(const float r) const {return Quaternion(x / r, y  / r, z / r, w / r);}
    
    inline void operator+=(const Quaternion& r) {*this = *this + r;}
	inline void operator-=(const Quaternion& r) {*this = *this - r;}
	inline void operator*=(const Quaternion& r) {*this = *this * r;}
	inline void operator*=(const Vector3f& r)   {*this = *this * r;}
	inline void operator*=(float r)             {*this = *this * r;}
	inline void operator/=(float r)             {*this = *this / r;}
    
    inline float GetX() const {return x;}
    inline float GetY() const {return y;}
    inline float GetZ() const {return z;}
    inline float GetW() const {return w;}
        
    inline void SetX(float X) {x = X;}
    inline void SetY(float Y) {y = Y;}
    inline void SetZ(float Z) {z = Z;}
    inline void SetW(float W) {w = W;}
    inline void Set(float X, float Y, float Z, float W) {SetX(X); SetY(Y); SetZ(Z); SetW(W);}
private:
    float x, y, z, w;
};

#endif // MATH3D_H_INCLUDED
