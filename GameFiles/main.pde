/**
* Main class for the game.
* Used for drawing the game and controlling most of the game logic.
* @author Julius Jauga 5 gr.
*/
import ddf.minim.*;
Minim minim;
AudioPlayer lose, coin, jump, land;
Player player;

//Image variables
PImage[] subimage_array;
PImage[] runLeft = new PImage[6];
PImage[] runRight = new PImage[6];
PImage[] idle = new PImage[6];
PImage[] jumpLeft = new PImage[6];
PImage[] jumpRight = new PImage[6];
PImage[] climbRight = new PImage[6];
PImage[] climbLeft = new PImage[6];
PImage tileImage;
PImage background;
PImage subimage;
PImage leftRunSource;
PImage rightRunSource;
PImage idleSource;
PImage jumpRightSource;
PImage jumpLeftSource;
PImage climbRightSource;
PImage climbLeftSource;

//JSON variables
JSONObject jsonMap;
JSONArray layers;
JSONArray jsonArray;
JSONArray jsonArray2;
JSONObject layer;
JSONObject layer2;

//Map coordinates
int translateX = 0;
int translateY = 0;

//Control keys
boolean keyAPressed = false;
boolean keyDPressed = false;
boolean spacePressed = false;

//Game information
int tileSize = 16;
int resize = 64;
int currentLevel = 1;
int airTile = 143;
int spikeTile = 133;
int coinTile = 17;
int coinCount;
int mapHeight;
int mapWidth;
int sheetWidth;
int sheetHeight;

//Player Attributes
int gravity = 1;
int playerSpeedCap = 20;
int jumpStrength = 18;
int acceleration = 2;
int terminalVelocity = 70;
int startTime;
int elapsedTime;

int temp;
/**
* Setup method for main. Loads all the images, sounds and sets up the arrays.
*/
void setup() {
  size(1280, 1080);
  player = new Player();
  reset_game();
  tileImage = loadImage("map_source\\test_shee.png");
  background = loadImage("map_source\\background.jpg");
  leftRunSource = loadImage("Animations\\RUN_LEFT.png");
  rightRunSource = loadImage("Animations\\RUN_RIGHT.png");
  idleSource = loadImage("Animations\\IDLE.png");
  jumpLeftSource = loadImage("Animations\\JUMP_LEFT.png");
  jumpRightSource = loadImage("Animations\\JUMP_RIGHT.png");
  climbRightSource = loadImage("Animations\\CLIMB_RIGHT.png");
  climbLeftSource = loadImage("Animations\\CLIMB_LEFT.png");
  sheetHeight = tileImage.height / tileSize;
  sheetWidth = tileImage.width / tileSize;
  subimage_array = new PImage[sheetHeight * sheetWidth];
  for(int i = 0; i < sheetHeight; i++) {
    for(int j = 0; j < sheetWidth; j++) {
      subimage_array[i*sheetWidth+j] = tileImage.get(j * tileSize, i * tileSize, tileSize, tileSize);
      subimage_array[i*sheetWidth+j].resize(resize, resize);
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
  lose = minim.loadFile("GameMusic/lose.mp3");
  land = minim.loadFile("GameMusic/land.mp3");
  jump = minim.loadFile("GameMusic/jump.wav");
  coin = minim.loadFile("GameMusic/coin.mp3");
}

/**
* Draw method for main, calls all the needed methods for game. Sets up the timer which is needed for player animations.
*/
void draw() {
  timer(600);
  image(background, translateX / 6 - width/ 4, translateY / 6);
  translate(translateX, translateY);
  drawMapArray();
  display_game_status();
  player.display();
  player.update();
}

/**
* Checks for pressed keys for controls of the game
* A, or LEFT_ARROW - player goes left.
* D, or RIGHT_ARROW - player goes right.
* SPACE - player jumps.
* E - next level.
* Q - previous level.
* R - reset level.
*/
void keyPressed() {
  if (key == 32) {
    player.onAir = true;
  }
  if (key == 'a' || key == 'A' || keyCode == LEFT) {
    player.goingLeft = true;
  }
  if ((key == 'd' || key == 'D') || keyCode == RIGHT) {
    player.goingRight = true;
  }
  if (key == 'E' || key == 'e') {
    if (loadJSONObject("Levels\\level" + str(currentLevel + 1) + ".json") != null) {
      currentLevel++;
      reset_game();
    }
    reset_game();
  }
  if (key == 'Q' || key == 'q') {
    if (currentLevel > 1) {
      currentLevel--;
    } 
    reset_game();
  }
  if (key == 'r' || key == 'R') {
    reset_game();
  }
}
/**
* Checks for the key releases.
*/
void keyReleased() {
  if (key == 'a' || key == 'A' || keyCode == LEFT) {
    player.goingLeft = false;
    player.playerSpeedX = 0;
  }
  if (key == 'd' || key == 'D' || keyCode == RIGHT) {
    player.goingRight = false;
    player.playerSpeedX = 0;
  }
  if (key == 32) {
    player.onAir = false;
  }
}
/**
* Draws the current map from the JSON file.
*/
void drawMapArray() {
  for(int i = 0; i < mapHeight; i++) {
    for(int j = 0; j < mapWidth; j++) {
      temp = jsonArray2.getInt(i*mapWidth + j);
      image(subimage_array[temp], j*resize, i*resize);
    }
  }
  for(int i = 0; i < mapHeight; i++) {
    for(int j = 0; j < mapWidth; j++) {
      temp = jsonArray.getInt(i*mapWidth + j);
      image(subimage_array[temp], j*resize, i*resize);
    }
  }
  
}
/**
* Resets the current level, reseting the coins and player coordinates.
*/
void reset_game() {
  coinCount = 0;
  player.reset();
  jsonMap = loadJSONObject("Levels\\level" + str(currentLevel) +  ".json");
  layers = jsonMap.getJSONArray("layers");
  layer = layers.getJSONObject(1);
  layer2 = layers.getJSONObject(0);
  jsonArray = layer.getJSONArray("data");
  jsonArray2 = layer2.getJSONArray("data");
  mapWidth = jsonMap.getInt("width");
  mapHeight = jsonMap.getInt("height");
  for(int i = 0; i < mapHeight; i++) {
    for(int j = 0; j < mapWidth; j++) {
      if (jsonArray.getInt(i*mapWidth + j) == coinTile) {
        coinCount++;
      }
    }
  }
  translateY = resize;
  translateX = 0;
}
/**
* Timer method to check the time needed for animation frames.
* @param int miliseconds - time when the timer needs to reset.
*/
void timer(int miliseconds) {
  elapsedTime = millis() - startTime;
  if (elapsedTime >= miliseconds) {
    startTime = millis();
  }
}
/**
* Displays game status, the coins left and the current level for the player.
*/
void display_game_status() {
  textSize(30);
  fill(#D3D654, 100);
  rect(-translateX, -translateY , 195, 50, 100);
  fill(#54D6AC, 100);
  rect(-translateX + 195, -translateY , 195, 50, 100);
  fill(#050500);
  text("COINS LEFT " + coinCount, -translateX + 5, -translateY + resize/2 + 5);
  text("LEVEL " + str(currentLevel), -translateX + 245, -translateY + resize/2 + 5);
  textSize(10);
}
