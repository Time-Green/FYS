class icicle extends Obstacle {
    
    private int damage = 10;
    private int radiusX = 1;
    private int radiusY = 10;



  //Icicle() {
   // size.set(10, 50);
   // image = ResourceManager.getImage("Icicle");
   // anchored = true;
  //}

  void pushed(Mob mob, PVector otherPosition) {

    if (otherPosition.y > 0) { 
      mob.takeDamage(1f);
    }
  }

  void spawn() {
      //icicle's only spawn in the ice biome and always spawns in caves at the ceiling.
  }

  void react() {

      //if the player walks under the icile this would react and fall down we need to add gravity 
      //the fallspeed and activation radius it should look down about 10 blocks and it may differ +1 -1 
      //from xplayer.

  }

  void delete() {
     //delete the icicle after it has been fallen.
  }
}