//
//  Menu.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 27/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Menu.h"
#import "MenuType.h"
#import "SubMenuType.h"
#import "OrderTaking.h"
#import "BuffetMenuMap.h"
#import "SharedMenu.h"
#import "SharedCurrentMenu.h"
#import "SharedMenuForBuffet.h"
#import "SharedBuffetMenuMap.h"
#import "Utility.h"
#import "Receipt.h"



@implementation Menu

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [self valueForKey:@"menuID"]?[self valueForKey:@"menuID"]:[NSNull null],@"menuID",
        [self valueForKey:@"menuCode"]?[self valueForKey:@"menuCode"]:[NSNull null],@"menuCode",
        [self valueForKey:@"titleThai"]?[self valueForKey:@"titleThai"]:[NSNull null],@"titleThai",
        [self valueForKey:@"price"]?[self valueForKey:@"price"]:[NSNull null],@"price",
        [self valueForKey:@"menuTypeID"]?[self valueForKey:@"menuTypeID"]:[NSNull null],@"menuTypeID",
        [self valueForKey:@"subMenuTypeID"]?[self valueForKey:@"subMenuTypeID"]:[NSNull null],@"subMenuTypeID",
        [self valueForKey:@"buffetMenu"]?[self valueForKey:@"buffetMenu"]:[NSNull null],@"buffetMenu",
        [self valueForKey:@"alacarteMenu"]?[self valueForKey:@"alacarteMenu"]:[NSNull null],@"alacarteMenu",
        [self valueForKey:@"timeToOrder"]?[self valueForKey:@"timeToOrder"]:[NSNull null],@"timeToOrder",
        [self valueForKey:@"recommended"]?[self valueForKey:@"recommended"]:[NSNull null],@"recommended",
        [self valueForKey:@"recommendedOrderNo"]?[self valueForKey:@"recommendedOrderNo"]:[NSNull null],@"recommendedOrderNo",
        [self valueForKey:@"imageUrl"]?[self valueForKey:@"imageUrl"]:[NSNull null],@"imageUrl",
        [self valueForKey:@"color"]?[self valueForKey:@"color"]:[NSNull null],@"color",
        [self valueForKey:@"orderNo"]?[self valueForKey:@"orderNo"]:[NSNull null],@"orderNo",
        [self valueForKey:@"status"]?[self valueForKey:@"status"]:[NSNull null],@"status",
        [self valueForKey:@"remark"]?[self valueForKey:@"remark"]:[NSNull null],@"remark",
        [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
        [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
        nil];
}

-(Menu *)initWithMenuCode:(NSString *)menuCode titleThai:(NSString *)titleThai price:(float)price menuTypeID:(NSInteger)menuTypeID subMenuTypeID:(NSInteger)subMenuTypeID buffetMenu:(NSInteger)buffetMenu alacarteMenu:(NSInteger)alacarteMenu timeToOrder:(NSInteger)timeToOrder recommended:(NSInteger)recommended recommendedOrderNo:(NSInteger)recommendedOrderNo imageUrl:(NSString *)imageUrl color:(NSString *)color orderNo:(NSInteger)orderNo status:(NSInteger)status remark:(NSString *)remark
{
    self = [super init];
    if(self)
    {
        self.menuID = [Menu getNextID];
        self.menuCode = menuCode;
        self.titleThai = titleThai;
        self.price = price;
        self.menuTypeID = menuTypeID;
        self.subMenuTypeID = subMenuTypeID;
        self.buffetMenu = buffetMenu;
        self.alacarteMenu = alacarteMenu;
        self.timeToOrder = timeToOrder;
        self.recommended = recommended;
        self.recommendedOrderNo = recommendedOrderNo;
        self.imageUrl = imageUrl;
        self.color = color;
        self.orderNo = orderNo;
        self.status = status;
        self.remark = remark;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"menuID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;


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

+(void)addObject:(Menu *)menu
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    [dataList addObject:menu];
}

+(void)removeObject:(Menu *)menu
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    [dataList removeObject:menu];
}

+(void)addList:(NSMutableArray *)menuList
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    [dataList addObjectsFromArray:menuList];
}

+(void)removeList:(NSMutableArray *)menuList
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    [dataList removeObjectsInArray:menuList];
}

+(Menu *)getMenu:(NSInteger)menuID
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuID = %ld",menuID];
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
        ((Menu *)copy).menuID = self.menuID;
        [copy setMenuCode:self.menuCode];
        [copy setTitleThai:self.titleThai];
        ((Menu *)copy).price = self.price;
        ((Menu *)copy).menuTypeID = self.menuTypeID;
        ((Menu *)copy).subMenuTypeID = self.subMenuTypeID;
        ((Menu *)copy).buffetMenu = self.buffetMenu;
        ((Menu *)copy).alacarteMenu = self.alacarteMenu;
        ((Menu *)copy).timeToOrder = self.timeToOrder;
        ((Menu *)copy).recommended = self.recommended;
        ((Menu *)copy).recommendedOrderNo = self.recommendedOrderNo;
        [copy setImageUrl:self.imageUrl];
        [copy setColor:self.color];
        ((Menu *)copy).orderNo = self.orderNo;
        ((Menu *)copy).status = self.status;
        [copy setRemark:self.remark];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editMenu:(Menu *)editingMenu
{
    if(self.menuID == editingMenu.menuID
    && [self.menuCode isEqualToString:editingMenu.menuCode]
    && [self.titleThai isEqualToString:editingMenu.titleThai]
    && self.price == editingMenu.price
    && self.menuTypeID == editingMenu.menuTypeID
    && self.subMenuTypeID == editingMenu.subMenuTypeID
    && self.buffetMenu == editingMenu.buffetMenu
    && self.alacarteMenu == editingMenu.alacarteMenu
    && self.timeToOrder == editingMenu.timeToOrder
    && self.recommended == editingMenu.recommended
    && self.recommendedOrderNo == editingMenu.recommendedOrderNo
    && [self.imageUrl isEqualToString:editingMenu.imageUrl]
    && [self.color isEqualToString:editingMenu.color]
    && self.orderNo == editingMenu.orderNo
    && self.status == editingMenu.status
    && [self.remark isEqualToString:editingMenu.remark]
    )
    {
        return NO;
    }
    return YES;
}

+(Menu *)copyFrom:(Menu *)fromMenu to:(Menu *)toMenu
{
    toMenu.menuID = fromMenu.menuID;
    toMenu.menuCode = fromMenu.menuCode;
    toMenu.titleThai = fromMenu.titleThai;
    toMenu.price = fromMenu.price;
    toMenu.menuTypeID = fromMenu.menuTypeID;
    toMenu.subMenuTypeID = fromMenu.subMenuTypeID;
    toMenu.buffetMenu = fromMenu.buffetMenu;
    toMenu.alacarteMenu = fromMenu.alacarteMenu;
    toMenu.timeToOrder = fromMenu.timeToOrder;
    toMenu.recommended = fromMenu.recommended;
    toMenu.recommendedOrderNo = fromMenu.recommendedOrderNo;
    toMenu.imageUrl = fromMenu.imageUrl;
    toMenu.color = fromMenu.color;
    toMenu.orderNo = fromMenu.orderNo;
    toMenu.status = fromMenu.status;
    toMenu.remark = fromMenu.remark;
    toMenu.modifiedUser = [Utility modifiedUser];
    toMenu.modifiedDate = [Utility currentDateTime];
    
    return toMenu;
}

+(Menu *)getMenu:(NSInteger)menuID branchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuID = %ld and _branchID = %ld",menuID,branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getMenuListWithMenuType:(NSInteger)menuTypeID menuList:(NSMutableArray *)menuList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld",menuTypeID];
    NSArray *filterArray = [menuList filteredArrayUsingPredicate:predicate];
    
    
    NSMutableArray *sortArray = [self sortList:[filterArray mutableCopy]];
    return sortArray;
}

+(NSMutableArray *)sortList:(NSMutableArray *)menuList
{
    for(Menu *item in menuList)
    {
        SubMenuType *subMenuType = [SubMenuType getSubMenuType:item.subMenuTypeID];
        item.subMenuOrderNo = subMenuType.orderNo;
        MenuType *menuType = [MenuType getMenuType:item.menuTypeID];
        item.menuOrderNo = menuType.orderNo;
    }
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_menuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_subMenuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"_menuID" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3,sortDescriptor4, nil];
    NSArray *sortArray = [menuList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(void)setSharedData:(NSMutableArray *)dataList
{
    [SharedMenu sharedMenu].menuList = dataList;
}

+(NSMutableArray *)getMenuListWithOrderTakingList:(NSMutableArray *)orderTakingList
{
    NSSet *menuIDSet = [NSSet setWithArray:[orderTakingList valueForKey:@"_menuID"]];
    
    
    NSInteger branchID = 0;
    if([orderTakingList count]>0)
    {
        OrderTaking *orderTaking = orderTakingList[0];
        branchID = orderTaking.branchID;
    }
    NSMutableArray *menuList = [[NSMutableArray alloc]init];
    for(NSNumber *item in menuIDSet)
    {
        Menu *menu = [Menu getMenu:[item integerValue] branchID:branchID];
        [menuList addObject:menu];
    }
    
    menuList = [Menu sortList:menuList];
    return menuList;
}

+(NSMutableArray *)getMenuListWithBranchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_branchID = %ld",branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)setBranchID:(NSInteger)branchID menuList:(NSMutableArray *)menuList
{
    for(Menu *item in menuList)
    {
        item.branchID = branchID;
    }
    
    return menuList;
}

+(NSMutableArray *)getCurrentMenuList
{
    NSMutableArray *dataList = [SharedCurrentMenu SharedCurrentMenu].menuList;
    return dataList;
}

+(void)setCurrentMenuList:(NSMutableArray *)menuList
{
    [SharedCurrentMenu SharedCurrentMenu].menuList = menuList;
}

+(void)removeCurrentMenuList
{
    NSMutableArray *dataList = [SharedCurrentMenu SharedCurrentMenu].menuList;
    [dataList removeAllObjects];
}

+(MenuForBuffet *)getCurrentMenuForBuffet
{
    MenuForBuffet *menuForBuffet = [SharedMenuForBuffet sharedMenuForBuffet].menuForBuffet;
    return menuForBuffet;
}

+(void)setCurrentMenuForBuffet:(MenuForBuffet *)menuForBuffet
{
    [SharedMenuForBuffet sharedMenuForBuffet].menuForBuffet = menuForBuffet;
}

+(void)removeCurrentMenuForBuffet
{
    MenuForBuffet *menuForBuffet = [SharedMenuForBuffet sharedMenuForBuffet].menuForBuffet;
    menuForBuffet = nil;
}

+(NSMutableArray *)getMenuListALaCarteWithBranchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_branchID = %ld and _alacarteMenu = 1",branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getMenuBelongToBuffet:(Receipt *)receipt
{
    NSMutableSet *menuSet = [[NSMutableSet alloc]init];
    NSMutableSet *menuBelongToBuffetSet = [[NSMutableSet alloc]init];
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
    for(OrderTaking *item in orderTakingList)
    {
        Menu *menu = [Menu getMenu:item.menuID branchID:item.branchID];
        [menuSet addObject:menu];
    }
    
    for(Menu *item in menuSet)
    {
        if(item.buffetMenu)
        {
            NSMutableArray *dataList = [SharedBuffetMenuMap sharedBuffetMenuMap].buffetMenuMapList;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_branchID = %ld and _buffetMenuID = %ld",item.branchID,item.menuID];

            NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
            for(BuffetMenuMap *buffetMenuMap in filterArray)
            {
                Menu *menu = [Menu getMenu:buffetMenuMap.menuID branchID:item.branchID];
                [menuBelongToBuffetSet addObject:menu];
                
            }            
        }
    }
    
    return [[menuBelongToBuffetSet allObjects] mutableCopy];
}

+(NSMutableArray *)getMenuListRecommendedWithMenuList:(NSMutableArray *)menuList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_recommended = 1"];
    NSArray *filterArray = [menuList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_recommendedOrderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

+(BOOL)hasRecommendedMenuWithMenuList:(NSMutableArray *)menuList
{
    return [[self getMenuListRecommendedWithMenuList:menuList] count] > 0;
}
@end
