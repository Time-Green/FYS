class DungeonBlock0 extends Tile{

    DungeonBlock0(int x, int y){
        super(x, y);
        image = ResourceManager.getImage("DungeonBlock0");

        density = true;

        //setMaxHp(99999);
    }
}

class DungeonBlock1 extends Tile{

    DungeonBlock1(int x, int y){
        super(x, y);
        image = ResourceManager.getImage("DungeonBlock1");

        density = true;

        //setMaxHp(99999);
    }
}

class DungeonBlock2 extends Tile{

    DungeonBlock2(int x, int y){
        super(x, y);
        image = ResourceManager.getImage("DungeonBlock2");

        density = true;

        //setMaxHp(99999);
    }
}

class DungeonStairL extends Tile{

    DungeonStairL(int x, int y){
        super(x, y);
        image = ResourceManager.getImage("DungeonStairL");
        //setMaxHp(99999);
    }
}

class DungeonStairR extends Tile{

    DungeonStairR(int x, int y){
        super(x, y);
        image = ResourceManager.getImage("DungeonStairR");
        //setMaxHp(99999);
    }
}

class Art0 extends Obstacle{

    Art0(){
        anchored = true;
        image = ResourceManager.getImage("Art0");
    }
}

class Art1 extends Obstacle{

    Art1(){
        anchored = true;
        image = ResourceManager.getImage("Art1");
    }
}

class Banner extends Obstacle{

    Banner(){
        anchored = true;
        image = ResourceManager.getImage("Banner");
    }
}

class ChairL extends Obstacle{

    ChairL(){
        anchored = true;
        image = ResourceManager.getImage("ChairL");
    }
}

class ChairR extends Obstacle{

    ChairR(){
        anchored = true;
        image = ResourceManager.getImage("ChairR");
    }
}

class Table extends Obstacle{

    Table(){
        anchored = true;
        image = ResourceManager.getImage("Table");
    }
}

class Shelf0 extends Obstacle{

    Shelf0(){
        anchored = true;
        image = ResourceManager.getImage("Table");
    }
}

class Shelf1 extends Obstacle{

    Shelf1(){
        anchored = true;
        image = ResourceManager.getImage("Table");
    }
}

class Skull extends Obstacle{

    Skull(){
        anchored = true;
        image = ResourceManager.getImage("Skull");
    }
}

class SkullTorch extends Obstacle{

    SkullTorch(){
        anchored = true;
        image = ResourceManager.getImage("SkullTorch");
    }
}