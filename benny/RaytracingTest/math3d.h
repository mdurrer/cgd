#ifndef MATH3D_H
#define MATH3D_H

#include <math.h>
#include <algorithm>
#include "globalData.h"

template<typename T>
inline T Clamp(const T &a, const T &min, const T &max)
{
	if (a < min) return min;
	else if (a > max) return max; 
	else return a;
}

template<typename T> inline T degtorad(const T &angle) { return angle * M_PI / T(180); }

template<typename T>
bool solveQuadratic(const T &a, const T &b, const T &c, T &x0, T &x1)
{
	T discr = b * b - 4 * a * c;
	if (discr <= 0) return false;
	//else if (discr == 0) x0 = x1 = - 0.5 * b / a;
	//else {
		T q = (b < 0) ? 
			-0.5 * (b - sqrt(discr)) :
			-0.5 * (b + sqrt(discr));
		x0 = q / a;
		x1 = c / q;
	//}
	if (x0 > x1) std::swap(x0, x1);
	return true;
}

class Vector3f
{
public:
	Vector3f(float x = 0.0f, float y = 0.0f, float z = 0.0f)  : 
		x(x), 
		y(y), 
		z(z) {}
	
	inline Vector3f Cross(const Vector3f& r) const
	{
		return Vector3f(y * r.GetZ() - z * r.GetY(), 
		                z * r.GetX() - x * r.GetZ(), 
		                x * r.GetY() - y * r.GetX());
	}
	
	inline Vector3f Normalized() const { return (*this)/Length(); }
	inline float Length() const { return sqrtf(LengthSq()); }
	inline float LengthSq() const { return Dot(*this); }
	inline float Dot(const Vector3f& r) const { return x * r.GetX() + y * r.GetY() + z * r.GetZ(); }
	
	inline float GetX() const { return x; }
	inline float GetY() const { return y; }
	inline float GetZ() const { return z; }
	
	inline void SetX(float x) { this->x = x; }
	inline void SetY(float y) { this->y = y; }
	inline void SetZ(float z) { this->z = z; }
	
	inline Vector3f operator+(const Vector3f& r) const { return Vector3f(x + r.GetX(), y + r.GetY(), z + r.GetZ()); }
	inline Vector3f operator-(const Vector3f& r) const { return Vector3f(x - r.GetX(), y - r.GetY(), z - r.GetZ()); }
	inline Vector3f operator*(const float r) const { return Vector3f(x*r,y*r,z*r); }
	inline Vector3f operator/(const float r) const { return Vector3f(x/r,y/r,z/r); }
	
	inline void operator+=(const Vector3f& r) { *this = *this + r; }
	inline void operator-=(const Vector3f& r) { *this = *this - r; }
	inline void operator*=(float r) { *this = *this * r; }
	inline void operator/=(float r) { *this = *this / r; }
	
	inline bool operator==(const Vector3f& r) { return x == r.GetX() && y == r.GetY() && z == r.GetZ(); }
	
	friend Vector3f operator * (const float s, const Vector3f& v) { return Vector3f(s * v.GetX(), s * v.GetY(), s * v.GetZ()); }
	friend Vector3f operator / (const float s, const Vector3f& v) { return Vector3f(s / v.GetX(), s / v.GetY(), s / v.GetZ()); } 
protected:
private:
	float x;
	float y;
	float z;
};

class Vector2f
{
public:
	Vector2f(float x = 0.0f, float y = 0.0f) :
		x(x),
		y(y) {}
	
	inline float GetX() const { return x; }
	inline float GetY() const { return y; }
	
	inline bool operator==(const Vector2f& r) { return x == r.GetX() && y == r.GetY(); }
protected:
private:
	float x;
	float y;
};

class Matrix4f
{
public:
	Matrix4f InitIdentity()
	{
		m[0][0] = 1.0f;
		m[0][1] = 0.0f;
		m[0][2] = 0.0f;
		m[0][3] = 0.0f;
		m[1][0] = 0.0f;
		m[1][1] = 1.0f;
		m[1][2] = 0.0f;
		m[1][3] = 0.0f;
		m[2][0] = 0.0f;
		m[2][1] = 0.0f;
		m[2][2] = 1.0f;
		m[2][3] = 0.0f;
		m[3][0] = 0.0f;
		m[3][1] = 0.0f;
		m[3][2] = 0.0f;
		m[3][3] = 1.0f;
		
		return *this;
	}
	
	Matrix4f InitScale(const Vector3f& scale)
	{
		m[0][0] = scale.GetX(); m[1][0] = 0;            m[2][0] = 0;            m[3][0] = 0;
		m[0][1] = 0;            m[1][1] = scale.GetY(); m[2][1] = 0;            m[3][1] = 0;
		m[0][2] = 0;            m[1][2] = 0;            m[2][2] = scale.GetZ(); m[3][2] = 0;
		m[0][3] = 0;            m[1][3] = 0;            m[2][3] = 0;            m[3][3] = 1;
		
		return *this;
	}
	Matrix4f InitTranslation(const Vector3f& translation)
	{
		m[0][0] = 1; m[1][0] = 0; m[2][0] = 0; m[3][0] = translation.GetX();
		m[0][1] = 0; m[1][1] = 1; m[2][1] = 0; m[3][1] = translation.GetY();
		m[0][2] = 0; m[1][2] = 0; m[2][2] = 1; m[3][2] = translation.GetZ();
		m[0][3] = 0; m[1][3] = 0; m[2][3] = 0; m[3][3] = 1;

		return *this;
	}

	Vector3f Transform(const Vector3f& src) const
	{
		float x = src.GetX() * m[0][0] + src.GetY() * m[1][0] + src.GetZ() * m[2][0] + m[3][0];
		float y = src.GetX() * m[0][1] + src.GetY() * m[1][1] + src.GetZ() * m[2][1] + m[3][1];
		float z = src.GetX() * m[0][2] + src.GetY() * m[1][2] + src.GetZ() * m[2][2] + m[3][2];
		float w = src.GetX() * m[0][3] + src.GetY() * m[1][3] + src.GetZ() * m[2][3] + m[3][3];
		
		return Vector3f(x/w,y/w,z/w);
	}
	
	Vector3f Transform3x3(const Vector3f& src) const
	{
		return Vector3f(src.GetX() * m[0][0] + src.GetY() * m[1][0] + src.GetZ() * m[2][0],
		                src.GetX() * m[0][1] + src.GetY() * m[1][1] + src.GetZ() * m[2][1],
		                src.GetX() * m[0][2] + src.GetY() * m[1][2] + src.GetZ() * m[2][2]);
	}

	Matrix4f Inverse() const
	{
		int i, j, k;
		Matrix4f s;
		Matrix4f t(*this);

		// Forward elimination
		for (i = 0; i < 3 ; i++) {
			int pivot = i;

			float pivotsize = t[i][i];

			if (pivotsize < 0)
				pivotsize = -pivotsize;

			for (j = i + 1; j < 4; j++) {
				float tmp = t[j][i];

				if (tmp < 0)
					tmp = -tmp;

				if (tmp > pivotsize) {
					pivot = j;
					pivotsize = tmp;
				}
			}

			if (pivotsize == 0) {
				//if (singExc)
				//	throw ::Imath::SingMatrixExc ("Cannot invert singular matrix.");

				return Matrix4f();
			}

			if (pivot != i) {
				for (j = 0; j < 4; j++) {
					float tmp;

					tmp = t[i][j];
					t[i][j] = t[pivot][j];
					t[pivot][j] = tmp;

					tmp = s[i][j];
					s[i][j] = s[pivot][j];
					s[pivot][j] = tmp;
				}
			}

			for (j = i + 1; j < 4; j++) {
				float f = t[j][i] / t[i][i];

				for (k = 0; k < 4; k++) {
					t[j][k] -= f * t[i][k];
					s[j][k] -= f * s[i][k];
				}
			}
		}

		// Backward substitution
		for (i = 3; i >= 0; --i) {
			float f;

			if ((f = t[i][i]) == 0) {
				//if (singExc)
				//	throw ::Imath::SingMatrixExc ("Cannot invert singular matrix.");

				return Matrix4f();
			}

			for (j = 0; j < 4; j++) {
				t[i][j] /= f;
				s[i][j] /= f;
			}

			for (j = 0; j < i; j++) {
				f = t[j][i];

				for (k = 0; k < 4; k++) {
					t[j][k] -= f * t[i][k];
					s[j][k] -= f * s[i][k];
				}
			}
		}

		return s;
	}
	
	Matrix4f Transpose() const
	{
		Matrix4f t;
		for (int j = 0; j < 4; j++) {
			for (int i = 0; i < 4; i++) {
				t[i][j] = m[j][i];
			}
		}
		return t;
	}
	
	Matrix4f operator * (const Matrix4f& right) const
	{
		Matrix4f r;
		for (int i = 0; i < 4; ++i)
			for (int j = 0; j < 4; ++j)
				r.m[i][j] = 
					m[i][0] * right.m[0][j] +
					m[i][1] * right.m[1][j] +
					m[i][2] * right.m[2][j] +
					m[i][3] * right.m[3][j];
		return r;
	}

	inline const float* operator [] (size_t i) const { return &m[i][0]; }
	inline float* operator [] (size_t i) { return &m[i][0]; }
protected:
private:
	float m[4][4];
};

class Ray
{
public:
	Ray(const Vector3f& origin, const Vector3f& direction) :
		m_origin(origin),
		m_direction(direction) 
	{
		invdir = 1.0f / m_direction; 
		sign[0] = (invdir.GetX() < 0); 
		sign[1] = (invdir.GetY() < 0); 
		sign[2] = (invdir.GetZ() < 0);
	}
	
	inline Vector3f* GetOrigin() { return &m_origin; }
	inline Vector3f* GetDirection() { return &m_direction; }
	inline const Vector3f* GetOrigin() const { return &m_origin; }
	inline const Vector3f* GetDirection() const { return &m_direction; }
	
	Vector3f operator() (const float t) const { return m_origin + m_direction * t; }
	
	mutable float tmin;
	mutable float tmax;
	Vector3f invdir;
	int sign[3];
private:
	Vector3f m_origin;
	Vector3f m_direction;
};

struct RayIntersectData
{
	float u;
	float v;
	float t;
};

#include <iostream>

class AABB
{
public:
	AABB(const Vector3f& minCorner = Vector3f(0,0,0), const Vector3f& maxCorner = Vector3f(0,0,0))
	{
		bounds[0] = minCorner;
		bounds[1] = maxCorner;
	}

	AABB(const Vector3f* positionsList, unsigned int positionsListLength)
	{
		bounds[0].SetX(positionsList[0].GetX());
		bounds[0].SetY(positionsList[0].GetY());
		bounds[0].SetZ(positionsList[0].GetZ());
		
		bounds[1].SetX(positionsList[0].GetX());
		bounds[1].SetY(positionsList[0].GetY());
		bounds[1].SetZ(positionsList[0].GetZ());
		
		for(int i = 1; i < positionsListLength; i++)
		{
			if(positionsList[i].GetX() < bounds[0].GetX())
				bounds[0].SetX(positionsList[i].GetX());
			if(positionsList[i].GetY() < bounds[0].GetY())
				bounds[0].SetY(positionsList[i].GetY());
			if(positionsList[i].GetZ() < bounds[0].GetZ())
				bounds[0].SetZ(positionsList[i].GetZ());
				
			if(positionsList[i].GetX() > bounds[1].GetX())
				bounds[1].SetX(positionsList[i].GetX());
			if(positionsList[i].GetY() > bounds[1].GetY())
				bounds[1].SetY(positionsList[i].GetY());
			if(positionsList[i].GetZ() > bounds[1].GetZ())
				bounds[1].SetZ(positionsList[i].GetZ());
		}
	}
	
	bool RayIntersect(const Ray& r)
	{
		GlobalData::g_numAABBIntersectionTests++;
		float tmin, tmax, tymin, tymax, tzmin, tzmax; 
		tmin = (bounds[r.sign[0]].GetX() - r.GetOrigin()->GetX()) * r.invdir.GetX(); 
		tmax = (bounds[1-r.sign[0]].GetX() - r.GetOrigin()->GetX()) * r.invdir.GetX(); 
		tymin = (bounds[r.sign[1]].GetY() - r.GetOrigin()->GetY()) * r.invdir.GetY(); 
		tymax = (bounds[1-r.sign[1]].GetY() - r.GetOrigin()->GetY()) * r.invdir.GetY(); 
		
		if ((tmin > tymax) || (tymin > tmax)) 
			return false; 
		if (tymin > tmin) 
			tmin = tymin; 
		if (tymax < tmax) 
			tmax = tymax; 
			
		tzmin = (bounds[r.sign[2]].GetZ() - r.GetOrigin()->GetZ()) * r.invdir.GetZ(); 
		tzmax = (bounds[1-r.sign[2]].GetZ() - r.GetOrigin()->GetZ()) * r.invdir.GetZ(); 
		
		if ((tmin > tzmax) || (tzmin > tmax)) 
			return false;
 
		if (tzmin > tmin) 
			tmin = tzmin; 
		if (tzmax < tmax) 
			tmax = tzmax; 
		if (tmin > r.tmin) 
			r.tmin = tmin; 
		if (tmax < r.tmax) 
			r.tmax = tmax; 
		
		GlobalData::g_numAABBIntersected++;
		return true;
	}
	
	inline Vector3f GetMinCorner() { return bounds[0]; }
	inline Vector3f GetMaxCorner() { return bounds[1]; }
	inline Vector3f GetCenter() { return (bounds[1] - bounds[0]) * 0.5f + bounds[0]; }
protected:
private:
	Vector3f bounds[2];
};

#endif // MATH3D_H
