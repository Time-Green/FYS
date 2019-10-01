class Atom {
  int atomX = 100, atomY = 300;
  int atomWidth = 100;
  int atomHeight = 20;

  void process(){
    rect(atomX, atomY, atomWidth, atomHeight); 
  }
  void move(int x, int y){ //amount of pixels we move
    atomX += x;
    atomY += y;
  }
}
