//
//  CreditCardAndOrderSummary.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 15/11/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditCardAndOrderSummary : NSObject
@property (nonatomic) float totalAmount;
@property (nonatomic) float specialPriceDiscount;
@property (nonatomic) float discountProgramValue;
@property (nonatomic) float discountPromoCodeValue;
@property (nonatomic) BOOL showVoucherListButton;
@property (nonatomic) float afterDiscount;
@property (nonatomic) float serviceChargeValue;
@property (nonatomic) float vatValue;
@property (nonatomic) float netTotal;
@property (nonatomic) NSInteger luckyDrawCount;
@property (nonatomic) float beforeVat;


@property (nonatomic) BOOL showTotalAmount;
@property (nonatomic) BOOL showSpecialPriceDiscount;
@property (nonatomic) BOOL showDiscountProgram;
@property (nonatomic) BOOL applyVoucherCode;
@property (nonatomic) BOOL showAfterDiscount;
@property (nonatomic) BOOL showServiceCharge;
@property (nonatomic) BOOL showVat;
@property (nonatomic) BOOL showNetTotal;
@property (nonatomic) BOOL showLuckyDrawCount;
@property (nonatomic) BOOL showBeforeVat;
@property (nonatomic) NSInteger showPayBuffetButton;//0=not show,1=pay,2=order obuffet

@property (nonatomic) NSInteger noOfItem;
@property (retain, nonatomic) NSString *discountProgramTitle;
@property (nonatomic) BOOL priceIncludeVat;
@property (nonatomic) float serviceChargePercent;
@property (nonatomic) float percentVat;
@end
