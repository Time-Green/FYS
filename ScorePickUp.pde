public class ScorePickUp extends PickUp {
  int score;

  // drop based on tile
  public ScorePickUp(ResourceTile tile) {
    score = tile.value / tile.pickUpDropAmountValue;
    image = tile.pickUpImage;
  }

  // independant drop
  public ScorePickUp(int scoreToGiveOnPickup, PImage image) {
    score = scoreToGiveOnPickup;
    this.image = image;
  }

  void pickedUp(Mob mob) {
    player.addScore(score);
    load(new PickupText(score, position));

    super.pickedUp(mob);
  }
}
