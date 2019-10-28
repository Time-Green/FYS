import processing.sound.*;

public static class ResourceManager{

  private static PApplet game;

  private static ArrayList<String> resourcesToLoadNames = new ArrayList<String>();
  private static ArrayList<String> resourcesToLoadFileNames = new ArrayList<String>();
  private static int currentLoadIndex = 0;
  private static int totalResourcesToLoad = 0;

  private static HashMap<String, PImage> imageMap = new HashMap<String, PImage>();
  private static HashMap<String, SoundFile> soundMap = new HashMap<String, SoundFile>();
  private static HashMap<String, PFont> fontMap = new HashMap<String, PFont>();

  public static void setup(PApplet game){
    ResourceManager.game = game;
  }

  public static void prepareLoad(String name, String fileName){
    totalResourcesToLoad++;

    resourcesToLoadNames.add(name);
    resourcesToLoadFileNames.add(fileName);
  }

  public static String loadNext(){

    String currentResourceName = resourcesToLoadNames.get(currentLoadIndex);
    String currentResourceFileName = resourcesToLoadFileNames.get(currentLoadIndex);

    load(currentResourceName, currentResourceFileName);
    currentLoadIndex++;

    return currentResourceFileName;
  }

  public static boolean isLoaded(){
    return currentLoadIndex == totalResourcesToLoad;
  }

  public static int getCurrentLoadIndex(){
    return currentLoadIndex;
  }

  public static int getTotalResourcesToLoad(){
    return totalResourcesToLoad;
  }
  
  public static void load(String name, String fileName){
    if(fileName.endsWith(".png") || fileName.endsWith(".jpg")){
      loadImage(name, fileName);
    }
    else if(fileName.endsWith(".mp3") || fileName.endsWith(".wav")){
      loadSoundFile(name, fileName);
    }
    else if(fileName.endsWith(".ttf")){
      loadFont(name, fileName);
    }
  }

  private static void loadImage(String name, String fileName){
    PImage image = game.loadImage(fileName);

    if(image == null){
      println("Could not load image: " + fileName);
      return;
    }

    println("Image '" + fileName + "' loaded as: " + name);
    imageMap.put(name, image);
  }

  private static void loadSoundFile(String name, String fileName){
    SoundFile sound = new SoundFile(game, fileName);

    if(sound == null){
      println("Could not load sound: " + fileName);
      return;
    }

    println("Sound '" + fileName + "' loaded as: " + name);
    soundMap.put(name, sound);
  }

  private static void loadFont(String name, String fileName) {
    PFont font = game.createFont(fileName, 32);

    if(font == null){
      println("Could not load font: " + fileName);
      return;
    }

    println("Font '" + fileName + "' loaded as: " + name);
    fontMap.put(name, font);
  }

  public static PImage getImage(String name){
    PImage image = imageMap.get(name);

    if(image == null){
      println("Image '" + name + "' not found!");
      return null;
    }

    return image;
  }

  public static SoundFile getSound(String name){
    SoundFile sound = soundMap.get(name);

    if(sound == null){
      println("SoundFile '" + name + "' not found!");
      return null;
    }

    return sound;
  }

  public static PFont getFont(String name){
    PFont font = fontMap.get(name);

    if(font == null){
      println("Font '" + name + "' not found!");
      return null;
    }

    return font;
  }
}
