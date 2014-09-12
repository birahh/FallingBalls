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
		self.physicsWorld.contactDelegate = self;
		self.physicsWorld.gravity = CGVectorMake(0.0, -2);
		self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
		self.name = @"world";
		self.physicsBody.categoryBitMask = WORLD;
		self.physicsBody.collisionBitMask = WORLD;
        
        SKAction *action =[SKAction performSelector:@selector(releaseBall) onTarget:self];
        SKAction *delay = [SKAction waitForDuration:0.2];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[action, delay]]]];
        
        [self parallaxBackground];
        
        self.backgroundColor = [UIColor colorWithRed:0.06 green:0.09 blue:0.12 alpha:1];
        
        if(_points == nil){
            _points = [[SKLabelNode alloc] initWithFontNamed:@"Verdana"];
            _points.text = @"0";
            _points.fontSize = 21;
            _points.position = CGPointMake(270, 535);
            _points.zPosition = 300;
            [self addChild:_points];
        }
        if(_status == nil){
            _status = [[SKLabelNode alloc] initWithFontNamed:@"Verdana"];
            _status.text = @"";
            _status.fontSize = 34;
            _status.position = CGPointMake(self.size.width/2, 512);
            _status.zPosition = 300;
            [self addChild:_status];
        }
    }
    
    return self;
}

#pragma mark - Touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
    if (self.scene.view.paused) {
        
        UITouch *anyTouch = [touches anyObject];
        CGPoint touchLocation = [anyTouch locationInView:self.view];
        touchLocation = [self convertPointFromView:touchLocation];
        
        if ([self isDistanceOfTouchRight:touchLocation]) {
            
            self.scene.view.paused = NO;
            
            [self enumerateChildNodesWithName:@"pause-screen" usingBlock:^(SKNode *node, BOOL *stop){[node removeFromParent];}];
            
            [self enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop){[node removeFromParent];}];
            
            _points.fontSize = 21;
            _points.position = CGPointMake(270, 535);
            
            _status.text = @"";
            
            [self parallaxBackground];
            SKAction *action =[SKAction performSelector:@selector(releaseBall) onTarget:self];
            SKAction *delay = [SKAction waitForDuration:0.2];
            [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[action, delay]]]];
        }
    }

    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"Cursor" ofType:@"sks"];

    SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    myParticle.particlePosition = [self convertPointFromView:[[touches anyObject] locationInView:self.view]];
    myParticle.name = @"cursor";
    myParticle.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:myParticle.frame.size.height center:CGPointMake(myParticle.position.x+myParticle.frame.size.height/2, myParticle.position.y+myParticle.frame.size.height/2)];
    myParticle.physicsBody.affectedByGravity = NO;
    myParticle.physicsBody.categoryBitMask = CURSOR;
    myParticle.physicsBody.collisionBitMask = METEOR;
    myParticle.zPosition = 200;

    [self addChild:myParticle];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
     
    UITouch *anyTouch = [touches anyObject];
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    touchLocation = [self convertPointFromView:touchLocation];
    _currentPoint = touchLocation;
    
    SKEmitterNode *test = (SKEmitterNode*)[self childNodeWithName:@"cursor"];
    test.particlePosition = [self convertPointFromView:[[touches anyObject] locationInView:self.view]];
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.scene.view.paused) {
        
        [self runAction:[SKAction sequence:@[
            [SKAction runBlock:^{
                UITouch *anyTouch = [touches anyObject];
                CGPoint touchLocation = [anyTouch locationInView:self.view];
                touchLocation = [self convertPointFromView:touchLocation];
                _currentPoint = touchLocation;
                
                SKSpriteNode *pauseSprite = [[SKSpriteNode alloc] initWithImageNamed:@"pause-screen"];
                pauseSprite.name = @"pause-screen";
                pauseSprite.zPosition = 250;
                pauseSprite.alpha = 0.89;
                [pauseSprite setPosition:touchLocation];
                
                [self addChild:pauseSprite];
            
                _points.fontSize = 34;
                _points.position = CGPointMake(self.size.width/2, 35);
            
                _status.text = @"Paused";
            }],

            [SKAction waitForDuration:0.0013],

            [SKAction runBlock:^{

                [self enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop){[node removeFromParent];}];
                [(SKEmitterNode*)[self childNodeWithName:@"cursor"] removeFromParent];
                
                self.scene.view.paused = YES;
                [self removeAllActions];
            }]
        ]]];
        
        
    } else {
        [(SKEmitterNode*)[self childNodeWithName:@"cursor"] removeFromParent];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - Update + Physics
-(void)update:(NSTimeInterval)currentTime
{
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
    }
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"block" usingBlock:^(SKNode *node, BOOL *stop){if(node.position.y<0){[node removeFromParent];}}];
    [self enumerateChildNodesWithName:@"bola" usingBlock:^(SKNode *node, BOOL *stop){if(node.position.y<0){[node removeFromParent];}}];
    [self enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop){if(node.position.y<-1024){[node removeFromParent];}}];
}

#pragma mark - Parallax
-(void)parallaxBackground
{
    SKAction *backgroundCimaAction = [SKAction runBlock:^{
        
        //  REALLY-FAR
        SKSpriteNode *backgroundCima = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"really-far"]];
        [backgroundCima setPosition:CGPointMake(self.scene.frame.origin.x + backgroundCima.size.width/2,self.scene.frame.origin.y + backgroundCima.frame.size.height/2)];
        backgroundCima.name = @"background";
        backgroundCima.zPosition = 34;
        [self addChild:backgroundCima];
        
        [backgroundCima runAction:[SKAction moveBy:CGVectorMake(0, -backgroundCima.frame.size.height*3) duration:5702887]];
        
        //  FAR
        backgroundCima = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"far-left"]];
        [backgroundCima setPosition:CGPointMake(self.scene.frame.origin.x + backgroundCima.size.width/2, self.scene.frame.origin.y + backgroundCima.frame.size.height + backgroundCima.frame.size.height/2)];
        backgroundCima.name = @"background";
        backgroundCima.zPosition = 55;
        [self addChild:backgroundCima];
        
        [backgroundCima runAction:[SKAction moveBy:CGVectorMake(0, -backgroundCima.frame.size.height*3) duration:377]];
        
        //  NOT-SO-FAR
        backgroundCima = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"not-so-far-left"]];
        [backgroundCima setPosition:CGPointMake(self.scene.frame.origin.x + backgroundCima.size.width/2, self.scene.frame.origin.y + backgroundCima.frame.size.height + backgroundCima.frame.size.height/2)];
        backgroundCima.name = @"background";
        backgroundCima.zPosition = 89;
        [self addChild:backgroundCima];
        
        [backgroundCima runAction:[SKAction moveBy:CGVectorMake(0, -backgroundCima.frame.size.height*3) duration:233]];
        
        //  NEAR
        backgroundCima = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"near-left"]];
        [backgroundCima setPosition:CGPointMake(self.scene.frame.origin.x + backgroundCima.size.width/2, self.scene.frame.origin.y + backgroundCima.frame.size.height + backgroundCima.frame.size.height/2)];
        backgroundCima.name = @"background";
        backgroundCima.zPosition = 144;
        [self addChild:backgroundCima];
        
        [backgroundCima runAction:[SKAction moveBy:CGVectorMake(0, -backgroundCima.frame.size.height*3) duration:144]];
    }];
    
    SKAction *backgroundBaixoAction = [SKAction runBlock:^{
        
        //  REALLY-FAR
        SKSpriteNode *backgroundBaixo = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"really-far"]];
        [backgroundBaixo setPosition:CGPointMake(self.scene.frame.origin.x + backgroundBaixo.size.width/2,self.scene.frame.origin.y + backgroundBaixo.frame.size.height/2)];
        backgroundBaixo.name = @"background";
        backgroundBaixo.zPosition = 34;
        [self addChild:backgroundBaixo];
        
        [backgroundBaixo runAction:[SKAction moveBy:CGVectorMake(0, -backgroundBaixo.frame.size.height*3) duration:5702887]];
        
        //  FAR
        backgroundBaixo = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"far-left"]];
        [backgroundBaixo setPosition:CGPointMake(self.scene.frame.origin.x + backgroundBaixo.size.width/2,self.scene.frame.origin.y + backgroundBaixo.frame.size.height/2)];
        backgroundBaixo.name = @"background";
        backgroundBaixo.zPosition = 55;
        [self addChild:backgroundBaixo];
        
        [backgroundBaixo runAction:[SKAction moveBy:CGVectorMake(0, -backgroundBaixo.frame.size.height*3) duration:377]];
        
        //  NOT-SO-FAR
        backgroundBaixo = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"not-so-far-left"]];
        [backgroundBaixo setPosition:CGPointMake(self.scene.frame.origin.x + backgroundBaixo.size.width/2,self.scene.frame.origin.y + backgroundBaixo.frame.size.height/2)];
        backgroundBaixo.name = @"background";
        backgroundBaixo.zPosition = 89;
        [self addChild:backgroundBaixo];
        
        [backgroundBaixo runAction:[SKAction moveBy:CGVectorMake(0, -backgroundBaixo.frame.size.height*3) duration:233]];
        
        //  NEAR
        backgroundBaixo = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"near-left"]];
        [backgroundBaixo setPosition:CGPointMake(self.scene.frame.origin.x + backgroundBaixo.size.width/2,self.scene.frame.origin.y + backgroundBaixo.frame.size.height/2)];
        backgroundBaixo.name = @"background";
        backgroundBaixo.zPosition = 144;
        [self addChild:backgroundBaixo];
        
        [backgroundBaixo runAction:[SKAction moveBy:CGVectorMake(0, -backgroundBaixo.frame.size.height*3) duration:144]];
    }];
    
    SKAction *backgroundsAction = [SKAction runBlock:^{
        [self runAction:backgroundCimaAction];
        [self runAction:backgroundBaixoAction];
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:55], backgroundCimaAction]]]];
    }];
    
    [self runAction:backgroundsAction];
}


#pragma mark - Other methods
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
    
    sprite.zPosition = 200;
    
    [self addChild:sprite];
}

-(void)hitTheRightOne: (SKSpriteNode*) one
{
    
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"Energy" ofType:@"sks"];
    
    SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    myParticle.particlePosition = _currentPoint;
    myParticle.name = @"boom";
    myParticle.numParticlesToEmit = 64;
    myParticle.zPosition = 200;
    
    [self addChild:myParticle];
    
    [one removeFromParent];
}

-(BOOL)isDistanceOfTouchRight:(CGPoint)touch
{
    float tolerance = 50;
    
    float difX = touch.x-_currentPoint.x;
    float difY = touch.y-_currentPoint.y;
    
    if (difX <= tolerance && difX > (tolerance*-1) && difY <= tolerance && difY > (tolerance*-1)) {
        return YES;
    }
    
    return NO;
}

-(CGPoint)quadrante
{
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

@end
