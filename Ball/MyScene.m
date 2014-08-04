//
//  MyScene.m
//  Ball
//
//  Created by Matheus Cardoso on 7/24/14.
//  Copyright (c) 2014 Matheus Cardoso. All rights reserved.
//

#import "MyScene.h"

const uint32_t RIGHT_BALL = 0x1 << 0;
const uint32_t WRONG_BALL = 0x1 << 1;
const uint32_t SPECIAL_BALL = 0x1 << 2;
const uint32_t WORLD = 0x1 << 3;
const uint32_t CURSOR = 0x1 << 4;

const float TIME_INTERVAL = 0.35;
const float HEIGHT_SPAWN = 144.0;
const CGPoint INITIAL_TOUCH = {160.0, 280.0};

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {

        self.backgroundColor = [SKColor colorWithRed:0.485 green:0.485 blue:0.489 alpha:1.0];
        self.name = @"world";
        
		self.physicsWorld.contactDelegate = self;
		self.physicsWorld.gravity = CGVectorMake(0.0, -3.0);
		self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
		self.physicsBody.categoryBitMask = WORLD;
//		self.physicsBody.collisionBitMask = WORLD;
        _cont = 0;
        
//        _tempCast = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL
//                                                     target:self
//                                                   selector:@selector(releaseBall)
//                                                   userInfo:nil
//                                                    repeats:YES];
//
    }
    
    return self;
}


//  TOUCHES ------
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isRunning = YES;
    
    if (self.scene.view.paused) {
        self.scene.view.paused = NO;
        _tempCast = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL
                                                     target:self
                                                   selector:@selector(releaseBall)
                                                   userInfo:nil
                                                    repeats:YES];
    }
    
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"MyTestParticle" ofType:@"sks"];
    
    SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    myParticle.particlePosition = [self convertPointFromView:[[touches anyObject] locationInView:self.view]];
    myParticle.name = @"cursor";
    myParticle.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:myParticle.frame.size.height];
    myParticle.physicsBody.categoryBitMask = CURSOR;
    myParticle.physicsBody.collisionBitMask = WRONG_BALL|RIGHT_BALL;
    myParticle.physicsBody.usesPreciseCollisionDetection = YES;
//    myParticle.physicsBody.contactTestBitMask = WRONG_BALL|RIGHT_BALL;
    myParticle.physicsBody.dynamic = YES;
    
    [self addChild:myParticle];
    
    if(_points == nil){
        _points = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
        _points.center = CGPointMake(self.frame.origin.x + self.view.frame.size.width - _points.frame.size.width/2, self.view.frame.origin.y + self.view.frame.size.height - _points.frame.size.height/2);
        _points.text = @"PONTOS";
        [self.view addSubview:_points];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self currentPointSetter:touches];
    
    SKEmitterNode *test = (SKEmitterNode*)[self childNodeWithName:@"cursor"];
    test.particlePosition = _currentPoint;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self currentPointSetter:touches];
    
    if (!self.scene.view.paused) {
        self.scene.view.paused = YES;
        _isRunning = NO;
        [(SKEmitterNode*)[self childNodeWithName:@"cursor"] removeFromParent];
        [_tempCast invalidate];
        
    } else {
        [(SKEmitterNode*)[self childNodeWithName:@"cursor"] removeFromParent];
    }
}


-(void)update:(CFTimeInterval)currentTime
{
    SKSpriteNode *block = (SKSpriteNode*)[self nodeAtPoint:_currentPoint];
    
    if([block.name isEqualToString:@"bola"]){
        block.name = @"bola_done";
        block.color = [UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1];
        _points.text = [NSString stringWithFormat:@"%d", _points.text.intValue+50];
    }
    else if([block.name isEqualToString:@"block"]){
        _isRunning = NO;
        [_tempCast invalidate];
//        [self ending];
    }
    
}


-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"%@, %@", contact.bodyA, contact.bodyB);
}


//  Point setter
-(void)currentPointSetter:(NSSet *)touches
{
    UITouch *anyTouch = [touches anyObject];
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    touchLocation = [self convertPointFromView:touchLocation];
    _currentPoint = touchLocation;
}

-(void)releaseBall
{
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"ball"]];
    sprite.xScale = 0.5;
    sprite.yScale = 0.5;
    
    _randomSpawn = rand() %(int)(self.view.frame.origin.x + self.view.bounds.size.width - sprite.size.width);
    _randomSpawn = _randomSpawn + self.view.frame.origin.x + sprite.size.width/2;
    
    sprite.position = [self quadrante];
    
    _cont++;
    
    if(_cont == 4) {
        sprite.name = @"bola";
        sprite.color = [UIColor colorWithRed:0.4 green:0.6 blue:0.8 alpha:1];
        [sprite setColorBlendFactor:1];
        
        _cont = 0;
    } else {
        sprite.name = @"block";
    }
    
    [self addChild:sprite];
    
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.height center:sprite.position];
    
    
    if(_cont == 4) {
        sprite.physicsBody.categoryBitMask = RIGHT_BALL;
    } else {
        sprite.physicsBody.categoryBitMask = WRONG_BALL;
    }
    sprite.physicsBody.collisionBitMask = WRONG_BALL|RIGHT_BALL|CURSOR;
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.usesPreciseCollisionDetection = YES;
//    sprite.physicsBody.contactTestBitMask = WRONG_BALL;
    [sprite.physicsBody applyImpulse:CGVectorMake(0.0, -1.44)];
    
//    SKAction *action = [SKAction moveToY:(0.0 - sprite.size.height) duration:2.0];
//    [self addChild:sprite];
//    
//    [sprite runAction:[SKAction sequence:@[action,[SKAction removeFromParent]]]];
//    
//    if(!_isRunning){
//        
//    }

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

    quad = CGPointMake(point, self.view.frame.origin.y + self.view.bounds.size.height + HEIGHT_SPAWN);
    
    return quad;
}

-(void)wrongBall: (SKSpriteNode *)sprite
{
    [sprite.physicsBody applyImpulse:CGVectorMake(0.0, 0.05)];
}
//
//-(void)ending
//{
//    BOOL carry = NO;
//    
//    for(SKNode *nodo in [self children]) {
//        if(!carry) {
//            [nodo removeAllActions];
//            [nodo runAction:[SKAction moveToX:0.0 - nodo.frame.size.width duration:0.2]];
//            carry = YES;
//        } else {
//            [nodo removeAllActions];
//            [nodo runAction:[SKAction moveToX:0 + self.view.frame.size.width + nodo.frame.size.width duration:0.5]];
//            carry = NO;
//        }
//    }
//}

@end
