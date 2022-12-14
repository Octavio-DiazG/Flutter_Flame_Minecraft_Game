import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:minecraft2d_game/global/player_data.dart';
import 'package:minecraft2d_game/utils/game_methods.dart';

class Entity extends SpriteAnimationComponent with CollisionCallbacks{
  bool isFacingRight = true;
  double yVelocity = 0;

  bool isCollidingBottom = false;
  bool isCollidingRight = false;
  bool isCollidingLeft = false;
  bool isCollidingTop = false;

  double jumpForce = 0;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

      intersectionPoints.forEach((Vector2 individualIntersectionPoint) { 
  
        //Ground Collision
        if (individualIntersectionPoint.y > (position.y - (size.y * 0.3)) && (intersectionPoints.first.x - intersectionPoints.last.x).abs() > size.x * 0.4) { 
          //print("bottom Collision");
          isCollidingBottom = true;
          yVelocity = 0;
        }
  
        //Top Collision
        if (individualIntersectionPoint.y < (position.y - (size.y * 0.75)) && (intersectionPoints.first.x - intersectionPoints.last.x).abs() > size.x * 0.4 && jumpForce > 0) {
          isCollidingTop = true;
        }
  
        //Horizontal Collision
        if (individualIntersectionPoint.y < (position.y - (size.y * 0.3))) {
          //print("isCollidingHotizontally");
          //create right collision
          if (individualIntersectionPoint.x > position.x) {
            isCollidingRight = true;
          } else {
            isCollidingLeft = true;
          }
        }
      });
  }

  void jumpingLogic(){
    if (jumpForce > 0) {
      position.y -= jumpForce;
      jumpForce -= GameMethods.instance.blockSize.x * 0.10;
      if (isCollidingTop) {
        jumpForce = 0;
      }
    }
  }

  void fallingLogic(double dt){

    if (!isCollidingBottom) {
      if (yVelocity < (GameMethods.instance.gravity * dt) * 10) { //place a limit to the yVelocity //5
        position.y += yVelocity;
        yVelocity += GameMethods.instance.gravity * dt;
      } else {
        position.y += yVelocity;
      }
    }
  }

  void setAllCollisionsToFalse(){
    isCollidingBottom = false;
    isCollidingRight = false;
    isCollidingLeft = false;
    isCollidingTop = false;
  }

  void move(ComponentMotionState componentMotionState, double dt, double speed) {
    switch (componentMotionState) {
      case ComponentMotionState.walkingLeft:
        if(!isCollidingLeft){
          position.x -= speed; //moving the player to the Left * speed
          if (isFacingRight) {
            flipHorizontallyAroundCenter();
            isFacingRight = false;
          }
        }
        break;
      case ComponentMotionState.walkingRight:
        if(!isCollidingRight) {
          position.x += speed; //moving the player to the Left * speed
          if (!isFacingRight) {
            flipHorizontallyAroundCenter();
            isFacingRight = true;
          }
        }
        break;
      default: 
        break;  //if its defoult it will do nothing
    }
  }

  


}

