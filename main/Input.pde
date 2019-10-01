void checkKeys(){
  if(keyCode ==  LEFT ){
    user.move(-5,0); 
  } else if(keyCode == RIGHT){
    user.move(5,0);
  }
}

void keyReleased(){
  keyCode = 0;
  key = 0;
}
