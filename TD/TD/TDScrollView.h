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
@class TDTrapezium;
@class TDListCustomRow;
@interface TDScrollView : UIView
@property(assign) CGPoint initialCentre;
@property(assign) BOOL pullUpDetected;
@property(assign)BOOL pullDownDetected;
@property(assign)BOOL startedpullingDownFlag; //This flag ensures rotation when pulled up again after pulldown first
@property(nonatomic,retain)UIView *overlayView;
@property(nonatomic,assign) id<TDCustomViewPulledDelegate> delegate;
@property(nonatomic,retain) TDListCustomRow *customNewRow;
@property(nonatomic,retain)  TDListCustomRow *RowAdded;
- (void)overlayViewTapped;
@end
