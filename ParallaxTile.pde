class ParallaxTile extends BaseObject
{
    PImage image;
    int parallaxLayer;
    float darknessFactor = 80; //how much darker we get for every layer

    ArrayList<ParallaxTile> row; //the row we've placed in. It's so much easier with deleting, I feel stupid for not thinking of it while doing the same for normal tiles

    ParallaxTile(float x, float y, int parallaxLayer, PImage image)
    {
        position.set(x, y);

        this.image = image;
        this.parallaxLayer = parallaxLayer;
    }

    void specialAdd()
    {
        updateList.add(this);
    }

    void destroyed()
    {
        updateList.remove(this);
        row.remove(this);
    }

    void draw()
    {
        if(image != null)
        {
            tint(255 - darknessFactor * parallaxLayer);
            image(image, position.x - player.position.x * PARALLAX_INTENSITY * parallaxLayer, position.y);
            tint(0);
        }
    }
}