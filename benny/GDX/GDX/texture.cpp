#include "texture.h"
#include "stb_image.h"
#include "engine.h"

std::map<std::string, Texture*> Texture::Textures = std::map<std::string, Texture*>();

Texture* Texture::Get(const std::string& name, bool linearFiltering, bool repeatTexture)
{
	std::map<std::string, Texture*>::iterator it = Textures.find(name);
	if(it != Textures.end())
		return it->second;

	Textures.insert(std::pair<std::string, Texture*>(name, new Texture(name, linearFiltering, repeatTexture)));
    return Textures.at(name);
}

Texture* Texture::Create(const std::string& name, int width, int height, unsigned char* data, bool linearFiltering, bool repeatTexture)
{
	if(Textures.find(name) != Textures.end())
		Engine::GetDisplay()->Error("Texture " + name + " already exists, and therefore cannot be created.");

	Textures.insert(std::pair<std::string, Texture*>(name, new Texture(width, height, data, linearFiltering, repeatTexture)));
    return Textures.at(name);
}

void Texture::Delete(const std::string& name)
{
	std::map<std::string, Texture*>::iterator it = Textures.find(name);
	if(it != Textures.end()) 
	{
		delete it->second;
		Textures.erase(it);
	} 
}

void Texture::DeleteAll()
{
    for (std::map<std::string, Texture*>::iterator it=Textures.begin(); it!=Textures.end(); ++it)
        delete it->second;
}

Texture::Texture(const std::string& fileName, bool linearFiltering, bool repeatTexture)
{
	int x, y, numComponents;
    unsigned char* data = stbi_load(("./res/textures/" + fileName).c_str(), &x, &y, &numComponents, 4);

    if(data == NULL)
        Engine::GetDisplay()->Error("Unable to load texture: " + fileName);

    m_TextureID = Engine::GetRenderer()->CreateTexture(x, y, data, linearFiltering, repeatTexture);
    stbi_image_free(data);
}

Texture::Texture(int width, int height, unsigned char* data, bool linearFiltering, bool repeatTexture)
{
    m_TextureID = Engine::GetRenderer()->CreateTexture(width, height, data, linearFiltering, repeatTexture);
}

Texture::~Texture()
{
	Engine::GetRenderer()->DeleteTexture(m_TextureID);
}

void Texture::Bind(int unit) const
{
	Engine::GetRenderer()->BindTexture(m_TextureID, unit);
}
