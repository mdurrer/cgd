#ifndef TEXTURE_H_INCLUDED
#define TEXTURE_H_INCLUDED

#include <string>
#include <map>

class Texture
{
public:
	static Texture* Get(const std::string& fileName, bool linearFiltering = true, bool repeatTexture = true);
	static Texture* Create(const std::string& name, int width = 0, int height = 0, unsigned char* data = 0, bool linearFiltering = true, bool repeatTexture = true);
    static void DeleteAll();
	static void Delete(const std::string& name);

	void Bind(int unit = 0) const;
protected:
private:
	static std::map<std::string, Texture*> Textures;

    unsigned int m_TextureID;

	Texture(const std::string& fileName, bool linearFiltering = true, bool repeatTexture = true);
	Texture(int width = 0, int height = 0, unsigned char* data = 0, bool linearFiltering = true, bool repeatTexture = true);

	~Texture();
	Texture(const Texture& texture) {}
	void operator=(const Texture& texture) {}
};

#endif // TEXTURE_H_INCLUDED
