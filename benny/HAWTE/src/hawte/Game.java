package hawte;

import java.awt.*;
import java.util.ArrayList;

/**
 * The primary game interface of HAWTE.
 * Provides basic object list and updates with game clock
 */
public abstract class Game
{
	private ArrayList<GameObject> objectsToBeAdded = new ArrayList<GameObject>();
	private ArrayList<GameObject> objectsToBeRemoved = new ArrayList<GameObject>();
	private GameObject rootObject = new GameObject(new Transform(new Vector2d(0,0), new Vector2d(0,0), 0), this);
	private int width;
	private int height;

	public GameComponent[] findAllComponents(Class<?> className)
	{
		return rootObject.findAllComponents(className);
	}

	public int getWidth() { return width; }
	public int getHeight() { return height; }

	public abstract void init();

	public void input(Input input)
	{
		for(GameObject object : objectsToBeAdded)
			rootObject.addChild(object);
		objectsToBeAdded.clear();

		for(GameObject object : objectsToBeRemoved)
			rootObject.removeChild(object);
		objectsToBeRemoved.clear();

		rootObject.input(input);
	}

	private void addAndUpdatePhysicsComponents(GameObject object, ArrayList<PhysicsComponent> physicsComponents, double delta)
	{
		for(int i = 0; i < object.getNumComponents(); i++)
		{
			PhysicsComponent component;

			if(object.getComponent(i) instanceof PhysicsComponent)
				component = (PhysicsComponent)object.getComponent(i);
			else
				continue;

			component.integrate(delta);
			physicsComponents.add(component);
		}

		for(int i = 0; i < object.getNumChildren(); i++)
			addAndUpdatePhysicsComponents(object.getChild(i), physicsComponents, delta);
	}

	public void update(double delta)
	{
		rootObject.update(delta);

		//Update physics simulation. Possibly move this to other method/class
		ArrayList<PhysicsComponent> physicsComponents = new ArrayList<PhysicsComponent>();

		addAndUpdatePhysicsComponents(rootObject, physicsComponents, delta);

		for(int i = 0; i < physicsComponents.size(); i++)
		{
			PhysicsComponent component1 = physicsComponents.get(i);
			for(int j = i + 1; j < physicsComponents.size(); j++)
			{
				PhysicsComponent component2 = physicsComponents.get(j);
				if(component1.getVelocity().lengthSquared() == 0 &&
				   component2.getVelocity().lengthSquared() == 0)
					continue;

				Transform transform1 = component1.getGameObject().getTransform();
				Transform transform2 = component2.getGameObject().getTransform();

				Contact contact = transform1.checkBoxCollision(transform2);

				if(contact != null)
				{
					component1.onCollision(contact, component2);
					component2.onCollision(contact, component1);
				}
			}
		}
	}

	public void render(Graphics g)
	{
		rootObject.render(g);
	}

	//TODO: At some point, make this scale with changes to the engine
	public void updateEngineParameters(int width, int height)
	{
		this.width = width;
		this.height = height;
	}

	public void addObject(GameObject object)
	{
		objectsToBeAdded.add(object);
	}

	public void removeObject(GameObject object)
	{
		objectsToBeRemoved.add(object);
	}

	public void saveScene(String filePath)
	{
		rootObject.saveScene(filePath);
	}

	public void loadScene(String filePath, boolean isInJar)
	{
		rootObject.loadScene(filePath, isInJar);
	}
}
