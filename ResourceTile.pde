public class ResourceTile extends Tile{

	int value;
	int pickUpDropAmountValue = 1;
	PImage pickUpImage;

	public ResourceTile(int x, int y){
		super(x, y);
	}

	void mine(){
		super.mine();
		//for (int i = 0; i < pickUpDropAmountValue; i++) {
		//    load(new ScorePickUp(new PVector(position.x + 10 + random(size.x - 60), position.y + 10 + random(size.y - 60)), this));
		//}
	}

}
