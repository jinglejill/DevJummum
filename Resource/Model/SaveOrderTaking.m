//
//  SaveOrderTaking.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SaveOrderTaking.h"
#import "SharedSaveOrderTaking.h"
#import "Utility.h"
#import "OrderTaking.h"


@implementation SaveOrderTaking

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [self valueForKey:@"saveOrderTakingID"]?[self valueForKey:@"saveOrderTakingID"]:[NSNull null],@"saveOrderTakingID",
        [self valueForKey:@"branchID"]?[self valueForKey:@"branchID"]:[NSNull null],@"branchID",
        [self valueForKey:@"customerTableID"]?[self valueForKey:@"customerTableID"]:[NSNull null],@"customerTableID",
        [self valueForKey:@"menuID"]?[self valueForKey:@"menuID"]:[NSNull null],@"menuID",
        [self valueForKey:@"quantity"]?[self valueForKey:@"quantity"]:[NSNull null],@"quantity",
        [self valueForKey:@"specialPrice"]?[self valueForKey:@"specialPrice"]:[NSNull null],@"specialPrice",
        [self valueForKey:@"price"]?[self valueForKey:@"price"]:[NSNull null],@"price",
        [self valueForKey:@"takeAway"]?[self valueForKey:@"takeAway"]:[NSNull null],@"takeAway",
        [self valueForKey:@"takeAwayPrice"]?[self valueForKey:@"takeAwayPrice"]:[NSNull null],@"takeAwayPrice",
        [self valueForKey:@"noteIDListInText"]?[self valueForKey:@"noteIDListInText"]:[NSNull null],@"noteIDListInText",
        [self valueForKey:@"notePrice"]?[self valueForKey:@"notePrice"]:[NSNull null],@"notePrice",
        [self valueForKey:@"discountValue"]?[self valueForKey:@"discountValue"]:[NSNull null],@"discountValue",
        [self valueForKey:@"orderNo"]?[self valueForKey:@"orderNo"]:[NSNull null],@"orderNo",
        [self valueForKey:@"status"]?[self valueForKey:@"status"]:[NSNull null],@"status",
        [self valueForKey:@"saveReceiptID"]?[self valueForKey:@"saveReceiptID"]:[NSNull null],@"saveReceiptID",
        [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
        [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
        nil];
}

-(SaveOrderTaking *)initWithBranchID:(NSInteger)branchID customerTableID:(NSInteger)customerTableID menuID:(NSInteger)menuID quantity:(float)quantity specialPrice:(float)specialPrice price:(float)price takeAway:(NSInteger)takeAway takeAwayPrice:(float)takeAwayPrice noteIDListInText:(NSString *)noteIDListInText notePrice:(float)notePrice discountValue:(float)discountValue orderNo:(NSInteger)orderNo status:(NSInteger)status saveReceiptID:(NSInteger)saveReceiptID
{
    self = [super init];
    if(self)
    {
        self.saveOrderTakingID = [SaveOrderTaking getNextID];
        self.branchID = branchID;
        self.customerTableID = customerTableID;
        self.menuID = menuID;
        self.quantity = quantity;
        self.specialPrice = specialPrice;
        self.price = price;
        self.takeAway = takeAway;
        self.takeAwayPrice = takeAwayPrice;
        self.noteIDListInText = noteIDListInText;
        self.notePrice = notePrice;
        self.discountValue = discountValue;
        self.orderNo = orderNo;
        self.status = status;
        self.saveReceiptID = saveReceiptID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"saveOrderTakingID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedSaveOrderTaking sharedSaveOrderTaking].saveOrderTakingList;


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

+(void)addObject:(SaveOrderTaking *)saveOrderTaking
{
    NSMutableArray *dataList = [SharedSaveOrderTaking sharedSaveOrderTaking].saveOrderTakingList;
    [dataList addObject:saveOrderTaking];
}

+(void)removeObject:(SaveOrderTaking *)saveOrderTaking
{
    NSMutableArray *dataList = [SharedSaveOrderTaking sharedSaveOrderTaking].saveOrderTakingList;
    [dataList removeObject:saveOrderTaking];
}

+(void)addList:(NSMutableArray *)saveOrderTakingList
{
    NSMutableArray *dataList = [SharedSaveOrderTaking sharedSaveOrderTaking].saveOrderTakingList;
    [dataList addObjectsFromArray:saveOrderTakingList];
}

+(void)removeList:(NSMutableArray *)saveOrderTakingList
{
    NSMutableArray *dataList = [SharedSaveOrderTaking sharedSaveOrderTaking].saveOrderTakingList;
    [dataList removeObjectsInArray:saveOrderTakingList];
}

+(SaveOrderTaking *)getSaveOrderTaking:(NSInteger)saveOrderTakingID
{
    NSMutableArray *dataList = [SharedSaveOrderTaking sharedSaveOrderTaking].saveOrderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_saveOrderTakingID = %ld",saveOrderTakingID];
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
        ((SaveOrderTaking *)copy).saveOrderTakingID = self.saveOrderTakingID;
        ((SaveOrderTaking *)copy).branchID = self.branchID;
        ((SaveOrderTaking *)copy).customerTableID = self.customerTableID;
        ((SaveOrderTaking *)copy).menuID = self.menuID;
        ((SaveOrderTaking *)copy).quantity = self.quantity;
        ((SaveOrderTaking *)copy).specialPrice = self.specialPrice;
        ((SaveOrderTaking *)copy).price = self.price;
        ((SaveOrderTaking *)copy).takeAway = self.takeAway;
        ((SaveOrderTaking *)copy).takeAwayPrice = self.takeAwayPrice;
        [copy setNoteIDListInText:self.noteIDListInText];
        ((SaveOrderTaking *)copy).notePrice = self.notePrice;
        ((SaveOrderTaking *)copy).discountValue = self.discountValue;
        ((SaveOrderTaking *)copy).orderNo = self.orderNo;
        ((SaveOrderTaking *)copy).status = self.status;
        ((SaveOrderTaking *)copy).saveReceiptID = self.saveReceiptID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editSaveOrderTaking:(SaveOrderTaking *)editingSaveOrderTaking
{
    if(self.saveOrderTakingID == editingSaveOrderTaking.saveOrderTakingID
    && self.branchID == editingSaveOrderTaking.branchID
    && self.customerTableID == editingSaveOrderTaking.customerTableID
    && self.menuID == editingSaveOrderTaking.menuID
    && self.quantity == editingSaveOrderTaking.quantity
    && self.specialPrice == editingSaveOrderTaking.specialPrice
    && self.price == editingSaveOrderTaking.price
    && self.takeAway == editingSaveOrderTaking.takeAway
    && self.takeAwayPrice == editingSaveOrderTaking.takeAwayPrice
    && [self.noteIDListInText isEqualToString:editingSaveOrderTaking.noteIDListInText]
    && self.notePrice == editingSaveOrderTaking.notePrice
    && self.discountValue == editingSaveOrderTaking.discountValue
    && self.orderNo == editingSaveOrderTaking.orderNo
    && self.status == editingSaveOrderTaking.status
    && self.saveReceiptID == editingSaveOrderTaking.saveReceiptID
    )
    {
        return NO;
    }
    return YES;
}

+(SaveOrderTaking *)copyFrom:(SaveOrderTaking *)fromSaveOrderTaking to:(SaveOrderTaking *)toSaveOrderTaking
{
    toSaveOrderTaking.saveOrderTakingID = fromSaveOrderTaking.saveOrderTakingID;
    toSaveOrderTaking.branchID = fromSaveOrderTaking.branchID;
    toSaveOrderTaking.customerTableID = fromSaveOrderTaking.customerTableID;
    toSaveOrderTaking.menuID = fromSaveOrderTaking.menuID;
    toSaveOrderTaking.quantity = fromSaveOrderTaking.quantity;
    toSaveOrderTaking.specialPrice = fromSaveOrderTaking.specialPrice;
    toSaveOrderTaking.price = fromSaveOrderTaking.price;
    toSaveOrderTaking.takeAway = fromSaveOrderTaking.takeAway;
    toSaveOrderTaking.takeAwayPrice = fromSaveOrderTaking.takeAwayPrice;
    toSaveOrderTaking.noteIDListInText = fromSaveOrderTaking.noteIDListInText;
    toSaveOrderTaking.notePrice = fromSaveOrderTaking.notePrice;
    toSaveOrderTaking.discountValue = fromSaveOrderTaking.discountValue;
    toSaveOrderTaking.orderNo = fromSaveOrderTaking.orderNo;
    toSaveOrderTaking.status = fromSaveOrderTaking.status;
    toSaveOrderTaking.saveReceiptID = fromSaveOrderTaking.saveReceiptID;
    toSaveOrderTaking.modifiedUser = [Utility modifiedUser];
    toSaveOrderTaking.modifiedDate = [Utility currentDateTime];
    
    return toSaveOrderTaking;
}

+(NSMutableArray *)createSaveOrderTakingList:(NSMutableArray *)orderTakingList
{
    NSMutableArray *saveOrderTakingList = [[NSMutableArray alloc]init];
    for(OrderTaking *item in orderTakingList)
    {
        SaveOrderTaking *saveOrderTaking = [[SaveOrderTaking alloc]initWithBranchID:item.branchID customerTableID:item.customerTableID menuID:item.menuID quantity:item.quantity specialPrice:item.specialPrice price:item.price takeAway:item.takeAway takeAwayPrice:item.takeAwayPrice noteIDListInText:item.noteIDListInText notePrice:item.notePrice discountValue:0 orderNo:item.orderNo status:item.status saveReceiptID:0];
        [saveOrderTakingList addObject:saveOrderTaking];
        [SaveOrderTaking addObject:saveOrderTaking];
    }
    
    return saveOrderTakingList;
}
@end
