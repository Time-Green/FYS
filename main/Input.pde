void checkKeys(){
  if(keyCode ==  LEFT ){
    user.move(-5,0); 
  } else if(keyCode == RIGHT){
    user.move(5,0);
  } else if(keyCode == UP){
    user.move(0,-5);
  } else if(keyCode == DOWN){
    user.move(0,5);
  }
}

void keyReleased(){
  keyCode = 0;
  key = 0;
}
