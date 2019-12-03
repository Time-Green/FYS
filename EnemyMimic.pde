class EnemyMimic extends Enemy {

  EnemyMimic(PVector spawnPos){
    super(spawnPos);

    image = ResourceManager.getImage("MimicEnemy");
  }

}
