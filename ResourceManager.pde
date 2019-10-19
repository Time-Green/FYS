public static class ResourceManager{

    private static PApplet game;

    private static HashMap<String, PImage> imageMap = new HashMap<String, PImage>();
    //todo: add hashmap/functions for loading/getting audio files

    public static void setup(PApplet game){
        ResourceManager.game = game;
    }

    public static void load(String name, String fileName){
        PImage image = game.loadImage(fileName);

        if(image == null){
            println("Could not load image: " + fileName);
            return;
        }

        println("Image '" + fileName + "' loaded as: " + name);
        imageMap.put(name, image);
    }

    public static PImage getImage(String name){
        PImage image = imageMap.get(name);

        if(image == null){
            println("Image '" + name + "' not found!");
            return null;
        }

        return image;
    }
}
