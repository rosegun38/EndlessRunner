//
//  ERGEnemy.h
//  Endless Runner
//
//  Created by Jason Ma on 14-8-1.
//  Copyright (c) 2014年 Dmitry Volevodz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ERGEnemy : SKNode
// add one emitter as our enemy
@property (strong, nonatomic) SKEmitterNode *emitter;
@end
