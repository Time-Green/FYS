import processing.core.*;

public static class CameraShaker
{
  private static PApplet game;

  private static PVector currentShakeOffset = new PVector();

  private static float maxTraumaIntensity = 1f;

  // Maximum distance in each direction the transform
  // with translate during shaking.
  private static PVector maximumShakeAmount = new PVector(20, 20);

  // Frequency of the Perlin noise function. Higher values
  // will result in faster shaking.
  private static float frequency = 15;

  // Trauma is taken to this power before
  // shaking is applied. Higher values will result in a smoother
  // falloff as trauma reduces.
  private static float traumaExponent = 1;

  // Amount of trauma per frame that is recovered.
  private static float recoverySpeed = 0.04f;

  // Value between 0 and 1 defining the current amount
  // of stress this transform is enduring.
  private static float trauma;

  private static float seed;

  //set PApplet
  public static void setup(PApplet pApplet)
  {
    game = pApplet;
  }

  public static void update()
  {
    float shake = game.pow(trauma, traumaExponent);

    currentShakeOffset = new PVector(
      maximumShakeAmount.x * (game.noise(seed, game.millis() * 1000 * frequency) * 2 - 1), 
      maximumShakeAmount.y * (game.noise(seed + 1, game.millis() * 1000 * frequency) * 2 - 1)
      ).mult(shake);

    trauma = game.constrain(trauma - recoverySpeed, 0, maxTraumaIntensity);
  }

  public static void reset() {
    trauma = 0;
    currentShakeOffset = new PVector();
  }

  public static PVector getShakeOffset() {
    return currentShakeOffset;
  }

  public static void induceStress(float stress)
  {
    seed = game.random(1);
    trauma = game.constrain(trauma + stress, 0, maxTraumaIntensity);
  }

  public static void setTrauma(float traumaToSet)
  {
    trauma = game.constrain(traumaToSet, 0, maxTraumaIntensity);
  }
}
