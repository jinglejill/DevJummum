//
//  Rating.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 8/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Rating.h"
#import "SharedRating.h"
#import "Utility.h"
#import "Setting.h"


@implementation Rating

-(Rating *)initWithReceiptID:(NSInteger)receiptID score:(NSInteger)score comment:(NSString *)comment
{
    self = [super init];
    if(self)
    {
        self.ratingID = [Rating getNextID];
        self.receiptID = receiptID;
        self.score = score;
        self.comment = comment;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"ratingID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedRating sharedRating].ratingList;
    
    
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

+(void)addObject:(Rating *)rating
{
    NSMutableArray *dataList = [SharedRating sharedRating].ratingList;
    [dataList addObject:rating];
}

+(void)removeObject:(Rating *)rating
{
    NSMutableArray *dataList = [SharedRating sharedRating].ratingList;
    [dataList removeObject:rating];
}

+(void)addList:(NSMutableArray *)ratingList
{
    NSMutableArray *dataList = [SharedRating sharedRating].ratingList;
    [dataList addObjectsFromArray:ratingList];
}

+(void)removeList:(NSMutableArray *)ratingList
{
    NSMutableArray *dataList = [SharedRating sharedRating].ratingList;
    [dataList removeObjectsInArray:ratingList];
}

+(Rating *)getRating:(NSInteger)ratingID
{
    NSMutableArray *dataList = [SharedRating sharedRating].ratingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_ratingID = %ld",ratingID];
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
        ((Rating *)copy).ratingID = self.ratingID;
        ((Rating *)copy).receiptID = self.receiptID;
        ((Rating *)copy).score = self.score;
        [copy setComment:self.comment];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editRating:(Rating *)editingRating
{
    if(self.ratingID == editingRating.ratingID
       && self.receiptID == editingRating.receiptID
       && self.score == editingRating.score
       && [self.comment isEqualToString:editingRating.comment]
       )
    {
        return NO;
    }
    return YES;
}

+(Rating *)copyFrom:(Rating *)fromRating to:(Rating *)toRating
{
    toRating.ratingID = fromRating.ratingID;
    toRating.receiptID = fromRating.receiptID;
    toRating.score = fromRating.score;
    toRating.comment = fromRating.comment;
    toRating.modifiedUser = [Utility modifiedUser];
    toRating.modifiedDate = [Utility currentDateTime];
    
    return toRating;
}

+(Rating *)getRatingWithReceiptID:(NSInteger)receiptID
{
    NSMutableArray *dataList = [SharedRating sharedRating].ratingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld",receiptID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSString *)getTextWithScore:(NSInteger)score
{
    switch (score)
    {
        case 1:
        {
            NSString *message = [Setting getValue:@"091m" example:@"BAD"];
            return message;
        }
        case 2:
        {
            NSString *message = [Setting getValue:@"092m" example:@"POOR"];
            return message;
        }
        case 3:
        {
            NSString *message = [Setting getValue:@"093m" example:@"FAIR"];
            return message;
        }         
        case 4:
        {
            NSString *message = [Setting getValue:@"094m" example:@"GOOD"];
            return message;
        }
        case 5:
        {
            NSString *message = [Setting getValue:@"095m" example:@"EXCELLENT!"];
            return message;
        }
        default:
            break;
    }
    return @"";
}


@end
