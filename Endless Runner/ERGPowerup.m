//
//  ERGPowerup.m
//  Endless Runner
//
//  Created by Jason Ma on 14-8-1.
//  Copyright (c) 2014年 Dmitry Volevodz. All rights reserved.
//

#import "ERGPowerup.h"

@implementation ERGPowerup
- (void) setup
{
    self.emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"powerup" ofType:@"sks"]];
    self.emitter.name = @"shieldEmitter";
    self.emitter.zPosition = 50;
    [self addChild:self.emitter];
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20];
    self.physicsBody.contactTestBitMask = playerBitmask;
    self.physicsBody.categoryBitMask = shieldPowerupBitmask;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.affectedByGravity = NO;
}
@end
