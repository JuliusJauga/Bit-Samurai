class Button {
  int x;
  int y;
  int Wh;
  int Ht;
  String Text;
  int colour;
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
    fill(100, 100, 100, 100);
    if (mouseClickBool == true) {
      fill(25, 255, 25);
      if (y < imageHeight / 2) {
        NewMap();
      }
      else if (x < width - 250) {
        SaveMap();
      }
      else {
        LoadMap();
      }
    }
  }
  else {
    fill(colour);
  }
  fill(255,0,0);
  rect(x,y,Wh,Ht);
  fill(0,255,0);
  rect(x+4,y+4,Wh-4,Ht-4);
  fill(0);
  text(Text, x + (Wh/2 - Wh/4), y + (Ht / 2 + Ht / 4));
  
  }
}
