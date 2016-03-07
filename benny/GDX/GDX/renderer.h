#ifndef RENDERER_H_INCLUDED
#define RENDERER_H_INCLUDED

#include <string>
#include <vector>
#include "math3d.h"

struct VertexFormat
{
    int VertexSize;
    int nElements;
    int* ElementSizes;
};

struct UniformData
{
    unsigned int Location;
    std::string Type;
    std::string Name;
    
    UniformData(unsigned int UniformLocation, const std::string& UniformType, const std::string& UniformName)
    {
        Location = UniformLocation;
        Type = UniformType;
        Name = UniformName;
    }
};

class Renderer
{
public:
    virtual void Init();

    virtual void SetClearColor(float r, float g, float b, float a);
    virtual void ClearScreenAndDepth();
	virtual void ClearScreen();
	virtual void ClearDepth();

	virtual void SetDepthTest(bool value);
	virtual void SetDepthWrite(bool value);

	//TODO: Make these functions more useful!
	virtual void SetBlending(bool value);
	virtual void SetDepthFunc(bool value);
	
	virtual unsigned int CreateVertexBuffer(void* data, int dataSize, bool isStatic = true);
	virtual unsigned int CreateIndexBuffer(void* data, int dataSize, bool isStatic = true);
	virtual void DrawTriangles(unsigned int vertexBuffer, unsigned int indexBuffer, int nIndices, const VertexFormat& format);
	virtual void DeleteBuffer(unsigned int buffer);
	
    virtual unsigned int CreateVertexShader(const std::string& text);
    virtual unsigned int CreateFragmentShader(const std::string& text);
    virtual unsigned int CreateShaderProgram(unsigned int* shaders, int numShaders);
	virtual std::vector<UniformData> CreateShaderUniforms(const std::string& shaderText, unsigned int shaderProgram);
    virtual void ValidateShaderProgram(unsigned int program);
    virtual void BindShaderProgram(unsigned int program);
    virtual void DeleteShaderProgram(unsigned int program, unsigned int* shaders, int numShaders);
    
    virtual void SetUniformInt(unsigned int uniformLocation, int value);
    virtual void SetUniformFloat(unsigned int uniformLocation, float value);
    virtual void SetUniformVector3f(unsigned int uniformLocation, const Vector3f& value);
    virtual void SetUniformMatrix4f(unsigned int uniformLocation, const Matrix4f& value);
    
    virtual unsigned int CreateTexture(int width, int height, unsigned char* data, bool linearFiltering = true, bool repeatTexture = true);
    virtual void BindTexture(unsigned int texture, int unit);
    virtual void DeleteTexture(unsigned int texture);
    
    //TODO: FrameBuffer stuff!
//    virtual unsigned int CreateRenderTarget(unsigned int texture, bool depthTexture = false);
//    virtual void BindRenderTarget(unsigned int target);
//    virtual void DeleteRenderTarget(unsigned int target);
protected:
private:
};

#endif // RENDERER_H_INCLUDED
