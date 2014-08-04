//
//  Spawner.m
//  Ball
//
//  Created by BiraHH on 04/08/14.
//  Copyright (c) 2014 Matheus Cardoso. All rights reserved.
//

#import "Spawner.h"

const float HEIGHT_SPAWN = 144.0;

@implementation Spawner

-(id)initTimerWithScene:(SKScene *)scene
{
    _scene = scene;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval
                                                 target:self
                                               selector:@selector(releaseBallsInScene)
                                               userInfo:nil
                                                repeats:YES];
    return self;
}


-(void)releaseBallsInScene
{
    _randomSpawn = rand() %(int)(_scene.view.frame.origin.x + _scene.view.bounds.size.width - 64);
    _randomSpawn = _randomSpawn + _scene.view.frame.origin.x + 32;
    
    _cont++;

    Ball *ball = [Ball alloc];
    
    if(_cont == 4) {
        _cont = 0;
        ball = [[Ball alloc]initWithType: rightBall];
        
    } else {
        ball = [[Ball alloc] initWithType: wrongBall];
    }
    
    ball.position = [self quadrante];
    
    [_scene addChild:ball];
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.height center:ball.position];
    [ball fall];
}


-(CGPoint)quadrante
{
    CGPoint quad;
    int point;
    
    if(_randomSpawn < 64) {
        point = 64 - 31;
    }
    else if (_randomSpawn < 128) {
        point = 128 - 31;
    }
    else if (_randomSpawn < 192) {
        point = 192 - 31;
    }
    else if (_randomSpawn <256) {
        point = 256 - 31;
    }
    else {
        point = 320 - 31;
    }
    
    quad = CGPointMake(point, _scene.view.frame.origin.y + _scene.view.bounds.size.height + HEIGHT_SPAWN);
    
    return quad;
}



@end
