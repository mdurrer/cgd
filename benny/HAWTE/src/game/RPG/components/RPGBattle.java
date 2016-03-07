package game.RPG.components;

import hawte.Game;
import hawte.GameObject;
import hawte.Vector2d;

import java.awt.*;
import java.util.ArrayList;

/**
 * anijfhoiuqwehgahf
 */
public class RPGBattle extends RPGGridComponent
{
	private ArrayList<RPGBattleCharacter> battleCharacters = new ArrayList<RPGBattleCharacter>();
	private Vector2d characterPosStart;
	private double battleCharacterPositionStartX;
	private double battleCharacterPositionStartY;

	public void init(GameObject parent)
	{
		super.init(parent);
		setColor(Color.BLACK);

		Game game = parent.getGame();
		battleCharacterPositionStartX = game.getWidth() * 7 / 8;
		battleCharacterPositionStartY = game.getHeight() / 16;

		characterPosStart = new Vector2d(battleCharacterPositionStartX, battleCharacterPositionStartY);
	}

	public void addBattleCharacter(RPGBattleCharacter character)
	{
		character.init(getGameObject());
		battleCharacters.add(character);
	}

	@Override
	public void render(Graphics g)
	{
		drawBackground(g);
		drawBattleCharacters(g);
	}

	private void drawBattleCharacters(Graphics g)
	{
		characterPosStart.set(battleCharacterPositionStartX, battleCharacterPositionStartY);

		for(RPGBattleCharacter character : battleCharacters)
		{
			character.setRenderOffset(characterPosStart);
			character.render(g);
			characterPosStart.incY(RPGBattleCharacter.BATTLE_CHARACTER_SIZE + RPGBattleCharacter.BATTLE_CHARACTER_SPACING);
		}
	}

	private void drawBackground(Graphics g)
	{
		Vector2d pos = getGridCornerPos();
		Game game = getGameObject().getGame();
		bindColor(g);
		getGameObject().fillOffsetRect(g, (int) pos.getX(), (int) pos.getY(), game.getWidth(), game.getHeight());
	}
}
