class Atom {
  int atomX, atomY;

  void process(){
    
  }
  void move(int x, int y){ //amount of pixels we move
    atomX += x;
    atomY += y;
  }
}
