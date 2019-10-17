boolean[] keys = new boolean[128];

void keyPressed() {

  if (keyCode > keys.length) {
    return;
  }

  keys[keyCode] = true;
}

void keyReleased() {

  if (keyCode > keys.length) {
    return;
  }

  keys[keyCode] = false;
}
