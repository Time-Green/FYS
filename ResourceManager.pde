public static class ResourceManager
{
	private static FYS game;

	private static ArrayList<String> resourcesToLoadNames = new ArrayList<String>();
	private static ArrayList<String> resourcesToLoadFileNames = new ArrayList<String>();

	private static HashMap<String, PImage> imageMap = new HashMap<String, PImage>();
	private static HashMap<String, PFont> fontMap = new HashMap<String, PFont>();

	private static boolean isAllLoaded = false;
	public static ArrayList<LoaderThread> loaderThreads = new ArrayList<LoaderThread>();

	public static void setup(FYS game)
	{
		ResourceManager.game = game;
	}

	// find all resources
	public static void prepareResourceLoading()
	{
		String dataPath = game.sketchPath("data");
		File dataFolder = new File(dataPath);

		searchInFolder(dataFolder);
	}

	// get resources in a folder
	private static void searchInFolder(File folder)
	{
		for (File file : folder.listFiles())
		{
			if (file.isDirectory())
			{
				searchInFolder(file);
			}
			else if (file.isFile())
			{
				prepareLoad(getFileName(file), file.getPath());
			}
		}
	}

	// get the name of a file
	private static String getFileName(File file)
	{
		String name = file.getName();
		int pos = name.lastIndexOf(".");

		if (pos > 0)
		{
			name = name.substring(0, pos);
		}

		return name;
	}

	// prepare a file to be loaded
	public static void prepareLoad(String name, String fileName)
	{
		resourcesToLoadNames.add(name);
		resourcesToLoadFileNames.add(fileName);
	}

	// load all prepared resources
	public static void loadAll(boolean doPrepareResourceLoading)
	{
		if(doPrepareResourceLoading)
		{
			prepareResourceLoading();
		}

		for (int i = 0; i < resourcesToLoadNames.size(); i++)
		{
			String currentResourceName = resourcesToLoadNames.get(i);
			String currentResourceFileName = resourcesToLoadFileNames.get(i);

			game.startLoaderThread(currentResourceName, currentResourceFileName);
		}
	}

	// check if all resources are loaded
	public static boolean isAllLoaded()
	{
		if(isAllLoaded)
		{
			return true;
		}

		for (int i = 0; i < loaderThreads.size(); i++)
		{
			if(loaderThreads.get(i).isAlive())
			{
				return false;
			}
		}

		isAllLoaded = true;

		return true;
	}

	// get the progress of resource loading
	public static float getLoadingAllProgress()
	{
		float totalThreadsCompleted = 0;

		for (int i = 0; i < loaderThreads.size(); i++)
		{
			if(loaderThreads.get(i).isAlive())
			{
				totalThreadsCompleted++;
			}
		}

		return 1 - (totalThreadsCompleted / float(loaderThreads.size()));
	}

	// get a list of all active loader threads
	public static ArrayList<String> getLoadingResources()
	{
		ArrayList<String> currentlyLoadingResources = new ArrayList<String>();

		for (int i = 0; i < loaderThreads.size(); i++)
		{
			if(loaderThreads.get(i).isAlive())
			{
				String name = ((Thread) loaderThreads.get(i)).getName();

				currentlyLoadingResources.add(name);
			}
		}

		return currentlyLoadingResources;
	}

	// load a resource
	public static void load(String name, String fileName)
	{
		// do something else based on file extention
		if (fileName.endsWith(".png") || fileName.endsWith(".jpg"))
		{
			loadImage(name, fileName);
		}
		else if (fileName.endsWith(".mp3") || fileName.endsWith(".wav"))
		{
			loadSoundFile(name, fileName);
		}
		else if (fileName.endsWith(".ttf"))
		{
			loadFont(name, fileName);
		}
	}

	// load a image file
	private static void loadImage(String name, String fileName)
	{
		PImage image = game.loadImage(fileName);

		if (image == null)
		{
			println("Could not load image: " + fileName);

			return;
		}

		imageMap.put(name, image);
	}

	// load a sound file
	private static void loadSoundFile(String name, String fileName)
	{
		if (fileName.contains("Music"))
		{
			AudioManager.loadMusic(name, fileName);
		}
		else
		{
			AudioManager.loadSoundEffect(name, fileName);
		}
	}

	// load a font file
	private static void loadFont(String name, String fileName)
	{
		PFont font = game.createFont(fileName, 32);

		if (font == null)
		{
			println("Could not load font: " + fileName);

			return;
		}

		fontMap.put(name, font);
	}

	// get a loaded image
	public static PImage getImage(String name)
	{
		PImage image = imageMap.get(name);

		if (image == null)
		{
			println("WARNING Image '" + name + "' not found! Trying to load it again...");

			int resourceIndex = resourcesToLoadNames.indexOf(name);

			if(resourceIndex < 0)
			{
				// resource not found in dictionary
				return null;
			}

			load(resourcesToLoadNames.get(resourceIndex), resourcesToLoadFileNames.get(resourceIndex));

			// retry
			return getImage(name);
		}

		return image;
	}

	// get a loaded image and flip it
	public static PImage getImage(String name, boolean randomFlipped)
	{
		if(randomFlipped)
		{
			return getRandomFlippedImage(name);
		}
		else
		{
			return getImage(name);
		}
	}

	// get a flipped image
	public static PImage getRandomFlippedImage(String name)
	{
		int randomFlipIndex = game.floor(game.random(3));

		PImage image = imageMap.get(name + "_Flip" + randomFlipIndex);

		if (image == null)
		{
			//println("WARNING Random flip image '" + name + "' not found! Generating at runtime...");

			// generate the flipped images at runtime
			generateFlippedImages(name);

			// retry to get the newly generated image
			return getRandomFlippedImage(name);
		}

		return image;
	}

	// flips an existing image to add more variation
	public static void generateFlippedImages(String name)
	{
		PImage baseImage = getImage(name);

		PImage horizontallyFlippedImage = generateHorizontallyFlippedImage(baseImage);
		PImage verticallyFlippedImage = generateVerticallyFlippedImage(baseImage);
		PImage horizontallyAndVerticallyFlippedImage = generateHorizontallyAndVerticallyFlippedImage(baseImage);

		imageMap.put(name + "_Flip0", horizontallyFlippedImage);
		imageMap.put(name + "_Flip1", verticallyFlippedImage);
		imageMap.put(name + "_Flip2", horizontallyAndVerticallyFlippedImage);
	}

	// flip image horizontally
	private static PImage generateHorizontallyFlippedImage(PImage baseImage)
	{
		PImage newImage = new PImage(baseImage.width, baseImage.height, ARGB);

		baseImage.loadPixels();
		newImage.loadPixels();

		for (int y = 0; y < baseImage.height; y++)
		{
			for (int x = 0; x < baseImage.width; x++)
			{
				int xPos = newImage.width - x - 1;

				newImage.pixels[y * newImage.width + xPos] = baseImage.pixels[y * baseImage.width + x];
			}
		}

		newImage.updatePixels();

		return newImage;
	}

	// flip image vertically
	private static PImage generateVerticallyFlippedImage(PImage baseImage)
	{
		PImage newImage = new PImage(baseImage.width, baseImage.height, ARGB);

		baseImage.loadPixels();
		newImage.loadPixels();

		for (int y = 0; y < baseImage.height; y++)
		{
			for (int x = 0; x < baseImage.width; x++)
			{
				int yPos = newImage.height - y - 1;
				
				newImage.pixels[yPos * newImage.width + x] = baseImage.pixels[y * baseImage.width + x];
			}
		}

		newImage.updatePixels();

		return newImage;
	}

	// flip image horizontally and vertically
	private static PImage generateHorizontallyAndVerticallyFlippedImage(PImage baseImage)
	{
		PImage newImage = new PImage(baseImage.width, baseImage.height, ARGB);

		PImage horizontallyFlippedImage = generateHorizontallyFlippedImage(baseImage);
		PImage horizontallyAndVerticallyFlippedImage = generateVerticallyFlippedImage(horizontallyFlippedImage);

		return horizontallyAndVerticallyFlippedImage;
	}

	// get a loaded font
	public static PFont getFont(String name)
	{
		PFont font = fontMap.get(name);

		if (font == null)
		{
			println("Font '" + name + "' not found!");
			
			return null;
		}

		return font;
	}
}
