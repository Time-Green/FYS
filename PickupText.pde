public class PickupText extends BaseObject {

  PVector velocity;
  private int score, scoreDisplay;
  private float lifeTime = 0;

  private color fromColor = color(#0070dd);
  private color toColor = color(#ff8000);

  public PickupText(int scoreToDraw, PVector currentPos) {        
    score = scoreToDraw;
    scoreDisplay = score / 2;
    position.set(currentPos);
    velocity = new PVector(random(-2, 2), random(-1, -0.5));
  }

  void draw() {

    position.add(velocity);
    handleScore();

    textAlign(CENTER);
    textSize(20 + (scoreDisplay / 100));

    color displayColor = lerpColor(fromColor, toColor, float(scoreDisplay) / float(score));
    fill(displayColor);

    //Draw the score text
    text("+" + scoreDisplay, position.x, position.y);

    lifeTime++;

    if (lifeTime > 180){
      delete(this);
    }
  }

  private void handleScore(){
		if(scoreDisplay < score){

			int scoreToAdd = round((score - scoreDisplay) / 10);

			if(scoreToAdd == 0){
				scoreToAdd++;
			}

			scoreDisplay += scoreToAdd;

			if(scoreDisplay > score){
				scoreDisplay = score;
			}
		}
	}
} 