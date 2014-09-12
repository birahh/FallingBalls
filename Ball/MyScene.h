//
//  MyScene.h
//  Ball
//

//  Copyright (c) 2014 Matheus Cardoso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate>
@property int cont;
@property BOOL isRunning;
@property NSTimeInterval *initialTime;
@property CGPoint currentPoint;
@property int randomSpawn;
@property SKLabelNode *points;
@property SKLabelNode *status;
@property SKEmitterNode *cursor;

@end