//
//  ERGMyScene.m
//  Endless Runner
//
//  Created by Jian Ma on 13.7.14.
//  Copyright (c) 2013 Dmitry Volevodz. All rights reserved.
//

#import "ERGMyScene.h"
#import "ERGBackground.h"
#import "Common.h"
#import "ERGPlayer.h"
#import "ERGEnemy.h"
#import "ERGPowerup.h"
#import "ERGGameOverScene.h"

@implementation ERGMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.currentBackground = [ERGBackground generateNewBackground];
        [self addChild:self.currentBackground];
        
        self.currentParallax = [ERGBackground generateNewParallax];
        [self addChild:self.currentParallax];
        
        ERGPlayer *player = [[ERGPlayer alloc] init];
        player.position = CGPointMake(100, 68);
        [self addChild:player];
        
        self.score = 0;
        self.scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        self.scoreLabel.fontSize = 15;
        self.scoreLabel.color = [UIColor whiteColor];
        self.scoreLabel.position = CGPointMake(20, 300);
        self.scoreLabel.zPosition = 100;
        
        [self addChild:self.scoreLabel];
            
        SKAction *tempAction = [SKAction runBlock:^{
            self.scoreLabel.text = [NSString stringWithFormat:@"%3.0f", self.score];
        }];
        
        SKAction *waitAction = [SKAction waitForDuration:0.2];
        [self.scoreLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[tempAction, waitAction]]]];

        self.physicsWorld.gravity = CGVectorMake(0, globalGravity);
        self.physicsWorld.contactDelegate = self;
        
        // Initial the enemies and powerups
        for (int i = 0; i < maximumEnemies; i++) {
            [self addChild:[self spawnEnemy]];
        }
        for (int i = 0; i < maximumPowerups; i++) {
            [self addChild:[self spawnPowerup]];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOver) name:@"playerDied" object:nil];
        
        [self setupMusic];
    }
    return self;
}

- (void) adjustBaseline
{
    self.baseline = self.manager.accelerometerData.acceleration.x;
}

- (void) setupMusic
{
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"mp3"];
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:musicPath] error:NULL];
    self.musicPlayer.numberOfLoops = -1;
    self.musicPlayer.volume = 1.0;
    [self.musicPlayer play];
}

- (void) gameOver
{
    [self.musicPlayer stop];
    ERGGameOverScene *newScene = [[ERGGameOverScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:0.5];
    transition.pausesOutgoingScene = YES;
    [self.view presentScene:newScene transition:transition];
    
}

- (ERGEnemy *) spawnEnemy
{
    ERGEnemy *temp = [[ERGEnemy alloc] init];
    temp.name = @"enemy";
    temp.position = CGPointMake(self.size.width + arc4random() % 800, arc4random() % 240 + 40);
    return temp;
}

- (ERGPowerup *) spawnPowerup
{
    ERGPowerup *temp = [[ERGPowerup alloc] init];
    temp.name = @"shieldPowerup";
    temp.position = CGPointMake(self.size.width + arc4random() % 100, arc4random() % 240 + 40);
    return temp;
}


- (void) didBeginContact:(SKPhysicsContact *)contact
{
    ERGPlayer *player = nil;
    if (contact.bodyA.categoryBitMask == playerBitmask) {
        player = (ERGPlayer *) contact.bodyA.node;
        if (contact.bodyB.categoryBitMask == shieldPowerupBitmask) {
            player.shielded = YES;
            contact.bodyB.node.hidden = YES;
            self.score += 5;
        }
        if (contact.bodyB.categoryBitMask == enemyBitmask) {
            [player takeDamage];
            contact.bodyB.node.hidden = YES;
        }
    } else {
        player = (ERGPlayer *) contact.bodyB.node;
        if (contact.bodyA.categoryBitMask == shieldPowerupBitmask) {
            player.shielded = YES;
            contact.bodyA.node.hidden = YES;
            self.score += 5;
        }
        if (contact.bodyA.categoryBitMask == enemyBitmask) {
            [player takeDamage];
            contact.bodyA.node.hidden = YES;
        }
    }
}
- (void) didMoveToView:(SKView *)view
{
    UILongPressGestureRecognizer *tapper = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScreen:)];
    tapper.minimumPressDuration = 0.05;
    [view addGestureRecognizer:tapper];
}


-(void)willMoveFromView:(SKView *)view
{
    [view removeGestureRecognizer:self.tapper];
//    for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
//        [view removeGestureRecognizer:recognizer];
//    }
}

- (void) tappedScreen:(UITapGestureRecognizer *)recognizer
{
    ERGPlayer *player = (ERGPlayer *)[self childNodeWithName:@"player"];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        player.accelerating = YES;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        player.accelerating = NO;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    [self enumerateChildNodesWithName:backgroundName usingBlock:^(SKNode *node, BOOL *stop) {
        node.position = CGPointMake(node.position.x - backgroundMoveSpeed * timeSinceLast, node.position.y);
        if (node.position.x < - (node.frame.size.width + 100)) {
            // if the node went completely off screen (with some extra pixels)
            // remove it
            [node removeFromParent];
        }}];
    if (self.currentBackground.position.x < -500) {
        // we create new background node and set it as current node
        ERGBackground *temp = [ERGBackground generateNewBackground];
        temp.position = CGPointMake(self.currentBackground.position.x + self.currentBackground.frame.size.width, 0);
        [self addChild:temp];
        self.currentBackground = temp;
    }
    
    [self enumerateChildNodesWithName:parallaxName usingBlock:^(SKNode *node, BOOL *stop) {
        node.position = CGPointMake(node.position.x - parallaxMoveSpeed * timeSinceLast, node.position.y);
        if (node.position.x < - (node.frame.size.width + 100)) {
            // if the node went completely off screen (with some extra pixels)
            // remove it
            [node removeFromParent];
        }}];
    if (self.currentParallax.position.x < -500) {
        // we create new background node and set it as current node
        ERGBackground *temp = [ERGBackground generateNewParallax];
        temp.position = CGPointMake(self.currentParallax.position.x + self.currentParallax.frame.size.width, 0);
        [self addChild:temp];
        self.currentParallax = temp;
    }

    self.score = self.score + (backgroundMoveSpeed * timeSinceLast / 100);
    
    [self enumerateChildNodesWithName:@"player" usingBlock:^(SKNode *node, BOOL *stop) {
        ERGPlayer *player = (ERGPlayer *)node;
        if (player.accelerating) {
            [player.physicsBody applyForce:CGVectorMake(0, playerJumpForce * timeSinceLast)];
            player.animationState = playerStateJumping;
        } else if (player.position.y < 75) {
            player.animationState = playerStateRunning;
        }
    }];
    
    [self enumerateChildNodesWithName:@"enemy" usingBlock:^(SKNode *node, BOOL *stop) {
        ERGEnemy *enemy = (ERGEnemy *) node;
        enemy.position = CGPointMake(enemy.position.x - backgroundMoveSpeed * timeSinceLast, enemy.position.y);
        
        if (enemy.position.x < -200) {
            enemy.position = CGPointMake(self.size.width + arc4random() % 800, arc4random() % 240 + 40);
            enemy.hidden = NO;
        }
    }];
    
    [self enumerateChildNodesWithName:@"shieldPowerup" usingBlock:^(SKNode *node, BOOL *stop) {
        ERGPowerup *shield = (ERGPowerup *) node;
        shield.position = CGPointMake(shield.position.x - backgroundMoveSpeed * timeSinceLast, shield.position.y);
        
        if (shield.position.x < -200) {
            shield.position = CGPointMake(self.size.width + arc4random() % 100, arc4random() % 240 + 40);
            shield.hidden = NO;
        }
    }];
    
    
}

@end
