ArrayList<Atom> atomList = new ArrayList<Atom>();
ArrayList<Tile> tileList = new ArrayList<Tile>();

int s

void setup(){
  fullScreen(P2D);
  background(255,255,255);
  tileList.add(new Tile());
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
