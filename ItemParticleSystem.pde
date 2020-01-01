public class ItemParticleSystem extends BaseParticleSystem
{
	public ItemParticleSystem(PVector spawnPos, int amount, Item item)
	{
		super(spawnPos, amount);

		ItemParticle particle = new ItemParticle(this, position, new PVector(0,0), item);
		load(particle);
	}
}
