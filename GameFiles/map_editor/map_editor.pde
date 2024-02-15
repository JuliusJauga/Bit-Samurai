PImage image;
int tileSize = 16;
int mapHeight;
int mapWidth;
int imageHeight;
int imageWidth;
PImage[] subImgArr;
PImage clickedImg;
int clickedID;
PImage[] grid;
int[] gridIDArr;
int gridTile = 32;
int mousePosX;
int mousePosY;
boolean mouseClick = false;
boolean mouseClickBool = false;
Button SaveButton;
Button LoadButton;
Button NewButton;
void setup() {
  size(1280, 640);
  fill(255, 0, 0);
  textSize(30);
  image = loadImage("..\\Source\\sheet.png");
  imageHeight = image.height;
  imageWidth = image.width;
  mapHeight = image.height / tileSize;
  mapWidth = image.width / tileSize;
  println(mapHeight);
  println(mapWidth);
  subImgArr = new PImage[mapHeight * mapWidth];
  grid = new PImage[width / gridTile * (height-imageHeight) / gridTile];
  gridIDArr = new int[width / gridTile * (height-imageHeight) / gridTile];
  println((height-imageHeight) / gridTile);
  println(width / gridTile);
  makeSubArray();
  NewMap();
  clickedImg = subImgArr[mapHeight * mapWidth - 1].get(0, 0, tileSize, tileSize);
  clickedID = mapHeight * mapWidth - 1;
  println(clickedID);
  SaveButton = new Button(width - 500 - 2, imageHeight / 2 + 1, 250, imageHeight / 2 - 1);
  SaveButton.Text = "Save Map";
  NewButton = new Button(width - 250, 0, 250, imageHeight / 2 - 2);
  NewButton.Text = "New Map";
  LoadButton = new Button(width - 250, imageHeight / 2 + 1, 250,imageHeight / 2 - 1);
  LoadButton.Text = "Load Map";
  //LoadMap();
}

int x;
int y;
int spacing = 32;
int translateX = 0;
void draw() {
  background(125, 125, 125);
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
  mouseClickBool = false;
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
        grid[(mouseX / gridTile) + ((mouseY - imageHeight) / gridTile * (width / gridTile))] = clickedImg;
        gridIDArr[(mouseX / gridTile) + ((mouseY - imageHeight) / gridTile * (width / gridTile))] = clickedID;
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
  if (mouseX < imageWidth && mouseX > 0 && mouseY < imageHeight && mouseY > 0) {
    mousePosX = (int)(mouseX / tileSize);
    mousePosY = (int)(mouseY / tileSize);
    clickedImg = subImgArr[mousePosY * mapWidth + mousePosX].get(0, 0, tileSize, tileSize);
    clickedID = mousePosY * mapWidth + mousePosX;
  }
  mouseClickBool = true;
}
void drawGrid() {
  int H = (height-imageHeight)/gridTile;//width / gridTile * (height-imageHeight) / gridTile
  int W = (width / gridTile);
  for (int i = 0; i < H; i++) {
    for (int j = 0; j < W; j++) {
      image(grid[i*W + j], j * gridTile, i * gridTile + imageHeight, gridTile, gridTile);
    }
  }
}
void SaveMap() {
   JSONObject json = new JSONObject();
   json.setInt("height",(height-imageHeight)/gridTile);
   json.setInt("width",(width / gridTile));
   JSONArray layers = new JSONArray();
   JSONArray data = new JSONArray();
   for(int i = 0; i < (height-imageHeight)/gridTile; i++) {
     for(int j = 0; j < (width / gridTile); j++) {
       data.setInt((width / gridTile) * i + j, gridIDArr[i * (width / gridTile) + j]);
     }
   }
   // Create a JSONObject for the data array
  JSONObject dataObject = new JSONObject();
  dataObject.setJSONArray("data", data);

  // Add data object to layers array
  layers.setJSONObject(0, dataObject);

  // Add layers array to main JSON object
  json.setJSONArray("layers", layers);

  // Save the JSONObject to a file
  saveJSONObject(json, "grid_data.json");
  println("JSON file saved!");
}
void NewMap() {
  for (int i = 0; i < width / gridTile * (height-imageHeight) / gridTile; i++) {
    gridIDArr[i] = mapHeight * mapWidth - 1;
    grid[i] = subImgArr[mapHeight * mapWidth - 1].get(0, 0, tileSize, tileSize);
  }
}
void LoadMap() {
  JSONObject jsonMap;
  JSONArray layers;
  JSONArray jsonArray;
  JSONObject layer;
  int mapW;
  int mapH;
  int temp;
  jsonMap = loadJSONObject("grid_data.json");
  layers = jsonMap.getJSONArray("layers");
  layer = layers.getJSONObject(0);
  jsonArray = layer.getJSONArray("data");
  mapW = jsonMap.getInt("width");
  mapH = jsonMap.getInt("height");
  for (int i = 0; i < mapH; i++) {
    for (int j = 0; j < mapW; j++) {
      temp = jsonArray.getInt(i*mapW + j);
      gridIDArr[i * mapW + j] = temp;
      grid[i * mapW + j] = subImgArr[temp].get(0,0,tileSize,tileSize);
    }
  }
}
