import processing.sound.*;
import ddf.minim.*;
Minim minim, minim2;
AudioPlayer lose, coin, jump, land;
//SoundFile lose;
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
JSONObject jsonMap;
JSONArray layers;
JSONArray jsonArray;
JSONObject layer;

boolean notAir = true;
int translateX;
int translateY;
int playerSpeedY;
int playerSpeedX;
int belowPlayerTile;
boolean keyAPressed = false;
boolean keyDPressed = false;
boolean spacePressed = false;

int airTile = 143;
int spikeTile = 133;
int coinTile = 17;
// Attributes
int gravity = 1;
int playerSpeedCap = 20;
int jumpStrength = 18;
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
PImage icon;
void setup() {
  size(1280,640);
  frameRate(60);
  ok = new Player();
  reset_game();
  myImage = loadImage("map_source\\test_shee.png");
  background = loadImage("map_source\\background.jpg");
  leftRunSource = loadImage("Animations\\RUN_LEFT.png");
  rightRunSource = loadImage("Animations\\RUN_RIGHT.png");
  idleSource = loadImage("Animations\\IDLE.png");
  jumpLeftSource = loadImage("Animations\\JUMP_LEFT.png");
  jumpRightSource = loadImage("Animations\\JUMP_RIGHT.png");
  climbRightSource = loadImage("Animations\\CLIMB_RIGHT.png");
  climbLeftSource = loadImage("Animations\\CLIMB_LEFT.png");
  background.resize(width,0);
  sheetHeight = myImage.height / tileSize;
  sheetWidth = myImage.width / tileSize;
  subimage_array = new PImage[sheetHeight * sheetWidth];
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
  minim = new Minim(this);
  minim2 = new Minim(this);
  lose = minim.loadFile("GameMusic/lose.mp3");
  land = minim.loadFile("GameMusic/land.mp3");
  jump = minim.loadFile("GameMusic/jump.wav");
  coin = minim2.loadFile("GameMusic/coin.mp3");
  //AudioPlayer tate = minim.loadFile("tate.mp3");
  //tate.play();
}
void draw() {
  elapsedTime = millis() - startTime;
  if (elapsedTime >= 600) {
    startTime = millis();
  }
  image(background, 0 ,0);
  text(mouseX + " : " + mouseY, 400, 200);
  text("Player speed Y: " + playerSpeedY, 400, 300);
  text("Player speed X: " + playerSpeedX, 400, 400);
  translate(translateX, translateY);
  DrawMapArray();
  ok.display();
  ok.update();
}
void keyPressed() {
  if (key == 32) {
    ok.onAir = true;
  }
  if (key == 'a' || key == 'A' || keyCode == LEFT) {
    ok.goingLeft = true;
  }
  if ((key == 'd' || key == 'D') || keyCode == RIGHT) {
    ok.goingRight = true;
  }
}
void keyReleased() {
  if (key == 'a' || key == 'A' || keyCode == LEFT) {
    ok.goingLeft = false;
    playerSpeedX = 0;
    keyAPressed = false;
  }
  if (key == 'd' || key == 'D' || keyCode == RIGHT) {
    ok.goingRight = false;
    playerSpeedX = 0;
  }
  if (key == 32) {
    ok.onAir = false;
  }
  if (key == 'E' || key == 'e') {
    reset_game();
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
void reset_game() {
  ok.reset();
  jsonMap = loadJSONObject("Levels\\level2.json");
  layers = jsonMap.getJSONArray("layers");
  layer = layers.getJSONObject(0);
  jsonArray = layer.getJSONArray("data");
  mapWidth = jsonMap.getInt("width");
  mapHeight = jsonMap.getInt("height");
  translateY = 0;
  translateX = width / 2;
}
