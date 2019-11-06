public class PowerUpTile extends Tile{

public PowerUpTile(int x, int y){

    super(x, y); 
    image = ResourceManager.getImage("MysteryBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
}

void pickUp(){


}

void mine(){
    
    super.mine();

}
}