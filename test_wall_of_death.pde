float x1; // rectangle the wall of death
int rectY;
float x2 = 1920;   
float y2 = 100;


float sx;     // Player
float sy; 
float sw = 100;    // and size
float sh = 100;


void setupWall() {
  size(1920, 1080);
  sx = width/2;    // Player
  sy = height/2;
  x1 = width/2; 


  strokeWeight(5);  // make the line easier to see
}


void drawWall() {
  background(255);
  rectY++;
  // check if line has hit the square
  // if so, change the fill color
  boolean hit = lineRect(x1, rectY, x2, y2, sx, sy, sw, sh);
  if (hit) fill(255, 150, 0);
  else fill(0, 150, 255);
  noStroke();
  rectMode(CENTER);
  rect(sx, sy, sw, sh);    

  //Wall of death
  rectMode(CENTER);
  fill(100, 100, 100, 100);
  rect(x1, rectY, x2, y2);
}



// LINE/RECTANGLE
boolean lineRect(float x1, int rectY, float x2, float y2, float rx, float ry, float rw, float rh) {

  // check if the line has hit any of the rectangle's sides
  // uses the Line/Line function below
  boolean left =   lineLine(x1, rectY, x2, y2, rx, ry, rx, ry+rh);
  boolean right =  lineLine(x1, rectY, x2, y2, rx+rw, ry, rx+rw, ry+rh);
  boolean top =    lineLine(x1, rectY, x2, y2, rx, ry, rx+rw, ry);
  boolean bottom = lineLine(x1, rectY, x2, y2, rx, ry+rh, rx+rw, ry+rh);

  // if ANY of the above are true, the line
  // has hit the rectangle
  if (left || right || top || bottom) {
    return true;
  }
  return false;
}


// LINE/LINE
boolean lineLine(float x1, float rectY, float x2, float y2, float x3, float y3, float x4, float y4) {

  // calculate the direction of the lines
  float uA = ((x4-x3)*(rectY-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-rectY));
  float uB = ((x2-x1)*(rectY-y3) - (y2-rectY)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-rectY));

  // if uA and uB are between 0-1, lines are colliding
  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {

    return true;
  }
  return false;
}
