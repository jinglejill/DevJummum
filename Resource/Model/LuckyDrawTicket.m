//
//  LuckyDrawTicket.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 8/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "LuckyDrawTicket.h"
#import "SharedLuckyDrawTicket.h"
#import "Utility.h"


@implementation LuckyDrawTicket

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self valueForKey:@"luckyDrawTicketID"]?[self valueForKey:@"luckyDrawTicketID"]:[NSNull null],@"luckyDrawTicketID",
            [self valueForKey:@"receiptID"]?[self valueForKey:@"receiptID"]:[NSNull null],@"receiptID",
            [self valueForKey:@"memberID"]?[self valueForKey:@"memberID"]:[NSNull null],@"memberID",
            [self valueForKey:@"rewardRedemptionID"]?[self valueForKey:@"rewardRedemptionID"]:[NSNull null],@"rewardRedemptionID",
            [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
            [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
            nil];
}

-(LuckyDrawTicket *)initWithReceiptID:(NSInteger)receiptID memberID:(NSInteger)memberID rewardRedemptionID:(NSInteger)rewardRedemptionID
{
    self = [super init];
    if(self)
    {
        self.luckyDrawTicketID = [LuckyDrawTicket getNextID];
        self.receiptID = receiptID;
        self.memberID = memberID;
        self.rewardRedemptionID = rewardRedemptionID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"luckyDrawTicketID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedLuckyDrawTicket sharedLuckyDrawTicket].luckyDrawTicketList;
    
    
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

+(void)addObject:(LuckyDrawTicket *)luckyDrawTicket
{
    NSMutableArray *dataList = [SharedLuckyDrawTicket sharedLuckyDrawTicket].luckyDrawTicketList;
    [dataList addObject:luckyDrawTicket];
}

+(void)removeObject:(LuckyDrawTicket *)luckyDrawTicket
{
    NSMutableArray *dataList = [SharedLuckyDrawTicket sharedLuckyDrawTicket].luckyDrawTicketList;
    [dataList removeObject:luckyDrawTicket];
}

+(void)addList:(NSMutableArray *)luckyDrawTicketList
{
    NSMutableArray *dataList = [SharedLuckyDrawTicket sharedLuckyDrawTicket].luckyDrawTicketList;
    [dataList addObjectsFromArray:luckyDrawTicketList];
}

+(void)removeList:(NSMutableArray *)luckyDrawTicketList
{
    NSMutableArray *dataList = [SharedLuckyDrawTicket sharedLuckyDrawTicket].luckyDrawTicketList;
    [dataList removeObjectsInArray:luckyDrawTicketList];
}

+(LuckyDrawTicket *)getLuckyDrawTicket:(NSInteger)luckyDrawTicketID
{
    NSMutableArray *dataList = [SharedLuckyDrawTicket sharedLuckyDrawTicket].luckyDrawTicketList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_luckyDrawTicketID = %ld",luckyDrawTicketID];
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
        ((LuckyDrawTicket *)copy).luckyDrawTicketID = self.luckyDrawTicketID;
        ((LuckyDrawTicket *)copy).receiptID = self.receiptID;
        ((LuckyDrawTicket *)copy).memberID = self.memberID;
        ((LuckyDrawTicket *)copy).rewardRedemptionID = self.rewardRedemptionID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editLuckyDrawTicket:(LuckyDrawTicket *)editingLuckyDrawTicket
{
    if(self.luckyDrawTicketID == editingLuckyDrawTicket.luckyDrawTicketID
       && self.receiptID == editingLuckyDrawTicket.receiptID
       && self.memberID == editingLuckyDrawTicket.memberID
       && self.rewardRedemptionID == editingLuckyDrawTicket.rewardRedemptionID
       )
    {
        return NO;
    }
    return YES;
}

+(LuckyDrawTicket *)copyFrom:(LuckyDrawTicket *)fromLuckyDrawTicket to:(LuckyDrawTicket *)toLuckyDrawTicket
{
    toLuckyDrawTicket.luckyDrawTicketID = fromLuckyDrawTicket.luckyDrawTicketID;
    toLuckyDrawTicket.receiptID = fromLuckyDrawTicket.receiptID;
    toLuckyDrawTicket.memberID = fromLuckyDrawTicket.memberID;
    toLuckyDrawTicket.rewardRedemptionID = fromLuckyDrawTicket.rewardRedemptionID;
    toLuckyDrawTicket.modifiedUser = [Utility modifiedUser];
    toLuckyDrawTicket.modifiedDate = [Utility currentDateTime];
    
    return toLuckyDrawTicket;
}




@end
