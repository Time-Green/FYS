public class AnimatedImage{

  PImage[] frames;
  float frameDelay;
  PVector drawPosition;

  public AnimatedImage(PImage[] frames, float frameDelay, PVector drawPosition){
    this.frames = frames;
    this.frameDelay = frameDelay;
    this.drawPosition = drawPosition;
  }

  public void draw(){
    image(frames[frameCount / round(frameDelay) % frames.length], drawPosition.x, drawPosition.y);
  }
}
