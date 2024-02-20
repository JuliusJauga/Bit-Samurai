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
int[] othergridIDArr;
int gridTile = 32;
int mousePosX;
int mousePosY;
boolean mouseClick = false;
boolean mouseClickBool = false;
boolean TakingInput = false;
String userInput = "";
Button SaveButton;
Button LoadButton;
Button NewButton;
Button MapNameButton;
Button NoCollisionButton;
Button CollisionButton;
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
  subImgArr = new PImage[mapHeight * mapWidth];
  grid = new PImage[width / gridTile * (height-imageHeight) / gridTile];
  gridIDArr = new int[width / gridTile * (height-imageHeight) / gridTile];
  othergrid = new PImage[width / gridTile * (height-imageHeight) / gridTile];
  othergridIDArr = new int[width / gridTile * (height-imageHeight) / gridTile];
  makeSubArray();
  NewMap();
  clickedImg = subImgArr[mapHeight * mapWidth - 1].get(0, 0, tileSize, tileSize);
  clickedID = mapHeight * mapWidth - 1;
  SaveButton = new Button(width - 500 - 2, imageHeight / 2 + 1, 250, imageHeight / 2 - 1);
  SaveButton.Text = "Save Map";
  SaveButton.SaveMapButton = true;
  NewButton = new Button(width - 250, 0, 250, imageHeight / 2 - 2);
  NewButton.Text = "New Map";
  NewButton.NewMapButton = true;
  LoadButton = new Button(width - 250, imageHeight / 2 + 1, 250,imageHeight / 2 - 1);
  LoadButton.Text = "Load Map";
  LoadButton.LoadMapButton = true;
  MapNameButton = new Button(width - 500 - 2, 0, 250, imageHeight / 2 - 2);
  MapNameButton.Text = "|";
  MapNameButton.MapNameButton = true;
  CollisionButton = new Button(width - 750 - 4, 0, 250, imageHeight / 2 - 2);
  CollisionButton.Text = "Solid Layer";
  CollisionButton.SolidLayerButton = true;
  NoCollisionButton = new Button(width - 750 - 4, imageHeight / 2 + 1, 250, imageHeight / 2 - 1);
  NoCollisionButton.Text = "Non-Solid";
  NoCollisionButton.NonSolidLayerButton = true;
  openedEye.resize(0, imageHeight / 2 - 1);
  closedEye.resize(0, imageHeight / 2 - 1);
  //LoadMap();
}

int x;
int y;
int spacing = 32;
int translateX = 0;
void draw() {
  background(125, 125, 125);
  MapNameButton.Text = userInput;
  //stroke(255);
  //strokeWeight(2);
  x = 0;
  while (x < width ) {
    line(x, imageHeight, x, height);
    x = x + spacing;
  }
  y = imageHeight;
  while (y < height) {
    line(0, y, width, y);
    y = y + spacing;
  }
  makeSubArray();
  //image(subImgArr[3 * 17 + 8], 320, 320);
  if (mouseX < imageWidth && mouseX > 0 && mouseY < imageHeight && mouseY > 0) {
    mousePosX = (int)(mouseX / tileSize);
    mousePosY = (int)(mouseY / tileSize);
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
  rect(width - 830, 0, 74, imageHeight/2 - 2);
  rect(width - 830, imageHeight/2 + 1, 74, imageHeight/2 - 1);
  if (seeSolid == true) {
    image(openedEye, width - 830, 0);
  }
  else if (seeSolid == false) {
    image(closedEye, width - 830, 0);
  }
  if (seeNonSolid == true) {
    image(openedEye, width - 830, imageHeight/2);
  }
  else if (seeNonSolid == false) {
    image(closedEye, width - 830, imageHeight/2);
  }
}
void makeSubArray() {
  for (int i = 0; i < mapHeight; i++) {
    for (int j = 0; j < mapWidth; j++) {
      subImgArr[i*mapWidth + j] = image.get(j * tileSize, i * tileSize, tileSize, tileSize);
      image(subImgArr[i*mapWidth + j], j * 16, i * 16);
    }
  }
}
void Drawing() {
  if (mouseX < imageWidth && mouseX > 0 && mouseY < imageHeight && mouseY > 0) image(clickedImg, mouseX, mouseY, 32, 32);
     if ((mouseX > imageWidth || mouseX < 0) || (mouseY > imageHeight || mouseY < 0)) {
      if (mouseY > imageHeight && mouseX >= 0) {
        //mouseX / 32
        //(mouseY - imageHeight) / 32
        image(clickedImg, mouseX, mouseY, 32, 32);
        
        if (mouseClick == true) {
          if (noCollisionLayer == true) {
            othergrid[(mouseX / gridTile) + ((mouseY - imageHeight) / gridTile * (width / gridTile))] = clickedImg;
            othergridIDArr[(mouseX / gridTile) + ((mouseY - imageHeight) / gridTile * (width / gridTile))] = clickedID;
          }
          else if (CollisionLayer == true) {
            grid[(mouseX / gridTile) + ((mouseY - imageHeight) / gridTile * (width / gridTile))] = clickedImg;
            gridIDArr[(mouseX / gridTile) + ((mouseY - imageHeight) / gridTile * (width / gridTile))] = clickedID;
          }
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
  if (mouseX >= width - 830 && mouseX <= width - 756 && mouseY >= 0 && mouseY <= imageHeight / 2 - 1) {
    if(seeSolid == true) {
      seeSolid = false;
    }
    else seeSolid = true;
  }
  if (mouseX >= width - 830 && mouseX <= width - 756 && mouseY >= imageHeight / 2 - 1 && mouseY <= imageHeight) {
    if(seeNonSolid == true) {
      seeNonSolid = false;
    }
    else seeNonSolid = true;
  }
  if (mouseX < imageWidth && mouseX > 0 && mouseY < imageHeight && mouseY > 0) {
    mousePosX = (int)(mouseX / tileSize);
    mousePosY = (int)(mouseY / tileSize);
    clickedImg = subImgArr[mousePosY * mapWidth + mousePosX].get(0, 0, tileSize, tileSize);
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
void drawGrid() {
  int H = (height-imageHeight)/gridTile;//width / gridTile * (height-imageHeight) / gridTile
  int W = (width / gridTile);
  if (seeNonSolid == true) {
    for (int i = 0; i < H; i++) {
      for (int j = 0; j < W; j++) {
        image(othergrid[i*W + j], j * gridTile, i * gridTile + imageHeight, gridTile, gridTile);
      }
    }
  }
  if (seeSolid == true) {
    for (int i = 0; i < H; i++) {
      for (int j = 0; j < W; j++) {
        image(grid[i*W + j], j * gridTile, i * gridTile + imageHeight, gridTile, gridTile);
      }
    }
  }
}
void SaveMap() {
   JSONObject json = new JSONObject();
   json.setInt("height",(height-imageHeight)/gridTile);
   json.setInt("width",(width / gridTile));
   JSONArray layers = new JSONArray();
   JSONArray dataNoSolid = new JSONArray();
   JSONArray dataSolid = new JSONArray();
   for(int i = 0; i < (height-imageHeight)/gridTile; i++) {
     for(int j = 0; j < (width / gridTile); j++) {
       dataNoSolid.setInt((width / gridTile) * i + j, othergridIDArr[i * (width / gridTile) + j]);
       dataSolid.setInt((width / gridTile) * i + j, gridIDArr[i * (width / gridTile) + j]);
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
  for (int i = 0; i < width / gridTile * (height-imageHeight) / gridTile; i++) {
    othergridIDArr[i] = mapHeight * mapWidth - 1;
    othergrid[i] = subImgArr[mapHeight * mapWidth - 1].get(0, 0, tileSize, tileSize);
    gridIDArr[i] = mapHeight * mapWidth - 1;
    grid[i] = subImgArr[mapHeight * mapWidth - 1].get(0, 0, tileSize, tileSize);
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
      grid[i * mapW + j] = subImgArr[temp2].get(0,0,tileSize,tileSize);
      othergridIDArr[i * mapW + j] = temp;
      othergrid[i * mapW + j] = subImgArr[temp].get(0,0,tileSize,tileSize);
    }
  }
}
