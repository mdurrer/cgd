#ifndef MESH_H_INCLUDED
#define MESH_H_INCLUDED

#include "math3d.h"
#include "renderer.h"
#include <map>

typedef int INDEX;

struct Vertex
{
    static VertexFormat Format;
    
    Vector3f Pos;
    Vector2f TexCoord;
    Vector3f Normal;
    Vector3f Tangent;
    
    Vertex(Vector3f pos = Vector3f(0,0,0), Vector2f texCoord = Vector2f(0,0), Vector3f normal = Vector3f(0,0,0), Vector3f tangent = Vector3f(0,0,0))
	{
		Pos = pos;
		TexCoord = texCoord;
		Normal = normal;
		Tangent = tangent;
		
		if(!FormatInitialized)
		{
		    static int sizes[] = {sizeof(Vector3f),sizeof(Vector2f),sizeof(Vector3f),sizeof(Vector3f)};
            Format.nElements = sizeof(sizes)/sizeof(int);
            Format.ElementSizes = sizes;
            Format.VertexSize = sizeof(Vertex);
            
            FormatInitialized = true;
		}
	}
	private:
        static bool FormatInitialized;
};

class Mesh
{
public:
	void Draw();

	static Mesh* Get(const std::string& fileName);
	static Mesh* Create(const std::string& name, Vertex* vertices, int nVertices, INDEX* indices, int nIndices, bool calcNormals = true, bool calcTangents = true, const VertexFormat& vertexFormat = Vertex::Format);
    static void DeleteAll();
	static void Delete(const std::string& name);
protected:
	void CalcTexCoords(Vertex* vertices, int nVertices, INDEX* indices, int nIndices);
    void CalcNormals(Vertex* vertices, int nVertices, INDEX* indices, int nIndices);
    void CalcTangents(Vertex* vertices, int nVertices, INDEX* indices, int nIndices);
private:
	static std::map<std::string, Mesh*> Meshes;

	unsigned int  m_hVertexBuffer;
	unsigned int  m_hIndexBuffer;
	int            m_nVertices;
	int            m_nIndices;
	const VertexFormat*  m_pVertexFormat;

	Mesh(Vertex* vertices, int nVertices, INDEX* indices, int nIndices, bool calcNormals = true, bool calcTangents = true, const VertexFormat& vertexFormat = Vertex::Format); 
	Mesh(const std::string& fileName);
	~Mesh();
	Mesh(const Mesh& mesh) {}
	void operator=(const Mesh& mesh) {}
};

#endif // MESH_H_INCLUDED
