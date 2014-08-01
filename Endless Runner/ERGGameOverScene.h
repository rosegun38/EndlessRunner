//
//  ERGGameOverScene.h
//  Endless Runner
//
//  Created by Jason Ma on 14-8-1.
//  Copyright (c) 2014年 Dmitry Volevodz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import AVFoundation;

@interface ERGGameOverScene : SKScene
@property (strong, nonatomic) AVAudioPlayer *musicPlayer;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (assign) double score;

@end
