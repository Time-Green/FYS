class ParallaxTile extends BaseObject
{
    PImage image;
    int parallaxLayer;
    float darknessFactor = 80; //how much darker we get for every layer

    PVector originalPosition = new PVector();

    ArrayList<ParallaxTile> row; //the row we've placed in. It's so much easier with deleting, I feel stupid for not thinking of it while doing the same for normal tiles

    ParallaxTile(float x, float y, int parallaxLayer, PImage image)
    {
        position.set(x, y);

        originalPosition.set(x, y);

        this.image = image;
        this.parallaxLayer = parallaxLayer;
    }

    void destroyed()
    {
        updateList.remove(this);
        row.remove(this);
    }

    void update()
    {
        position.x = originalPosition.x - player.position.x * PARALLAX_INTENSITY * parallaxLayer;
        return;
    }

    void draw()
    {
        if(image != null && inCameraView())
        {
            tint(255 - darknessFactor * parallaxLayer);
            image(image, position.x, position.y);
            tint(0);
        }
    }
}