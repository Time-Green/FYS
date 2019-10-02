import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FYS extends PApplet {

ArrayList<Atom> atomList = new ArrayList<Atom>();
ArrayList<Tile> tileList = new ArrayList<Tile>();
ArrayList<ArrayList<Tile>> map = new ArrayList<ArrayList<Tile>>();//2d lijst met x, y en Tile. 

Mob user;

int tilesHorizontal = 50;
int tilesVertical = 50;
int tileWidth = 50;
int tileHeight = 50;

int safeZone = 10;

public void setup() {
  
  tileList.add(new Tile(100, 100));

  Mob player = new Player();
  atomList.add(player);
  user = player;

  generateTiles();
}

public void draw() {
  background(255, 255, 255);
  translate(-user.atomX+width*0.5f-user.atomWidth/2, -user.atomY+height*0.5f);
  for (Tile tile : tileList) {
    tile.process();
  }
  for (Atom atom : atomList) {
    atom.process();
  }
}

public Tile getTile(int x, int y){ //geeft je de tile waar je op zit. 
  ArrayList<Tile> subList = map.get(x / tileWidth);
  return subList.get(y / tileHeight);
}
boolean[] keys = new boolean[128];
public void keyPressed(){
  if(keyCode > keys.length){
    return;
  }
  keys[keyCode] = true;
  
}

public void keyReleased(){
  if(keyCode > keys.length){
    return;
  }
  keys[keyCode] = false;
}
class Atom {
  int atomX = 100, atomY = 300;
  int atomWidth = 40;
  int atomHeight = 40;

  public void process(){
    draw();
  }
  public void draw(){
    rect(atomX, atomY, atomWidth, atomHeight); 
  }
  public void move(int x, int y){ //amount of pixels we move
    atomX += x;
    atomY += y;
  }
}
class Mob extends Atom{
  
}
class Player extends Mob{
  public void process(){
    super.process();
    if(keys[LEFT]){
      user.atomX--;
    }
    if(keys[UP]){
      user.atomY--;
    }
     if(keys[DOWN]){
      user.atomY++;
    }
    if(keys[RIGHT]){
      user.atomX++;
    }
  }
}
class Tile {
  int tileX;
  int tileY;
  
  int tileXWhole, tileYWhole; //zelfde als tileX en tileY, maar in plaats van pixels complete tiles
  
  boolean tileDestroy;
  boolean density = true;
  
  ArrayList<Atom> contents = new ArrayList<Atom>(); //alle Atom's die op die tile staan
  
  Tile(int x , int y){
    tileX = x * tileWidth;
    tileY = y * tileHeight;
    
    tileXWhole = x;
    tileYWhole = y;
  }
  
  public void process(){
    draw();
  }
  public void draw(){
    rect(tileX,tileY,tileWidth,tileHeight);
  }
}

class openTile extends Tile{
  
  openTile(int x, int y){
    super(x, y);
    density = false;
  }
  public void draw(){
    return;
  }
}
public void generateTiles(){  
  for(int iY = 0; iY < tilesVertical; iY++){
    ArrayList<Tile> subArray = new ArrayList<Tile>(); //maak een lijst voor tile's
    map.add(subArray); //voeg de lege lijst voor tiles toe aan de grote lijst. we vullen hem een paar lijnen verder
    for(int iX = 0; iX < tilesHorizontal; iX++){
      Tile tile;
      if(iY > safeZone){ //tijdelijk voor een soort van open lucht gebied
        tile = new Tile(iX, iY);
      }
      else{
        tile = new openTile(iX, iY);
      }
      subArray.add(tile); 
      tileList.add(tile);
    }
  }
}

  public void settings() {  fullScreen(P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "FYS" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
