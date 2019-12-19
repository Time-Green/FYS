class TileDecal extends Movable
{ //those little spikes on tiless

    TileDecal(int dir, String decalType)
    {
        switch(dir)
        {
            case UP : 
                decalType += "_u";
                break;
            case DOWN : 
                decalType += "_d";
                break;
           case RIGHT : 
                decalType += "_r";
                break;
            case LEFT : 
                decalType += "_l";
                break;
        }

        image = ResourceManager.getImage(decalType);
        size.set(Globals.TILE_SIZE, Globals.TILE_SIZE); //tile size, or we'll weirdly stick out or clip through
        anchored = true;
    }
}