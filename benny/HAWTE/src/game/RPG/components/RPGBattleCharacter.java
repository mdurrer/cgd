package game.RPG.components;

import hawte.Game;
import hawte.GameObject;
import hawte.Vector2d;

import java.awt.*;

/**
 * kjahfkljashfisjldf
 */
public class RPGBattleCharacter extends RPGGridComponent
{
	public static final double BATTLE_CHARACTER_SIZE = 48.0;
	public static final double BATTLE_CHARACTER_SPACING = BATTLE_CHARACTER_SIZE / 1.5;
	private Vector2d renderOffset;

	public void setRenderOffset(Vector2d renderOffset) { this.renderOffset = renderOffset; }

	@Override
	public RPGBattleCharacter setColor(Color color)
	{
		return (RPGBattleCharacter)super.setColor(color);
	}

	public void init(GameObject parent)
	{
		super.init(parent);
	}

	@Override
	public void render(Graphics g)
	{
		Vector2d pos = renderOffset;
		bindColor(g);
		getGameObject().fillOffsetRect(g, (int) pos.getX(), (int) pos.getY(), (int)BATTLE_CHARACTER_SIZE, (int)BATTLE_CHARACTER_SIZE);
	}
}
