class Atom {
  PVector position = new PVector(100, 300);
  PVector size = new PVector(40, 40);

  void process(){
    draw();
  }

  void draw(){
    rect(position.x, position.y, size.x, size.y); 
  }

  void move(int x, int y){ //amount of pixels we move
    position.x += x;
    position.y += y;
  }
}
