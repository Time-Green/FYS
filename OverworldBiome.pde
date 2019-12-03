class OverworldBiome extends Biome{

    OverworldBiome(){
        length = 10;
        destroyedImage = ResourceManager.getImage("Invisible");
    }

    Tile getTileToGenerate(int x, int depth){
        return new AirTile(x, depth);
    }

}