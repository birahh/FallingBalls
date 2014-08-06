//
//  Ball.h
//  Ball
//
//  Created by BiraHH on 01/08/14.
//  Copyright (c) 2014 Matheus Cardoso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    rightBall,
    wrongBall,
    specialBall
} BallType;

typedef enum : uint32_t {
    righBallMask = 0x1 << 0,
    wrongBallMask = 0x1 << 1,
    specialBallMask = 0x1 << 2,
    cursorBallMask = 0x1 << 3
} BallCollisionType;

@interface Ball : SKSpriteNode

@property (nonatomic) BallType ballType;

-(id)initWithType:(BallType) type;
-(void)fall;

@end
