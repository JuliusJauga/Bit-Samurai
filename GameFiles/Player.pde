class Player {
    int x, y, w, h;
    boolean goingRight = false;
    boolean goingLeft = false;
    boolean onAir = false;
    
    
    boolean LeftCollision = false;
    boolean RightCollision = false;
    boolean SpikeCollision = false;
    boolean BottomCollision = false;
    boolean Climbing = false;
    
    boolean RunningLeft = false;
    boolean RunningRight = false;
    boolean AirTime = false;
    boolean landed = false;
    int tile;
    int tile2;
    int tilething;
    Player() {
    x = 64;
    y = mapHeight/ 2 * resize;
    w = 64;
    h = 64;
    }
    void reset() {
      x = 64;
      y = mapHeight/ 2 * resize;
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
      if (SpikeCollisionCheck(32,0) == true || SpikeCollisionCheck(32,60) == true) {
        if (lose.isPlaying()) {
          lose.rewind();
        }
        lose.play();
        lose.rewind();
        reset_game();
      }
      if (x + 17 < 0) {
        LeftCollision = true;
      }
      else if (x + resize > mapWidth * resize) {
        RightCollision = true;
      }
      //int tile2 = y / resize;
      //TopCollision = (CollisionChecker(4, 4) || CollisionChecker(60, 4));
    }
    void display() {
      //rect(x,y,64,64);
      playerAnimation(getAnimationFrameIndex());
      textSize(30);
      fill(#D3D654, 100);
      rect(-translateX, -translateY , 195, 50, 100);
      fill(#54D6AC, 100);
      rect(-translateX + 195, -translateY , 195, 50, 100);
      fill(#050500);
      text("COINS LEFT " + coinCount, -translateX + 5, -translateY + resize/2 + 5);
      text("LEVEL " + str(currentLevel), -translateX + 245, -translateY + resize/2 + 5);
      text("X : " + x + "   Y : " + y, x, y - 100);
      textSize(10);
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
        if (x > width / 2) {
          if (x + resize/2> (mapWidth * 64 - width / 2 + resize)) {
          }
          else translateX -= playerSpeedX;
        }
        
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
        if (x > width / 2) {
          if (x > (mapWidth * 64 - width / 2)) {
          }
          else translateX -= playerSpeedX;
        }
      }
    }
    void goDown() {
      if (BottomCollision == false) {
        if (playerSpeedY < terminalVelocity) {
          playerSpeedY += gravity;
        }
        tilething = (y + playerSpeedY + resize) / 64 * mapWidth + (x+32) / 64;
        if (tilething < mapWidth * mapHeight && tilething >= 0) {
          if (jsonArray.getInt(tilething) == coinTile) {
            jsonArray.setInt(tilething, airTile);
            if (coin.isPlaying()) {
              coin.rewind();
            }
            coin.play();
            coin.rewind();
            coinCount--;
          }
          if (jsonArray.getInt(tilething) < airTile) {
            playerSpeedY = 2;
            landed = true;
          }
        }
        y += playerSpeedY;
        translateY -= playerSpeedY;
        /*if (y > height / 2) {
          if (y < (mapHeight * 64 - height / 2)) {
          }
          else translateY -= playerSpeedY;
        }*/
        return;
      }
      
      playerSpeedY = 0;
    }
    void Jump() {
      if (BottomCollision == true) {
        if (AirTime == true && landed == true) {
          if (land.isPlaying()) {
            land.rewind();
          }
          land.play();
          land.rewind();
        }
        AirTime = false;
      }
      if (BottomCollision == true && onAir == true) {
        if (Climbing == false) {
          if (jump.isPlaying()) {
            jump.rewind();
          }
          jump.play();
          jump.rewind();
        }
        AirTime = true;
        landed = false;
        playerSpeedY -= jumpStrength;
        y += playerSpeedY;
        translateY -= playerSpeedY;
        /*if (y > height / 2) {
          if (y < (mapHeight * 64 - height / 2)) {
          }
          else translateY -= playerSpeedY;
        }*/
      }
    }
    boolean CollisionChecker(int dX, int dY) {
      tile = (x + dX) / resize;
      tile2 = (y + dY) / resize;
      if (tile2 > mapHeight + 10) {
        lose.play();
        lose.rewind();
        reset_game();
      }
      if (tile > mapWidth - 2 && coinCount == 0) {
        if (loadJSONObject("Levels\\level" + str(currentLevel + 1) + ".json") != null) {
          currentLevel++;
          reset_game();
        }
      }
      if (tile > mapWidth - 1 || tile < 0 || tile2 > mapHeight - 1 || tile2 < 0) return false;
      else if (jsonArray.getInt(tile2 * mapWidth + tile) == coinTile) {
        jsonArray.setInt(tile2 * mapWidth + tile, airTile);
        if (coin.isPlaying()) {
          coin.rewind();
        }
        coin.play();
        coin.rewind();
        coinCount--;
        return false;
      }
       else if (jsonArray.getInt(tile2 * mapWidth + tile) >= spikeTile && jsonArray.getInt(tile2 * mapWidth + tile) <= spikeTile + 4) {
        return false;
      }
      else if (jsonArray.getInt(tile2 * mapWidth + tile) >= airTile) {
        return false;
      }
      else {
        return true;
      }
    }
    boolean SpikeCollisionCheck(int dX, int dY) {
      tile = (x + dX) / resize;
      tile2 = (y + dY) / resize;
      if (tile > mapWidth - 1 || tile < 0 || tile2 > mapHeight - 1 || tile2 < 0) return false;
      if (jsonArray.getInt(tile2 * mapWidth + tile) >= spikeTile && jsonArray.getInt(tile2 * mapWidth + tile) <= spikeTile + 4) {
        return true;
      }
      return false;
    }
    void playerAnimation(int index) {
      if (BottomCollision == true && RightCollision == true && playerSpeedY == 0) {
        image(climbRight[0], x - 20, y);
        Climbing = true;
        return;
      }
      else if (BottomCollision == true && LeftCollision == true && playerSpeedY == 0) {
        image(climbLeft[0], x - 5, y);
        Climbing = true;
        return;
      }
      else if (BottomCollision == true && RightCollision == true && playerSpeedY < 0) {
        image(climbRight[index], x - 20, y);
        Climbing = true;
        return;
      }
      else if (BottomCollision == true && LeftCollision == true && playerSpeedY < 0) {
        image(climbLeft[index], x - 8, y);
        Climbing = true;
        return;
      }
      else if (AirTime == true) {
        if (RunningLeft == false) {
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
          image(idle[index], x - 17, y - 15);
        }
      }
      Climbing = false;
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
