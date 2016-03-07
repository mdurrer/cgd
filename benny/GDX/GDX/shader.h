#ifndef SHADER_H_INCLUDED
#define SHADER_H_INCLUDED

#include "math3d.h"
#include "material.h"
#include "transform.h"
#include "engine.h"

#include <string>
#include <fstream>
#include <vector>
#include <map>
#include <iostream>

class Shader
{
public:
	void Update(Transform& transform, Material& material);
	void Bind();
	
	static Shader* Get(const std::string& name);
	static void Delete(const std::string& name);
    static void DeleteAll();
	
private:
    static std::map<std::string, Shader*> ShaderPrograms;

    unsigned int m_Program;
    std::vector<unsigned int> m_Shaders;
    std::vector<UniformData> m_Uniforms;
    bool m_IsValidated;
	
	void ValidateShader();
	
    Shader(const std::string& fileName);
    ~Shader();
    
    Shader(const Shader& shader) {};
	void operator=(const Shader& shader) {};

	static std::string LoadShader(const std::string& fileName);
	//{
	//    std::ifstream file;
 //       file.open(("./res/shaders/" + fileName).c_str());

 //       std::string output;
 //       std::string line;

 //       if(file.is_open())
 //       {
 //           while(file.good())
 //           {
 //               getline(file, line);
 //               output.append(line + "\n");
 //           }
 //       }
 //       else
 //       {
 //           Engine::GetDisplay()->Error("Unable to load shader: " + fileName);
 //       }

 //       return output;
	//}
};

#endif // SHADER_H_INCLUDED
