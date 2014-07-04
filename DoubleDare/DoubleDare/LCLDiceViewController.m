//
//  LCLDiceViewController.m
//  DoubleDare
//
//  Created by Leonard Li on 3/7/14.
//  Copyright (c) 2014 Leonard Li. All rights reserved.
//

#import "LCLDiceViewController.h"

@interface LCLDiceViewController () <UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate>
@property (strong, nonatomic) UIView *dice;
@property (strong, nonatomic) UIView *dice2;
@property (strong, nonatomic) UIView *barrier;
@end

@implementation LCLDiceViewController {
    UIDynamicAnimator* _animator;
    UIGravityBehavior* _gravity;
    UICollisionBehavior* _collision;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (motion == UIEventSubtypeMotionShake) {
        [self.dice removeFromSuperview];
        
        self.dice = [[UIView alloc] initWithFrame:
                     CGRectMake(140, 100, 50, 50)];
        self.dice.layer.cornerRadius = self.dice.bounds.size.width/2;
        
        self.dice.layer.masksToBounds = YES;
        self.dice.layer.borderWidth = 0;
        self.dice.backgroundColor = [UIColor yellowColor];
        
        self.barrier = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 130, 20)];
        self.barrier.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.barrier];
        
        
        [self.view addSubview:self.dice];
        
        UIView *diceSide1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.dice.frame.size.width, self.dice.frame.size.height)];
        diceSide1.backgroundColor = [UIColor brownColor];
        [self.dice addSubview:diceSide1];
        
        UIView *diceSide2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.dice.frame.size.width, self.dice.frame.size.height)];
        diceSide2.backgroundColor = [UIColor blueColor];
        [self.dice addSubview:diceSide2];
        [CATransaction flush];
        
        [UIView transitionFromView:diceSide2
                            toView:diceSide1
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:NULL];
        
        [UIView transitionFromView:diceSide2 toView:diceSide1 duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            
            self.dice2 = [[UIView alloc] initWithFrame:
                             CGRectMake(20, 150, 50, 50)];
            self.dice2.backgroundColor = [UIColor redColor];
            self.dice2.layer.cornerRadius = 5.0;
            self.dice2.layer.masksToBounds = YES;
            self.dice2.layer.borderWidth = 0;
            [self.view addSubview:self.dice2];
            
            UIView* dice3 = [[UIView alloc] initWithFrame:
                             CGRectMake(173, 40, 50, 50)];
            dice3.backgroundColor = [UIColor orangeColor];
            dice3.layer.cornerRadius = 5.0;
            dice3.layer.masksToBounds = YES;
            dice3.layer.borderWidth = 0;
            [self.view addSubview:dice3];
            
            // Do any additional setup after loading the view.
            _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
            _gravity = [[UIGravityBehavior alloc] initWithItems:@[self.dice, self.dice2, dice3]];
            [_animator addBehavior:_gravity];
            
            _collision = [[UICollisionBehavior alloc]
                          initWithItems:@[self.
                                          dice, self.barrier, self.dice2, dice3]];
            CGPoint rightEdge = CGPointMake(self.barrier.frame.origin.x +
                                            self.barrier.frame.size.width, self.barrier.frame.origin.y);
            [_collision addBoundaryWithIdentifier:@"barrier"
                                        fromPoint:self.barrier.frame.origin
                                          toPoint:rightEdge];
            
            _collision.translatesReferenceBoundsIntoBoundary = YES;
            _collision.collisionDelegate = self;
            [_animator addBehavior:_collision];
            
            UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dice, self.barrier, self.dice2, dice3]];
            elasticityBehavior.elasticity = 0.7f;
            [_animator addBehavior:elasticityBehavior];
            
        }];
        
        
    }
}
- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier
{

    [behavior removeBoundaryWithIdentifier:identifier];
    [_gravity addItem:item];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    NSLog(@"hi");

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
