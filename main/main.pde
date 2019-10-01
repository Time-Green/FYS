ArrayList<Atom> atomList = new ArrayList<Atom>();
ArrayList<Tile> tileList = new ArrayList<Tile>();

void setup(){
  fullScreen(P2D);
  background(255,255,255);
  
  atomList.add(new Player());
}

void draw(){
  for(Atom atom : atomList){
    atom.process();
  }
  for(Tile tile : tileList){
    tile.process();
  }
}
