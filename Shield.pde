class Shield extends BaseObject
{

    private PImage image;
    public boolean drawShield;

    public Shield()
    {
        image = ResourceManager.getImage("BombTile");
        drawLayer = PRIORITY_LAYER;
    }

    // void draw()
    // {
    //     println("hi");
    //     image(image, position.x, position.y, size.x, size.y);
    // }

    // void update()
    // {
    //     position = new PVector(player.position.x,player.position.x);
    // }

    // public void drawShield()
    // {
        
    //     update();
    //     // draw();
    // }

}