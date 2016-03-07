package com.base.engine;

import java.nio.ByteBuffer;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;
import java.util.ArrayList;
import static org.lwjgl.opengl.GL11.*;
import static org.lwjgl.opengl.GL13.*;
import static org.lwjgl.opengl.GL15.*;
import static org.lwjgl.opengl.GL20.*;
import static org.lwjgl.opengl.GL32.*;

public class Renderer 
{
	public void init()
	{
		glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
		
		glFrontFace(GL_CW);
		glCullFace(GL_BACK);
		glEnable(GL_CULL_FACE);
		glEnable(GL_DEPTH_TEST);
		
		glEnable(GL_DEPTH_CLAMP);
		glEnable(GL_TEXTURE_2D);
	}
	
	public void setClearColor(float r, float g, float b, float a)
	{
		glClearColor(r,g,b,a);
	}
	
    public void clearScreenAndDepth()
	{
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	}
	
    public void clearScreen()
	{
		glClear(GL_COLOR_BUFFER_BIT);
	}
	
    public void clearDepth()
	{
		glClear(GL_DEPTH_BUFFER_BIT);
	}

    public void setDepthTest(boolean value)
	{
		if(value)
			glEnable(GL_DEPTH_TEST);
        else
			glDisable(GL_DEPTH_TEST);
	}
	
    public void setDepthWrite(boolean value)
	{
		if(value)
			glDepthMask(true);
        else
			glDepthMask(false);
	}

    public void setBlending(boolean value)
	{
		if(value)
        {
			glEnable(GL_BLEND);
			glBlendFunc(GL_ONE,GL_ONE);
        }
        else
        {
			glDisable(GL_BLEND);
        }
	}
	
    public void setDepthFunc(boolean value)
	{
		if(value)
			glDepthFunc(GL_EQUAL);
        else
			glDepthFunc(GL_LESS);
	}

    public int createVertexBuffer(FloatBuffer data, boolean isStatic)
	{
		int buffer = glGenBuffers();
		int hint = GL_STATIC_DRAW;

		if(!isStatic)
			hint = GL_DYNAMIC_DRAW;//TODO: Make sure this hint is appropriate!

		glBindBuffer(GL_ARRAY_BUFFER, buffer);
		glBufferData(GL_ARRAY_BUFFER, data, hint);
		
		return buffer;
	}
	
    public int createIndexBuffer(IntBuffer data, boolean isStatic)
	{
		int buffer = glGenBuffers();
		int hint = GL_STATIC_DRAW;

		if(!isStatic)
			hint = GL_DYNAMIC_DRAW;//TODO: Make sure this hint is appropriate!

		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, data, hint);

		return buffer;
	}
	
    public void drawTriangles(int vertexBuffer, int indexBuffer, int nIndices)
	{
		glEnableVertexAttribArray(0);
		glEnableVertexAttribArray(1);
		glEnableVertexAttribArray(2);
		glEnableVertexAttribArray(3);
		
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
		glVertexAttribPointer(0, 3, GL_FLOAT, false, Vertex.SIZE * 4, 0);
		glVertexAttribPointer(1, 2, GL_FLOAT, false, Vertex.SIZE * 4, 12);
		glVertexAttribPointer(2, 3, GL_FLOAT, false, Vertex.SIZE * 4, 20);
		glVertexAttribPointer(3, 3, GL_FLOAT, false, Vertex.SIZE * 4, 32);
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
		glDrawElements(GL_TRIANGLES, nIndices, GL_UNSIGNED_INT, 0);
		
		glDisableVertexAttribArray(0);
		glDisableVertexAttribArray(1);
		glDisableVertexAttribArray(2);
		glDisableVertexAttribArray(3);
	}
	
    public void deleteBuffer(int buffer)
	{
		glDeleteBuffers(buffer);
	}
	
	private int String_Find(String string, String key)
	{
		return String_Find(string, key, 0);
	}
	
	private int String_Find(String string, String key, int start)
	{
		for(int i = start; i < string.length(); i++)
		{
			if(string.charAt(i) == key.charAt(0))
			{
				String test = string.substring(i, i + key.length());
				
				if(test.equals(key))
					return i;
			}
		}
		
		return -1;
	}
	
	private String getSpecifiedVersion(String shaderText)
	{
		final String VERSION_KEY = "#version ";

		int versionLocation = String_Find(shaderText, VERSION_KEY);
		int versionNumberStart = versionLocation + VERSION_KEY.length();
		int versionNumberEnd = String_Find(shaderText, "\n", versionNumberStart);
		
		return shaderText.substring(versionNumberStart, versionNumberEnd);     
	}
	
	private int String_FindClosingBrace(String text, int initialBraceLocation)
	{
		int currentLocation = initialBraceLocation + 1;

		while(currentLocation != -1)
		{
			int nextOpening = String_Find(text, "{", currentLocation);
			int nextClosing = String_Find(text, "}", currentLocation);

			if(nextClosing < nextOpening || nextOpening == -1)
				return nextClosing;

			currentLocation = nextClosing;
		}

		Debug.assertError(false, "Error: Shader is missing a closing brace!");
		
		return -1;
	}
	
	private String eraseShaderFunction(String text, String functionHeader)
	{
		int begin = String_Find(text, functionHeader);

		if(begin == -1)
			return text;

		int end = String_FindClosingBrace(text, String_Find(text, "{", begin));

		String firstHalf = text.substring(0, begin);
		String secondHalf = text.substring(end + 1);
		
		return firstHalf.concat(secondHalf);
	}
	
	private String String_InsertCounter(String string)
	{
		final String KEY = "%d";
		
		int location = String_Find(string, KEY);
		int num = 0;
		
		while(location != -1)
		{
			String firstHalf = string.substring(0, location);
			String secondHalf = string.substring(location + KEY.length());
			
			string = firstHalf + num + secondHalf;
			num++;
			location = String_Find(string, KEY, location);
		}
		
		return string;
	}
	
	private String String_ReplaceLines(String text, String name)
	{
		int start = String_Find(text, name);
		
		while(start != -1)
		{
			int end = String_Find(text, "\n", start);
			
			String firstHalf = text.substring(0, start);
			String secondHalf = text.substring(end);
			
			text = firstHalf + secondHalf;
			
			start = String_Find(text, name, start);
		}
		
		return text;
	}
	
	private static void checkShaderError(int shader, int flag, boolean isProgram, String errorMessage)
	{
		int success;
		String error;

		if(isProgram)
			success = glGetProgrami(shader, flag);
		else
			success = glGetShaderi(shader, flag);

		if(success == 0)
		{
			if(isProgram)
				error = glGetProgramInfoLog(shader, 1024);
			else
				error = glGetShaderInfoLog(shader, 1024);

			System.err.println(errorMessage + ": '" + error + "'");
			System.exit(1);
		}
	}
	
	private int createShader(String text, int type)
	{
		int shader = glCreateShader(type);
		
		Debug.assertError(shader != 0, "Shader creation failed: Could not find valid memory location when adding shader");
		
		glShaderSource(shader, text);
		glCompileShader(shader);
		
		Debug.assertError(glGetShaderi(shader, GL_COMPILE_STATUS) != 0, glGetShaderInfoLog(shader, 1024));

		checkShaderError(shader, GL_COMPILE_STATUS, false, "Error compiling shader type " + type);

		return shader;
	}
	
    public int createVertexShader(String text)
	{
		String version = getSpecifiedVersion(text);
		String vertexShaderText = text.replace("void VSmain()", "void main()");

		vertexShaderText = eraseShaderFunction(vertexShaderText, "void FSmain()");
		
		if(version.equals("330"))
		{
			vertexShaderText = vertexShaderText.replaceAll("attribute", "layout(location = %d) in");
			vertexShaderText = String_InsertCounter(vertexShaderText);
			vertexShaderText = vertexShaderText.replaceAll("varying", "out");
		}

		Debug.println(vertexShaderText);
		
		return createShader(vertexShaderText, GL_VERTEX_SHADER);
	}
	
	public int createFragmentShader(String text)
	{
		String version = getSpecifiedVersion(text);
		String fragmentShaderText = text.replace("void FSmain()", "void main()");

		fragmentShaderText = eraseShaderFunction(fragmentShaderText, "void VSmain()");

		fragmentShaderText = String_ReplaceLines(fragmentShaderText, "attribute");

		if(version.equals("330"))
        {
			fragmentShaderText = fragmentShaderText.replace("varying", "in");
			fragmentShaderText = fragmentShaderText.replace("gl_FragColor", "OUT_Fragment_Color");

			String newFragout = "out vec4 OUT_Fragment_Color;\n";
			int start = String_Find(fragmentShaderText, "\n");
			
			String firstHalf = fragmentShaderText.substring(0, start + 1);
			String secondHalf = fragmentShaderText.substring(start + 1);
			
			fragmentShaderText = firstHalf + newFragout + secondHalf;
        }

		Debug.println(fragmentShaderText);
		
		return createShader(fragmentShaderText, GL_FRAGMENT_SHADER);
	}
	
    public int createShaderProgram(int[] shaders)
	{
		int program = glCreateProgram();

        for (int shader : shaders) glAttachShader(program, shader);
		
		glLinkProgram(program);
		checkShaderError(program, GL_LINK_STATUS, true, "Error linking shader program");
		
		return program;
	}
	
	//TODO: Structs should be an arraylist of uniformData
	private void addUniform(String uniformName, String uniformType, int shaderProgram, ArrayList<UniformData> structs, ArrayList<UniformData> result)
	{
		boolean addThis = true;

//		for(unsigned int i = 0; i < structs.size(); i++)
//		{
//				if(structs[i].name.compare(uniformType) == 0)
//				{
//						addThis = false;
//						for(unsigned int j = 0; j < structs[i].memberNames.size(); j++)
//						{
//								AddUniform(uniformName + "." + structs[i].memberNames[j].name, structs[i].memberNames[j].type, shaderProgram, structs, result);
//						}
//				}
//		}

		if(!addThis)
			return;

		int location = glGetUniformLocation(shaderProgram, uniformName);

		Debug.assertError(location != 0xFFFFFFFF, "Could not find uniform: " + uniformName + " " + uniformType);

		result.add(new UniformData(location, uniformType, uniformName));
	}
	
	//TODO: Add struct detection!
    public UniformData[] createShaderUniforms(String shaderText, int shaderProgram)
	{
		final String UNIFORM_KEY = "uniform";
    
        //ArrayList<UniformStruct> structs = FindUniformStructs(shaderText);

        ArrayList<UniformData> result = new ArrayList<UniformData>();

		int uniformLocation = String_Find(shaderText, UNIFORM_KEY);
		while(uniformLocation != -1)
		{
			boolean isCommented = false;
//			int lastLineEnd = shaderText.rfind(";", uniformLocation);
//
//			if(lastLineEnd != std::string::npos)
//			{
//				String potentialCommentSection = shaderText.substring(lastLineEnd,uniformLocation);
//				isCommented = potentialCommentSection.find("//") != std::string::npos;
//			}

			if(!isCommented)
			{
				int begin = uniformLocation + UNIFORM_KEY.length();
				int end = String_Find(shaderText, ";", begin);

				String uniformLine = shaderText.substring(begin + 1, end);

				begin = String_Find(uniformLine, " ");
				String uniformName = uniformLine.substring(begin + 1);
				String uniformType = uniformLine.substring(0, begin);

				Debug.println("Adding Uniform: " + uniformName + "," + uniformType);
				//AddUniform(uniformName, uniformType, shaderProgram, structs, result);
				addUniform(uniformName, uniformType, shaderProgram, null, result);
			}
			uniformLocation = String_Find(shaderText, UNIFORM_KEY, uniformLocation + UNIFORM_KEY.length());
		}
		
		UniformData[] returnValue = new UniformData[result.size()];
		result.toArray(returnValue);
		
        return returnValue;
	}
	
    public void validateShaderProgram(int program)
	{
		glValidateProgram(program);
		checkShaderError(program, GL_VALIDATE_STATUS, true, "Invalid shader program");
	}
	
	private static int lastProgram = 0;
	
    public void bindShaderProgram(int program)
	{
		if(lastProgram != program)
		{
			glUseProgram(program);
			lastProgram = program;
		}
	}
	
    public void deleteShaderProgram(int program, int[] shaders)
	{
        for (int shader : shaders)
        {
            glDetachShader(program, shader);
            glDeleteShader(shader);
        }

		glDeleteProgram(program);
	}	
    
    public void setUniformInt(int uniformLocation, int value)
	{
		glUniform1i(uniformLocation, value);
	}
	
    public void setUniformFloat(int uniformLocation, float value)
	{
		glUniform1f(uniformLocation, value);
	}
	
    public void setUniformVector3f(int uniformLocation, Vector3f value)
	{
		glUniform3f(uniformLocation, value.getX(), value.getY(), value.getZ());
	}
	
    public void setUniformMatrix4f(int uniformLocation, Matrix4f value)
	{
		glUniformMatrix4(uniformLocation, true, Util.createFlippedBuffer(value));
	}

    public int createTexture(int width, int height, ByteBuffer data, boolean linearFiltering, boolean repeatTexture)
    {
        float filter;
        int wrapMode;

        if(linearFiltering)
            filter = GL_LINEAR;
        else
            filter = GL_NEAREST;

        if(repeatTexture)
            wrapMode = GL_REPEAT;
        else
            wrapMode = GL_NEAREST;

        int texture = glGenTextures();
        glBindTexture(GL_TEXTURE_2D, texture);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrapMode);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrapMode);

        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filter);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);

        return texture;
    }

    private static int lastTexture = 0;
    private static int lastUnit = 0;

    public void bindTexture(int texture, int unit)
    {
        if(lastTexture != texture)
        {
            if(unit != lastUnit)
            {
                //TODO: This may fail if GL_TEXTUREX is not ordered sequentially!
                assert(unit >= 0 && unit <= 31);
                glActiveTexture(GL_TEXTURE0 + unit);
                lastUnit = unit;
            }

            glBindTexture(GL_TEXTURE_2D, texture);
            lastTexture = texture;
        }
    }

    public void deleteTexture(int texture)
    {
        glDeleteTextures(texture);
    }
}
