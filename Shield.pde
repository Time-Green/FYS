class Shield
{
    private PImage image;
    public boolean drawShield;

    public Shield()
    {
        image = ResourceManager.getImage("ShieldOld");
    }

    void draw()
    {
        image(image, player.position.x, player.position.y, player.size.x, player.size.y);
    }

}