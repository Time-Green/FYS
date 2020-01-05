class Parallax extends BaseObject
{
    PImage parallaxImage; 

    Parallax(PImage parallaxImage)
    {
        this.parallaxImage = parallaxImage;
        drawLayer = BACKGROUND_LAYER;
    }

    void draw()
    {
        image(parallaxImage, position.x - player.position.x * PARALLAX_INTENSITY, position.y);
    }
}