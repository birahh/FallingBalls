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

@interface Ball : SKSpriteNode

@property (nonatomic) BallType ballType;

-(id)initWithType:(BallType) type;
-(void)fall;

@end
