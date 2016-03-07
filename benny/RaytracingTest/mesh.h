#ifndef MESH_H
#define MESH_H

#include "obj_loader.h"
#include "math3d.h"

class Mesh
{
public:
	Mesh(const std::string& fileName);
	
	bool IntersectsRay(const Ray& ray, RayIntersectData* intersectData);
	
	inline int GetNumTriangles() { return m_model.indices.size() / 3; }
protected:
private:
	bool RayIntersectTriangle(const Vector3f& v0, const Vector3f& v1, const Vector3f& v2, const Ray& ray, RayIntersectData* intersectData);
	
	AABB m_boundingBox;
	IndexedModel m_model;
	
	unsigned int* m_leftFaces;
	unsigned int* m_rightFaces;
	unsigned int m_numLeftFaces;
	unsigned int m_numRightFaces;
};

#endif // MESH_H
