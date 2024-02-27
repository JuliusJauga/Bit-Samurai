/**
* Class of Button.
* Used for making new buttons and displaying them.
* @author Julius Jauga 5 gr.
*/
class Button {
  String Text;
  int x, y, Wh, Ht;
  int colour;
  
  boolean SolidLayerButton = false;
  boolean NonSolidLayerButton = false;
  boolean SaveMapButton = false;
  boolean NewMapButton = false;
  boolean LoadMapButton = false;
  boolean MapNameButton = false;
  
  /**
  * Constructor for button class. Sets the default text and colour.
  * @param x - x coordinates for a button.
  * @param y - y coordinates for a button.
  * @param Wh - width of a button on x coordinates.
  * @param Ht - height of a button on y coordinates.
  */
  Button(int x, int y, int Wh, int Ht) {
    this.x = x;
    this.y = y;
    this.Ht = Ht;
    this.Wh = Wh;
    colour = 255;
    Text = "Button";
  }
  /**
  * Display method for buttons, checks the button type and calls a corresponding method from map_editor class.
  */
  void Display() {
    if (mX >= x && mX <= x + Wh && mY >= y && mY <= y + Ht) {
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
  rect(x,y,Wh,Ht);
  fill(0);
  text(Text, x + (Wh/2 - Wh/4), y + (Ht / 2 + Ht / 4));
  }
}
