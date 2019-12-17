public class EnemyMimicTile extends Tile
{
	private boolean hasSpawnedMimic;

	public EnemyMimicTile(int x, int y)
	{
		super(x, y); 

		image = ResourceManager.getImage("MimicTile");
	}

	void mine(boolean playMineSound)
	{
		super.mine(playMineSound);

		//Stop this function from creating more than one mimic
		if (hasSpawnedMimic)
		{
			return;
		}

		hasSpawnedMimic = true;

		load(new EnemyMimic(new PVector(this.position.x, this.position.y)));
	}
}
