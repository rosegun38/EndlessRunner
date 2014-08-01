//
//  ERGViewController.m
//  Endless Runner
//
//  Created by Jian Ma on 13.7.14.
//  Copyright (c) 2013 Dmitry Volevodz. All rights reserved.
//

#import "ERGViewController.h"
#import "ERGMyScene.h"

@implementation ERGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void) viewWillLayoutSubviews
{
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    if (!skView.scene) {
        SKScene * scene = [ERGMyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
            
        // Present the scene.
        
        [skView presentScene:scene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
