import processing.sound.*;

public static class ResourceManager{

    private static PApplet game;

    private static HashMap<String, PImage> imageMap = new HashMap<String, PImage>();
    private static HashMap<String, SoundFile> soundMap = new HashMap<String, SoundFile>();

    public static void setup(PApplet game){
        ResourceManager.game = game;
    }

    public static void load(String name, String fileName){
        if(fileName.endsWith(".png") || fileName.endsWith(".jpg")){
            loadImage(name, fileName);
        }
        else if(fileName.endsWith(".mp3") || fileName.endsWith(".wav")){
            loadSoundFile(name, fileName);
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
}
