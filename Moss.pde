class Moss extends BaseObject
{
    PImage image = ResourceManager.getImage("MossGreyscale");
    color greyscaleColor;
    Tile host; //the tile we're covering

    int maxPotency = 4;
    int potency = maxPotency; //how many times we can spread and how thick we are. ticks down to zero between generations

    //NORTH, SOUTH, EAST and WEST. We'll tick them off if we spread or absolutely cant spread. Needed because tiles are often not loaded yet
    boolean[] directionAcquired = new boolean[4];

    float stickOut = 40; //how much we stick out, should not be considered for anything other than visual so we dont chance pos and size

    Moss(Tile tile, color greyscale)
    {
        greyscaleColor = greyscale;

        size.set(TILE_SIZE, TILE_SIZE);
        position.set(tile.position);

        drawLayer = ABOVE_TILE_LAYER;

        tile.rootedIn.add(this);
        host = tile;
        tile.moss = this;
    }

    Moss(Tile tile, color greyscale, int potency)
    {
        this(tile, greyscale);
        this.potency = potency;
    }

    void update()
    {
        super.update();

        if(potency <= 0)
        {
            return;
        }

        acquireVictims();
    }

    void draw()
    {
        applyTint();
        image(image, position.x - stickOut * .5, position.y - stickOut * .5, size.x + stickOut, size.y + stickOut);
        tint(255);
    }   

    void acquireVictims()
    {
        if(!directionAcquired[NORTH])
        {
            assimilate(world.getTile(position.x, position.y - TILE_SIZE), NORTH);
        }

        if(!directionAcquired[SOUTH])
        {
            assimilate(world.getTile(position.x, position.y + TILE_SIZE), SOUTH);
        }

        if(!directionAcquired[EAST])
        {
            assimilate(world.getTile(position.x + TILE_SIZE, position.y), EAST);
        }

        if(!directionAcquired[WEST])
        {
            assimilate(world.getTile(position.x - TILE_SIZE, position.y), WEST);
        }
    }

    void assimilate(Tile victim, int dir)
    {
        if(victim == null)
        {
            return; //we'll try another time
        }

        if(victim.rootedIn.size() == 0 && victim.density)
        {
            int subtract = int(random(2));
            load(new Moss(victim, greyscaleColor, potency - subtract));
        }

        directionAcquired[dir] = true;
    }

    void applyTint()
    {
        //we lerp, so we can shift from our color, to black dependent on how much light there is
        tint(lerpColor(color(0), greyscaleColor, lightningAmount / 255), 150 + float(potency) / float(maxPotency) * 255); //float() because otherwise we get int division
    }

    void applyTileTint()
    {
        tint(lerpColor(color(0), lerpColor(greyscaleColor, color(255), .5), host.lightningAmount / 255));
    }
}