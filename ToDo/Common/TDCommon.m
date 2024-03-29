//
//  TDCommon.m
//  TD
//
//  Created by Megha Wadhwa on 13/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TDCommon.h"
#import "TDConstants.h"

@implementation TDCommon

NSString *currentViewTheme = nil;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(UIColor *)getColorByPriority:(int)prioirity
{
    UIColor *color;
    
    if ([currentViewTheme isEqualToString:THEME_BLUE]) {
    color = [TDCommon getBlueColorByPriority:prioirity];
    }
    else if ([currentViewTheme isEqualToString:THEME_HEAT_MAP])
    {
     color = [TDCommon getRedColorByPriority:prioirity];
    }
    else if ([currentViewTheme isEqualToString:THEME_MAIN_GRAY]) {
        color = [TDCommon getGrayColorByPriority:prioirity];
    }
   
    return color;
}

+(UIColor *)getGrayColorByPriority:(int)prioirity
{
    float red =  0.250; 
    float green = 0.250; 
    float blue = 0.250;  
    
    red -= 0.026 *prioirity/2;
    green -=0.026 *prioirity/2;
    blue -= 0.026 *prioirity/2;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    return color;
}

+(UIColor *)getBlueColorByPriority:(int)prioirity
{
    float red = 0.067;
    float green = 0.494;
    float blue = 0.980;

    red -=((prioirity == 1)? 0.004:0.008)*prioirity/2;
    green +=(0.028 +0.01 *prioirity)*prioirity/2;
    blue +=((prioirity %2 == 0)? 0 :0.004)*prioirity/2;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    return color;
}

+(UIColor *)getRedColorByPriority:(int)prioirity
{
    float red =  0.851; 
    float green = 0.0; 
    float blue = 0.086;  
    
    red += 0.012 *prioirity/2;
    green +=0.113 *prioirity/2;
    blue += 0.004 *prioirity/2;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    return color;
}

#pragma mark -Utility methods
+ (int)calculateLastIndexForArray:(NSMutableArray *)anyArray
{
    if (anyArray && [anyArray count] >0) {
        int lastObjectIndex = 0;
        if ([anyArray count] >1) {
            lastObjectIndex = [anyArray count] -1;
        }
        return lastObjectIndex;
    }
    return nil;
}

+ (void)setDoneStatus:(TDListCustomRow *)RowSwiped
{
    if (RowSwiped.doneStatus == TRUE) {
        RowSwiped.doneStatus = FALSE;
    }
    else RowSwiped.doneStatus = TRUE;
}

+ (NSString *)getTheme
{
    return currentViewTheme;
}

+ (void)setTheme: (NSString *)myTheme
{
    currentViewTheme = myTheme;
}


@end
