PImage image;
int tileSize = 16;
int mapHeight;
int mapWidth;
int imageHeight;
int imageWidth;
PImage[] subImgArr;
PImage clickedImg;
PImage openedEye;
PImage closedEye;
boolean noCollisionLayer = false;
boolean CollisionLayer = true;
boolean seeSolid = true;
boolean seeNonSolid = true;
int clickedID;
PImage[] grid;
int[] gridIDArr;
PImage[] othergrid;
PImage[] gridSubArr;
int[] othergridIDArr;
int gridTile = 32;
int mousePosX;
int mousePosY;
boolean mouseClick = false;
boolean mouseClickBool = false;
boolean TakingInput = false;
String userInput = "";
int testFPS = 0;
int screenWidth;
int screenHeight;
Button SaveButton;
Button LoadButton;
Button NewButton;
Button MapNameButton;
Button NoCollisionButton;
Button CollisionButton;
void setup() {
  frameRate(60);
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
  //LoadMap();
  
}

int x;
int y;
int spacing = 32;
int mY, mX;
void draw() {
  println(frameRate);
  background(125, 125, 125);
  if (TakingInput == false) {
    MapNameButton.Text = "default.json";
  }
  else {
    MapNameButton.Text = userInput;
  }
  //stroke(255);
  //strokeWeight(2);
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
  makeSubArray();
  mX = mouseX;
  mY = mouseY;
  //image(subImgArr[3 * 17 + 8], 320, 320);
  if (mX < imageWidth && mX > 0 && mY < imageHeight && mY > 0) {
    mousePosX = (int)(mX / tileSize);
    mousePosY = (int)(mY / tileSize);
    text(mousePosX + " : " + mousePosY, imageWidth + 30, 30);
  }
  drawGrid();
  Drawing();
  SaveButton.Display();
  NewButton.Display();
  LoadButton.Display();
  MapNameButton.Display();
  CollisionButton.Display();
  NoCollisionButton.Display();
  mouseClickBool = false;
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
void makeSubArray() {
  for (int i = 0; i < mapHeight; i++) {
    for (int j = 0; j < mapWidth; j++) {
      subImgArr[i*mapWidth + j] = image.get(j * tileSize, i * tileSize, tileSize, tileSize);
      image(subImgArr[i*mapWidth + j], j * 16, i * 16);
      gridSubArr[i*mapWidth + j] = subImgArr[i*mapWidth + j];
      gridSubArr[i*mapWidth + j].resize(spacing,spacing);
    }
  }
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
void Drawing() {
  if (mX < imageWidth && mX > 0 && mY < imageHeight && mY > 0) image(clickedImg, mX, mY);
  if ((mX > 0 && mX < screenWidth) && (mY > imageHeight && mY < screenHeight)) {
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
void mouseReleased() {
  mouseClick = false;
}
void mousePressed() {
  mouseClick = true;
}
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
void keyPressed() {
  if (TakingInput == true) {
    if (key != 8 && key != 10 && key != 13 && key != 127 && keyCode != 20) {
      userInput += key;
    }
  }
}
int H;
int W;
void drawGrid() {
  H = (screenHeight-imageHeight)/gridTile;//width / gridTile * (height-imageHeight) / gridTile
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
void SaveMap() {
   JSONObject json = new JSONObject();
   json.setInt("height",(screenHeight-imageHeight)/gridTile);
   json.setInt("width",(screenWidth / gridTile));
   JSONArray layers = new JSONArray();
   JSONArray dataNoSolid = new JSONArray();
   JSONArray dataSolid = new JSONArray();
   for(int i = 0; i < (screenHeight-imageHeight)/gridTile; i++) {
     for(int j = 0; j < (screenWidth / gridTile); j++) {
       dataNoSolid.setInt((screenWidth / gridTile) * i + j, othergridIDArr[i * (screenWidth / gridTile) + j]);
       dataSolid.setInt((screenWidth / gridTile) * i + j, gridIDArr[i * (screenWidth / gridTile) + j]);
     }
   }
   // Create a JSONObject for the data array
  JSONObject dataObject = new JSONObject();
  dataObject.setJSONArray("data", dataNoSolid);
  layers.setJSONObject(0, dataObject);
  
  
  JSONObject dataSolidObject = new JSONObject();
  dataSolidObject.setJSONArray("data", dataSolid);
  layers.setJSONObject(1, dataSolidObject);
  // Add layers array to main JSON object
  
  json.setJSONArray("layers", layers);

  // Save the JSONObject to a file
  saveJSONObject(json, userInput);
  println("JSON file saved!");
}
void NewMap() {
  for (int i = 0; i < screenWidth / gridTile * (screenHeight-imageHeight) / gridTile; i++) {
    othergridIDArr[i] = mapHeight * mapWidth - 1;
    othergrid[i] = subImgArr[mapHeight * mapWidth - 1];
    gridIDArr[i] = mapHeight * mapWidth - 1;
    grid[i] = subImgArr[mapHeight * mapWidth - 1];
  }
}
void LoadMap() {
  JSONObject jsonMap;
  JSONArray layers;
  JSONArray jsonArray;
  JSONArray jsonArray2;
  JSONObject layer;
  JSONObject layer2;
  int mapW;
  int mapH;
  int temp;
  int temp2;
  jsonMap = loadJSONObject(userInput);
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
      temp2 = jsonArray2.getInt(i*mapW + j);
      gridIDArr[i * mapW + j] = temp2;
      grid[i * mapW + j] = subImgArr[temp2];
      othergridIDArr[i * mapW + j] = temp;
      othergrid[i * mapW + j] = subImgArr[temp];
    }
  }
}
