//
//  MyScene.h
//  Ball
//

//  Copyright (c) 2014 Matheus Cardoso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate>

@property int cont;
@property int randomSpawn;

@property CGPoint currentPoint;
@property CGPoint lastPoint;

@property BOOL isRunning;
@property NSTimer *tempCast;
@property UILabel *points;
@property SKEmitterNode *cursor;

@end
