class Button {
  int x;
  int y;
  int Wh;
  int Ht;
  String Text;
  int colour;
  
  boolean SolidLayerButton = false;
  boolean NonSolidLayerButton = false;
  boolean SaveMapButton = false;
  boolean NewMapButton = false;
  boolean LoadMapButton = false;
  boolean MapNameButton = false;
  
  Button(int x, int y, int Wh, int Ht) {
    this.x = x;
    this.y = y;
    this.Ht = Ht;
    this.Wh = Wh;
    colour = 255;
    Text = "Button";
  }
  void Update() {
  }
  void Display() {
  if (mouseX >= x && mouseX <= x + Wh && mouseY >= y && mouseY <= y + Ht) {
    fill(100, 100);
    if (mouseClickBool == true) {
      fill(25, 255, 25);
      if (SolidLayerButton == true) {
        if (CollisionLayer == false) {
          CollisionLayer = true;
          noCollisionLayer = false;
        }
      }
      else if (NonSolidLayerButton == true) {
        if (noCollisionLayer == false) {
          noCollisionLayer = true;
          CollisionLayer = false;
        }
      }
      else if (NewMapButton == true) {
        NewMap();
      }
      else if (MapNameButton) {
        if (TakingInput == true) {
          TakingInput = false;
          userInput = "";
        }
        else {
          TakingInput = true;
        }
      }
      else if (SaveMapButton) {
        SaveMap();
      }
      else if (LoadMapButton) {
        LoadMap();
      }
    }
  }
  else {
    fill(255);
    if (NonSolidLayerButton == true) {
      if (noCollisionLayer == true) {
        fill(0,255,0);
      }
      else {
        fill(255,125,125);
      }
    }
    if (SolidLayerButton == true) {
      if (CollisionLayer == true) {
        fill(0,255,0);
      }
      else {
        fill(255,125,125);
      }
    }
  }
  //fill(255,0,0);
  rect(x,y,Wh,Ht);
  //fill(0,255,0);
  //rect(x+4,y+4,Wh-4,Ht-4);
  fill(0);
  text(Text, x + (Wh/2 - Wh/4), y + (Ht / 2 + Ht / 4));
  }
}
