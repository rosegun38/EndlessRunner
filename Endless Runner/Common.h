//
//  common.h
//  Endless Runner
//
//  Created by Jian Ma on 26.10.13.
//  Copyright (c) 2013 Dmitry Volevodz. All rights reserved.
//

#ifndef Endless_Runner_common_h
#define Endless_Runner_common_h

static NSString *backgroundName = @"background";
static NSString *parallaxName = @"parallax";
static NSInteger parallaxMoveSpeed = 10;
static NSString *playerName = @"player";
static NSInteger backgroundMoveSpeed = 200;
static NSInteger accelerometerMultiplier = 15;
static NSInteger playerMass = 50;
static NSInteger playerCollisionBitmask = 1;
static NSInteger playerJumpForce = 1500000;
static NSInteger globalGravity = -2.8;

const static int playerBitmask = 1;
const static int enemyBitmask = 2;
const static int shieldPowerupBitmask = 4;
const static int groundBitmask = 8;

const static NSInteger maximumEnemies = 3;
const static NSInteger maximumPowerups = 1;

typedef enum playerState {
    
    playerStateRunning = 0,
    playerStateJumping,
    playerStateInAir
    
} playerState;


#endif
