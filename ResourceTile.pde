public class ResourceTile extends Tile{

    int value;

    public ResourceTile(int x, int y){
        super(x, y);
    }

    void giveScoreToPlayer(){
        player.addScore(value);
    }

    void mine(){
        super.mine();
        giveScoreToPlayer();
    }

}
