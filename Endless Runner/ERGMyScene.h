//
//  ERGMyScene.h
//  Endless Runner
//

//  Copyright (c) 2013 Dmitry Volevodz. All rights reserved.
//
@import CoreMotion;
@import AVFoundation;
#import <SpriteKit/SpriteKit.h>

@class ERGBackground;
@interface ERGMyScene : SKScene <SKPhysicsContactDelegate>
@property (strong, nonatomic) ERGBackground *currentBackground;
@property (strong, nonatomic) ERGBackground *currentParallax;
@property (assign) CFTimeInterval lastUpdateTimeInterval;
@property (assign) double score;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) CMMotionManager *manager;
@property (assign) float baseline;
@property (strong, nonatomic) UILongPressGestureRecognizer *tapper;
@property (strong, nonatomic) AVAudioPlayer *musicPlayer;

@end
