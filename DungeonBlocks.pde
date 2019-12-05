

class DungeonBlock0 extends Tile{

    DungeonBlock0(int x, int y){
        super(x, y);
        image = ResourceManager.getImage("DungeonBlock0");
        density = true;
        setMaxHp(100);
    }

    boolean canMine() {
    return false;
    }
}

class DungeonBlock1 extends Tile{

    DungeonBlock1(int x, int y){
        super(x, y);
        image = ResourceManager.getImage("DungeonBlock1");
        density = true;
        setMaxHp(100);
    }
    boolean canMine() {
    return false;
    }
}

class DungeonBlock2 extends Tile{

    DungeonBlock2(int x, int y){
        super(x, y);
        image = ResourceManager.getImage("DungeonBlock2");
        density = false;
        setMaxHp(100);
    }
    boolean canMine() {
    return false;
    }
}

class DungeonStairL extends Tile{

    DungeonStairL(int x, int y){
        super(x, y);
        image = ResourceManager.getImage("DungeonStairL");
        setMaxHp(100);
    }
    boolean canMine() {
    return false;
    }
}

class DungeonStairR extends Tile{

    DungeonStairR(int x, int y){
        super(x, y);
        image = ResourceManager.getImage("DungeonStairR");
        setMaxHp(100);
    }
    boolean canMine() {
    return false;
    }
}

class Art0 extends Obstacle{

    Art0(){
        anchored = true;
        image = ResourceManager.getImage("Art0");
        size.set(100, 50);
        density = false;
    }
}

class Art1 extends Obstacle{

    Art1(){
        anchored = true;
        image = ResourceManager.getImage("Art1");
        density = false;
    }
}

class Banner extends Obstacle{

    Banner(){
        anchored = true;
        image = ResourceManager.getImage("Banner");
        size.set(50, 100);
        density = false;
    }
}

class ChairL extends Obstacle{

    ChairL(){
        image = ResourceManager.getImage("ChairL");
        density = false;
    }
}

class ChairR extends Obstacle{

    ChairR(){
        image = ResourceManager.getImage("ChairR");
        density = false;
    }
}

class Table extends Obstacle{

    Table(){
        image = ResourceManager.getImage("Table");
        size.set(100, 50);
        density = false;
    }
}

class Shelf0 extends Obstacle{

    Shelf0(){
        anchored = true;
        image = ResourceManager.getImage("Shelf0");
        density = false;
    }
}

class Shelf1 extends Obstacle{

    Shelf1(){
        anchored = true;
        image = ResourceManager.getImage("Shelf1");
        density = false;
        
    }
}

class Skull extends Obstacle{

    Skull(){
        image = ResourceManager.getImage("Skull");
        size.set(20,20);
        density = false;
    }
}

class SkullTorch extends Obstacle{

    SkullTorch(){
        image = ResourceManager.getImage("SkullTorch");
        size.set(20,20);
        density = false;
    }
}

class Cobweb extends Obstacle{

    Cobweb(){
        anchored = true;
        image = ResourceManager.getImage("Cobweb");
        density = false;
        
    }
}