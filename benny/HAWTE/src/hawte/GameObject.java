package hawte;

import java.awt.*;
import java.io.*;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Scanner;

/**
 * Primary Game Object of HAWTE
 */
public class GameObject
{
	private ArrayList<GameObject> children;
	private ArrayList<GameComponent> components;
	private Transform transform;
	private Game game;

	public Game getGame() { return game; }
	public int getNumComponents() { return components.size(); }
	public int getNumChildren() { return children.size(); }
	public GameObject getChild(int index) { return children.get(index); }
	public GameComponent getComponent(int index) { return components.get(index); }
	public Transform getTransform() { return transform; }

	public GameObject(Transform transform, Game game)
	{
		components = new ArrayList<GameComponent>();
		children = new ArrayList<GameObject>();
		this.transform = transform;
		this.game = game;
	}

	public GameComponent[] findComponent(Class<?> className)
	{
		ArrayList<GameComponent> result = new ArrayList<GameComponent>();

		for(int i = 0; i < this.getNumComponents(); i++)
		{
			GameComponent component = this.getComponent(i);

			if(component.getClass() == className)
				result.add(component);
		}

		return result.toArray(new GameComponent[result.size()]);
	}

	public GameComponent[] findAllComponents(Class<?> className)
	{
		ArrayList<GameComponent> result = new ArrayList<GameComponent>();

		for(GameObject gameObject : children)
		{
			for(int i = 0; i < gameObject.getNumComponents(); i++)
			{
				GameComponent component = gameObject.getComponent(i);

				if(component.getClass() == className)
					result.add(component);
			}
		}

		return result.toArray(new GameComponent[result.size()]);
	}

	public void addChild(GameObject object)
	{
		children.add(object);
	}

	public void removeChild(GameObject object)
	{
		children.remove(object);
	}

//	public GameObject(Transform transform, GameComponent component, Game game)
//	{
//		components = new ArrayList<GameComponent>();
//		children = new ArrayList<GameObject>();
//		this.transform = transform;
//		this.game = game;
//		addComponent(component);
//	}

	public GameObject addComponent(GameComponent component)
	{
		component.init(this);
		components.add(component);
		return this;
	}

	public void input(Input input)
	{
		for(GameComponent component : components)
			component.input(input);
		for(GameObject child : children)
			child.input(input);
	}

	public void update(double delta)
	{
		for(GameComponent component : components)
			component.update(delta);
		for(GameObject child : children)
			child.update(delta);
	}

	public void render(Graphics g)
	{
		for(GameComponent component : components)
			component.render(g);
		for(GameObject child : children)
			child.render(g);
	}

	public void addToStringList(ArrayList<String> outputStrings)
	{
		outputStrings.add("go " + getClass().getCanonicalName() + " " + getTransform().toString());

		for(int i = 0; i < getNumComponents(); i++)
			outputStrings.add("cmp " + getComponent(i).getClass().getCanonicalName());
	}

	public void saveScene(String filePath)
	{
		ArrayList<String> outputStrings = new ArrayList<String>();

		addToStringList(outputStrings);

		if(children.size() > 0)
			outputStrings.add("child");
		for(GameObject gameObject : children)
			gameObject.addToStringList(outputStrings);

		PrintWriter out = null;
		try
		{
			out = new PrintWriter(new FileWriter(filePath));

			for(String string : outputStrings)
				out.println(string);
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
		finally
		{
			if(out != null)
				out.close();
		}
	}

	private void loadGameObjectTransform(GameObject object, Scanner scan)
	{
		Transform transform = object.getTransform();
		transform.getPos().setX(Double.parseDouble(scan.next()));
		transform.getPos().setY(Double.parseDouble(scan.next()));
		transform.getScale().setX(Double.parseDouble(scan.next()));
		transform.getScale().setY(Double.parseDouble(scan.next()));
		transform.setRotation(Double.parseDouble(scan.next()));
	}

	private String loadGameObjectChildren(GameObject object, Scanner scan) throws IllegalAccessException, ClassNotFoundException, InstantiationException
	{
		String token = scan.next();

		while(token.equals("go"))
		{
			token = scan.next();

			GameObject child = null;

			try
			{
				Class<?> gameObjectClass = Class.forName(token);
				Constructor<?> ctor = gameObjectClass.getConstructor(Transform.class, Game.class);
				child = (GameObject)ctor.newInstance(new Transform(), object.getGame());
			}
			catch(NoSuchMethodException e)
			{
				e.printStackTrace();
			}
			catch(InvocationTargetException e)
			{
				e.printStackTrace();
			}


			//GameObject child = new GameObject(new Transform(), object.getGame());
			token = loadGameObject(child, scan);
			object.addChild(child);
		}

		return token;
	}

	private String loadGameObjectComponents(GameObject object, Scanner scan) throws ClassNotFoundException, IllegalAccessException, InstantiationException
	{
		String token = scan.next();
		object.addComponent((GameComponent)Class.forName(token).newInstance());

		if(!scan.hasNext())
			return "";

		token = scan.next();
		while(token.equals("cmp"))
		{
			object.addComponent((GameComponent)Class.forName(scan.next()).newInstance());

			if(!scan.hasNext())
				return "";

			token = scan.next();
		}

		return token;
	}

	private String loadGameObject(GameObject object, Scanner scan) throws IllegalAccessException, InstantiationException, ClassNotFoundException
	{
		loadGameObjectTransform(object, scan);

		if(!scan.hasNext())
			return "";

		String token = scan.next();

		if(token.equals("cmp"))
			token = loadGameObjectComponents(object, scan);
		if(token.equals("child"))
			token = loadGameObjectChildren(object, scan);

		return token;
	}

	public void loadScene(String filePath, boolean isInJar)
	{
		children.clear();
		Scanner scan = null;
		try
		{
			if(!isInJar)
				scan = new Scanner(new File(filePath));
			else
				scan = new Scanner(getClass().getResourceAsStream(filePath.substring(1)));

			if(scan.hasNext() && scan.next().equals("go"))
			{
				try
				{
					scan.next();
					loadGameObject(this, scan);
				}
				catch(IllegalAccessException e)
				{
					e.printStackTrace();
				}
				catch(InstantiationException e)
				{
					e.printStackTrace();
				}
				catch(ClassNotFoundException e)
				{
					e.printStackTrace();
				}
			}
		}
		catch(FileNotFoundException e)
		{
			e.printStackTrace();
		}
		finally
		{
			if(scan != null)
				scan.close();
		}
	}
}
