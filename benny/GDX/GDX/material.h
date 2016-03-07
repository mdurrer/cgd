#ifndef MATERIAL_H_INCLUDED
#define MATERIAL_H_INCLUDED

#include "texture.h"
#include "math3d.h"
#include <map>
#include <string>

class Material
{
public:
    static const std::string DiffuseTextureName;
    static const std::string ColorVector3fName;
    
	static Material* Get(const std::string& name);
	static Material* Create(const std::string& name, Texture* diffuse = 0, const Vector3f& color = Vector3f(1,1,1));
    static void DeleteAll();
	static void Delete(const std::string& name);
    
    inline void AddTexture(const std::string& name, Texture* texture)    {m_TextureMap.insert(std::pair<std::string,const Texture*>(name, texture));}
    inline void AddVector3f(const std::string& name, const Vector3f& vector3f) {m_Vector3fMap.insert(std::pair<std::string,Vector3f>(name, vector3f));}
    inline void AddFloat(const std::string& name, float value)                 {m_FloatMap.insert(std::pair<std::string,float>(name, value));}
    
    inline void RemoveTexture(const std::string& name)  {m_TextureMap.erase(name);}
    inline void RemoveVector3f(const std::string& name) {m_Vector3fMap.erase(name);}
    inline void RemoveFloat(const std::string& name)    {m_FloatMap.erase(name);}
    
    inline const Texture* GetTexture(const std::string& name)  
	{
		std::map<std::string, const Texture*>::iterator it = m_TextureMap.find(name);
		if(it != m_TextureMap.end())
			return it->second;
		else
			return 0;
	}
    inline Vector3f GetVector3f(const std::string& name)       
	{
		std::map<std::string, Vector3f>::iterator it = m_Vector3fMap.find(name);
		if(it != m_Vector3fMap.end())
			return it->second;
		else
			return Vector3f::ZERO;
	}
    inline float GetFloat(const std::string& name)            
	{
		std::map<std::string, float>::iterator it = m_FloatMap.find(name);
		if(it != m_FloatMap.end())
			return it->second;
		else
			return 0;
	}
    
    inline const Texture* GetDiffuseTexture() {return GetTexture(DiffuseTextureName);}
    inline const Vector3f GetColor()          {return GetVector3f(ColorVector3fName);}
    
    inline void SetDiffuseTexture(Texture* texture) {m_TextureMap[DiffuseTextureName] = texture;}
    inline void SetColor(const Vector3f& color)           {m_Vector3fMap[ColorVector3fName] = color;}
    
    static inline int GetTextureUnit(const std::string& name) {return TextureUnits.at(name);}
protected:
private:
	static std::map<std::string, Material*> Materials;

    static bool HasInitialisedTextureUnits;
    static std::map<std::string, int> TextureUnits;
    std::map<std::string, const Texture*> m_TextureMap;
    std::map<std::string, Vector3f> m_Vector3fMap;
    std::map<std::string, float> m_FloatMap;

	Material(Texture* diffuse = 0, const Vector3f& color = Vector3f(1,1,1));
	Material(const std::string& fileName);
};

#endif // MATERIAL_H_INCLUDED
