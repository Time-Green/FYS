public class MimicTile extends Tile{

    private boolean hasSpawnedMimic;

    public MimicTile(int x, int y){
        super(x, y); 

        image = ResourceManager.getImage("MimicTile");
        breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
    }

    void mine(boolean playMineSound){
        super.mine(playMineSound);

        if(hasSpawnedMimic){
            return;
        }
        
        hasSpawnedMimic = true;
        
        load(new EnemyMimic(new PVector(this.position.x, this.position.y)));
        // delete(this);
    }

}