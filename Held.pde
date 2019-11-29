class Held extends Item{
    float damageCoefficient = .9;

    boolean canMine(BaseObject object, Mob miner){ 
        return true;
    }

    void onMine(BaseObject object, Mob miner){ 
        //load(new Explosion(miner.position, 500));

        object.takeDamage(miner.getAttackPower(true));
    }

    void onUse(Mob mob){ //overwrite, because we wanna mine and not throw it against a rock. 
        return;
    }

}