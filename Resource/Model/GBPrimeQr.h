//
//  GBPrimeQr.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 2/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBPrimeQr : NSObject
@property (retain, nonatomic) NSString * postUrl;
@property (retain, nonatomic) NSString * token;
@property (nonatomic) float amount;
@property (retain, nonatomic) NSString * referenceNo;//วันที่ + encrypted(receiptID)
@property (retain, nonatomic) NSString * payType;
@property (retain, nonatomic) NSString * responseUrl;
@property (retain, nonatomic) NSString * backgroundUrl;
@property (retain, nonatomic) NSString * merchantDefined1;//receiptID
@property (retain, nonatomic) NSString * merchantDefined2;//branchID
@property (retain, nonatomic) NSString * merchantDefined3;//deviceToken
@property (retain, nonatomic) NSString * merchantDefined4;//memberID
@property (retain, nonatomic) NSString * merchantDefined5;//receiptNoID
@property (retain, nonatomic) NSString * detail;//customerTableID


@end
