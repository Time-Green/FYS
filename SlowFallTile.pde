public class SlowFallTile extends Tile
{
	PImage particleImage = ResourceManager.getImage("LeafParticle"); //default particlr image

	float particleChance = 0.001;
	float rumbleParticleChance = 0.005;
	float slowdownCoeff = 0.95;

	public SlowFallTile(int x, int y)
	{
		super(x, y);

		density = true; //we are dense so we can distinguish ourselves from other blocks and draw the decals
	}

	void update()
	{
		if(gamePaused)
		{
			return;
		}

        super.update();


		if(!destroyed && random(1) < particleChance * TimeManager.deltaFix)
		{
			spawnParticle();
		}
	}

	boolean canCollideWith(BaseObject object)
	{
		if(!destroyed && object.canPlayerInteract())
		{
			Player player = (Player) object;
			player.velocity.mult(slowdownCoeff);

			if(random(1) < rumbleParticleChance)
			{
				spawnParticle();
			}
		}

		return false;
	}

	void spawnParticle()
	{
		load(new SingleParticle(null, position, new PVector(random(-2, 0), 1), particleImage));
	}
}