//
//  TDScrollView.h
//  TD
//
//  Created by Megha Wadhwa on 06/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDDelegates.h"
#import "TDConstants.h"
@interface TDScrollView : UIView
@property(assign) CGPoint initialCentre;
@property(assign) BOOL pullUpDetected;
@property(assign)BOOL pullDownDetected;
@property(nonatomic,assign) id<TDCustomViewPulledDelegate> delegate;
@end
