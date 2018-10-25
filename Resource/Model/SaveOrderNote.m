//
//  SaveOrderNote.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SaveOrderNote.h"
#import "SharedSaveOrderNote.h"
#import "Utility.h"
#import "OrderNote.h"


@implementation SaveOrderNote

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [self valueForKey:@"saveOrderNoteID"]?[self valueForKey:@"saveOrderNoteID"]:[NSNull null],@"saveOrderNoteID",
        [self valueForKey:@"saveOrderTakingID"]?[self valueForKey:@"saveOrderTakingID"]:[NSNull null],@"saveOrderTakingID",
        [self valueForKey:@"noteID"]?[self valueForKey:@"noteID"]:[NSNull null],@"noteID",
        [self valueForKey:@"quantity"]?[self valueForKey:@"quantity"]:[NSNull null],@"quantity",
        [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
        [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
        nil];
}

-(SaveOrderNote *)initWithSaveOrderTakingID:(NSInteger)saveOrderTakingID noteID:(NSInteger)noteID quantity:(float)quantity
{
    self = [super init];
    if(self)
    {
        self.saveOrderNoteID = [SaveOrderNote getNextID];
        self.saveOrderTakingID = saveOrderTakingID;
        self.noteID = noteID;
        self.quantity = quantity;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"saveOrderNoteID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedSaveOrderNote sharedSaveOrderNote].saveOrderNoteList;


    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];

    if([dataList count] == 0)
    {
        return -1;
    }
    else
    {
        id value = [dataList[0] valueForKey:primaryKeyName];
        if([value integerValue]>0)
        {
            return -1;
        }
        else
        {
            return [value integerValue]-1;
        }
    }
}

+(void)addObject:(SaveOrderNote *)saveOrderNote
{
    NSMutableArray *dataList = [SharedSaveOrderNote sharedSaveOrderNote].saveOrderNoteList;
    [dataList addObject:saveOrderNote];
}

+(void)removeObject:(SaveOrderNote *)saveOrderNote
{
    NSMutableArray *dataList = [SharedSaveOrderNote sharedSaveOrderNote].saveOrderNoteList;
    [dataList removeObject:saveOrderNote];
}

+(void)addList:(NSMutableArray *)saveOrderNoteList
{
    NSMutableArray *dataList = [SharedSaveOrderNote sharedSaveOrderNote].saveOrderNoteList;
    [dataList addObjectsFromArray:saveOrderNoteList];
}

+(void)removeList:(NSMutableArray *)saveOrderNoteList
{
    NSMutableArray *dataList = [SharedSaveOrderNote sharedSaveOrderNote].saveOrderNoteList;
    [dataList removeObjectsInArray:saveOrderNoteList];
}

+(SaveOrderNote *)getSaveOrderNote:(NSInteger)saveOrderNoteID
{
    NSMutableArray *dataList = [SharedSaveOrderNote sharedSaveOrderNote].saveOrderNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_saveOrderNoteID = %ld",saveOrderNoteID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];

    if (copy)
    {
        ((SaveOrderNote *)copy).saveOrderNoteID = self.saveOrderNoteID;
        ((SaveOrderNote *)copy).saveOrderTakingID = self.saveOrderTakingID;
        ((SaveOrderNote *)copy).noteID = self.noteID;
        ((SaveOrderNote *)copy).quantity = self.quantity;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editSaveOrderNote:(SaveOrderNote *)editingSaveOrderNote
{
    if(self.saveOrderNoteID == editingSaveOrderNote.saveOrderNoteID
    && self.saveOrderTakingID == editingSaveOrderNote.saveOrderTakingID
    && self.noteID == editingSaveOrderNote.noteID
    && self.quantity == editingSaveOrderNote.quantity
    )
    {
        return NO;
    }
    return YES;
}

+(SaveOrderNote *)copyFrom:(SaveOrderNote *)fromSaveOrderNote to:(SaveOrderNote *)toSaveOrderNote
{
    toSaveOrderNote.saveOrderNoteID = fromSaveOrderNote.saveOrderNoteID;
    toSaveOrderNote.saveOrderTakingID = fromSaveOrderNote.saveOrderTakingID;
    toSaveOrderNote.noteID = fromSaveOrderNote.noteID;
    toSaveOrderNote.quantity = fromSaveOrderNote.quantity;
    toSaveOrderNote.modifiedUser = [Utility modifiedUser];
    toSaveOrderNote.modifiedDate = [Utility currentDateTime];
    
    return toSaveOrderNote;
}

+(NSMutableArray *)createSaveOrderNoteList:(NSMutableArray *)orderNoteList
{
    NSMutableArray *saveOrderNoteList = [[NSMutableArray alloc]init];
    for(OrderNote *item in orderNoteList)
    {
        SaveOrderNote *saveOrderNote = [[SaveOrderNote alloc]initWithSaveOrderTakingID:item.orderTakingID noteID:item.noteID quantity:item.quantity];
        [saveOrderNoteList addObject:saveOrderNote];
        [SaveOrderNote addObject:saveOrderNote];
    }
    
    return saveOrderNoteList;
}

+(NSMutableArray *)getOrderNoteListWithSaveOrderTakingID:(NSInteger)saveOrderTakingID
{
    NSMutableArray *dataList = [SharedSaveOrderNote sharedSaveOrderNote].saveOrderNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_saveOrderTakingID = %ld",saveOrderTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}
@end
