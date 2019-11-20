public class PickUp extends Movable{

  boolean canTake = true; //in-case we need an override to stop people picking stuff up, like thrown dynamite

  PickUp(){
    size.set(30, 30);
  }
  void draw(){
    super.draw();
  }

  void update(){
    super.update();
  }

  void pickedUp(Mob mob){
    delete(this);
  }

  boolean canCollideWith(BaseObject object){

    if(object instanceof Mob){
      Mob mob = (Mob) object;

      if(canTake && mob.canPickUp(this)){ //maybe replace with canPickUp?
        pickedUp(mob);

        return false;
      }
    }

    if(object instanceof PickUp){
      return false;
    }

    return super.canCollideWith(object);
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}
