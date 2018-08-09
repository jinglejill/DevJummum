//
//  Comment.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 4/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Comment.h"
#import "SharedComment.h"
#import "Utility.h"


@implementation Comment

-(Comment *)initWithUserAccountID:(NSInteger)userAccountID text:(NSString *)text type:(NSInteger)type receiptID:(NSInteger)receiptID
{
    self = [super init];
    if(self)
    {
        self.commentID = [Comment getNextID];
        self.userAccountID = userAccountID;
        self.text = text;
        self.type = type;
        self.receiptID = receiptID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"commentID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedComment sharedComment].commentList;
    
    
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

+(void)addObject:(Comment *)comment
{
    NSMutableArray *dataList = [SharedComment sharedComment].commentList;
    [dataList addObject:comment];
}

+(void)removeObject:(Comment *)comment
{
    NSMutableArray *dataList = [SharedComment sharedComment].commentList;
    [dataList removeObject:comment];
}

+(void)addList:(NSMutableArray *)commentList
{
    NSMutableArray *dataList = [SharedComment sharedComment].commentList;
    [dataList addObjectsFromArray:commentList];
}

+(void)removeList:(NSMutableArray *)commentList
{
    NSMutableArray *dataList = [SharedComment sharedComment].commentList;
    [dataList removeObjectsInArray:commentList];
}

+(Comment *)getComment:(NSInteger)commentID
{
    NSMutableArray *dataList = [SharedComment sharedComment].commentList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_commentID = %ld",commentID];
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
        ((Comment *)copy).commentID = self.commentID;
        ((Comment *)copy).userAccountID = self.userAccountID;
        [copy setText:self.text];
        ((Comment *)copy).type = self.type;
        ((Comment *)copy).receiptID = self.receiptID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editComment:(Comment *)editingComment
{
    if(self.commentID == editingComment.commentID
       && self.userAccountID == editingComment.userAccountID
       && [self.text isEqualToString:editingComment.text]
       && self.type == editingComment.type
       && self.receiptID == editingComment.receiptID
       )
    {
        return NO;
    }
    return YES;
}

+(Comment *)copyFrom:(Comment *)fromComment to:(Comment *)toComment
{
    toComment.commentID = fromComment.commentID;
    toComment.userAccountID = fromComment.userAccountID;
    toComment.text = fromComment.text;
    toComment.type = fromComment.type;
    toComment.receiptID = fromComment.receiptID;
    toComment.modifiedUser = [Utility modifiedUser];
    toComment.modifiedDate = [Utility currentDateTime];
    
    return toComment;
}


@end
