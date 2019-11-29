class Held extends Item{
    float damageCoefficient = 1;

    boolean canMine(BaseObject object, Mob miner){ 
        return true;
    }

    void onMine(BaseObject object, Mob miner){ 
        //load(new Explosion(miner.position, 500));

        object.takeDamage(miner.getAttackPower(true));
    }
}