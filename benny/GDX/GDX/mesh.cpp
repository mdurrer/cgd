#include "mesh.h"
#include "engine.h"
#include "util.h"

#include <fstream>
#include <algorithm>

bool Vertex::FormatInitialized = false;
VertexFormat Vertex::Format = VertexFormat();

std::map<std::string, Mesh*> Mesh::Meshes = std::map<std::string, Mesh*>();

Mesh* Mesh::Get(const std::string& name)
{
	std::map<std::string, Mesh*>::iterator it = Meshes.find(name);
	if(it != Meshes.end())
		return it->second;

	Meshes.insert(std::pair<std::string, Mesh*>(name, new Mesh(name)));
    return Meshes.at(name);
}

Mesh* Mesh::Create(const std::string& name, Vertex* vertices, int nVertices, INDEX* indices, int nIndices, bool calcNormals, bool calcTangents, const VertexFormat& vertexFormat)
{
	if(Meshes.find(name) != Meshes.end())
		Engine::GetDisplay()->Error("Mesh " + name + " already exists, and therefore cannot be created.");

	Meshes.insert(std::pair<std::string, Mesh*>(name, new Mesh(vertices, nVertices, indices, nIndices, calcNormals, calcTangents, vertexFormat)));
    return Meshes.at(name);
}

void Mesh::Delete(const std::string& name)
{
	std::map<std::string, Mesh*>::iterator it = Meshes.find(name);
	if(it != Meshes.end()) 
	{
		delete it->second;
		Meshes.erase(it);
	} 
}

void Mesh::DeleteAll()
{
    for (std::map<std::string, Mesh*>::iterator it=Meshes.begin(); it!=Meshes.end(); ++it)
        delete it->second;
}

Mesh::Mesh(Vertex* vertices, int nVertices, INDEX* indices, int nIndices, bool calcNormals, bool calcTangents, const VertexFormat& vertexFormat)
{
    if(calcNormals)
        CalcNormals(vertices, nVertices, indices, nIndices);
    if(calcTangents)
        CalcTangents(vertices, nVertices, indices, nIndices);
    
	m_nVertices = nVertices;
	m_nIndices = nIndices;
    m_hVertexBuffer = Engine::GetRenderer()->CreateVertexBuffer(vertices, nVertices * sizeof(Vertex));
    m_hIndexBuffer =  Engine::GetRenderer()->CreateIndexBuffer(indices, nIndices * sizeof(int));
    m_pVertexFormat = &vertexFormat;
}

struct OBJIndex
{
	unsigned int vertexIndex;
	unsigned int uvIndex;
	unsigned int normalIndex;
};

static OBJIndex CreateOBJIndex(const std::string& token, bool* hasUVs, bool* hasNormals)
{
	std::vector<std::string> vert = Util::Split(token, '/');

	OBJIndex result;
	result.vertexIndex = std::stoi(vert[0]) - 1;
	result.uvIndex = 0;
	result.normalIndex = 0;

	if(vert.size() > 1 && vert[1].compare("") != 0)
	{
		result.uvIndex = std::stoi(vert[1]) - 1;
		*hasUVs = true;
	}
	else if(vert.size() > 2 && vert[2].compare("") != 0)
	{
		result.normalIndex = std::stoi(vert[2]) - 1;
		*hasNormals = true;
	}

	return result;
}

bool CompareOBJIndex(const OBJIndex& a, const OBJIndex& b)
{
	return a.vertexIndex < b.vertexIndex;
}

int FindPreviousVertexIndex(const std::vector<OBJIndex>& indicesList, const OBJIndex& currentIndex, int i, 
							bool hasUVs, bool hasNormals, const std::vector<OBJIndex>& originalIndexList)
{
	//for(int j = 0; j < i; j++)
	//{
	//	OBJIndex previousIndex = originalIndexList[j];
	//	if(previousIndex.vertexIndex == currentIndex.vertexIndex
	//		&& (!hasUVs || previousIndex.uvIndex == currentIndex.uvIndex)
	//		&& (!hasNormals || previousIndex.normalIndex == currentIndex.normalIndex))
	//	{
	//		return j;
	//	}
	//}

	//return -1;
	
	int previousVertexStart = 0;
	int previousVertexEnd = indicesList.size();
	int previousVertexCurrent = (previousVertexEnd - previousVertexStart) / 2 + previousVertexStart;
	int previousVertexBefore = previousVertexCurrent - 1;
	
	while(previousVertexBefore != previousVertexCurrent) //Performs a binary search over the sorted list
	{
		OBJIndex previousIndex = indicesList[previousVertexCurrent];
		if(previousIndex.vertexIndex == currentIndex.vertexIndex
			&& (!hasUVs || previousIndex.uvIndex == currentIndex.uvIndex)
			&& (!hasNormals || previousIndex.normalIndex == currentIndex.normalIndex))
		{
			for(int j = 0; j < i; j++) //It's okay to do a linear search now, because most cases won't make it here
			{
				OBJIndex previousIndex = originalIndexList[j];
				if(previousIndex.vertexIndex == currentIndex.vertexIndex
					&& (!hasUVs || previousIndex.uvIndex == currentIndex.uvIndex)
					&& (!hasNormals || previousIndex.normalIndex == currentIndex.normalIndex))
				{
					return j;
				}
			}

			return -1;
		}
		else
		{
			if(previousIndex.vertexIndex < currentIndex.vertexIndex)
				previousVertexStart = previousVertexCurrent;
			else
				previousVertexEnd = previousVertexCurrent;
		}
		previousVertexBefore = previousVertexCurrent;
		previousVertexCurrent = (previousVertexEnd - previousVertexStart) / 2 + previousVertexStart;
	}

	//Note: For "perfect" mesh optimization, you would need to do a linear search here just in case 2 indices had the same vertex index
	//However, the marginal gain for such a rare case probably isn't worth the performance cost.

	return -1;
}

void OldMeshOBJLoadConstructor()
{
	//std::vector<OBJIndex> OBJIndices;
	//std::vector<Vector3f> vertices;
	//std::vector<Vector2f> uvs;
	//std::vector<Vector3f> normals;

	//std::ifstream file;
 //   file.open(("./res/models/" + fileName).c_str());

 //   std::string line;

	//bool hasUVs = false;
	//bool hasNormals = false;

 //   if(file.is_open())
 //   {
 //       while(file.good())
 //       {
	//		getline(file, line);
	//		std::vector<std::string> tokens = Util::Split(line, ' ');

	//		if(tokens.size() == 0)
	//			continue;

	//		if(tokens[0].compare("v") == 0)
	//			vertices.push_back(Vector3f(std::stof(tokens[1]),std::stof(tokens[2]),std::stof(tokens[3])));
	//		else if(tokens[0].compare("vt") == 0)
	//			uvs.push_back(Vector2f(std::stof(tokens[1]),std::stof(tokens[2])));
	//		else if(tokens[0].compare("vn") == 0)
	//			normals.push_back(Vector3f(std::stof(tokens[1]),std::stof(tokens[2]),std::stof(tokens[3])));
	//		else if(tokens[0].compare("f") == 0)
	//		{
	//			OBJIndices.push_back(CreateOBJIndex(tokens[1], &hasUVs, &hasNormals));
	//			OBJIndices.push_back(CreateOBJIndex(tokens[2], &hasUVs, &hasNormals));
	//			OBJIndices.push_back(CreateOBJIndex(tokens[3], &hasUVs, &hasNormals));

	//			if((int)tokens.size() > 4)
	//			{
	//				OBJIndices.push_back(CreateOBJIndex(tokens[1], &hasUVs, &hasNormals));
	//				OBJIndices.push_back(CreateOBJIndex(tokens[3], &hasUVs, &hasNormals));
	//				OBJIndices.push_back(CreateOBJIndex(tokens[4], &hasUVs, &hasNormals));
	//			}
	//		}
 //       }
 //   }
 //   else
 //   {
 //       Engine::GetDisplay()->Error("Unable to load mesh: " + fileName);
 //   }

	//std::vector<Vertex> vertexList;
	//std::vector<INDEX> indexList;
	//
	//std::map<int, int> indexMap;

	//std::vector<OBJIndex> indexLookup = std::vector<OBJIndex>(OBJIndices);
	//std::sort(indexLookup.begin(), indexLookup.end(), CompareOBJIndex);

	//for(int i = 0; i < (int)OBJIndices.size(); i++)
	//{
	//	OBJIndex currentIndex = OBJIndices[i];

	//	//Note that previousVertexLocation is purely for mesh optimization purposes. (However it helps with calculated normals)
	//	//If you wish, you can set this to -1 and remove the sorting code for a marginal performance boost (from O(NlogN) to O(N))
	//	//For context, in a test with a 1 million triangle mesh, this reduced load time from 16 seconds to 13 seconds.
	//	int previousVertexLocation = FindPreviousVertexIndex(indexLookup, currentIndex, i, hasUVs, hasNormals, OBJIndices);

	//	if(previousVertexLocation == -1)
	//	{
	//		indexMap.insert(std::pair<int, int>(i, vertexList.size()));
	//		indexList.push_back(vertexList.size());

	//		Vector3f pos = vertices[currentIndex.vertexIndex];
	//		Vector2f texCoord;
	//		Vector3f normal;

	//		if(hasUVs)
	//			texCoord = uvs[currentIndex.uvIndex];
	//		else
	//			texCoord = Vector2f(0,0);

	//		if(hasNormals)
	//			normal = normals[currentIndex.normalIndex];
	//		else
	//			normal = Vector3f(0,0,0);

	//		vertexList.push_back(Vertex(pos,texCoord,normal));
	//	}
	//	else
	//		indexList.push_back(indexMap.at(previousVertexLocation));
	//}

	//if(!hasUVs)
	//	CalcTexCoords(&vertexList[0],vertexList.size(),&indexList[0],indexList.size());
	//if(!hasNormals)
	//	CalcNormals(&vertexList[0],vertexList.size(),&indexList[0],indexList.size());

	//CalcTangents(&vertexList[0],vertexList.size(),&indexList[0],indexList.size());

	//m_nVertices = vertexList.size();
	//m_nIndices = indexList.size();
 //   m_hVertexBuffer = Engine::GetRenderer()->CreateVertexBuffer(&vertexList[0], m_nVertices * sizeof(Vertex));
 //   m_hIndexBuffer =  Engine::GetRenderer()->CreateIndexBuffer(&indexList[0], m_nIndices * sizeof(int));
	//m_pVertexFormat = &Vertex::Format;
}

#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>

Mesh::Mesh(const std::string& fileName)
{
	std::string fullFileName = "./res/models/" + fileName;

	Assimp::Importer Importer;

	const aiScene* pScene = Importer.ReadFile(fullFileName.c_str(), aiProcess_Triangulate | aiProcess_GenSmoothNormals);

	if(pScene)
	{
		std::vector<Vertex> vertices;
		std::vector<INDEX> indices;

		for(unsigned int i = 0; i < 1; i++) //TODO: i < pScene->mNumMeshes
		{
			const aiMesh* paiMesh = pScene->mMeshes[i];
			const aiVector3D Zero3D(0.0f, 0.0f, 0.0f);

			for(unsigned int j = 0; j < paiMesh->mNumVertices; j++)
			{
				const aiVector3D* pPos = &(paiMesh->mVertices[j]);
				const aiVector3D* pNormal = &(paiMesh->mNormals[j]);
				const aiVector3D* pTexCoord = paiMesh->HasTextureCoords(0) ?
					&(paiMesh->mTextureCoords[0][j]) : &Zero3D;

				Vector3f pos = Vector3f(pPos->x, pPos->y, pPos->z);
				Vector2f texCoord = Vector2f(pTexCoord->x, pTexCoord->y);
				Vector3f normal = Vector3f(pNormal->x, pNormal->y, pNormal->z);

				vertices.push_back(Vertex(pos, texCoord, normal));
			}

			for(unsigned int j = 0; j < paiMesh->mNumFaces; j++)
			{
				const aiFace& rFace = paiMesh->mFaces[j];
				indices.push_back(rFace.mIndices[0]);
				indices.push_back(rFace.mIndices[1]);
				indices.push_back(rFace.mIndices[2]);
			}
		}

		m_nVertices = vertices.size();
		m_nIndices = indices.size();
		m_hVertexBuffer = Engine::GetRenderer()->CreateVertexBuffer(&vertices[0], m_nVertices * sizeof(Vertex));
		m_hIndexBuffer =  Engine::GetRenderer()->CreateIndexBuffer(&indices[0], m_nIndices * sizeof(int));
		m_pVertexFormat = &Vertex::Format;
	}
	else
	{
		Engine::GetDisplay()->Error("Unable to load mesh: " + fileName);
	}

}

Mesh::~Mesh()
{
	if(m_hVertexBuffer)	Engine::GetRenderer()->DeleteBuffer(m_hVertexBuffer);
	if(m_hIndexBuffer)	Engine::GetRenderer()->DeleteBuffer(m_hIndexBuffer);
}

void Mesh::Draw()
{
    Engine::GetRenderer()->DrawTriangles(m_hVertexBuffer, m_hIndexBuffer, m_nIndices, *m_pVertexFormat);
}

void Mesh::CalcTexCoords(Vertex* vertices, int nVertices, INDEX* indices, int nIndices)
{
	//static Vector2f texCoords[] = {Vector2f(0.0f, 0.0f),Vector2f(0.0f, 1.0f),Vector2f(1.0f, 1.0f), Vector2f(1.0f, 0.0f)};
	static Vector2f texCoords[] = {Vector2f(0.0f, 0.0f),Vector2f(0.5f, 1.0f),Vector2f(1.0f, 0.0f)};

	for(int i = 0; i < nIndices; i++)
	{
		int i0 = indices[i];

		Vector2f texCoord = Vector2f(texCoords[i0 % (sizeof(texCoords)/sizeof(Vector2f))]);

		//texCoord = (texCoord * ((float)i/(float)nIndices));

		//float value = 1.0f - 2 *(float)i0/(float)nIndices;

		//Vector2f texCoord = Vector2f(value, value);

		vertices[i0].TexCoord = texCoord;
	}

	/*for(int i = 0; i < nVertices; i++)
		vertices[i].TexCoord = vertices[i].TexCoord.Normalized();*/
}

void Mesh::CalcNormals(Vertex* vertices, int nVertices, INDEX* indices, int nIndices)
{
    for(int i = 0; i < nIndices; i += 3)
    {
        int i0 = indices[i];
        int i1 = indices[i + 1];
        int i2 = indices[i + 2];
			
        Vector3f v1 = vertices[i1].Pos - vertices[i0].Pos;
        Vector3f v2 = vertices[i2].Pos - vertices[i0].Pos;
        
        Vector3f normal = v1.Cross(v2).Normalized();
        
        vertices[i0].Normal += normal;
        vertices[i1].Normal += normal;
        vertices[i2].Normal += normal;
    }
		
    for(int i = 0; i < nVertices; i++)
        vertices[i].Normal = vertices[i].Normal.Normalized();
}
	
void Mesh::CalcTangents(Vertex* vertices, int nVertices, INDEX* indices, int nIndices)
{
    for(int i = 0; i < nIndices; i += 3)
    {
        Vertex v0 = vertices[indices[i]];
        Vertex v1 = vertices[indices[i + 1]];
        Vertex v2 = vertices[indices[i + 2]];
			
        Vector3f edge1 = v1.Pos - v0.Pos;
        Vector3f edge2 = v2.Pos - v0.Pos;
        
        float deltaU1 = v1.TexCoord.GetX() - v0.TexCoord.GetX();
        float deltaU2 = v2.TexCoord.GetX() - v0.TexCoord.GetX();
        float deltaV1 = v1.TexCoord.GetY() - v0.TexCoord.GetY();
        float deltaV2 = v2.TexCoord.GetY() - v0.TexCoord.GetY();
        
        float f = 1.0f/(deltaU1 * deltaV2 - deltaU2 * deltaV1);
        
        Vector3f tangent = Vector3f(0,0,0);
        
        tangent.SetX(f * (deltaV2 * edge1.GetX() - deltaV1 * edge2.GetX()));
        tangent.SetY(f * (deltaV2 * edge1.GetY() - deltaV1 * edge2.GetY()));
        tangent.SetZ(f * (deltaV2 * edge1.GetZ() - deltaV1 * edge2.GetZ()));

//Bitangent example, in Java
//		Vector3f bitangent = new Vector3f(0,0,0);
//		
//		bitangent.setX(f * (-deltaU2 * edge1.getX() - deltaU1 * edge2.getX()));
//		bitangent.setX(f * (-deltaU2 * edge1.getY() - deltaU1 * edge2.getY()));
//		bitangent.setX(f * (-deltaU2 * edge1.getZ() - deltaU1 * edge2.getZ()));
		
		v0.Tangent += tangent;
		v1.Tangent += tangent;
		v2.Tangent += tangent;	
    }
		
    for(int i = 0; i < nVertices; i++)
        vertices[i].Tangent = vertices[i].Tangent.Normalized();
}
