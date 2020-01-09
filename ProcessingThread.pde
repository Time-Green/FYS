class ProcessingThread extends Thread
{
	int threadInt;
    boolean active = true;

	public ProcessingThread(int threadInt)
	{
		this.threadInt = threadInt;
	}

    public void run ()
    {
        updateObjects(threadInt);
        threadRunning[threadInt] = false;
    }
}