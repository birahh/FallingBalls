//
//  Ball.m
//  Ball
//
//  Created by BiraHH on 01/08/14.
//  Copyright (c) 2014 Matheus Cardoso. All rights reserved.
//

#import "Ball.h"

const uint32_t RIGHT_BALL = 0x1 << 0;
const uint32_t WRONG_BALL = 0x1 << 1;
const uint32_t SPECIAL_BALL = 0x1 << 2;
const uint32_t CURSOR = 0x1 << 3;

@implementation Ball

-(id)initWithType:(BallType) type
{
    if(self = [super init]) {
        _ballType = type;
        
        switch (type) {
            case rightBall:
                self.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"premierball"]];
                self.yScale = 0.125;
                self.xScale = 0.125;
                self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.texture.size.height center:self.position];
                self.physicsBody.categoryBitMask = RIGHT_BALL;
                self.physicsBody.collisionBitMask = RIGHT_BALL|WRONG_BALL|SPECIAL_BALL|CURSOR;
                break;
                
            case specialBall:
                self.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"ultraball"]];
                self.yScale = 0.125;
                self.xScale = 0.125;
                self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.texture.size.height center:self.position];
                self.physicsBody.categoryBitMask = SPECIAL_BALL;
                self.physicsBody.collisionBitMask = RIGHT_BALL|WRONG_BALL|SPECIAL_BALL|CURSOR;
                break;
                
            case wrongBall:
                self.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"pokeball"]];
                self.yScale = 0.125;
                self.xScale = 0.125;
                self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.texture.size.height center:self.position];
                self.physicsBody.categoryBitMask = WRONG_BALL;
                self.physicsBody.collisionBitMask = RIGHT_BALL|WRONG_BALL|SPECIAL_BALL|CURSOR;
                break;
                
            default:
                break;
        }
    }
    
    return self;
}

-(void)fall
{
    [self.physicsBody applyImpulse:CGVectorMake(0.0, -1.44)];
}

@end
