#include "mesh.h"
#include "globalData.h"
#include <iostream>

unsigned int GlobalData::g_numRaysCast = 0;
unsigned int GlobalData::g_numTriangles = 0;
unsigned int GlobalData::g_numTriangleIntersectionTest = 0;
unsigned int GlobalData::g_numTrianglesIntersected = 0;
unsigned int GlobalData::g_numAABBIntersectionTests = 0;
unsigned int GlobalData::g_numAABBIntersected = 0;

Mesh::Mesh(const std::string& fileName) :
	m_model(OBJModel(fileName).ToIndexedModel())
{
	m_boundingBox = AABB(&m_model.positions[0], m_model.positions.size());
	
	Vector3f aabbCenterPos = m_boundingBox.GetCenter();
	//TODO: In permanent system, these will need to be deleted at some point.
	m_leftFaces = new unsigned int[m_model.indices.size() / 3];
	m_rightFaces = new unsigned int[m_model.indices.size() / 3];
	
	int currentLeftFaceIndex = 0;
	int currentRightFaceIndex = 0;
	
//	for(int i = 0; i < m_model.indices.size(); i += 3)
//	{
//		rightFaces[currentRightFaceIndex] = i;
//		leftFaces[currentRightFaceIndex] = i;
//		currentRightFaceIndex++;
//		currentLeftFaceIndex++;
//	}
	
	for(int i = 0; i < m_model.indices.size(); i += 3)
	{
		Vector3f v0 = m_model.positions[m_model.indices[i + 0]];
		Vector3f v1 = m_model.positions[m_model.indices[i + 1]];
		Vector3f v2 = m_model.positions[m_model.indices[i + 2]];
		
		Vector3f center = (v0 + v1 + v2) / 3;
		
//		float boundingRadius = fabs(v0.GetX() - center.GetX());
//		
//		float tempRadius = fabs(v1.GetX() - center.GetX());
//		if(tempRadius > boundingRadius)
//			boundingRadius = tempRadius;
//			
//		tempRadius = fabs(v2.GetX() - center.GetX());
//		if(tempRadius > boundingRadius)
//			boundingRadius = tempRadius;
			
		bool isRight = false;
		float distanceToAABBCenter = center.GetX() - aabbCenterPos.GetX();
		
		if(distanceToAABBCenter > 0)
		{
			isRight = true;
			
			m_rightFaces[currentRightFaceIndex] = i;
			currentRightFaceIndex++;
		}
		else
		{
			m_leftFaces[currentLeftFaceIndex] = i;
			currentLeftFaceIndex++;
		}
		
		if(isRight && (v0.GetX() <= aabbCenterPos.GetX() || v1.GetX() <= aabbCenterPos.GetX() || v2.GetX() <= aabbCenterPos.GetX()))
		{
			m_leftFaces[currentLeftFaceIndex] = i;
			currentLeftFaceIndex++;
		}
		else if(!isRight && (v0.GetX() >= aabbCenterPos.GetX() || v1.GetX() >= aabbCenterPos.GetX() || v2.GetX() >= aabbCenterPos.GetX()))
		{
			m_rightFaces[currentRightFaceIndex] = i;
			currentRightFaceIndex++;
		}
		
//		if(fabs(distanceToAABBCenter < boundingRadius))
//		{
//			
//		}
	}
	
	m_numLeftFaces = currentLeftFaceIndex;
	m_numRightFaces = currentRightFaceIndex;
}

bool Mesh::IntersectsRay(const Ray& ray, RayIntersectData* intersectData)
{
	if(!m_boundingBox.RayIntersect(ray))
		return false;
	
	RayIntersectData temp;
	
	bool result = false;
	
	Vector3f maxLeftBox = m_boundingBox.GetMaxCorner();
	maxLeftBox.SetX(m_boundingBox.GetCenter().GetX());
	AABB leftBox(m_boundingBox.GetMinCorner(), maxLeftBox);
	
	unsigned int* indexList = m_rightFaces;
	unsigned int numFaces = m_numRightFaces;
	
	if(leftBox.RayIntersect(ray))
	{
		indexList = m_leftFaces;
		numFaces = m_numLeftFaces;
	}
	
	for(int i = 0; i < numFaces; i++)
	{
		if(RayIntersectTriangle(m_model.positions[m_model.indices[indexList[i] + 0]], 
			m_model.positions[m_model.indices[indexList[i] + 1]],
			m_model.positions[m_model.indices[indexList[i] + 2]], 
			ray, &temp))
		{
			if(!result || temp.t > intersectData->t)
			{
				intersectData->t = temp.t;
				intersectData->u = temp.u;
				intersectData->v = temp.v;
			}
			result = true;
		}
	}
	
//	for(int i = 0; i < m_model.indices.size(); i += 3)
//	{
//		if(RayIntersectTriangle(m_model.positions[m_model.indices[i]], 
//			m_model.positions[m_model.indices[i + 1]],
//			m_model.positions[m_model.indices[i + 2]], 
//			ray, &temp))
//		{
//			if(!result || temp.t > intersectData->t)
//			{
//				intersectData->t = temp.t;
//				intersectData->u = temp.u;
//				intersectData->v = temp.v;
//			}
//			result = true;
//		}
//	}
	
	return result;
}

bool Mesh::RayIntersectTriangle(const Vector3f& v0, const Vector3f& v1, const Vector3f& v2, const Ray& ray, RayIntersectData* intersectData)
{
	GlobalData::g_numTriangleIntersectionTest++;
	
	Vector3f edge1 = v1 - v0;
	Vector3f edge2 = v2 - v0;
	Vector3f pvec = ray.GetDirection()->Cross(edge2);
	
	float det = edge1.Dot(pvec);
	
	if (det == 0) 
		return false;
		
	float invDet = 1 / det;
	Vector3f tvec = *ray.GetOrigin() - v0;
	intersectData->u = tvec.Dot(pvec) * invDet;
	
	if (intersectData->u < 0 || intersectData->u > 1) 
		return false;
		
	Vector3f qvec = tvec.Cross(edge1);
	intersectData->v = ray.GetDirection()->Dot(qvec) * invDet;
	
	if (intersectData->v < 0 || intersectData->u + intersectData->v > 1)
		return false;
	
	intersectData->t = edge2.Dot(qvec) * invDet;
	
	GlobalData::g_numTrianglesIntersected++;
	return true;
}

