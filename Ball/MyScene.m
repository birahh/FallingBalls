//
//  MyScene.m
//  Ball
//
//  Created by Matheus Cardoso on 7/24/14.
//  Copyright (c) 2014 Matheus Cardoso. All rights reserved.
//

#import "MyScene.h"

const uint32_t ENERGY = 0x1 << 0;
const uint32_t METEOR = 0x1 << 1;
const uint32_t CURSOR = 0x1 << 2;
const uint32_t SCREEN_END = 0x1 << 3;
const uint32_t WORLD = 0x1 << 4;

const float DESC = 0.6;

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
		self.physicsWorld.contactDelegate = self;
		self.physicsWorld.gravity = CGVectorMake(0.0, -2.8);
		self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
		self.name = @"world";
		self.physicsBody.categoryBitMask = WORLD;
		self.physicsBody.collisionBitMask = WORLD;
        
        SKAction *action =[SKAction performSelector:@selector(releaseBall) onTarget:self];
        SKAction *delay = [SKAction waitForDuration:0.2];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[action, delay]]]];
        
        self.backgroundColor = [UIColor blackColor];
    
        _BackGround1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"BackGround"]];
        [_BackGround1 setPosition:CGPointMake(self.scene.frame.origin.x + _BackGround1.size.width/2,self.scene.frame.origin.y + _BackGround1.frame.size.height/2)];
        [self addChild:_BackGround1];
        _BackGround1.alpha = 0.5;
        _BackGround1.name = @"Back1";
        
        if(_points == nil){
            _points = [[SKLabelNode alloc] initWithFontNamed:@"Verdana"];
            _points.text = @"0";
            _points.fontSize = 21;
            _points.position = CGPointMake(270, 535);
            [self addChild:_points];
        }
    }
    
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.scene.view.paused) {
        self.scene.view.paused = NO;
        
        SKAction *action =[SKAction performSelector:@selector(releaseBall) onTarget:self];
        SKAction *delay = [SKAction waitForDuration:0.2];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[action, delay]]]];
    }
    
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"MyTestParticle" ofType:@"sks"];
    
    SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    myParticle.particlePosition = [self convertPointFromView:[[touches anyObject] locationInView:self.view]];
    myParticle.name = @"cursor";
    myParticle.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:myParticle.frame.size.height center:CGPointMake(myParticle.position.x+myParticle.frame.size.height/2, myParticle.position.y+myParticle.frame.size.height/2)];
    myParticle.physicsBody.affectedByGravity = NO;
    myParticle.physicsBody.categoryBitMask = CURSOR;
    myParticle.physicsBody.collisionBitMask = METEOR;
    
    
    [self addChild:myParticle];
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *anyTouch = [touches anyObject];
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    touchLocation = [self convertPointFromView:touchLocation];
    _currentPoint = touchLocation;
    
    SKEmitterNode *test = (SKEmitterNode*)[self childNodeWithName:@"cursor"];
    test.particlePosition = [self convertPointFromView:[[touches anyObject] locationInView:self.view]];
}


-(void)update:(CFTimeInterval)currentTime
{
    [_BackGround1 setPosition:CGPointMake(_BackGround1.position.x, _BackGround1.position.y - DESC)];
    
    SKSpriteNode *block = (SKSpriteNode*)[self nodeAtPoint:_currentPoint];
    
    if([block.name isEqualToString:@"bola"]){
        block.name = @"bola_done";
        [block setTexture:[SKTexture textureWithImageNamed:@"Ring 4"]];
        block.xScale = 0.25;
        block.yScale = 0.25;
        
        [self hitTheRightOne:block];
        
        _points.text = [NSString stringWithFormat:@"%d", _points.text.intValue+50];
    }
    else if([block.name isEqualToString:@"block"]){
        
        [block.physicsBody applyImpulse:CGVectorMake(0.0, 25.0)];
        
        //[self Ending];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.scene.view.paused) {
        self.scene.view.paused = YES;
        [self removeAllActions];
        [(SKEmitterNode*)[self childNodeWithName:@"cursor"] removeFromParent];
        [_tempCast invalidate];
        
    } else {
        [(SKEmitterNode*)[self childNodeWithName:@"cursor"] removeFromParent];
    }
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"block" usingBlock:^(SKNode *node, BOOL *stop){if(node.position.y<0){[node removeFromParent];}}];
    [self enumerateChildNodesWithName:@"bola" usingBlock:^(SKNode *node, BOOL *stop){if(node.position.y<0){[node removeFromParent];}}];
}

-(void)releaseBall
{
    SKSpriteNode *sprite;
    
    _cont++;
    
    if(_cont == 4){
        sprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Ring 2"]];
        sprite.name = @"bola";
        sprite.color = [UIColor colorWithRed:0.4 green:0.6 blue:0.8 alpha:1];
        [sprite setColorBlendFactor:1];
        
        sprite.xScale = 0.25;
        sprite.yScale = 0.25;
        _cont = 0;
    }
    else{
        sprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"meteoro1"]];
        sprite.name = @"block";
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
    }
    
    _randomSpawn = rand() %(int)(self.view.frame.origin.x + self.view.bounds.size.width - sprite.size.width);
    _randomSpawn = _randomSpawn + self.view.frame.origin.x + sprite.size.width/2;
    
    sprite.position = [self quadrante];
    
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.frame.size.height center:CGPointMake(sprite.position.x+sprite.frame.size.height/2, sprite.position.y+sprite.frame.size.height/2)];
    sprite.physicsBody.categoryBitMask = METEOR;
    sprite.physicsBody.collisionBitMask = CURSOR;
    
    [self addChild:sprite];
}

-(void)hitTheRightOne: (SKSpriteNode*) one
{
    
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"sks"];
    
    SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    myParticle.particlePosition = _currentPoint;
    myParticle.name = @"boom";
    myParticle.numParticlesToEmit = 64;
    
    [self addChild:myParticle];
    
    [one removeFromParent];
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
    
    quad = CGPointMake(point, self.view.frame.origin.y + self.view.bounds.size.height + 262.5);
    
    return quad;
}

/*-(void)Ending{
    BOOL carry = NO;
    for(SKNode *nodo in [self children]){
        NSLog(@"%lu", self.children.count);
        if(!carry){
            if(![nodo.name isEqualToString:@"Block1"]){
            [nodo removeAllActions];
            [nodo runAction:[SKAction moveToX:0.0 - nodo.frame.size.width duration:0.2]];
            carry = YES;
            }
        }
        else{
            if(![nodo.name isEqualToString:@"Block1"]){
            [nodo removeAllActions];
            [nodo runAction:[SKAction moveToX:0 + self.view.frame.size.width + nodo.frame.size.width duration:0.5]];
            carry = NO;
            }
        }
    }
}*/

@end
