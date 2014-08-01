//
//  ERGPlayer.h
//  Endless Runner
//
//  Created by Jian Ma on 26.10.13.
//  Copyright (c) 2013 Dmitry Volevodz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ERGPlayer : SKSpriteNode

@property (assign, nonatomic) BOOL selected;
@property (assign, nonatomic) BOOL accelerating;
@property (strong, nonatomic) NSMutableArray *runFrames;
@property (strong, nonatomic) NSMutableArray *jumpFrames;
@property (strong, nonatomic) NSMutableArray *shieldOnFrames;
@property (strong, nonatomic) NSMutableArray *shieldOffFrames;
@property (assign, nonatomic) int animationState;
@property (strong, nonatomic) SKSpriteNode *shield;
@property (assign, nonatomic) BOOL shielded;

@property (strong, nonatomic) SKEmitterNode *engineEmitter;

- (void) takeDamage;
@end
