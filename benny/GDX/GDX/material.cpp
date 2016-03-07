#include "material.h"
#include "engine.h"

#include <fstream>
#include "util.h"

const std::string Material::DiffuseTextureName = "diffuse";
const std::string Material::ColorVector3fName = "color";
bool Material::HasInitialisedTextureUnits = false;

std::map<std::string, int> Material::TextureUnits = std::map<std::string, int>();
std::map<std::string, Material*> Material::Materials = std::map<std::string, Material*>();

Material* Material::Get(const std::string& name)
{
	std::map<std::string, Material*>::iterator it = Materials.find(name);
	if(it != Materials.end())
		return it->second;

	Materials.insert(std::pair<std::string, Material*>(name, new Material(name)));
	return Materials.at(name);
}

Material* Material::Create(const std::string& name, Texture* diffuse, const Vector3f& color)
{
	if(Materials.find(name) != Materials.end())
		Engine::GetDisplay()->Error("Material " + name + " already exists, and therefore cannot be created.");

	Materials.insert(std::pair<std::string, Material*>(name, new Material(diffuse, color)));
    return Materials.at(name);
}

void Material::Delete(const std::string& name)
{
	std::map<std::string, Material*>::iterator it = Materials.find(name);
	if(it != Materials.end()) 
	{
		delete it->second;
		Materials.erase(it);
	} 
}

void Material::DeleteAll()
{
    for (std::map<std::string, Material*>::iterator it=Materials.begin(); it!=Materials.end(); ++it)
        delete it->second;
}

Material::Material(Texture* diffuse, const Vector3f& color)
{
    AddTexture(DiffuseTextureName, diffuse);
    AddVector3f(ColorVector3fName, color);
    
    if(!HasInitialisedTextureUnits)
    {
        TextureUnits.insert(std::pair<std::string,int>(DiffuseTextureName, 0));
        HasInitialisedTextureUnits = true;
    }
}

Material::Material(const std::string& fileName)
{
	std::ifstream file;
    file.open(("./res/materials/" + fileName).c_str());

    std::string line;
	if(file.is_open())
    {
        while(file.good())
        {
			getline(file, line);
			std::vector<std::string> tokens = Util::Split(line, ' ');

			if(tokens.size() == 0)
				continue;

			if(tokens[0].compare("Texture") == 0)
				AddTexture(tokens[1], Texture::Get(tokens[2]));
			else if(tokens[0].compare("float") == 0)
				AddFloat(tokens[1], std::stof(tokens[2]));
			else if(tokens[0].compare("Vector3f") == 0)
				AddVector3f(tokens[1], Vector3f(std::stof(tokens[2]), std::stof(tokens[3]), std::stof(tokens[4])));
		}
    }
    else
    {
        Engine::GetDisplay()->Error("Unable to load material: " + fileName);
    }

	if(!HasInitialisedTextureUnits)
    {
        TextureUnits.insert(std::pair<std::string,int>(DiffuseTextureName, 0));
        HasInitialisedTextureUnits = true;
    }
}