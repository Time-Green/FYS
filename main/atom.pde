class Atom {
  int atomX = 100, atomY = 300;
  int atomWidth = 40;
  int atomHeight = 40;

  void process(){
    draw();
  }
  void draw(){
    rect(atomX, atomY, atomWidth, atomHeight); 
  }
  void move(int x, int y){ //amount of pixels we move
    atomX += x;
    atomY += y;
  }
}
