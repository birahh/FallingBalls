//
//  Cursor.m
//  Ball
//
//  Created by BiraHH on 01/08/14.
//  Copyright (c) 2014 Matheus Cardoso. All rights reserved.
//

#import "Cursor.h"

const uint32_t RIGHT_BALL = 0x1 << 0;
const uint32_t WRONG_BALL = 0x1 << 1;
const uint32_t SPECIAL_BALL = 0x1 << 2;
const uint32_t CURSOR = 0x1 << 3;

@implementation Cursor

-(id)init
{
    if(self = [super init]) {
        
        NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"MyTestParticle" ofType:@"sks"];
        
        SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
        myParticle.name = @"cursor";
        myParticle.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:myParticle.frame.size.height];
        myParticle.physicsBody.categoryBitMask = CURSOR;
        myParticle.physicsBody.collisionBitMask = WRONG_BALL|RIGHT_BALL|SPECIAL_BALL;
        myParticle.physicsBody.usesPreciseCollisionDetection = YES;
        myParticle.physicsBody.dynamic = YES;
        
        self = (Cursor*)myParticle;

    }
    
    return self;
}

@end
