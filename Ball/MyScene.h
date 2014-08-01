//
//  MyScene.h
//  Ball
//

//  Copyright (c) 2014 Matheus Cardoso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene
@property int cont;
@property BOOL isRunning;
@property NSTimer *tempCast;
@property CGPoint currentPoint;
@property int randomSpawn;
@property UILabel *points;
@property SKEmitterNode *cursor;

@end
