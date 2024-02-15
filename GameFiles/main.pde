import processing.sound.*;
SoundFile file;
PImage myImage;
PImage background;
PImage subimage;
PImage[] runLeft = new PImage[6];
PImage[] runRight = new PImage[6];
PImage[] idle = new PImage[6];
PImage[] jumpLeft = new PImage[6];
PImage[] jumpRight = new PImage[6];
PImage[] climbRight = new PImage[6];
PImage[] climbLeft = new PImage[6];
PImage leftRunSource;
PImage rightRunSource;
PImage idleSource;
PImage jumpRightSource;
PImage jumpLeftSource;
PImage climbRightSource;
PImage climbLeftSource;
int tileSize = 16;
int resize = 64;
int mapHeight;
int mapWidth;
int sheetWidth;
int sheetHeight;
int resolutionX = 1280;
int resolutionY = 640;
JSONObject jsonMap;
JSONArray layers;
JSONArray jsonArray;
JSONObject layer;

boolean notAir = true;
int translateX;
int translateY;
int step = 64;
int playerX;
int playerY;
int playerTranslateX;
int playerTranslateY;
int playerSpeedY;
int playerSpeedX;
int belowPlayerTile;
boolean keyAPressed = false;
boolean keyDPressed = false;
boolean spacePressed = false;

int airTile = 135;
// Attributes
int gravity = 1;
int playerSpeedCap = 10;
int jumpStrength = 12;
int acceleration = 2;
int startTime;
int elapsedTime;
Player ok;

boolean goDown = true;
boolean changed = false;
boolean notLeftWall = true;
boolean notRightWall = true;
boolean ground = false;
PImage[] subimage_array;
void setup() {
  frameRate(60);
  print(resolutionX);
  size(1280,640);
  playerX = width / 2;
  playerY = height / 2;
  ok = new Player();
  //translateY;
  translateY = 0;
  translateX = width / 2;
  //translateY += 800;
  myImage = loadImage("Source\\sheet.png");
  background = loadImage("Source\\background.jpg");
  leftRunSource = loadImage("Animations\\RUN_LEFT.png");
  rightRunSource = loadImage("Animations\\RUN_RIGHT.png");
  idleSource = loadImage("Animations\\IDLE.png");
  jumpLeftSource = loadImage("Animations\\JUMP_LEFT.png");
  jumpRightSource = loadImage("Animations\\JUMP_RIGHT.png");
  climbRightSource = loadImage("Animations\\CLIMB_RIGHT.png");
  climbLeftSource = loadImage("Animations\\CLIMB_LEFT.png");
  background.resize(1280, 0);
  //subimage = myImage.get(128, 0, 16, 16);
  sheetHeight = myImage.height / tileSize;
  sheetWidth = myImage.width / tileSize;
  subimage_array = new PImage[sheetHeight * sheetWidth];
  jsonMap = loadJSONObject("map_editor\\grid_data.json");
  layers = jsonMap.getJSONArray("layers");
  layer = layers.getJSONObject(0);
  jsonArray = layer.getJSONArray("data");
  mapWidth = jsonMap.getInt("width");
  mapHeight = jsonMap.getInt("height");
  for(int i = 0; i < sheetHeight; i++) {
    for(int j = 0; j < sheetWidth; j++) {
      subimage_array[i*sheetWidth+j] = myImage.get(j * tileSize, i * tileSize, tileSize, tileSize);
    }
  }
  for(int i = 0; i < 6; i++) {
    runRight[i] = rightRunSource.get(i * 96, 0, 96, 87);
    runLeft[i] = leftRunSource.get(i * 96, 0, 96, 87);
    idle[i] = idleSource.get(i * 96, 0, 96, 87);
    jumpRight[i] = jumpRightSource.get(i * 96, 0, 96, 87);
    jumpLeft[i] = jumpLeftSource.get(i * 96, 0, 96, 87);
    climbRight[i] = climbRightSource.get(i * 96, 0, 96, 87);
    climbLeft[i] = climbLeftSource.get(i * 96, 0, 96, 87);
  }
  //file = new SoundFile(this, ".mp3");
  //file.jump(20.0);
  //file.play();
}

void draw() {
  elapsedTime = millis() - startTime;
  if (elapsedTime >= 600) {
    startTime = millis();
  }
  println(elapsedTime);
  background(150, 170, 10);
  frameRate(60);
  image(background, 0 ,0);
  text(mouseX + " : " + mouseY, 400, 200);
  text("Player speed Y: " + playerSpeedY, 400, 300);
  text("Player speed X: " + playerSpeedX, 400, 400);
  translate(translateX, translateY);
  DrawMapArray();
  playerMovement();
  fill(255, 0, 0);
  rect(playerX, playerY, 64, 64);
  ok.display();
  ok.update();
}
void keyPressed() {
  if (key == 32 && notAir) {
    spacePressed = true;
  }
  if (key == 'a' || key == 'A') {
    keyAPressed = true;
  }
  if ((key == 'd' || key == 'D') && notRightWall) {
    keyDPressed = true;
  }
}
void keyReleased() {
  if (key == 'a' || key == 'A') {
    ok.goingLeft = false;
    playerSpeedX = 0;
    keyAPressed = false;
  }
  if (key == 'd' || key == 'D') {
    ok.goingRight = false;
    playerSpeedX = 0;
    keyDPressed = false;
  }
  if (key == 32) {
    spacePressed = false;
    ok.onAir = false;
  }
}
void playerMovement() {
  if (spacePressed && notAir) {
    ok.onAir = true;
  }
  if (keyAPressed && notLeftWall) {
    ok.goingLeft = true;
  }
  if (keyDPressed && notRightWall) {
    ok.goingRight = true;
  }
}
void DrawMapArray() {
  int temp;
  for(int i = 0; i < mapHeight; i++) {
    for(int j = 0; j < mapWidth; j++) {
      temp = jsonArray.getInt(i*mapWidth + j);
      subimage_array[temp].resize(resize, resize);
      image(subimage_array[temp], j*resize, i*resize);
    }
  }
}
