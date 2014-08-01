//
//  ERGGameOverScene.m
//  Endless Runner
//
//  Created by Jason Ma on 14-8-1.
//  Copyright (c) 2014年 Dmitry Volevodz. All rights reserved.
//

#import "ERGGameOverScene.h"
#import "ERGMyScene.h"

@implementation ERGGameOverScene
- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        SKLabelNode *node = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        node.text = @"Game Over";
        node.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        node.fontSize = 35;
        node.color = [UIColor whiteColor];
        [self addChild:node];
        self.scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        self.scoreLabel.fontSize = 15;
        self.scoreLabel.color = [UIColor redColor];
        self.scoreLabel.position = CGPointMake(self.size.width / 2, 80);
        self.scoreLabel.text = [NSString stringWithFormat:@"You can do better"];
        [self addChild:self.scoreLabel];
        [self setupMusic];
    }
    return self;
}

- (void) didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newGame)];
    [view addGestureRecognizer:tapper];
}

-(void) newGame
{
    [self.musicPlayer stop];
    ERGMyScene *newScene = [[ERGMyScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:0.5];
    [self.view presentScene:newScene transition:transition];
}

- (void) setupMusic
{
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"end" ofType:@"mp3"];
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:musicPath] error:NULL];
    self.musicPlayer.numberOfLoops = -1;
    self.musicPlayer.volume = 1.0;
    [self.musicPlayer play];
    
}
@end
