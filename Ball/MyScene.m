//
//  MyScene.m
//  Ball
//
//  Created by Matheus Cardoso on 7/24/14.
//  Copyright (c) 2014 Matheus Cardoso. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */

        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        _tempCast = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                     target:self
                                                   selector:@selector(releaseBall)
                                                   userInfo:nil
                                                    repeats:YES];
        _cont = 0;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
//  for(SKNode *node in self.children){
//      
//    }
    
    //NSLog(@"%f", sprite.position.x);
    
    //NSLog(@"%f     %f", self.view.frame.origin.x + sprite.size.width/2, self.view.frame.origin.x + self.view.bounds.size.width - sprite.size.width/2);
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *anyTouch = [touches anyObject];
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    touchLocation = [self convertPointFromView:touchLocation];
    SKNode *block = [self nodeAtPoint:touchLocation];
    
//    NSLog(@"%f   , %f", touchLocation.x,touchLocation.y);
    
    if([block.name isEqualToString:@"bola"]){
        NSLog(@"UHUL");
        block.name = @"bola_done";
    }
    else if([block.name isEqualToString:@"block"]){
        NSLog(@"LL");
    }
}

-(void)update:(CFTimeInterval)currentTime {
//    NSArray *child = [self.scene children];
    
    SKSpriteNode *test = (SKSpriteNode *)[self childNodeWithName:@"bola_done"];
    test.color = [UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1];
}
-(void)releaseBall{
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"ball"]];
    sprite.xScale = 0.5;
    sprite.yScale = 0.5;
    
    
    _randomSpawn = rand() %(int)(self.view.frame.origin.x + self.view.bounds.size.width - sprite.size.width);
    _randomSpawn = _randomSpawn + self.view.frame.origin.x + sprite.size.width/2;
    
    
    sprite.position = [self quadrante];
    
    _cont++;
    
    if(_cont == 4){
        sprite.name = @"bola";
        sprite.color = [UIColor colorWithRed:0.4 green:0.6 blue:0.8 alpha:1];
        [sprite setColorBlendFactor:1];
        
        _cont = 0;
    }
    else{
        sprite.name = @"block";
    }
    
    
    SKAction *action = [SKAction moveToY:(0.0 - sprite.size.height) duration:2.0];
    [self addChild:sprite];
    
    [sprite runAction:[SKAction sequence:@[action,[SKAction removeFromParent]]]];
    

}

-(CGPoint)quadrante{
    CGPoint quad;
    int point;
    if(_randomSpawn < 64){
        point = 64 - 31;
    }
    else if (_randomSpawn < 128){
        point = 128 - 31;
    }
    else if (_randomSpawn < 192){
        point = 192 - 31;
    }
    else if (_randomSpawn <256){
        point = 256 - 31;
    }
    else{
        point = 320 - 31;
    }

    quad = CGPointMake(point, self.view.frame.origin.y + self.view.bounds.size.height + 62.5);
    
    return quad;
    
}

@end
