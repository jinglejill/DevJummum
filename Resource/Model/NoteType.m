//
//  NoteType.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "NoteType.h"
#import "SharedNoteType.h"
#import "Utility.h"
#import "Note.h"


@implementation NoteType

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [self valueForKey:@"noteTypeID"]?[self valueForKey:@"noteTypeID"]:[NSNull null],@"noteTypeID",
        [self valueForKey:@"name"]?[self valueForKey:@"name"]:[NSNull null],@"name",
        [self valueForKey:@"nameEn"]?[self valueForKey:@"nameEn"]:[NSNull null],@"nameEn",
        [self valueForKey:@"allowQuantity"]?[self valueForKey:@"allowQuantity"]:[NSNull null],@"allowQuantity",
        [self valueForKey:@"orderNo"]?[self valueForKey:@"orderNo"]:[NSNull null],@"orderNo",
        [self valueForKey:@"status"]?[self valueForKey:@"status"]:[NSNull null],@"status",
        [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
        [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
        nil];
}

-(NoteType *)initWithName:(NSString *)name nameEn:(NSString *)nameEn allowQuantity:(NSInteger)allowQuantity orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.noteTypeID = [NoteType getNextID];
        self.name = name;
        self.nameEn = nameEn;
        self.allowQuantity = allowQuantity;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"noteTypeID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;


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

+(void)addObject:(NoteType *)noteType
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    [dataList addObject:noteType];
}

+(void)removeObject:(NoteType *)noteType
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    [dataList removeObject:noteType];
}

+(void)addList:(NSMutableArray *)noteTypeList
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    [dataList addObjectsFromArray:noteTypeList];
}

+(void)removeList:(NSMutableArray *)noteTypeList
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    [dataList removeObjectsInArray:noteTypeList];
}

+(NoteType *)getNoteType:(NSInteger)noteTypeID branchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteTypeID = %ld and _branchID = %ld",noteTypeID,branchID];
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
        ((NoteType *)copy).noteTypeID = self.noteTypeID;
        [copy setName:self.name];
        [copy setNameEn:self.nameEn];
        ((NoteType *)copy).allowQuantity = self.allowQuantity;
        ((NoteType *)copy).orderNo = self.orderNo;
        ((NoteType *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editNoteType:(NoteType *)editingNoteType
{
    if(self.noteTypeID == editingNoteType.noteTypeID
    && [self.name isEqualToString:editingNoteType.name]
    && [self.nameEn isEqualToString:editingNoteType.nameEn]
    && self.allowQuantity == editingNoteType.allowQuantity
    && self.orderNo == editingNoteType.orderNo
    && self.status == editingNoteType.status
    )
    {
        return NO;
    }
    return YES;
}

+(NoteType *)copyFrom:(NoteType *)fromNoteType to:(NoteType *)toNoteType
{
    toNoteType.noteTypeID = fromNoteType.noteTypeID;
    toNoteType.name = fromNoteType.name;
    toNoteType.nameEn = fromNoteType.nameEn;
    toNoteType.allowQuantity = fromNoteType.allowQuantity;
    toNoteType.orderNo = fromNoteType.orderNo;
    toNoteType.status = fromNoteType.status;
    toNoteType.modifiedUser = [Utility modifiedUser];
    toNoteType.modifiedDate = [Utility currentDateTime];
    
    return toNoteType;
}

+(void)setSharedData:(NSMutableArray *)dataList
{
    [SharedNoteType sharedNoteType].noteTypeList = dataList;
}

+(NSMutableArray *)getNoteTypeList
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    return dataList;
}

+(NSMutableArray *)sort:(NSMutableArray *)noteTypeList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_type" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
    NSArray *sortArray = [noteTypeList sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getNoteTypeListWithNoteList:(NSMutableArray *)noteList branchID:(NSInteger)branchID
{
    NSSet *noteTypeIDSet = [NSSet setWithArray:[noteList valueForKey:@"_noteTypeID"]];
    
    NSMutableArray *noteTypeList = [[NSMutableArray alloc]init];
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    for(NSNumber *item in noteTypeIDSet)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteTypeID = %ld and _branchID = %ld",[item integerValue],branchID];
        NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
        [noteTypeList addObjectsFromArray:filterArray];
    }
    
    return noteTypeList;
    
}
@end
