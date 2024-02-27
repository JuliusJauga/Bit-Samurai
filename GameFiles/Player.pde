/**
* Class of player, handles game logic like player collisions, animmations, death conditions and movement.
* @author Julius Jauga 5 gr.
*/
class Player {
    int x, y, w, h;
    int tileX, tileY, currentTile;
    int playerSpeedX, playerSpeedY;
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
    /**
    * Player constructor, calls reset method which restarts the coordinates and player size.
    */
    Player() {
      reset();
    }
    /**
    * Reset method, restarts player coordinates and size.
    */
    void reset() {
      x = resize;
      y = height / 2 - resize;
      w = resize;
      h = resize;
    }
    /**
    * Update method for player, checks all the collisions with collision checker method. Also checks for map boundaries.
    */
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
    }
    /**
    * Displays the current player animation frame.
    */
    void display() {
      playerAnimation(getAnimationFrameIndex());
    }
    /**
    * Conditions and logic for the player to go left.
    */
    void goLeft() {
      if (playerSpeedX < 0) RunningLeft = true;
      else RunningLeft = false;
      if (goingLeft == true && LeftCollision == false && goingRight == false) {
        if (RightCollision) playerSpeedX = 0;
        if (playerSpeedX > playerSpeedCap * -1) {
          playerSpeedX -= acceleration; 
        }
        x += playerSpeedX;
        if (x < width / 2 - translateX - 100 && translateX < 0) {
          translateX -= playerSpeedX;
        }
      }
    }
    /**
    * Conditions and the logic for the player to go right.
    */
    void goRight() {
      if (playerSpeedX > 0) RunningRight = true;
      else RunningRight = false;
      if (goingRight == true && RightCollision == false && goingLeft == false) {
        if (LeftCollision) playerSpeedX = 0;
        if (playerSpeedX < playerSpeedCap) {
          playerSpeedX += acceleration;
        }
        x += playerSpeedX;
        if ((x > width / 2 - translateX + 100) && (translateX > -(mapWidth * resize - width - 15))) {
          translateX -= playerSpeedX;
        }
      }
    }
    /**
    * Conditions and the logic for the player to fall.
    */
    void goDown() {
      if (BottomCollision == false) {
        if (playerSpeedY < terminalVelocity) {
          playerSpeedY += gravity;
        }
        currentTile = (y + playerSpeedY + resize) / 64 * mapWidth + (x+32) / 64;
        if (currentTile < mapWidth * mapHeight && currentTile >= 0) {
          if (jsonArray.getInt(currentTile) == coinTile) {
            jsonArray.setInt(currentTile, airTile);
            AudioPlay(coin);
            coinCount--;
          }
          if (jsonArray.getInt(currentTile) < airTile) {
            playerSpeedY = 5;
            landed = true;
          }
        }
        y += playerSpeedY;
        translateY -= playerSpeedY;
        return;
      }
      
      playerSpeedY = 0;
    }
    /**
    * Conditions and the logic for the player to jump.
    */
    void Jump() {
      if (BottomCollision == true) {
        if (AirTime == true && landed == true) {
          AudioPlay(land);
        }
        AirTime = false;
      }
      if (BottomCollision == true && onAir == true) {
        if (Climbing == false) {
          AudioPlay(jump);
        }
        AirTime = true;
        landed = false;
        playerSpeedY -= jumpStrength;
        y += playerSpeedY;
        translateY -= playerSpeedY;
      }
    }
    /**
    * Collision checker method which checks if a given point is colliding with a tile which is solid.
    * Also the collision checks if a coin has been collected or the map boundary has been touched.
    * @param int dX - offset from player x coordinates.
    * @param int dY - offset from player y coordinates.
    * @return boolean true or false, collision or no collision
    */
    boolean CollisionChecker(int dX, int dY) {
      tileX = (x + dX) / resize;
      tileY = (y + dY) / resize;
      if (tileY > mapHeight + 10) {
        AudioPlay(lose);
        reset_game();
      }
      if (tileX > mapWidth - 2 && coinCount == 0) {
        if (loadJSONObject("Levels\\level" + str(currentLevel + 1) + ".json") != null) {
          currentLevel++;
          reset_game();
        }
      }
      if (tileX > mapWidth - 1 || tileX < 0 || tileY > mapHeight - 1 || tileY < 0) return false;
      else if (jsonArray.getInt(tileY * mapWidth + tileX) == coinTile) {
        jsonArray.setInt(tileY * mapWidth + tileX, airTile);
        AudioPlay(coin);
        coinCount--;
        return false;
      }
      else if (jsonArray.getInt(tileY * mapWidth + tileX) >= spikeTile && jsonArray.getInt(tileY * mapWidth + tileX) <= spikeTile + 4) {
        return false;
      }
      else if (jsonArray.getInt(tileY * mapWidth + tileX) >= airTile) {
        return false;
      }
      else {
        return true;
      }
    }
    /**
    * Separate collision checker for a spike for a given point with offset from player x, y coordinates.
    * @param int dX - offset from player x coordinates.
    * @param int dY - offset from player y coordinates.
    * @return boolean true or false, spike collision or no collision.
    */
    boolean SpikeCollisionCheck(int dX, int dY) {
      tileX = (x + dX) / resize;
      tileY = (y + dY) / resize;
      if (tileX > mapWidth - 1 || tileX < 0 || tileY > mapHeight - 1 || tileY < 0) return false;
      if (jsonArray.getInt(tileY * mapWidth + tileX) >= spikeTile && jsonArray.getInt(tileY * mapWidth + tileX) <= spikeTile + 4) {
        return true;
      }
      return false;
    }
    /**
    * This method draws the corresponding frame of animation depending on the current player state and given index.
    * @param int index - index for the frame of animation.
    */
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
        else image(idle[index], x - 17, y - 15);
      }
      Climbing = false;
    }
    /**
    * This method returns the current animation index depending on the timer method defined in main class.
    * @return int - index for frame.
    */
    int getAnimationFrameIndex() {
      if (elapsedTime <= 100) return 0;
      else if (elapsedTime <= 200) return 1;
      else if (elapsedTime <= 300) return 2;
      else if (elapsedTime <= 400) return 3;
      else if (elapsedTime <= 500) return 4;
      else if (elapsedTime <= 600) return 5;
      return 0;
    }
    /**
    * This method plays the given sound from AudioPlayer class.
    */
    void AudioPlay(AudioPlayer sound) {
      if (sound.isPlaying()) {
          sound.rewind();
        }
        sound.play();
        sound.rewind();
    }
}
