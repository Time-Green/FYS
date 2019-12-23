class Parallax extends BaseObject
{
    PImage parallaxImage; 

    Parallax(PImage parallaxImage)
    {
        this.parallaxImage = parallaxImage;
        drawLayer = BACKGROUND_LAYER;

        size.set(TILES_HORIZONTAL * TILE_SIZE, TILE_SIZE * 10); //should be 50 wide and 10 high as default
    }

    void draw()
    {
        image(parallaxImage, position.x - player.position.x * PARALLAX_INTENSITY, position.y, size.x, size.y);
    }
}