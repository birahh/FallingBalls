//
//  Spawner.h
//  Ball
//
//  Created by BiraHH on 04/08/14.
//  Copyright (c) 2014 Matheus Cardoso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ball.h"

@interface Spawner : NSObject

@property SKScene *scene;
@property NSTimer *timer;
@property float timeInterval;

@property int randomSpawn;
@property int cont;

-(id)initTimerWithScene:(SKScene *)scene AndTimeInterval:(float)timeInterval;
-(void)releaseBallsInScene;

@end
