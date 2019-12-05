public static class ResourceManager {

  private static PApplet game;

  private static ArrayList<String> resourcesToLoadNames = new ArrayList<String>();
  private static ArrayList<String> resourcesToLoadFileNames = new ArrayList<String>();
  private static int currentLoadIndex = 0;
  private static int totalResourcesToLoad = 0;

  private static HashMap<String, PImage> imageMap = new HashMap<String, PImage>();
  private static HashMap<String, PFont> fontMap = new HashMap<String, PFont>();

  public static void setup(PApplet game) {
    ResourceManager.game = game;
  }

  public static void prepareResourceLoading() {
    String dataPath = game.sketchPath("data");

    File dataFolder = new File(dataPath);

    searchInFolder(dataFolder);
  }

  private static void searchInFolder(File folder) {

    for (File file : folder.listFiles()) {

      if (file.isDirectory()) {
        searchInFolder(file);
      } else if (file.isFile()) {
        prepareLoad(getFileName(file), file.getPath());
      }
    }
  }

  private static String getFileName(File file) {
    String name = file.getName();
    int pos = name.lastIndexOf(".");

    if (pos > 0) {
      name = name.substring(0, pos);
    }

    return name;
  }

  public static void prepareLoad(String name, String fileName) {
    totalResourcesToLoad++;

    resourcesToLoadNames.add(name);
    resourcesToLoadFileNames.add(fileName);
  }

  public static String loadNext() {
    String currentResourceName = resourcesToLoadNames.get(currentLoadIndex);
    String currentResourceFileName = resourcesToLoadFileNames.get(currentLoadIndex);

    load(currentResourceName, currentResourceFileName);
    currentLoadIndex++;

    if (currentLoadIndex + 1 < resourcesToLoadFileNames.size()) {
      String nextResourceToLoad = resourcesToLoadFileNames.get(currentLoadIndex + 1);

      return nextResourceToLoad;
    } else {
      return "";
    }
  }

  public static boolean isLoaded() {
    return currentLoadIndex == totalResourcesToLoad;
  }

  public static int getCurrentLoadIndex() {
    return currentLoadIndex;
  }

  public static int getTotalResourcesToLoad() {
    return totalResourcesToLoad;
  }

  public static void load(String name, String fileName) {
    if (fileName.endsWith(".png") || fileName.endsWith(".jpg")) {
      loadImage(name, fileName);
    } else if (fileName.endsWith(".mp3") || fileName.endsWith(".wav")) {
      loadSoundFile(name, fileName);
    } else if (fileName.endsWith(".ttf")) {
      loadFont(name, fileName);
    }
  }

  private static void loadImage(String name, String fileName) {
    PImage image = game.loadImage(fileName);

    if (image == null) {
      println("Could not load image: " + fileName);
      return;
    }

    imageMap.put(name, image);
  }

  private static void loadSoundFile(String name, String fileName) {
    if (fileName.contains("Music")) {
      AudioManager.loadMusic(name, fileName);
    } else {
      AudioManager.loadSoundEffect(name, fileName);
    }
  }

  private static void loadFont(String name, String fileName) {
    PFont font = game.createFont(fileName, 32);

    if (font == null) {
      println("Could not load font: " + fileName);
      return;
    }

    fontMap.put(name, font);
  }

  public static PImage getImage(String name) {
    PImage image = imageMap.get(name);

    if (image == null) {
      println("Image '" + name + "' not found!");
      return null;
    }

    return image;
  }

  public static PFont getFont(String name) {
    PFont font = fontMap.get(name);

    if (font == null) {
      println("Font '" + name + "' not found!");
      return null;
    }

    return font;
  }
}
