public class AnimatedImage{

  PImage[] frames;
  float frameDelay, objectWidth;
  PVector drawPosition;
  boolean flipSpriteHorizontal;

  public AnimatedImage(PImage[] frames, float frameDelay, PVector drawPosition, float objectWidth, boolean flipSpriteHorizontal){
    this.frames = frames;
    this.objectWidth = objectWidth;
    this.frameDelay = frameDelay;
    this.drawPosition = drawPosition;
    this.flipSpriteHorizontal = flipSpriteHorizontal;
  }

  public void draw(){
    pushMatrix();

    translate(drawPosition.x, drawPosition.y);

    if(flipSpriteHorizontal){
      scale(-1, 1);
      image(frames[frameCount / round(frameDelay) % frames.length], -objectWidth, 0);
    }else{
      image(frames[frameCount / round(frameDelay) % frames.length], 0, 0);
    }

    popMatrix();
  }
}
