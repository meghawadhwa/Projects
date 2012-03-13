//
//  TDViewController.m
//  TD
//
//  Created by Megha Wadhwa on 06/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "TDViewController.h"
#import "TDCategory.h"
#import "ToDoList.h"
#import "TDScrollView.h"
#import "TDListCustomRow.h"

@interface TDViewController(privateMethods)
- (void)createUI;
- (void)rearrangeRowsAfterRemovingObjectAtIndex:(NSMutableArray*)indexArray withDeletionFlag:(BOOL)flag;
- (void)rearrangeListObjectsAfterRemovingObjectAtIndex:(NSMutableArray*)indexArray withDeletionFlag:(BOOL)flag;
- (void)shiftRowsFromIndex:(int)index;
- (void)shiftRowsBackFromIndex:(int)index;
@end

@implementation TDViewController
@synthesize backgroundScrollView;
@synthesize listArray;
@synthesize customViewsArray;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    self.listArray = [[NSMutableArray alloc] init];
    self.customViewsArray = [[NSMutableArray alloc] init];
    [self getDataFromServer];
    [self createUI];
    
}
#pragma mark -Delegates

- (void)TDCustomRowToBeDeleted:(BOOL)flag WithId:(int)senderId
{
    int numberOfviews = [self.customViewsArray count];
    NSMutableArray *swipedIndexArray = [[NSMutableArray alloc] init];
    int index;
    for (index = 0; index< numberOfviews; index++) 
    {
        TDListCustomRow * currentView = [self.customViewsArray objectAtIndex:index];  
        if(senderId == currentView.tag){  [swipedIndexArray addObject:[NSNumber numberWithInt:index]]; }   
    }
    if ([swipedIndexArray count]>0) {
        [self rearrangeRowsAfterRemovingObjectAtIndex:swipedIndexArray withDeletionFlag:flag];
        // TODO: remove from Server also.
    }
}

- (void)TDCustomViewPulledUp
{
    int numberOfRows = [listArray count];
    NSMutableArray *checkedIndexArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<numberOfRows; i++) 
    { 
        ToDoList *currentList = [self.listArray objectAtIndex:i];
        if (currentList.doneStatus == TRUE) 
        {
            [checkedIndexArray addObject:[NSNumber numberWithInt:i]];
            NSLog(@"index :%i",i);
        }
    }
    if ([checkedIndexArray count]>0) {
        [self rearrangeRowsAfterRemovingObjectAtIndex:checkedIndexArray withDeletionFlag:YES];
        // TODO: remove from Server also.
    }
}

- (void)TDCustomViewPulledDown
{
    [self shiftRowsFromIndex:0];
}
- (void)shiftRowsFromIndex:(int)index
{
    // rearrange after the new row is added
}
- (void)shiftRowsBackFromIndex:(int)index
{
    int lastObjectIndex = [self.customViewsArray count]-1;
    if (index < lastObjectIndex) // Not the last object
    {
        for (int i = lastObjectIndex; i > index; i--)  // transfer frames from last to current
        {
            TDListCustomRow *Row = [self.customViewsArray objectAtIndex:i];
            TDListCustomRow *previousRow = [self.customViewsArray objectAtIndex:i-1];
            [UIView animateWithDuration:0.8 animations:^{
                Row.frame = CGRectMake(0, previousRow.frame.origin.y, previousRow.frame.size.width, previousRow.frame.size.height);
            }]; 
        }
    }
}

#pragma mark - UI
- (void)rearrangeRowsAfterRemovingObjectAtIndex:(NSMutableArray*)indexArray withDeletionFlag:(BOOL)flag
{
    NSLog(@"array here %@",self.customViewsArray);
    int lastObjectIndex = [indexArray count] -1;
    for (int i =lastObjectIndex; i>=0; i--) 
    {
            int index = [[indexArray objectAtIndex:i] intValue];
            int lastObjectIndex = [self.customViewsArray count]-1;
        TDListCustomRow *RowToBeMoved = [self.customViewsArray objectAtIndex:index];
        
        if (flag == TRUE)     // deleted row to be removed from view
        {
            [UIView animateWithDuration:0.5 animations:^{
                RowToBeMoved.alpha =0;
                [RowToBeMoved removeFromSuperview]; }];
        }   
        
        
        if (index < lastObjectIndex) // Not the last object
        {
            for (int i = lastObjectIndex; i > index; i--)  // transfer frames from last to current
            {
                TDListCustomRow *Row = [self.customViewsArray objectAtIndex:i];
                TDListCustomRow *previousRow = [self.customViewsArray objectAtIndex:i-1];
                [UIView animateWithDuration:0.8 animations:^{
                Row.frame = CGRectMake(0, previousRow.frame.origin.y, previousRow.frame.size.width, previousRow.frame.size.height);
                }]; 
            }
        }
        if (flag == TRUE) {    // deleted row to be removed from custom views array
        [self.customViewsArray removeObjectAtIndex:index];
        }
        else
        {
         [self.customViewsArray removeObjectAtIndex:index];
            [UIView animateWithDuration:0.5 animations:^{
            TDListCustomRow *lastRow = [self.customViewsArray lastObject];
            
            [self.backgroundScrollView bringSubviewToFront:RowToBeMoved];
            RowToBeMoved.frame =CGRectMake(0, lastRow.frame.origin.y + lastRow.frame.size.height + 1, RowToBeMoved.frame.size.width, RowToBeMoved.frame.size.height);
            RowToBeMoved.backgroundColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1];
            }];
            RowToBeMoved.listNameButton.textColor = [UIColor grayColor];
            [self.customViewsArray addObject:RowToBeMoved];
        }
    }
    [self rearrangeListObjectsAfterRemovingObjectAtIndex:indexArray withDeletionFlag:flag];
     NSLog(@"array now %@",self.customViewsArray);
}


- (void)rearrangeListObjectsAfterRemovingObjectAtIndex:(NSMutableArray*)indexArray withDeletionFlag:(BOOL)flag
{
     NSLog(@"array before %@",self.listArray);
    int lastObjectIndex = [indexArray count] -1;
    for (int i =lastObjectIndex; i>=0; i--) 
    {
        int index = [[indexArray objectAtIndex:i] intValue];

        if (flag == TRUE) 
        {                                   // TODO: DELETE WEB SERVICE CALL
        [self.listArray removeObjectAtIndex:index];
        } 
        else
        {
            ToDoList *listToBeMoved = [self.listArray objectAtIndex:index];
            listToBeMoved.doneStatus = TRUE;
            [self.listArray removeObjectAtIndex:index];
            [self.listArray addObject:listToBeMoved];
                                            // TODO: update WEB SERVICE CALL
            // checked
            //TODO:delete after pull
        }
    }
    NSLog(@"array now %@",self.listArray);
}
- (void)createUI
{
  /************** background scrollview *************/
    self.backgroundScrollView = [[TDScrollView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
    self.backgroundScrollView.delegate = self;
    [self.view addSubview:self.backgroundScrollView];
    
    //static int y =1;
    for (int i =0; i<[self.listArray count]; i++)
    {
        ToDoList *toDoList = [self.listArray objectAtIndex:i];
         static int y =0;
         y= 60 *i + 1*i;
        TDListCustomRow *row = [[TDListCustomRow alloc ] initWithFrame:CGRectMake(0, y,ROW_WIDTH , ROW_HEIGHT)];
        //[row.listNameButton setTitle:toDoList.listName forState:UIControlStateNormal];
        row.listNameButton.text = toDoList.listName;
        row.delegate = self;
        row.tag =toDoList.listId;
        NSLog(@" To Do List :%@,%i",toDoList.listName,y);
        [self.backgroundScrollView addSubview:row];
        [self.customViewsArray addObject:row];       
    }
     NSLog(@"array now %@",self.customViewsArray);
}


# pragma mark - FETCH  DATA FROM SERVER
- (void)getDataFromServer
{
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfJSONURLString:@"http://localhost:3000/to_do_lists.json"];
    
    if (dict) 
    {
            NSArray* responseArray = [dict objectForKey:@"result"]; //2
            NSLog(@"response array: %@",responseArray);

            //****************** populating model with data
            for (int i =0; i<[responseArray count]; i++)
            {
                ToDoList *toDoList = [[ToDoList alloc] init];
                NSDictionary *paramDict = [responseArray objectAtIndex:i];
                [toDoList readFromDictionary:paramDict]; 
                [self.listArray addObject:toDoList];
                NSLog(@" To Do List :%@",self.listArray);
            }
            }
    
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"To Do App" message:@"Server unavailable" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
