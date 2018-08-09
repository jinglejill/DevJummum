//
//  RecommendShop.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 4/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RecommendShop.h"
#import "SharedRecommendShop.h"
#import "Utility.h"


@implementation RecommendShop

-(RecommendShop *)initWithUserAccountID:(NSInteger)userAccountID text:(NSString *)text type:(NSInteger)type
{
    self = [super init];
    if(self)
    {
        self.recommendShopID = [RecommendShop getNextID];
        self.userAccountID = userAccountID;
        self.text = text;
        self.type = type;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"recommendShopID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedRecommendShop sharedRecommendShop].recommendShopList;
    
    
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

+(void)addObject:(RecommendShop *)recommendShop
{
    NSMutableArray *dataList = [SharedRecommendShop sharedRecommendShop].recommendShopList;
    [dataList addObject:recommendShop];
}

+(void)removeObject:(RecommendShop *)recommendShop
{
    NSMutableArray *dataList = [SharedRecommendShop sharedRecommendShop].recommendShopList;
    [dataList removeObject:recommendShop];
}

+(void)addList:(NSMutableArray *)recommendShopList
{
    NSMutableArray *dataList = [SharedRecommendShop sharedRecommendShop].recommendShopList;
    [dataList addObjectsFromArray:recommendShopList];
}

+(void)removeList:(NSMutableArray *)recommendShopList
{
    NSMutableArray *dataList = [SharedRecommendShop sharedRecommendShop].recommendShopList;
    [dataList removeObjectsInArray:recommendShopList];
}

+(RecommendShop *)getRecommendShop:(NSInteger)recommendShopID
{
    NSMutableArray *dataList = [SharedRecommendShop sharedRecommendShop].recommendShopList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_recommendShopID = %ld",recommendShopID];
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
        ((RecommendShop *)copy).recommendShopID = self.recommendShopID;
        ((RecommendShop *)copy).userAccountID = self.userAccountID;
        [copy setText:self.text];
        ((RecommendShop *)copy).type = self.type;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editRecommendShop:(RecommendShop *)editingRecommendShop
{
    if(self.recommendShopID == editingRecommendShop.recommendShopID
       && self.userAccountID == editingRecommendShop.userAccountID
       && [self.text isEqualToString:editingRecommendShop.text]
       && self.type == editingRecommendShop.type
       )
    {
        return NO;
    }
    return YES;
}

+(RecommendShop *)copyFrom:(RecommendShop *)fromRecommendShop to:(RecommendShop *)toRecommendShop
{
    toRecommendShop.recommendShopID = fromRecommendShop.recommendShopID;
    toRecommendShop.userAccountID = fromRecommendShop.userAccountID;
    toRecommendShop.text = fromRecommendShop.text;
    toRecommendShop.type = fromRecommendShop.type;
    toRecommendShop.modifiedUser = [Utility modifiedUser];
    toRecommendShop.modifiedDate = [Utility currentDateTime];
    
    return toRecommendShop;
}


@end
