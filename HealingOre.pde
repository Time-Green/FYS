public class HealthTile extends Tile
{
	public float healAmount = 20;
	boolean hasHealed; 

	public HealthTile(int x, int y)
	{
		super(x, y); 

		image = ResourceManager.getImage("MagmaTile");
	}

	private void heal()
	{
		player.currentHealth += healAmount;
	}
}
