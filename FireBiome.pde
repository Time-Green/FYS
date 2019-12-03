class FireBiome extends Biome{

    FireBiome(){
        structureChance = 0.1;
        caveSpawningPossibilityScale = 0.51f;
        destroyedImage = ResourceManager.getImage("DestroyedVulcanic");
    }

    Tile getTileToGenerate(int x, int depth){
        float oreChance = 0.01;
        if(random(1) < oreChance){
            return new EmeraldTile(x, depth);
        }
        else{
            return new VulcanicTile(x, depth);
        }
    }

    String getStructureName(){
        return "MagmaRock" + int(random(3));

    }
}