//
//  TDScrollView.m
//  TD
//
//  Created by Megha Wadhwa on 06/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TDScrollView.h"
#import "TDListCustomRow.h"
#import <QuartzCore/QuartzCore.h>

#define HORIZ_SWIPE_DRAG_MAX  4
#define VERT_PULL_DRAG_MIN   60

@interface TDScrollView(privateMethods)
- (void)customViewPullUpDetected:(NSSet *)touches withEvent:(UIEvent*)event;
- (void)customViewPullDownDetected:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)removeCheckedItems;
@end

@implementation TDScrollView
@synthesize initialCentre;
@synthesize pullUpDetected,pullDownDetected;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        [self setUserInteractionEnabled:YES];
        }
    return self;
}

#pragma mark - touch delegates

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    initialCentre = self.center;
    pullDownDetected = FALSE;
    pullUpDetected = FALSE;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self];
    CGPoint prevTouchPosition = [touch previousLocationInView:self];
    
    CGRect myFrame = self.frame;
    float deltaY = currentTouchPosition.y - prevTouchPosition.y;
    myFrame.origin.y += deltaY;
    [self setFrame:myFrame];
    
    // To be a pull, direction of touch must be vertical and long enough.
    if (fabsf(initialCentre.y - self.center.y) >= VERT_PULL_DRAG_MIN && fabsf(initialCentre.x - self.center.x) <= HORIZ_SWIPE_DRAG_MAX)
    {
        if (prevTouchPosition.y > currentTouchPosition.y)  // PULL UP
        {
            NSLog(@" TO DEL :delta ,prev , current : %f %f,%f",initialCentre.y - self.center.y,initialCentre.y,self.center.y);
            pullUpDetected = TRUE;
            NSLog(@"pullUpDetected %i",pullUpDetected);
        }
        else
        {
            NSLog(@" TO DEL :delta ,prev , current : %f %f,%f",initialCentre.y - self.center.y,initialCentre.y,self.center.y);
            pullDownDetected = TRUE;
            NSLog(@"pullDownDetected %i",pullDownDetected);

        }
    } 
} 

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  
    if (pullUpDetected) {
        [self customViewPullUpDetected:touches withEvent:event];
    }
    else if (pullDownDetected){
        [self customViewPullDownDetected:touches withEvent:event];
    }
    [self setFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
    pullUpDetected = NO;
    pullDownDetected = NO;
    [self setFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
}

#pragma mark -  PUll UP
- (void)customViewPullUpDetected:(NSSet *)touches withEvent:(UIEvent*)event
{
    [self performSelector:@selector(removeCheckedItems) withObject:nil afterDelay:0.4];
}

- (void)removeCheckedItems
{
    if ([delegate respondsToSelector:@selector(TDCustomViewPulledUp)])
    {
    [delegate TDCustomViewPulledUp];
    }
}
#pragma mark -  PUll Down

- (void)customViewPullDownDetected:(NSSet *)touches withEvent:(UIEvent *)event
{
    TDListCustomRow * newRow = [[TDListCustomRow alloc]initWithFrame:CGRectMake(0, -60, ROW_WIDTH, ROW_HEIGHT)];
    [self addSubview:newRow];
   
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self];
    CGPoint prevTouchPosition = [touch previousLocationInView:self];
    
    CGRect myFrame = newRow.frame;
    float deltaY = currentTouchPosition.y - prevTouchPosition.y;
    myFrame.origin.y += deltaY;
    [newRow setFrame:myFrame];
    
    [self setFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
    [self performSelector:@selector(addNewItem) withObject:nil afterDelay:0.4];
}

- (void)addNewItem
{
}
@end
