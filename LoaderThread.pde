class LoaderThread extends Thread
{
	String currentResourceName;
	String currentResourceFileName;
	
	public LoaderThread(String currentResourceName, String currentResourceFileName)
	{
		setName(currentResourceName);

		this.currentResourceName = currentResourceName;
		this.currentResourceFileName = currentResourceFileName;
	}

	public String getResouceName()
	{
		return currentResourceName;
	}
	
	public void run()
	{
		ResourceManager.load(currentResourceName, currentResourceFileName);
	}
}