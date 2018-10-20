//
//  Note.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Note.h"
#import "SharedNote.h"
#import "Utility.h"


@implementation Note

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [self valueForKey:@"noteID"]?[self valueForKey:@"noteID"]:[NSNull null],@"noteID",
        [self valueForKey:@"name"]?[self valueForKey:@"name"]:[NSNull null],@"name",
        [self valueForKey:@"nameEn"]?[self valueForKey:@"nameEn"]:[NSNull null],@"nameEn",
        [self valueForKey:@"price"]?[self valueForKey:@"price"]:[NSNull null],@"price",
        [self valueForKey:@"noteTypeID"]?[self valueForKey:@"noteTypeID"]:[NSNull null],@"noteTypeID",
        [self valueForKey:@"type"]?[self valueForKey:@"type"]:[NSNull null],@"type",
        [self valueForKey:@"orderNo"]?[self valueForKey:@"orderNo"]:[NSNull null],@"orderNo",
        [self valueForKey:@"status"]?[self valueForKey:@"status"]:[NSNull null],@"status",
        [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
        [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
        nil];
}

-(Note *)initWithName:(NSString *)name nameEn:(NSString *)nameEn price:(float)price noteTypeID:(NSInteger)noteTypeID type:(NSInteger)type orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.noteID = [Note getNextID];
        self.name = name;
        self.nameEn = nameEn;
        self.price = price;
        self.noteTypeID = noteTypeID;
        self.type = type;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"noteID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;


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

+(void)addObject:(Note *)note
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    [dataList addObject:note];
}

+(void)removeObject:(Note *)note
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    [dataList removeObject:note];
}

+(void)addList:(NSMutableArray *)noteList
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    [dataList addObjectsFromArray:noteList];
}

+(void)removeList:(NSMutableArray *)noteList
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    [dataList removeObjectsInArray:noteList];
}

+(Note *)getNote:(NSInteger)noteID
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteID = %ld",noteID];
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
        ((Note *)copy).noteID = self.noteID;
        [copy setName:self.name];
        [copy setNameEn:self.nameEn];
        ((Note *)copy).price = self.price;
        ((Note *)copy).noteTypeID = self.noteTypeID;
        ((Note *)copy).type = self.type;
        ((Note *)copy).orderNo = self.orderNo;
        ((Note *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editNote:(Note *)editingNote
{
    if(self.noteID == editingNote.noteID
    && [self.name isEqualToString:editingNote.name]
    && [self.nameEn isEqualToString:editingNote.nameEn]
    && self.price == editingNote.price
    && self.noteTypeID == editingNote.noteTypeID
    && self.type == editingNote.type
    && self.orderNo == editingNote.orderNo
    && self.status == editingNote.status
    )
    {
        return NO;
    }
    return YES;
}

+(Note *)copyFrom:(Note *)fromNote to:(Note *)toNote
{
    toNote.noteID = fromNote.noteID;
    toNote.name = fromNote.name;
    toNote.nameEn = fromNote.nameEn;
    toNote.price = fromNote.price;
    toNote.noteTypeID = fromNote.noteTypeID;
    toNote.type = fromNote.type;
    toNote.orderNo = fromNote.orderNo;
    toNote.status = fromNote.status;
    toNote.modifiedUser = [Utility modifiedUser];
    toNote.modifiedDate = [Utility currentDateTime];
    
    return toNote;
}

+(void)setSharedData:(NSMutableArray *)dataList
{
    [SharedNote sharedNote].noteList = dataList;
}


+(NSMutableArray *)getNoteList
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    return dataList;
}

+(NSMutableArray *)getNoteListWithStatus:(NSInteger)status noteList:(NSMutableArray *)noteList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld",status];
    NSArray *filterArray = [noteList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getNoteListWithNoteTypeID:(NSInteger)noteTypeID type:(NSInteger)type noteList:(NSMutableArray *)noteList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteTypeID = %ld and _type = %ld",noteTypeID,type];
    NSArray *filterArray = [noteList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getNoteListWithNoteTypeID:(NSInteger)noteTypeID noteList:(NSMutableArray *)noteList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteTypeID = %ld",noteTypeID];
    NSArray *filterArray = [noteList filteredArrayUsingPredicate:predicate];
    
    
    return [filterArray mutableCopy];
}

+(Note *)getNote:(NSInteger)noteID branchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteID = %ld and branchID = %ld",noteID,branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}


@end
