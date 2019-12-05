public class ExplosionParticle extends BaseParticle {

  float sizeDegrade;

  final color YELLOWCOLOR = color(#F6F052);
  final color REDCOLOR = color(#7C0A02);

  public ExplosionParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc) {
    super(parentParticleSystem, spawnLocation, spawnAcc);

    particleColor = lerpColor(YELLOWCOLOR, REDCOLOR, random(1));
    sizeDegrade = random(0.5, 1);
  }

  void update() {
    super.update();

    updateSize();
  }

  private void updateSize() {
    size -= sizeDegrade;

    if (size <= 0) {
      cleanup();
    }
  }
}
