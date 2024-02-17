class Player {
    int x, y, w, h;
    boolean goingRight = false;
    boolean goingLeft = false;
    boolean onAir = false;
    
    
    boolean LeftCollision = false;
    boolean RightCollision = false;
    boolean TopCollision = false;
    boolean BottomCollision = false;
    
    boolean RunningLeft = false;
    boolean RunningRight = false;
    boolean AirTime = false;
    boolean onGoingAnimation = false;
    Player() {
    x = 64;
    y = height / 2;
    w = 64;
    h = 64;
    }
    void update() {
      goRight();
      goLeft();
      goDown();
      Jump();
      BottomCollision = (CollisionChecker(16, 60) || CollisionChecker(48, 60));
      LeftCollision = (CollisionChecker(16, 4) || CollisionChecker(16, 48));
      RightCollision = (CollisionChecker(48, 4) || CollisionChecker(48, 48));
      //TopCollision = (CollisionChecker(4, 4) || CollisionChecker(60, 4));
      //translateX -= playerSpeedX;
      //translateY -= playerSpeedY;
    }
    void display() {
      //rect(x,y,64,64);
      //fill(255);
      //rect(x + 4,y + 4, 56, 56);
      playerAnimation(getAnimationFrameIndex());
    }
    void goLeft() {
      if (playerSpeedX < 0) RunningLeft = true;
      else RunningLeft = false;
      if (goingLeft == true && LeftCollision == false && goingRight == false) {
        if (RightCollision) playerSpeedX = 0;
        if (playerSpeedX > playerSpeedCap * -1) {
          playerSpeedX -= acceleration; 
        }
        x += playerSpeedX;
        translateX -= playerSpeedX;
      }
    }
    void goRight() {
      if (playerSpeedX > 0) RunningRight = true;
      else RunningRight = false;
      if (goingRight == true && RightCollision == false && goingLeft == false) {
        if (LeftCollision) playerSpeedX = 0;
        if (playerSpeedX < playerSpeedCap) {
          playerSpeedX += acceleration;
        }
        x += playerSpeedX;
        translateX -= playerSpeedX;
      }
    }
    void goDown() {
      if (BottomCollision == false) {
        if (playerSpeedX > 0) {
          onGoingAnimation = false;
        }
        playerSpeedY += gravity;
        int tile = (y + playerSpeedY + resize) / 64 * mapWidth + (x+32) / 64;
        if (tile < mapWidth * mapHeight && tile >= 0) {
          println(jsonArray.getInt(tile));
          if (jsonArray.getInt(tile) < airTile) {
            playerSpeedY = 1;
            //println("hello");
          }
        } 
        y += playerSpeedY;
        translateY -= playerSpeedY;
        return;
      }
      playerSpeedY = 0;
    }
    void Jump() {
      if (BottomCollision == true) {
        AirTime = false;
      }
      if (BottomCollision == true && spacePressed) {
        AirTime = true;
        playerSpeedY -= jumpStrength;
        y += playerSpeedY;
        translateY -= playerSpeedY;
      }
    }
    boolean CollisionChecker(int dX, int dY) {
      int tile = (x + dX) / resize;
      int tile2 = (y + dY) / resize;
      if (tile > mapWidth - 1 || tile < 0 || tile2 > mapHeight - 1 || tile2 < 0) return false;
      else if (jsonArray.getInt(tile2 * mapWidth + tile) >= airTile) return false;
      else return true;
    }
    void playerAnimation(int index) {
      if (BottomCollision == true && RightCollision == true && playerSpeedY == 0) {
        image(climbRight[0], x - 20, y);
      }
      else if (BottomCollision == true && LeftCollision == true && playerSpeedY == 0) {
        image(climbLeft[0], x - 5, y);
      }
      else if (BottomCollision == true && RightCollision == true && playerSpeedY < 0) {
        image(climbRight[index], x - 20, y);
      }
      else if (BottomCollision == true && LeftCollision == true && playerSpeedY < 0) {
        image(climbLeft[index], x - 8, y);
      }
      else if (AirTime == true) {
        if (RunningLeft == false) {
          //if (index == 5)
          image(jumpRight[index], x - 17, y - 15);
        }
        if (RunningLeft == true) {
          image(jumpLeft[index], x - 17, y - 15);
        }
      }
      else {
        if (RunningLeft == true) image(runLeft[index], x - 17, y - 15);
        else if (RunningRight == true) image(runRight[index], x - 17, y - 15);
        else {
          //image(idle[index], x, y);
          image(idle[index], x - 17, y - 15);
        }
      }
    }
    int getAnimationFrameIndex() {
      if (elapsedTime <= 100) return 0;
      else if (elapsedTime <= 200) return 1;
      else if (elapsedTime <= 300) return 2;
      else if (elapsedTime <= 400) return 3;
      else if (elapsedTime <= 500) return 4;
      else if (elapsedTime <= 600) return 5;
      return 0;
    }
}
