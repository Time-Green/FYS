class Icicle extends Obstacle {
    
    private float damage = 10f;
    private int radiusX = 1;
    private int radiusY = 10;
    private String shatterNoise = "GlassBreak" + floor(random(1, 4));


  Icicle() {
    anchored = true;
    
    image = ResourceManager.getImage("Icicle");
  }

  void collidedWith(BaseObject object){

    if(object.position.y > position.y){ //we're beneath
      object.takeDamage(damage);
      shatter();
    }
  }

  void shatter(){
    
    AudioManager.playSoundEffect(shatterNoise);

    delete(this);
  }

  void update(){

    super.update();

    if(player.position.x < position.x + size.x && player.position.x > position.x){
      println("iets");
      if(player.position.y > position.y){
        println("iets2");

        anchored = false;
      }

    }
  }

}