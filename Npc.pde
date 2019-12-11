public class Npc extends Mob{

  private String name;
  private color nameColor = #ffa259;

  private boolean isPanicking;

  // talking
  private String currentlySayingFullText;
  private String currentlySaying;
  private boolean isTalking, isAboutToTalk;
  private int currentTextIndex = 0;
  private int currentTalkingWaitTime = 0;
  private final int MAX_TALKING_WAIT_FRAMES = 2; // max frames untill showing next character when talking
  private float maxTalkingShowTime;
  private int timeStartedTalking;
  private float timeToStartTalking;
  private PImage textBaloon;
  String[] genericTexts;
  String[] panicTexts;
  String[] personalTexts;

  private AnimatedImage walkCycle;
  private final int WALKFRAMES = 4;
  private AnimatedImage animatedImageIdle;
  private final int IDLEFRAMES = 3;

  private int lastWalkingStateChange = millis();

  private float changeWalkingDirectionChance = 0.01f;
  private float panicChangeWalkingDirectionChance = 0.05f;
  private float doJumpChance = 0.0025f;
  private float panicDoJumpChance = 0.01f;
  private float changeIsWalkingChance = 0.05f;
  private float doTalkChance = 0.001f;

  private final float MIN_TIME_INBETWEEN_WALKING_CHANGE = 3 * 1000;
  private final float MIN_X = 50;
  private final float MAX_X = 1650;
  private boolean isWalking;

  PImage[] walkFrames = new PImage[WALKFRAMES];
  PImage[] idleFrames = new PImage[IDLEFRAMES];

  public Npc(World world, String name, String[] genericTexts, String[] panicTexts, String[] personalTexts){
    
    this.name = name;
    this.genericTexts = genericTexts;
    this.panicTexts = panicTexts;
    this.personalTexts = personalTexts;
    maxTalkingShowTime = random(4000, 6000);
    textBaloon = ResourceManager.getImage("TextBaloon");
    speed = 0.25f;
    jumpForce = 12f;

    changeWalkingDirection(0.5f);
    loadFrames();
  }

  private void loadFrames(){
    for (int i = 0; i < WALKFRAMES; i++){
      walkFrames[i] = ResourceManager.getImage("PlayerWalk" + i);
    }

    walkCycle = new AnimatedImage(walkFrames, 10, position, size.x, flipSpriteHorizontal);

    for (int i = 0; i < IDLEFRAMES; i++){
      idleFrames[i] = ResourceManager.getImage("PlayerIdle" + i);
    }

    animatedImageIdle = new AnimatedImage(idleFrames, 60, position, size.x, flipSpriteHorizontal);
  }

  void update() {

    if (Globals.gamePaused) {  
      return;
    }

    super.update();

    if(Globals.currentGameState == Globals.GameState.InGame && !isPanicking){
      panic();
    }

    handleMovement();
    handleTalking();
  }

  private void panic(){
    isPanicking = true;
    speed = 0.35f;
    changeWalkingDirectionChance = panicChangeWalkingDirectionChance;
    doJumpChance = panicDoJumpChance;
    startTalking();
  }

  private void handleMovement(){
    
    changeIsWalking(changeIsWalkingChance);

    borderCheck();

    if(isWalking){
      addForce(new PVector(speed, 0));
    }

    changeWalkingDirection(changeWalkingDirectionChance);
    
    //chance to jump walking direction
    boolean doJump = random(1f) <= doJumpChance;

    if (doJump && isGrounded()){
      addForce(new PVector(0, -jumpForce));
    }
  }

  private void handleTalking(){

    if(isTalking){

      if(millis() < timeToStartTalking){
        return;
      }

      //stop talking after 5 seconds
      if(millis() - timeStartedTalking > maxTalkingShowTime){
        isTalking = false;
        return;
      }

      if(currentTalkingWaitTime < MAX_TALKING_WAIT_FRAMES){
        currentTalkingWaitTime++;
        return;
      }else{
        currentTalkingWaitTime = 0;
      }

      if(currentTextIndex < currentlySayingFullText.length()){
        currentTextIndex++;
        currentlySaying = currentlySayingFullText.substring(0, currentTextIndex);
      }
    }else if(!isPanicking){

      //chance to start talking when not panicking
      boolean doTalk = random(1f) <= doTalkChance;

      if (doTalk){
        startTalking();
      }
    }
  }

  private void startTalking(){
    timeToStartTalking = millis() + random(1500);
    timeStartedTalking = millis();
    currentTextIndex = 0;
    currentTalkingWaitTime = 0;
    currentlySayingFullText = getTextToSay();
    currentlySaying = "";
    isTalking = true;
  }

  private String getTextToSay(){

    if(isPanicking){
      return panicTexts[floor(random(panicTexts.length))];
    }else{
      if(random(1) <= 0.5f){ // random personal text
        return personalTexts[floor(random(personalTexts.length))];
      }else{ // random generic text
        return genericTexts[floor(random(genericTexts.length))];
      }
    }
  }

  private void borderCheck(){

    if(position.x <= MIN_X){
      velocity.x = 0;
      changeWalkingDirection(1f);
      position.x = MIN_X + 5;
    }else if(position.x >= MAX_X){
      velocity.x = 0;
      changeWalkingDirection(1f);
      position.x = MAX_X - 5;
    }
  }

  private void changeIsWalking(float chance){

    if(isPanicking){
      isWalking = true;
      return;
    }

    if(millis() - lastWalkingStateChange < MIN_TIME_INBETWEEN_WALKING_CHANGE){
      //it was to soon we started/stopped walking, dont do anything
      return;
    }

    //chance to change walking direction
    boolean doChangeIsWalking = random(1f) <= chance;

    if(doChangeIsWalking){
      isWalking = !isWalking;
    }
  }

  private void changeWalkingDirection(float chance){

    //chance to change walking direction
    boolean doChangeWalkingDirection = random(1f) <= chance;

    if(doChangeWalkingDirection){
      speed *= -1;
    }
  }

  void draw() {

    if (Globals.gamePaused) {
      return;
    }

    if (abs(velocity.x) > 0.1f && isGrounded()) {//Walking
      walkCycle.flipSpriteHorizontal = velocity.x >= 0;
      walkCycle.draw();
    }else {//Idle
      animatedImageIdle.flipSpriteHorizontal = velocity.x >= 0;
      animatedImageIdle.draw();
    }

    textAlign(CENTER);
    textSize(10);

    drawName();

    if(isTalking && millis() > timeToStartTalking){
      drawTalking();
    }

    textAlign(LEFT);
  }

  private void drawName(){
    fill(nameColor);
    text(name, position.x + size.x / 2, position.y - 5);
  }

  private void drawTalking(){
    fill(0);
    image(textBaloon, position.x + 15, position.y - 25 - textBaloon.height / 1.5f, textBaloon.width / 1.5f, textBaloon.height / 1.5f);
    text(currentlySaying, position.x + 55, position.y - 100, textBaloon.width / 1.5f - 75, textBaloon.height / 1.5f);
  }

  void takeDamage(float damageTaken) {
    super.takeDamage(damageTaken);

    AudioManager.playSoundEffect("HurtSound", position);
    delete(this);
  }
}
