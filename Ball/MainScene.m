//
//  MainScene.m
//  Ball
//
//  Created by BiraHH on 01/08/14.
//  Copyright (c) 2014 Matheus Cardoso. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _spawner = [[Spawner alloc] initTimerWithScene:self];
    [_spawner releaseBallsInScene];
    
    _cursor = [[Cursor alloc] init];
    [self positionRefresh:touches];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self positionRefresh:touches];
}


//  Auxiliar Methods
-(void)positionRefresh:(NSSet *)touches
{
    _cursor.position = [[touches anyObject] locationInView:self.view];
}

@end
