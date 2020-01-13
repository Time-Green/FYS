class ObjectFinderThread extends Thread
{
    public ArrayList<BaseObject> objectsInRadius;

    private PVector position;
    private float radius;
    
	public ObjectFinderThread(PVector position, float radius)
	{
		this.position = position;
        this.radius = radius;
	}
	
	public void run()
	{
		objectsInRadius = getObjectsInRadius(position, radius);
	}
}