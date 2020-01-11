public class TintedTile extends Tile
{
    float sparkleChance = 0.001;

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
            load(new ShineParticle(null, position, new PVector(0, -1)));
        }
    }
}