public class TintedTile extends Tile
{
    float sparkleChance = 0.0004;
    PImage particleImage = ResourceManager.getImage("Sparkle");

	public TintedTile(int x, int y)
	{
		super(x, y);

		decalType = "DecalGolden";
		image = ResourceManager.getImage("TintedBlock", true);
	}

    void update()
    {
        super.update();

        if(random(1) < sparkleChance)
        {
            load(new SingleParticle(null, position, new PVector(0, -1), particleImage));
        }
    }
}