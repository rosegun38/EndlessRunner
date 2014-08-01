//
//  ERGPlayer.m
//  Endless Runner
//
//  Created by Jian Ma on 26.10.13.
//  Copyright (c) 2013 Dmitry Volevodz. All rights reserved.
//

#import "ERGPlayer.h"



@implementation ERGPlayer


-(instancetype)init
{
    self = [super initWithImageNamed:@"character.png"];
    {
        self.name = playerName;
        self.zPosition = 10;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
        self.physicsBody.dynamic = YES;
        self.physicsBody.mass = playerMass;
        self.physicsBody.contactTestBitMask = shieldPowerupBitmask | enemyBitmask;
        self.physicsBody.collisionBitMask = groundBitmask;
        self.physicsBody.categoryBitMask = playerBitmask;
        self.physicsBody.allowsRotation = NO;
        [self setupAnimations];
        [self startRunningAnimation];
        self.shield = [[SKSpriteNode alloc] init];
        self.shield.blendMode = SKBlendModeAdd;
        [self addChild:self.shield];
        // Add engine emitter to the player
        self.engineEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"jet" ofType:@"sks"]];
        self.engineEmitter.position = CGPointMake(-12, 18);
        self.engineEmitter.name = @"jetEmitter";
        [self addChild:self.engineEmitter];
        self.engineEmitter.hidden = YES;
    }
    return self;
}

- (void) setAccelerating:(BOOL)accelerating
{
    if (accelerating) {
        if (self.engineEmitter.hidden) {
            self.engineEmitter.hidden = NO;
        }
    } else {
        self.engineEmitter.hidden = YES;
    }
    _accelerating = accelerating;
}

- (void) setAnimationState:(int)animationState
{
    switch (animationState) {
        case playerStateJumping:
            if (_animationState == playerStateRunning) {
                [self stopRunningAnimation];
                [self startJumpingAnimation];
            }
            break;
        case playerStateInAir:
            [self stopRunningAnimation];
            break;
        case playerStateRunning:
            [self startRunningAnimation];
            break;
        default:
            break;
    }
    _animationState = animationState;
}

- (void) startRunningAnimation
{
    if (![self actionForKey:@"running"]) {
    [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.runFrames timePerFrame:0.05 resize:YES restore:NO]] withKey:@"running"];
    }
}

- (void) stopRunningAnimation
{
    [self removeActionForKey:@"running"];

}

- (void) startJumpingAnimation
{
    if (![self actionForKey:@"jumping"]) {
        [self runAction:[SKAction sequence:@[[SKAction animateWithTextures:self.jumpFrames timePerFrame:0.03 resize:YES restore:NO],[SKAction runBlock:^{
            self.animationState = playerStateInAir;
        }]]] withKey:@"jumping"];
    }
}


- (void) setShielded:(BOOL)shielded
{
    if (shielded) {
        if (![self.shield actionForKey:@"shieldOn"]) {
            [self.shield runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.shieldOnFrames timePerFrame:0.1 resize:YES restore:NO]] withKey:@"shieldOn"];
            SKAction *musicAction = [SKAction playSoundFileNamed:@"powerup.wav" waitForCompletion:NO];
            [self runAction:musicAction];
        }
    } else if (_shielded) {
        [self blinkRed];
        [self.shield removeActionForKey:@"shieldOn"];
        [self.shield runAction:[SKAction animateWithTextures:self.shieldOffFrames timePerFrame:0.15 resize:YES restore:NO] withKey:@"shieldOff"];
        SKAction *musicAction = [SKAction playSoundFileNamed:@"smashed.wav" waitForCompletion:NO];
        [self runAction:musicAction];
    }
    _shielded = shielded;
}

- (void) blinkRed
{
    SKAction *blinkRed = [SKAction sequence:@[
                                              [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.2],
                                              [SKAction waitForDuration:0.1],
                                              [SKAction colorizeWithColorBlendFactor:0.0 duration:0.2]]];
    [self runAction:blinkRed];
}

- (void) takeDamage
{
    if (self.shielded) {
        self.shielded = NO;
    } else {
        self.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playerDied" object:nil];
    }
}

- (void) setupAnimations
{
    self.runFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *runAtlas = [SKTextureAtlas atlasNamed:@"run"];
    
    for (int i = 0; i < [runAtlas.textureNames count]; i++) {
        NSString *tempName = [NSString stringWithFormat:@"run%.3d", i];
        SKTexture *tempTexture = [runAtlas textureNamed:tempName];
        if (tempTexture) {
            [self.runFrames addObject:tempTexture];
        }
    }
    
    self.jumpFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *jumpAtlas = [SKTextureAtlas atlasNamed:@"jump"];
    
    for (int i = 0; i < [jumpAtlas.textureNames count]; i++) {
        NSString *tempName = [NSString stringWithFormat:@"jump%.3d", i];
        SKTexture *tempTexture = [jumpAtlas textureNamed:tempName];
        if (tempTexture) {
            [self.jumpFrames addObject:tempTexture];
        }
    }
    
    self.shieldOnFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *shieldOnAtlas = [SKTextureAtlas atlasNamed:@"shield"];
    
    for (int i = 0; i < [shieldOnAtlas.textureNames count]; i++) {
        NSString *tempName = [NSString stringWithFormat:@"shield%.3d", i];
        SKTexture *tempTexture = [shieldOnAtlas textureNamed:tempName];
        if (tempTexture) {
            [self.shieldOnFrames addObject:tempTexture];
        }
    }
    
    self.shieldOffFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *shieldOffAtlas = [SKTextureAtlas atlasNamed:@"deplete"];
    
    for (int i = 0; i < [shieldOffAtlas.textureNames count]; i++) {
        NSString *tempName = [NSString stringWithFormat:@"deplete%.3d", i];
        SKTexture *tempTexture = [shieldOffAtlas textureNamed:tempName];
        if (tempTexture) {
            [self.shieldOffFrames addObject:tempTexture];
        }
    }
}


@end
