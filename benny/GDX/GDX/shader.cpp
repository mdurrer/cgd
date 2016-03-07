#include "shader.h"
#include "util.h"

#include <sstream>
#include <cassert>
#include <iostream>

std::map<std::string, Shader*> Shader::ShaderPrograms = std::map<std::string, Shader*>();

Shader* Shader::Get(const std::string& name)
{
	std::map<std::string, Shader*>::iterator it = ShaderPrograms.find(name);
	if(it != ShaderPrograms.end())
		return it->second;

	ShaderPrograms.insert(std::pair<std::string, Shader*>(name, new Shader(name)));
    return ShaderPrograms.at(name);
}

void Shader::Delete(const std::string& name)
{
	std::map<std::string, Shader*>::iterator it = ShaderPrograms.find(name);
	if(it != ShaderPrograms.end()) 
	{
		delete it->second;
		ShaderPrograms.erase(it);
	} 
}

void Shader::DeleteAll()
{
    for (std::map<std::string, Shader*>::iterator it=ShaderPrograms.begin(); it!=ShaderPrograms.end(); ++it)
        delete it->second;
}

std::string Shader::LoadShader(const std::string& fileName)
{
    std::ifstream file;
    file.open(("./res/shaders/" + fileName).c_str());

    std::string output;
    std::string line;

    if(file.is_open())
    {
        while(file.good())
        {
            getline(file, line);

			if(line.find("#include") == std::string::npos)
				output.append(line + "\n");
			else
			{
				std::string includeFileName = Util::Split(line, ' ')[1];
				includeFileName = includeFileName.substr(1,includeFileName.length() - 2);

				std::string toAppend = LoadShader(includeFileName);
				output.append(toAppend + "\n");
			}
        }
    }
    else
    {
        Engine::GetDisplay()->Error("Unable to load shader: " + fileName);
    }

    return output;
}

Shader::Shader(const std::string& fileName)
{
    m_Program = 0;
	m_Shaders = std::vector<unsigned int>();
	m_Uniforms = std::vector<UniformData>();
	m_IsValidated = false;
    
    std::string shaderText = LoadShader(fileName + ".glsl");

    m_Shaders.push_back(Engine::GetRenderer()->CreateVertexShader(shaderText));
	m_Shaders.push_back(Engine::GetRenderer()->CreateFragmentShader(shaderText));
    m_Program = Engine::GetRenderer()->CreateShaderProgram(&m_Shaders[0], m_Shaders.size());
	m_Uniforms = Engine::GetRenderer()->CreateShaderUniforms(shaderText, m_Program);
}

Shader::~Shader()
{
	Engine::GetRenderer()->DeleteShaderProgram(m_Program, &m_Shaders[0], m_Shaders.size());
}

void Shader::Bind()
{
    Engine::GetRenderer()->BindShaderProgram(m_Program);
}

void Shader::ValidateShader()
{
    Engine::GetRenderer()->ValidateShaderProgram(m_Program);
    m_IsValidated = true;
}

void Shader::Update(Transform& transform, Material& material)
{
    for(std::vector<UniformData>::iterator it = m_Uniforms.begin(); it != m_Uniforms.end(); ++it)
		Engine::GetRenderingEngine()->UpdateUniform(&(*it), transform, material);
    
    if(!m_IsValidated)
        ValidateShader();
}
