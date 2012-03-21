//
//  TDListCustomRow.m
//  TD
//
//  Created by Megha Wadhwa on 06/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#define HORIZ_SWIPE_DRAG_MIN  50
#define VERT_SWIPE_DRAG_MAX   3
#define HORIZ_SWIPE_DRAG_MAX 2 
#define VERT_SWIPE_DRAG_MIN 2
#import "TDListCustomRow.h"

@implementation TDListCustomRow
@synthesize listTextField;
@synthesize delegate;
@synthesize initialCentre;
@synthesize rightSwipeDetected,leftSwipeDetected;
@synthesize strikedLabel;
@synthesize currentRowColor;
@synthesize PullDetected,swipeDetected;
@synthesize startPoint;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        static int counter =1;
        static float red = 0.067;// 0.851; //0.067;
        static float green = 0.494; // 0.0;      //0.494;
        static float blue = 0.980;// 0.086;       //0.980;
        self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        counter += 1;
        //red += 0.012;
        //green +=0.113;
        //blue += 0.004;
         red -=(counter == 1)? 0.004:0.008;
        green += 0.028 +0.01 *counter;
        blue += (counter %2 == 0)? 0 :0.004;
        UITextField *listField = [[UITextField alloc] initWithFrame:CGRectMake(10,15,frame.size.width -25,frame.size.height-30)];
        listField.enablesReturnKeyAutomatically =YES;
        listField.backgroundColor = [UIColor clearColor];
        listField.textColor =[UIColor whiteColor];
        [listField setFont:[UIFont boldSystemFontOfSize:18]];
        listField.delegate = self;
        listField.returnKeyType = UIReturnKeyDone;
        self.listTextField = listField;
        [self addSubview:self.listTextField];
        NSLog(@"here");
        self.currentRowColor = self.backgroundColor;
        [self setUserInteractionEnabled:YES];
        [self  makeDeleteIcon];
        [self makeCheckedIcon];
    }
    return self;
}

#pragma mark - touch delegates

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    initialCentre = self.center;
    swipeDetected = NO;
    rightSwipeDetected = NO;
    leftSwipeDetected = NO;
    self.currentRowColor = self.backgroundColor;
    [[self superview] touchesBegan:touches withEvent:event];
    PullDetected = NO;
    
    UITouch *touch = [touches anyObject];
     startPoint = [touch locationInView:self];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self];
    CGPoint prevTouchPosition = [touch previousLocationInView:self];
    
    // to check for scrollView's touch 
    if( (rightSwipeDetected == YES) || (leftSwipeDetected == YES) || (swipeDetected == YES)){
        PullDetected = NO;
    }
    else if(PullDetected == NO && swipeDetected == NO)
    {
        if (fabsf(startPoint.x - currentTouchPosition.x) <= HORIZ_SWIPE_DRAG_MAX && fabsf(startPoint.y - currentTouchPosition.y) >= VERT_SWIPE_DRAG_MIN)
        {
             PullDetected = YES;
            swipeDetected = NO;
            [[self superview] touchesMoved:touches withEvent:event];
        }
        else
        {
            swipeDetected = YES;
            PullDetected = NO;
        }
    }
      if(PullDetected == YES)
    {
        [[self superview] touchesMoved:touches withEvent:event];
    }
    else
    {
        CGRect myFrame = self.frame;
        float deltaX = currentTouchPosition.x - prevTouchPosition.x;
        if (rightSwipeDetected || leftSwipeDetected) // give decelleration effect
        {
            deltaX = deltaX/DECELERATION_RATE;
        }
        myFrame.origin.x += deltaX;
        [self setFrame:myFrame];
        
        
        UIImageView *deleteImgView = (UIImageView *)[self viewWithTag:100];
        deleteImgView.frame =CGRectMake(self.frame.size.width +20,15, 24, 24);
        
        UIImageView *checkImgView = (UIImageView *)[self viewWithTag:101];
        checkImgView.frame =CGRectMake(320 - self.frame.size.width - 30 ,15, 24, 24);  
        
        // To be a swipe, direction of touch must be horizontal and long enough.
        if (fabsf(initialCentre.x - self.center.x) >= HORIZ_SWIPE_DRAG_MIN && fabsf(initialCentre.y - self.center.y) <= VERT_SWIPE_DRAG_MAX)
        {
            // It appears to be a right swipe.
                    if (prevTouchPosition.x > currentTouchPosition.x && leftSwipeDetected == NO)
            {
                //NSLog(@" TO DEL :delta ,prev , current : %f %f,%f",initialCentre.x - self.center.x,initialCentre.x,self.center.x);
                self.alpha =0.5;
                rightSwipeDetected =YES;
                PullDetected = NO;
            }
     
      else  if (prevTouchPosition.x < currentTouchPosition.x && rightSwipeDetected == NO)
            {
                //NSLog(@" TO CHECK :delta ,prev , current : %f , %f %f",initialCentre.x - currentTouchPosition.x,initialCentre.x,currentTouchPosition.x);
                self.backgroundColor = [UIColor colorWithRed:0.082 green:0.71 blue:0.11 alpha:1]; 
                [self makeStrikedLabel]; //TODO: make it non editable after checked
                 [self addSubview:self.strikedLabel];
                leftSwipeDetected = YES;
                PullDetected = NO;
            }
        }
        else
        {
            NSLog(@" else :delta ,prev , current : %f %f,%f",initialCentre.x - self.center.x,initialCentre.x,self.center.x);
            if (rightSwipeDetected == YES)
            {
                NSLog(@"right");
                self.alpha =1;
                rightSwipeDetected =NO;
            }
            if(leftSwipeDetected == YES)
            {
                NSLog(@"here");
                self.backgroundColor = self.currentRowColor; 
                [self.strikedLabel removeFromSuperview];    
                leftSwipeDetected = NO;
            }
            
        }
    }
} 

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (PullDetected == YES) {
        [[self superview] touchesEnded:touches withEvent:event];
        PullDetected = NO;
    }
    if (rightSwipeDetected == YES)
        {
        [self customRowRightSwipe:touches withEvent:event];
        }
    else if(leftSwipeDetected == YES)
        {
        [self customRowLeftSwipe:touches withEvent:event];  
        [self setFrame:CGRectMake(0, self.frame.origin.y, ROW_WIDTH, ROW_HEIGHT)];    
        }
    else{
        [self setFrame:CGRectMake(0, self.frame.origin.y, ROW_WIDTH, ROW_HEIGHT)];  
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
    PullDetected = NO;
    rightSwipeDetected = NO;
    leftSwipeDetected = NO;
    [self setFrame:CGRectMake(0, self.frame.origin.y, ROW_WIDTH , ROW_HEIGHT)];
}

- (void)customRowRightSwipe:(NSSet *)touches withEvent:(UIEvent*)event
{
    self.alpha = 0.9;
    [self performSelector:@selector(deleteRow) withObject:nil afterDelay:0];
}

- (void)customRowLeftSwipe:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1;
    [self setFrame:CGRectMake(0, self.frame.origin.y, ROW_WIDTH, ROW_HEIGHT)];
    [self performSelector:@selector(checkRow) withObject:nil afterDelay:0.4];
}

# pragma mark - delegates

- (void)checkRow
{
    if ([delegate respondsToSelector:@selector(TDCustomRowToBeDeleted:WithId:bySwipe:)])
    {
    [delegate TDCustomRowToBeDeleted:FALSE WithId:self.tag bySwipe:NO ];
    }
}
- (void)deleteRow
{
    if ([delegate respondsToSelector:@selector(TDCustomRowToBeDeleted:WithId:bySwipe:)])
    {
    [delegate TDCustomRowToBeDeleted:TRUE WithId:self.tag bySwipe:YES];
    }
}

#pragma mark -UI
- (void)makeStrikedLabel
{ 
    //calculate the width of text in textfield
    CGSize textSize = [[listTextField text] sizeWithFont:[listTextField font]];
    CGFloat strikeWidth = textSize.width;
    
    if (self.strikedLabel) {
        [self.strikedLabel setFrame: CGRectMake(self.listTextField.frame.origin.x, self.listTextField.frame.origin.y, strikeWidth, self.listTextField.frame.size.height)];
        return;
    }
    
    //create the striked label with calculated text width
    self.strikedLabel = [[TDStrikedLabel alloc] initWithFrame:CGRectMake(self.listTextField.frame.origin.x, self.listTextField.frame.origin.y, strikeWidth, self.listTextField.frame.size.height)];
    self.strikedLabel.backgroundColor = [UIColor clearColor];
}

- (void)makeCheckedIcon
{
     UIImageView *checkImgView = [[UIImageView alloc] init];
    [checkImgView setImage:[UIImage imageNamed:@"check.png"]];
    checkImgView.tag = 101;
    [self addSubview:checkImgView];
}

- (void)makeDeleteIcon
{
    UIImageView *deleteImgView = [[UIImageView alloc] init];
    [deleteImgView setImage:[UIImage imageNamed:@"delete.png"]];
    deleteImgView.tag = 100;
    [self addSubview:deleteImgView];

}
#pragma mark - text field delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.listTextField resignFirstResponder];
    if ([self.listTextField.text isEqualToString:@""] && [delegate respondsToSelector:@selector(TDCustomRowToBeDeleted:WithId:bySwipe:)]) {
        [delegate TDCustomRowToBeDeleted:YES WithId:self.tag bySwipe:YES];
    }
    else
    {
        TDScrollView * superView = (TDScrollView *)[self superview];
        if (superView.overlayView != nil) 
        {
            [superView overlayViewTapped];       
        }
        else
        {
            // TODO: update Web SErvice and update the list View array
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.listTextField.text isEqualToString:@""]) {
        self.listTextField.enablesReturnKeyAutomatically= YES;
    }
}


@end
