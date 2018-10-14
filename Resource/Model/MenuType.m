//
//  MenuType.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MenuType.h"
#import "SharedMenuType.h"
#import "Utility.h"
#import "Menu.h"


@implementation MenuType

-(MenuType *)initWithName:(NSString *)name nameEn:(NSString *)nameEn allowDiscount:(NSInteger)allowDiscount color:(NSString *)color orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.menuTypeID = [MenuType getNextID];
        self.name = name;
        self.nameEn = nameEn;
        self.allowDiscount = allowDiscount;
        self.color = color;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"menuTypeID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    
    
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

+(void)addObject:(MenuType *)menuType
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    [dataList addObject:menuType];
}

+(void)removeObject:(MenuType *)menuType
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    [dataList removeObject:menuType];
}

+(void)addList:(NSMutableArray *)menuTypeList
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    [dataList addObjectsFromArray:menuTypeList];
}

+(void)removeList:(NSMutableArray *)menuTypeList
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    [dataList removeObjectsInArray:menuTypeList];
}

+(MenuType *)getMenuType:(NSInteger)menuTypeID
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld",menuTypeID];
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
        ((MenuType *)copy).menuTypeID = self.menuTypeID;
        [copy setName:self.name];
        [copy setNameEn:self.nameEn];
        ((MenuType *)copy).allowDiscount = self.allowDiscount;
        [copy setColor:self.color];
        ((MenuType *)copy).orderNo = self.orderNo;
        ((MenuType *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editMenuType:(MenuType *)editingMenuType
{
    if(self.menuTypeID == editingMenuType.menuTypeID
       && [self.name isEqualToString:editingMenuType.name]
       && [self.nameEn isEqualToString:editingMenuType.nameEn]
       && self.allowDiscount == editingMenuType.allowDiscount
       && [self.color isEqualToString:editingMenuType.color]
       && self.orderNo == editingMenuType.orderNo
       && self.status == editingMenuType.status
       )
    {
        return NO;
    }
    return YES;
}

+(MenuType *)copyFrom:(MenuType *)fromMenuType to:(MenuType *)toMenuType
{
    toMenuType.menuTypeID = fromMenuType.menuTypeID;
    toMenuType.name = fromMenuType.name;
    toMenuType.nameEn = fromMenuType.nameEn;
    toMenuType.allowDiscount = fromMenuType.allowDiscount;
    toMenuType.color = fromMenuType.color;
    toMenuType.orderNo = fromMenuType.orderNo;
    toMenuType.status = fromMenuType.status;
    toMenuType.modifiedUser = [Utility modifiedUser];
    toMenuType.modifiedDate = [Utility currentDateTime];
    
    return toMenuType;
}
+(void)setSharedData:(NSMutableArray *)dataList
{
    [SharedMenuType sharedMenuType].menuTypeList = dataList;
}

+(NSMutableArray *)getMenuTypeList
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    return dataList;
}

+(NSMutableArray *)sortList:(NSMutableArray *)menuTypeList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [menuTypeList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray * )getMenuTypeListWithBranchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_branchID = %ld",branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    return [filterArray mutableCopy];
}
    
+(MenuType *)getMenuType:(NSInteger)menuTypeID branchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedMenuType sharedMenuType].menuTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld and _branchID = %ld",menuTypeID,branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}
    
+(NSMutableArray *)getMenuTypeListWithMenuList:(NSMutableArray *)menuList
{
    NSMutableSet *menuTypeSet = [[NSMutableSet alloc]init];
    for(Menu *item in menuList)
    {
        MenuType *menuType = [MenuType getMenuType:item.menuTypeID branchID:item.branchID];
        [menuTypeSet addObject:menuType];
    }
    
    NSMutableArray *sortArray = [self sortList:[[menuTypeSet allObjects] mutableCopy]];
    NSMutableArray *recommendedList = [Menu getMenuListRecommendedWithMenuList:menuList];
    if([recommendedList count]>0)
    {
        MenuType *menuType = [[MenuType alloc]initWithName:@"แนะนำ" nameEn:@"Recommended" allowDiscount:0 color:@"" orderNo:0 status:1];
        [sortArray insertObject:menuType atIndex:0];
    }
    
    return sortArray;
}

@end
