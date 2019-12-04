class NormalBiome extends Biome{ //the default biome, almost identical to the Biome class itself

    NormalBiome(){
        structureChance = 0.00;
    }

    void placeStructure(int depth){
        if(random(1) < .5) { //50% chance to insert a special big dungeon
            world.safeSpawnStructure(("Dungeon1"), new PVector(int(random(40)), depth));
            return;
        }

        super.placeStructure(depth);
    }
}