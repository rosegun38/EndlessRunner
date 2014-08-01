//
//  ERGBackground.m
//  Endless Runner
//
//  Created by Jian Ma on 26.10.13.
//  Copyright (c) 2013 Dmitry Volevodz. All rights reserved.
//

#import "ERGBackground.h"

@implementation ERGBackground

+ (ERGBackground *)generateNewBackground
{
    ERGBackground *background = [[ERGBackground alloc] initWithImageNamed:@"background.png"];
    background.anchorPoint = CGPointMake(0, 0);
    background.name = backgroundName;
    background.position = CGPointMake(0, 0);
    background.zPosition = 5;
    background.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 34) toPoint:CGPointMake(background.size.width, 34)];
    background.physicsBody.collisionBitMask = playerCollisionBitmask;
    SKNode *topCollider = [SKNode node];
    topCollider.position = CGPointMake(0, 0);
    topCollider.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, background.size.height - 30) toPoint:CGPointMake(background.size.width, background.size.height - 30)];
    topCollider.physicsBody.collisionBitMask = 1;
    [background addChild:topCollider];
    
    return background;
}

+ (ERGBackground *)generateNewParallax
{
    ERGBackground *background = [[ERGBackground alloc] initWithImageNamed:@"parallax.png"];
    background.anchorPoint = CGPointMake(0, 0);
    background.name = parallaxName;
    background.position = CGPointMake(0, 0);
    background.zPosition = 4;
    return background;
}


@end
