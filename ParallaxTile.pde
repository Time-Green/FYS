class ParallaxTile extends BaseObject
{
    PImage image;
    int parallaxLayer; //the layer we're on. Higher means deeper
    float darknessFactor = 80; //how much darker we get for every layer

    ArrayList<ParallaxTile> row; //the row we've placed in. It's so much easier with deleting, I feel stupid for not thinking of it while doing the same for normal tiles

    ParallaxTile(float x, float y, int parallaxLayer, PImage image)
    {
        position.set(x, y);

        this.image = image;
        this.parallaxLayer = parallaxLayer;
    }

    void specialAdd() //we overwrite this so that we're not added to the normal drawing layers
    {
        updateList.add(this);
    }

    void destroyed()
    {
        updateList.remove(this);
        row.remove(this);
    }

    void update()
    {
        return;
    }

    void draw() //called from FYS.pde, where we got a special loop for just us
    {
        if(image != null)
        {
            tint(255 - darknessFactor * parallaxLayer);
            image(image, position.x - player.position.x * PARALLAX_INTENSITY * parallaxLayer, position.y); //displace it aswell, to get the parallax effect
            tint(0);
        }
    }
}