//
//  SaveReceipt.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SaveReceipt.h"
#import "SharedSaveReceipt.h"
#import "SharedCurrentSaveReceipt.h"
#import "Utility.h"


@implementation SaveReceipt

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [self valueForKey:@"saveReceiptID"]?[self valueForKey:@"saveReceiptID"]:[NSNull null],@"saveReceiptID",
        [self valueForKey:@"branchID"]?[self valueForKey:@"branchID"]:[NSNull null],@"branchID",
        [self valueForKey:@"customerTableID"]?[self valueForKey:@"customerTableID"]:[NSNull null],@"customerTableID",
        [self valueForKey:@"memberID"]?[self valueForKey:@"memberID"]:[NSNull null],@"memberID",
        [self valueForKey:@"remark"]?[self valueForKey:@"remark"]:[NSNull null],@"remark",
        [self valueForKey:@"status"]?[self valueForKey:@"status"]:[NSNull null],@"status",
        [self valueForKey:@"buffetReceiptID"]?[self valueForKey:@"buffetReceiptID"]:[NSNull null],@"buffetReceiptID",
        [self valueForKey:@"voucherCode"]?[self valueForKey:@"voucherCode"]:[NSNull null],@"voucherCode",
        [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
        [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
        nil];
}

-(SaveReceipt *)initWithBranchID:(NSInteger)branchID customerTableID:(NSInteger)customerTableID memberID:(NSInteger)memberID remark:(NSString *)remark status:(NSInteger)status buffetReceiptID:(NSInteger)buffetReceiptID voucherCode:(NSString *)voucherCode
{
    self = [super init];
    if(self)
    {
        self.saveReceiptID = [SaveReceipt getNextID];
        self.branchID = branchID;
        self.customerTableID = customerTableID;
        self.memberID = memberID;
        self.remark = remark;
        self.status = status;
        self.buffetReceiptID = buffetReceiptID;
        self.voucherCode = voucherCode;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"saveReceiptID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedSaveReceipt sharedSaveReceipt].saveReceiptList;


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

+(void)addObject:(SaveReceipt *)saveReceipt
{
    NSMutableArray *dataList = [SharedSaveReceipt sharedSaveReceipt].saveReceiptList;
    [dataList addObject:saveReceipt];
}

+(void)removeObject:(SaveReceipt *)saveReceipt
{
    NSMutableArray *dataList = [SharedSaveReceipt sharedSaveReceipt].saveReceiptList;
    [dataList removeObject:saveReceipt];
}

+(void)addList:(NSMutableArray *)saveReceiptList
{
    NSMutableArray *dataList = [SharedSaveReceipt sharedSaveReceipt].saveReceiptList;
    [dataList addObjectsFromArray:saveReceiptList];
}

+(void)removeList:(NSMutableArray *)saveReceiptList
{
    NSMutableArray *dataList = [SharedSaveReceipt sharedSaveReceipt].saveReceiptList;
    [dataList removeObjectsInArray:saveReceiptList];
}

+(SaveReceipt *)getSaveReceipt:(NSInteger)saveReceiptID
{
    NSMutableArray *dataList = [SharedSaveReceipt sharedSaveReceipt].saveReceiptList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_saveReceiptID = %ld",saveReceiptID];
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
        ((SaveReceipt *)copy).saveReceiptID = self.saveReceiptID;
        ((SaveReceipt *)copy).branchID = self.branchID;
        ((SaveReceipt *)copy).customerTableID = self.customerTableID;
        ((SaveReceipt *)copy).memberID = self.memberID;
        [copy setRemark:self.remark];
        ((SaveReceipt *)copy).status = self.status;
        ((SaveReceipt *)copy).buffetReceiptID = self.buffetReceiptID;
        [copy setVoucherCode:self.voucherCode];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editSaveReceipt:(SaveReceipt *)editingSaveReceipt
{
    if(self.saveReceiptID == editingSaveReceipt.saveReceiptID
    && self.branchID == editingSaveReceipt.branchID
    && self.customerTableID == editingSaveReceipt.customerTableID
    && self.memberID == editingSaveReceipt.memberID
    && [self.remark isEqualToString:editingSaveReceipt.remark]
    && self.status == editingSaveReceipt.status
    && self.buffetReceiptID == editingSaveReceipt.buffetReceiptID
    && [self.voucherCode isEqualToString:editingSaveReceipt.voucherCode]
    )
    {
        return NO;
    }
    return YES;
}

+(SaveReceipt *)copyFrom:(SaveReceipt *)fromSaveReceipt to:(SaveReceipt *)toSaveReceipt
{
    toSaveReceipt.saveReceiptID = fromSaveReceipt.saveReceiptID;
    toSaveReceipt.branchID = fromSaveReceipt.branchID;
    toSaveReceipt.customerTableID = fromSaveReceipt.customerTableID;
    toSaveReceipt.memberID = fromSaveReceipt.memberID;
    toSaveReceipt.remark = fromSaveReceipt.remark;
    toSaveReceipt.status = fromSaveReceipt.status;
    toSaveReceipt.buffetReceiptID = fromSaveReceipt.buffetReceiptID;
    toSaveReceipt.voucherCode = fromSaveReceipt.voucherCode;
    toSaveReceipt.modifiedUser = [Utility modifiedUser];
    toSaveReceipt.modifiedDate = [Utility currentDateTime];
    
    return toSaveReceipt;
}




+(SaveReceipt *)getCurrentSaveReceipt;
{
    return [SharedCurrentSaveReceipt sharedCurrentSaveReceipt].saveReceipt;
}

+(void)setCurrentSaveReceipt:(SaveReceipt *)saveReceipt;
{
    [SharedCurrentSaveReceipt sharedCurrentSaveReceipt].saveReceipt = saveReceipt;
}

+(void)removeCurrentSaveReceipt;
{
    [SharedCurrentSaveReceipt sharedCurrentSaveReceipt].saveReceipt = nil;
}
@end
