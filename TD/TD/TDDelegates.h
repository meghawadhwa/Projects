//
//  TDDelegates.h
//  TD
//
//  Created by Megha Wadhwa on 07/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TDDelegates <NSObject>

@end

@protocol TDCustomRowSwipedDelegate<NSObject>
- (void)TDCustomRowToBeDeleted:(BOOL)flag WithId:(int)senderId;
@end

@protocol TDCustomViewPulledDelegate<NSObject>
- (void)TDCustomViewPulledUp;
- (void)TDCustomViewPulledDown;
@end