package com.base.engine;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;

public class Mesh
{
	public static final String DIRECTORY = "models/";
    private static final HashMap<String, Mesh> meshes = new HashMap<String, Mesh>();

	private int vbo;
	private int ibo;
	private int size;
	
	/**
	 *
	 * @throws java.lang.Throwable
	 */
	@Override
	protected void finalize() throws Throwable 
	{
		super.finalize();
		
		if(vbo != 0)
			Engine.getRenderer().deleteBuffer(vbo);
		if(ibo != 0)
			Engine.getRenderer().deleteBuffer(ibo);
	}
	
	private Mesh(Vertex[] vertices, int[] indices, boolean calcNormals, boolean calcTangents)
	{
		vbo = 0;
		ibo = 0;
		size = 0;
		addVertices(vertices, indices, calcNormals, calcTangents);
	}

    public static Mesh get(String name)
    {
        if(meshes.containsKey(name))
            return meshes.get(name);
        else
        {
            meshes.put(name, new Mesh(name));
            return meshes.get(name);
        }
    }

	public static void generatePrimitives()
	{
		generateRect();
		generatePlane();
		generateCube();
	}
	
	private static void generateRect()
	{
		Vertex[] vertices = new Vertex[] {	new Vertex(new Vector3f(-0.5f,-0.5f,0), new Vector2f(0,0)),
						    				new Vertex(new Vector3f(-0.5f,0.5f,0), new Vector2f(0,1)),
						    				new Vertex(new Vector3f(0.5f,0.5f,0), new Vector2f(1,1)),
						    				new Vertex(new Vector3f(0.5f,-0.5f,0), new Vector2f(1,0))};

		int[] indices = new int[] {	0,1,2,
				   					0,2,3};
		
		meshes.put("rect", new Mesh(vertices, indices, true, true));
	}
	
	private static void generatePlane()
	{
		Vertex[] vertices = new Vertex[] {	new Vertex( new Vector3f(-0.5f, 0.0f, -0.5f), new Vector2f(0.0f, 0.0f)),
											new Vertex( new Vector3f(-0.5f, 0.0f, 0.5f), new Vector2f(0.0f, 1.0f)),
											new Vertex( new Vector3f(0.5f, 0.0f, -0.5f), new Vector2f(1.0f, 0.0f)),
											new Vertex( new Vector3f(0.5f, 0.0f, 0.5f), new Vector2f(1.0f, 1.0f))};

		int indices[] = new int[] {	0, 1, 2,
									2, 1, 3};

        meshes.put("plane", new Mesh(vertices, indices, true, true));
	}
	
	private static void generateCube()
	{
		Vertex[] vertices = new Vertex[] {	new Vertex(new Vector3f(-0.5f,-0.5f,-0.5f), new Vector2f(0,0)),
											new Vertex(new Vector3f(-0.5f,0.5f,-0.5f), new Vector2f(0,1)),
											new Vertex(new Vector3f(0.5f,0.5f,-0.5f), new Vector2f(1,1)),
											new Vertex(new Vector3f(0.5f,-0.5f,-0.5f), new Vector2f(1,0)),
						    				
											new Vertex(new Vector3f(-0.5f,-0.5f,-0.5f), new Vector2f(0,0)),
						    				new Vertex(new Vector3f(0.5f,-0.5f,-0.5f), new Vector2f(0,1)),
						    				new Vertex(new Vector3f(0.5f,-0.5f,0.5f), new Vector2f(1,1)),
						    				new Vertex(new Vector3f(-0.5f,-0.5f,0.5f), new Vector2f(1,0)),
						    				
						    				new Vertex(new Vector3f(-0.5f,-0.5f,-0.5f), new Vector2f(1,0)),
						    				new Vertex(new Vector3f(-0.5f,-0.5f,0.5f), new Vector2f(0,0)),
						    				new Vertex(new Vector3f(-0.5f,0.5f,0.5f), new Vector2f(0,1)),
						    				new Vertex(new Vector3f(-0.5f,0.5f,-0.5f), new Vector2f(1,1)),
						    				
						    				new Vertex(new Vector3f(-0.5f,-0.5f,0.5f), new Vector2f(1,0)),
						    				new Vertex(new Vector3f(0.5f,-0.5f,0.5f), new Vector2f(0,0)),
						    				new Vertex(new Vector3f(0.5f,0.5f,0.5f), new Vector2f(0,1)),
						    				new Vertex(new Vector3f(-0.5f,0.5f,0.5f), new Vector2f(1,1)),
						    				
						    				new Vertex(new Vector3f(-0.5f,0.5f,-0.5f), new Vector2f(1,0)),
						    				new Vertex(new Vector3f(-0.5f,0.5f,0.5f), new Vector2f(0,0)),
						    				new Vertex(new Vector3f(0.5f,0.5f,0.5f), new Vector2f(0,1)),
						    				new Vertex(new Vector3f(0.5f,0.5f,-0.5f), new Vector2f(1,1)),
						    				
						    				new Vertex(new Vector3f(0.5f,-0.5f,-0.5f), new Vector2f(0,0)),
						    				new Vertex(new Vector3f(0.5f,0.5f,-0.5f), new Vector2f(0,1)),
						    				new Vertex(new Vector3f(0.5f,0.5f,0.5f), new Vector2f(1,1)),
						    				new Vertex(new Vector3f(0.5f,-0.5f,0.5f), new Vector2f(1,0))};

		int[] indices = new int[] {	0,1,2,
				   					0,2,3,
				   					
				   					4,5,6,
				   					4,6,7,
				   					
									8,9,10,
									8,10,11,
									
									12,13,14,
									12,14,15,
									
									16,17,18,
									16,18,19,
									
									20,21,22,
									20,22,23};

        meshes.put("cube", new Mesh(vertices, indices, true, true));
	}
	
	private void addVertices(Vertex[] vertices, int[] indices, boolean calcNormals, boolean calcTangents)
	{
		if(calcNormals)
			calcNormals(vertices, indices);
		if(calcTangents)
			calcTangents(vertices, indices);
		
		size = indices.length;
		
		vbo = Engine.getRenderer().createVertexBuffer(Util.createFlippedBuffer(vertices), true);
		ibo = Engine.getRenderer().createIndexBuffer(Util.createFlippedBuffer(indices), true);
	}
	
	public void draw()
	{
		Engine.getRenderer().drawTriangles(vbo, ibo, size);
	}
	
	private void calcNormals(Vertex[] vertices, int[] indices)
	{
		for(int i = 0; i < indices.length; i += 3)
		{
			int i0 = indices[i];
			int i1 = indices[i + 1];
			int i2 = indices[i + 2];
			
			Vector3f v1 = vertices[i1].getPos().sub(vertices[i0].getPos());
			Vector3f v2 = vertices[i2].getPos().sub(vertices[i0].getPos());
			
			Vector3f normal = v1.cross(v2).normalized();
			
			vertices[i0].setNormal(vertices[i0].getNormal().add(normal));
			vertices[i1].setNormal(vertices[i1].getNormal().add(normal));
			vertices[i2].setNormal(vertices[i2].getNormal().add(normal));
		}
		
		for (Vertex vertex : vertices)
			vertex.setNormal(vertex.getNormal().normalized());
	}
	
	private void calcTangents(Vertex[] vertices, int[] indices)
	{
		for(int i = 0; i < indices.length; i += 3)
		{
			Vertex v0 = vertices[indices[i]];
			Vertex v1 = vertices[indices[i + 1]];
			Vertex v2 = vertices[indices[i + 2]];
			
			Vector3f edge1 = v1.getPos().sub(v0.getPos());
			Vector3f edge2 = v2.getPos().sub(v0.getPos());
			
			float deltaU1 = v1.getTexCoord().getX() - v0.getTexCoord().getX();
			float deltaU2 = v2.getTexCoord().getX() - v0.getTexCoord().getX();
			float deltaV1 = v1.getTexCoord().getY() - v0.getTexCoord().getY();
			float deltaV2 = v2.getTexCoord().getY() - v0.getTexCoord().getY();
			
			float f = 1.0f/(deltaU1 * deltaV2 - deltaU2 * deltaV1);
			
			Vector3f tangent = new Vector3f(0,0,0);
			
			tangent.setX(f * (deltaV2 * edge1.getX() - deltaV1 * edge2.getX()));
			tangent.setY(f * (deltaV2 * edge1.getY() - deltaV1 * edge2.getY()));
			tangent.setZ(f * (deltaV2 * edge1.getZ() - deltaV1 * edge2.getZ()));
			
//			Vector3f bitangent = new Vector3f(0,0,0);
//			
//			bitangent.setX(f * (-deltaU2 * edge1.getX() - deltaU1 * edge2.getX()));
//			bitangent.setX(f * (-deltaU2 * edge1.getY() - deltaU1 * edge2.getY()));
//			bitangent.setX(f * (-deltaU2 * edge1.getZ() - deltaU1 * edge2.getZ()));
			
			v0.setTangent(v0.getTangent().add(tangent));
			v1.setTangent(v1.getTangent().add(tangent));
			v2.setTangent(v2.getTangent().add(tangent));
		}
		
		for (Vertex vertex : vertices)
			vertex.setTangent(vertex.getTangent().normalized());
	}
	
	private Mesh(String fileName)
	{
		String[] splitArray = fileName.split("\\.");
		String ext = splitArray[splitArray.length - 1];
		
		if(!ext.equals("obj"))
		{
			System.err.println("Error: File format not supported for mesh data: " + ext);
			new Exception().printStackTrace();
			System.exit(1);
		}
		
		ArrayList<Vertex> vertices = new ArrayList<Vertex>();
		ArrayList<Integer> indices = new ArrayList<Integer>();
		
		try
		{
            BufferedReader meshReader = new BufferedReader(new FileReader(Engine.getResourcePath(DIRECTORY + fileName)));
            try
			{
				String line;
				
				while((line = meshReader.readLine()) != null)
				{
					String[] tokens = line.split(" ");
					tokens = Util.removeEmptyStrings(tokens);
					
					if(tokens.length == 0 || tokens[0].equals("#"))
						continue;
					
					if(tokens[0].equals("v"))
                    {
							vertices.add(new Vertex(new Vector3f(Float.valueOf(tokens[1]),
									Float.valueOf(tokens[2]),
									Float.valueOf(tokens[3]))));
                    }
                    else if(tokens[0].equals("f"))
                    {
							indices.add(Integer.parseInt(tokens[1].split("/")[0]) - 1);
							indices.add(Integer.parseInt(tokens[2].split("/")[0]) - 1);
							indices.add(Integer.parseInt(tokens[3].split("/")[0]) - 1);
							if(tokens.length > 4)
							{
								indices.add(Integer.parseInt(tokens[1].split("/")[0]) - 1);
								indices.add(Integer.parseInt(tokens[3].split("/")[0]) - 1);
								indices.add(Integer.parseInt(tokens[4].split("/")[0]) - 1);
							}
                    }
				}
			}
            finally
            {
                meshReader.close();
            }
			
			Vertex[] vertexData = new Vertex[vertices.size()];
			vertices.toArray(vertexData);
			
			Integer[] indexData = new Integer[indices.size()];
			indices.toArray(indexData);
			
			addVertices(vertexData, Util.toIntArray(indexData), true, true);
		}
		catch(Exception e)
		{
			e.printStackTrace();
			System.exit(1);
		}
	}
}
