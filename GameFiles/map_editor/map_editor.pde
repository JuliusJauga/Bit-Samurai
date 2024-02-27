/**
* Class of map_editor.
* Used for making new maps for the game.
* @author Julius Jauga 5 gr.
*/


// Image variables
PImage[] subImgArr;
PImage[] othergrid;
PImage[] gridSubArr;
PImage[] grid;
PImage image;
PImage clickedImg;
PImage openedEye;
PImage closedEye;


// Map editor and grid array information variables.
String userInput = "";
int[] othergridIDArr;
int[] gridIDArr;
int clickedID;
int gridTile = 32;
int mousePosX;
int mousePosY;

//Booleans for interface logic.
boolean noCollisionLayer = false;
boolean CollisionLayer = true;
boolean seeSolid = true;
boolean seeNonSolid = true;
boolean mouseClick = false;
boolean mouseClickBool = false;
boolean TakingInput = false;


// Screen and map information variables.
int tileSize = 16;
int mapHeight;
int mapWidth;
int imageHeight;
int imageWidth;
int screenWidth;
int screenHeight;

//Button Variables
Button SaveButton;
Button LoadButton;
Button NewButton;
Button MapNameButton;
Button NoCollisionButton;
Button CollisionButton;

//JSON Variables
JSONObject json;
JSONArray dataNoSolid;
JSONArray dataSolid;
JSONObject dataObject;
JSONObject dataSolidObject;
JSONObject jsonMap;
JSONArray layers;
JSONArray jsonArray;
JSONArray jsonArray2;
JSONObject layer;
JSONObject layer2;

//Grid variables
int x;
int y;
int spacing = 32;
int mY, mX;

/**
* Setup method for main. Loading all the images, setting up arrays and buttons. No parameters.
*/
void setup() {
  size(1280, 640);
  fill(255, 0, 0);
  textSize(30);
  image = loadImage("..\\map_source\\test_shee.png");
  openedEye = loadImage("openedEye.png");
  closedEye = loadImage("closedEye.png");
  imageHeight = image.height;
  imageWidth = image.width;
  mapHeight = image.height / tileSize;
  mapWidth = image.width / tileSize;
  screenWidth = width;
  screenHeight = height;
  subImgArr = new PImage[mapHeight * mapWidth];
  gridSubArr = new PImage[mapHeight * mapWidth];
  grid = new PImage[screenWidth / gridTile * (screenHeight-imageHeight) / gridTile];
  gridIDArr = new int[screenWidth / gridTile * (screenHeight-imageHeight) / gridTile];
  othergrid = new PImage[screenWidth / gridTile * (screenHeight-imageHeight) / gridTile];
  othergridIDArr = new int[screenWidth / gridTile * (screenHeight-imageHeight) / gridTile];
  makeSubArray();
  NewMap();
  clickedImg = subImgArr[mapHeight * mapWidth - 1].get(0, 0, spacing, spacing);
  clickedID = mapHeight * mapWidth - 1;
  SaveButton = new Button(screenWidth - 500 - 2, imageHeight / 2 + 1, 250, imageHeight / 2 - 1);
  SaveButton.Text = "Save Map";
  SaveButton.SaveMapButton = true;
  NewButton = new Button(screenWidth - 250, 0, 250, imageHeight / 2 - 2);
  NewButton.Text = "New Map";
  NewButton.NewMapButton = true;
  LoadButton = new Button(screenWidth - 250, imageHeight / 2 + 1, 250,imageHeight / 2 - 1);
  LoadButton.Text = "Load Map";
  LoadButton.LoadMapButton = true;
  MapNameButton = new Button(screenWidth - 500 - 2, 0, 250, imageHeight / 2 - 2);
  MapNameButton.Text = "|";
  MapNameButton.MapNameButton = true;
  CollisionButton = new Button(screenWidth - 750 - 4, 0, 250, imageHeight / 2 - 2);
  CollisionButton.Text = "Solid Layer";
  CollisionButton.SolidLayerButton = true;
  NoCollisionButton = new Button(screenWidth - 750 - 4, imageHeight / 2 + 1, 250, imageHeight / 2 - 1);
  NoCollisionButton.Text = "Non-Solid";
  NoCollisionButton.NonSolidLayerButton = true;
  openedEye.resize(0, imageHeight / 2 - 1);
  closedEye.resize(0, imageHeight / 2 - 1);
}
/**
* Drawing method for main. Calls all displaying methods.
*/
void draw() {
  background(125, 125, 125);
  if (TakingInput == false) {
    MapNameButton.Text = "default.json";
  }
  else {
    MapNameButton.Text = userInput;
  }
  mX = mouseX;
  mY = mouseY;
  drawGrid();
  drawSubArray();
  Drawing();
  SaveButton.Display();
  NewButton.Display();
  LoadButton.Display();
  MapNameButton.Display();
  CollisionButton.Display();
  NoCollisionButton.Display();
  mouseClickBool = false;
  displaySeeButtons();
}
/**
*  Splits the tile source image to an array of 16x16 tiles.
*/
void makeSubArray() {
  for (int i = 0; i < mapHeight; i++) {
    for (int j = 0; j < mapWidth; j++) {
      subImgArr[i*mapWidth + j] = image.get(j * tileSize, i * tileSize, tileSize, tileSize);
      gridSubArr[i*mapWidth + j] = subImgArr[i*mapWidth + j];
      gridSubArr[i*mapWidth + j].resize(spacing,spacing);
    }
  }
}
/**
* Draws the grid and prints the map image.
*/
void drawSubArray() {
  image(image, 0, 0);
  x = 0;
  while (x < imageWidth + 1) {
    line(x, 0, x, imageHeight);
    x = x + tileSize;
  }
  y = 0;
  while (y < imageHeight) {
    line(0, y, imageWidth, y);
    y = y + tileSize;
  }
}
/**
*  This method draws the clicked image and lets the user draw on the grid, the clicked image changes the grid if mouse is pressed.
*/
void Drawing() {
  if (mX < imageWidth && mX > 0 && mY < imageHeight && mY > 0) {
    mousePosX = (int)(mX / tileSize);
    mousePosY = (int)(mY / tileSize);
    fill(255,255,255,100);
    rect(mousePosX*tileSize, mousePosY*tileSize, tileSize, tileSize);
    image(clickedImg, mX, mY);
    fill(0);
    text(mousePosX + " : " + mousePosY, imageWidth + 30, 30);
  }
  if ((mX > 0 && mX < screenWidth) && (mY > imageHeight && mY < screenHeight)) {
    mousePosX = (int)(mX / gridTile);
    mousePosY = (int)(mY / gridTile);
    fill(255,255,255,100);
    rect(mousePosX*gridTile, mousePosY*gridTile, gridTile, gridTile);
    image(clickedImg, mX, mY);
    if (mouseClick == true) {
      if (noCollisionLayer == true) {
        othergrid[(mX / gridTile) + ((mY - imageHeight) / gridTile * (screenWidth / gridTile))] = clickedImg;
        othergridIDArr[(mX / gridTile) + ((mY - imageHeight) / gridTile * (screenWidth / gridTile))] = clickedID;
      }
      else if (CollisionLayer == true) {
        grid[(mX / gridTile) + ((mY - imageHeight) / gridTile * (screenWidth / gridTile))] = clickedImg;
        gridIDArr[(mX / gridTile) + ((mY - imageHeight) / gridTile * (screenWidth / gridTile))] = clickedID;
      }
     }
  }
}
/**
* Checks for mouse release. 
*/
void mouseReleased() {
  mouseClick = false;
}
/**
* Checks for mouse hold. 
*/
void mousePressed() {
  mouseClick = true;
}
/**
* Checks for mouse click, and changed the layer booleans to see the different layers of the map. Also changes the clicked image if the coordinates are in map source area. 
*/
void mouseClicked() {
  if (mX >= screenWidth - 830 && mX <= screenWidth - 756 && mY >= 0 && mY <= imageHeight / 2 - 1) {
    if(seeSolid == true) {
      seeSolid = false;
    }
    else seeSolid = true;
  }
  if (mX >= screenWidth - 830 && mX <= screenWidth - 756 && mY >= imageHeight / 2 - 1 && mY <= imageHeight) {
    if(seeNonSolid == true) {
      seeNonSolid = false;
    }
    else seeNonSolid = true;
  }
  if (mX < imageWidth && mX > 0 && mY < imageHeight && mY > 0) {
    mousePosX = (int)(mX / tileSize);
    mousePosY = (int)(mY / tileSize);
    clickedImg = gridSubArr[mousePosY * mapWidth + mousePosX];
    clickedID = mousePosY * mapWidth + mousePosX;
  }
  mouseClickBool = true;
}
/**
* Checks for user input which is required to open or load a map. 
*/
void keyPressed() {
  if (TakingInput == true) {
    if (key != 8 && key != 10 && key != 13 && key != 127 && keyCode != 20) {
      userInput += key;
    }
    else if (key == 8 && userInput.length() != 0) {
      userInput = userInput.substring(0, userInput.length() - 1);
    }
  }
}
/**
* Draws the grids which are currently being displayed on the screen if the booleans allow that. 
*/
void drawGrid() {
  int H;
  int W;
  x = 0;
  while (x < screenWidth) {
    line(x, imageHeight, x, screenHeight);
    x = x + spacing;
  }
  y = imageHeight;
  while (y < screenHeight) {
    line(0, y, screenWidth, y);
    y = y + spacing;
  }
  H = (screenHeight-imageHeight) / gridTile;
  W = (screenWidth / gridTile);
  if (seeNonSolid == true) {
    for (int i = 0; i < H; i++) {
      for (int j = 0; j < W; j++) {
        image(othergrid[i*W + j], j * gridTile, i * gridTile + imageHeight);
      }
    }
  }
  if (seeSolid == true) {
    for (int i = 0; i < H; i++) {
      for (int j = 0; j < W; j++) {
        image(grid[i*W + j], j * gridTile, i * gridTile + imageHeight);
      }
    }
  }
}
/**
*  Displays layer buttons.
*/
void displaySeeButtons() {
  fill(255);
  rect(screenWidth - 830, 0, 74, imageHeight/2 - 2);
  rect(screenWidth - 830, imageHeight/2 + 1, 74, imageHeight/2 - 1);
  if (seeSolid == true) {
    image(openedEye,screenWidth - 830, 0);
  }
  else if (seeSolid == false) {
    image(closedEye, screenWidth - 830, 0);
  }
  if (seeNonSolid == true) {
    image(openedEye, screenWidth - 830, imageHeight/2);
  }
  else if (seeNonSolid == false) {
    image(closedEye, screenWidth - 830, imageHeight/2);
  }
}
/**
* Function to save the current grids to a JSON file. 
*/
void SaveMap() {
   json = new JSONObject();
   json.setInt("height",(screenHeight-imageHeight)/gridTile);
   json.setInt("width",(screenWidth / gridTile));
   layers = new JSONArray();
   dataNoSolid = new JSONArray();
   dataSolid = new JSONArray();
   for(int i = 0; i < (screenHeight-imageHeight)/gridTile; i++) {
     for(int j = 0; j < (screenWidth / gridTile); j++) {
       dataNoSolid.setInt((screenWidth / gridTile) * i + j, othergridIDArr[i * (screenWidth / gridTile) + j]);
       dataSolid.setInt((screenWidth / gridTile) * i + j, gridIDArr[i * (screenWidth / gridTile) + j]);
     }
   }
  dataObject = new JSONObject();
  dataObject.setJSONArray("data", dataNoSolid);
  layers.setJSONObject(0, dataObject);
  dataSolidObject = new JSONObject();
  dataSolidObject.setJSONArray("data", dataSolid);
  layers.setJSONObject(1, dataSolidObject);
  json.setJSONArray("layers", layers);
  saveJSONObject(json, "..\\Levels\\" + userInput);
}
/**
* Creates a new map by clearing the current grids, which are being drawn on the screen.
*/
void NewMap() {
  for (int i = 0; i < screenWidth / gridTile * (screenHeight-imageHeight) / gridTile; i++) {
    othergridIDArr[i] = mapHeight * mapWidth - 1;
    othergrid[i] = subImgArr[mapHeight * mapWidth - 1];
    gridIDArr[i] = mapHeight * mapWidth - 1;
    grid[i] = subImgArr[mapHeight * mapWidth - 1];
  }
}
/**
* Loads a map by filling the grid arrays with JSON file data. Opens JSON file using user input. 
*/
void LoadMap() {
  int mapW;
  int mapH;
  int temp;
  jsonMap = loadJSONObject("..\\Levels\\" + userInput);
  if (jsonMap == null) {
    NewMap();
    return;
  }
  layers = jsonMap.getJSONArray("layers");
  layer = layers.getJSONObject(0);
  layer2 = layers.getJSONObject(1);
  jsonArray = layer.getJSONArray("data");
  jsonArray2 = layer2.getJSONArray("data");
  mapW = jsonMap.getInt("width");
  mapH = jsonMap.getInt("height");
  for (int i = 0; i < mapH; i++) {
    for (int j = 0; j < mapW; j++) {
      temp = jsonArray.getInt(i*mapW + j);
      othergridIDArr[i * mapW + j] = temp;
      othergrid[i * mapW + j] = subImgArr[temp];
      temp = jsonArray2.getInt(i*mapW + j);
      gridIDArr[i * mapW + j] = temp;
      grid[i * mapW + j] = subImgArr[temp];
    }
  }
}
