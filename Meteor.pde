public class Meteor{

final int MIN_METEOR_SIZE = 10;  
final int MAX_METEOR_SIZE = 80;  
PVector position = new PVector(); 

Meteor(){
   
}

void update(){
  ellipseMode(CENTER);
  ellipse(100, 100, random(MIN_METEOR_SIZE, MAX_METEOR_SIZE), random(MIN_METEOR_SIZE, MAX_METEOR_SIZE)); 
}

}
