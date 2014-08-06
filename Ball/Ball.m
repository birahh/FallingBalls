//
//  Ball.m
//  Ball
//
//  Created by BiraHH on 01/08/14.
//  Copyright (c) 2014 Matheus Cardoso. All rights reserved.
//

#import "Ball.h"

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
                self.physicsBody.categoryBitMask = righBallMask;
                self.physicsBody.collisionBitMask = righBallMask|wrongBallMask|specialBallMask|cursorBallMask;
                break;
                
            case specialBall:
                self.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"ultraball"]];
                self.yScale = 0.125;
                self.xScale = 0.125;
                self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.texture.size.height center:self.position];
                self.physicsBody.categoryBitMask = specialBallMask;
                self.physicsBody.collisionBitMask = righBallMask|wrongBallMask|specialBallMask|cursorBallMask;
                break;
                
            case wrongBall:
                self.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"pokeball"]];
                self.yScale = 0.125;
                self.xScale = 0.125;
                self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.texture.size.height center:self.position];
                self.physicsBody.categoryBitMask = wrongBallMask;
                self.physicsBody.collisionBitMask = righBallMask|wrongBallMask|specialBallMask|cursorBallMask;
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
