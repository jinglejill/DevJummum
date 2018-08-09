//
//  MenuNote.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 11/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MenuNote.h"
#import "SharedMenuNote.h"
#import "Note.h"
#import "Utility.h"


@implementation MenuNote

-(MenuNote *)initWithMenuID:(NSInteger)menuID noteID:(NSInteger)noteID
{
    self = [super init];
    if(self)
    {
        self.menuNoteID = [MenuNote getNextID];
        self.menuID = menuID;
        self.noteID = noteID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"menuNoteID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedMenuNote sharedMenuNote].menuNoteList;
    
    
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

+(void)addObject:(MenuNote *)menuNote
{
    NSMutableArray *dataList = [SharedMenuNote sharedMenuNote].menuNoteList;
    [dataList addObject:menuNote];
}

+(void)removeObject:(MenuNote *)menuNote
{
    NSMutableArray *dataList = [SharedMenuNote sharedMenuNote].menuNoteList;
    [dataList removeObject:menuNote];
}

+(void)addList:(NSMutableArray *)menuNoteList
{
    NSMutableArray *dataList = [SharedMenuNote sharedMenuNote].menuNoteList;
    [dataList addObjectsFromArray:menuNoteList];
}

+(void)removeList:(NSMutableArray *)menuNoteList
{
    NSMutableArray *dataList = [SharedMenuNote sharedMenuNote].menuNoteList;
    [dataList removeObjectsInArray:menuNoteList];
}

+(MenuNote *)getMenuNote:(NSInteger)menuNoteID
{
    NSMutableArray *dataList = [SharedMenuNote sharedMenuNote].menuNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuNoteID = %ld",menuNoteID];
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
        ((MenuNote *)copy).menuNoteID = self.menuNoteID;
        ((MenuNote *)copy).menuID = self.menuID;
        ((MenuNote *)copy).noteID = self.noteID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editMenuNote:(MenuNote *)editingMenuNote
{
    if(self.menuNoteID == editingMenuNote.menuNoteID
       && self.menuID == editingMenuNote.menuID
       && self.noteID == editingMenuNote.noteID
       )
    {
        return NO;
    }
    return YES;
}

+(MenuNote *)copyFrom:(MenuNote *)fromMenuNote to:(MenuNote *)toMenuNote
{
    toMenuNote.menuNoteID = fromMenuNote.menuNoteID;
    toMenuNote.menuID = fromMenuNote.menuID;
    toMenuNote.noteID = fromMenuNote.noteID;
    toMenuNote.modifiedUser = [Utility modifiedUser];
    toMenuNote.modifiedDate = [Utility currentDateTime];
    
    return toMenuNote;
}

+(NSMutableArray *)getMenuNoteList
{
    NSMutableArray *dataList = [SharedMenuNote sharedMenuNote].menuNoteList;
    return dataList;
}

+(void)setSharedData:(NSMutableArray *)dataList
{
    [SharedMenuNote sharedMenuNote].menuNoteList = dataList;
}

+(NSMutableArray *)getNoteListWithMenuID:(NSInteger)menuID
{
    NSMutableArray *dataList = [SharedMenuNote sharedMenuNote].menuNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuID = %ld",menuID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSMutableArray *noteList = [[NSMutableArray alloc]init];
    for(MenuNote *item in filterArray)
    {
        Note *note = [Note getNote:item.noteID];
        [noteList addObject:note];
    }
    
    noteList = [Note getNoteListWithStatus:1 noteList:noteList];
    return noteList;
}

@end
