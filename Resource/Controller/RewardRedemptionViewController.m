//
//  RewardRedemptionViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 1/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RewardRedemptionViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "CustomTableViewCellRedemption.h"
#import "CustomTableViewCellLabel.h"
#import "CustomTableViewCellLabelDetailLabelWithImage.h"
#import "Setting.h"
#import "OrderTaking.h"
#import "Menu.h"
#import "SpecialPriceProgram.h"
#import "Message.h"
#import "DiscountGroupMenuMap.h"


@interface RewardRedemptionViewController ()
{
    NSTimer *timer;
    NSInteger _timeToCountDown;
    NSInteger _expandCollapse;//1=expand,0=collapse
    NSString *_promoCode;
}

@end

@implementation RewardRedemptionViewController
static NSString * const reuseIdentifierRedemption = @"CustomTableViewCellRedemption";
static NSString * const reuseIdentifierLabel = @"CustomTableViewCellLabel";
static NSString * const reuseIdentifierLabelDetailLabelWithImage = @"CustomTableViewCellLabelDetailLabelWithImage";


@synthesize lblNavTitle;
@synthesize lblCountDown;
@synthesize tbvData;
@synthesize rewardPoint;
@synthesize rewardRedemption;
@synthesize rewardPointSpent;
@synthesize promoCode;
@synthesize fromMenuMyReward;
@synthesize topViewHeight;
@synthesize bottomLabelHeight;


-(IBAction)unwindToRewardRedemption:(UIStoryboardSegue *)segue
{
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    bottomLabelHeight.constant = window.safeAreaInsets.bottom;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Language getText:@"แสดงโค้ด เพื่อรับสิทธิ์"];
    lblNavTitle.text = title;
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierRedemption bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierRedemption];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabel bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabel];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelDetailLabelWithImage bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelDetailLabelWithImage];
    }
    
    
    if(rewardRedemption.withInPeriod == 0)
    {
        NSString *message = [Language getText:@"ใช้ได้ 1 ครั้ง ภายใน %@"];
        lblCountDown.text = [NSString stringWithFormat:message,[Utility dateToString:rewardRedemption.usingEndDate toFormat:@"d MMM yyyy"]];
    }
    else
    {
        NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:rewardPointSpent.modifiedDate];
        _timeToCountDown = rewardRedemption.withInPeriod - seconds >= 0?rewardRedemption.withInPeriod - seconds:0;
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if(item == 0)
    {
        CustomTableViewCellLabelDetailLabelWithImage *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelDetailLabelWithImage];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lblText.text = [Language getText:@"แต้มคงเหลือ"];
        cell.lblText.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
        NSInteger point = floor(rewardPoint.point);
        NSString *strPoint = [Utility formatDecimal:point];
        cell.lblValue.text = [NSString stringWithFormat:@"%@ points",strPoint];        
        cell.lblValue.textColor = cSystem2;
        [cell.lblValue sizeToFit];
        cell.lblValueWidth.constant = cell.lblValue.frame.size.width;
        
        
        return cell;
    }
    else if(item == 1)
    {
        CustomTableViewCellRedemption *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRedemption];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height;
        
        
        NSString *strPoint = [Utility formatDecimal:rewardRedemption.point];
        cell.lblRemark.text = [NSString stringWithFormat:@"%@ points",strPoint];
        [cell.lblRemark sizeToFit];
        cell.lblRemarkWidth.constant = cell.lblRemark.frame.size.width;
        
        
        cell.lblRedeemDate.text = [Utility dateToString:rewardPointSpent.modifiedDate toFormat:@"d MMM yyyy HH:mm"];
        cell.txvPromoCode.text = promoCode.code;
        cell.imgQrCode.image = [self generateQRCodeWithString:promoCode.code scale:5];
        _promoCode = promoCode.code;
        
        
        if(rewardRedemption.discountGroupMenuID)
        {
            cell.btnCopy.hidden = NO;
            [cell.btnCopy setTitle:[Language getText:@"สั่งเลย"] forState:UIControlStateNormal];
            [cell.btnCopy removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
            [cell.btnCopy addTarget:self action:@selector(goToCreditAndOrderSummary:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.btnCopy.hidden = YES;
        }
        
        
        return cell;
    }
    else if(item == 2)
    {
        CustomTableViewCellLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = [Language getText:@"ข้อกำหนด และเงื่อนไข"];
        cell.lblTextLabel.text = rewardRedemption.termsConditions;
        [cell.lblTextLabel sizeToFit];
        cell.lblTextLabelHeight.constant = _expandCollapse?cell.lblTextLabel.frame.size.height:0;
        
        
        
        UIImage *image = _expandCollapse?[UIImage imageNamed:@"collapse2.png"]:[UIImage imageNamed:@"expand2.png"];
        [cell.btnValue setBackgroundImage:image forState:UIControlStateNormal];
        [cell.btnValue addTarget:self action:@selector(expandCollapse:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    if(item == 0)
    {
        return 44;
    }
    else if(item == 1)
    {
        CustomTableViewCellRedemption *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRedemption];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height;
        
        
        
        return 20+cell.lblHeaderHeight.constant+8+cell.lblSubTitleHeight.constant+8+266-71+8+30;
    }
    else if(item == 2)
    {
        CustomTableViewCellLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabel];
        
        
        cell.lblTitle.text = [Language getText:@"ข้อกำหนด และเงื่อนไข"];
        cell.lblTextLabel.text = rewardRedemption.termsConditions;
        [cell.lblTextLabel sizeToFit];
        cell.lblTextLabelHeight.constant = cell.lblTextLabel.frame.size.height;
        
        
        return 49+cell.lblTextLabelHeight.constant+20;
    }
    
    
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (IBAction)goBack:(id)sender
{
    if(fromMenuMyReward)
    {
        [self performSegueWithIdentifier:@"segUnwindToMyReward" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"segUnwindToReward" sender:self];
    }
    
}

-(void)updateTimer:(NSTimer *)timer {
    _timeToCountDown -= 1;
    _timeToCountDown = _timeToCountDown<0?0:_timeToCountDown;
    [self populateLabelwithTime:_timeToCountDown];
    if(_timeToCountDown == 0)
        [timer invalidate];
}

- (void)populateLabelwithTime:(NSInteger)seconds
{
    
    NSInteger minutes = seconds / 60;
    NSInteger hours = minutes / 60;
    
    seconds -= minutes * 60;
    minutes -= hours * 60;

    
    lblCountDown.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
}

-(void)expandCollapse:(id)sender
{
    _expandCollapse = !_expandCollapse;
    [tbvData reloadData];    
}

-(void)copyQRCode:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _promoCode;
}

-(void)goToCreditAndOrderSummary:(id)sender
{
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbMenu withData:@[@(rewardRedemption.mainBranchID), @(rewardRedemption.discountGroupMenuID)]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segCreditCardAndOrderSummary"])
    {
        Branch *branch = [Branch getBranch:rewardRedemption.mainBranchID];
        rewardRedemption.voucherCode = promoCode.code;
        CreditCardAndOrderSummaryViewController *vc = segue.destinationViewController;
        vc.branch = branch;
        vc.customerTable = nil;
        vc.fromRewardRedemption = 1;
        vc.receipt = nil;
        vc.buffetReceipt = nil;
        vc.rewardRedemption = rewardRedemption;
    }
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbMenu)
    {
        [Utility updateSharedObject:items];
        NSMutableArray *messageList = [items[0] mutableCopy];
        Message *message = messageList[0];
        if(![message.text integerValue])
        {
            NSString *message = [Language getText:@"ทางร้านไม่ได้เปิดระบบการสั่งอาหารด้วยตนเองตอนนี้ ขออภัยในความไม่สะดวกค่ะ"];
            [self showAlert:@"" message:message];
        }
        else
        {
            NSMutableArray *discountGroupMenuMapList = items[6];
            NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
            for(int i=0; i<[discountGroupMenuMapList count]; i++)
            {
                DiscountGroupMenuMap *discountGroupMenuMap = discountGroupMenuMapList[i];
                Menu *menu = [Menu getMenu:discountGroupMenuMap.menuID branchID:rewardRedemption.mainBranchID];
                SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:discountGroupMenuMap.menuID branchID:rewardRedemption.mainBranchID];
                float specialPrice = specialPriceProgram?specialPriceProgram.specialPrice:menu.price;
                
                
                for(int j=0; j<discountGroupMenuMap.quantity; j++)
                {
                    OrderTaking *orderTaking = [[OrderTaking alloc]initWithBranchID:rewardRedemption.mainBranchID customerTableID:0 menuID:discountGroupMenuMap.menuID quantity:1 specialPrice:specialPrice price:menu.price takeAway:0 takeAwayPrice:0 noteIDListInText:@"" notePrice:0 orderNo:0 status:1 receiptID:0];
                    [orderTakingList addObject:orderTaking];
                    [OrderTaking addObject:orderTaking];
                }
            }
            
            [OrderTaking setCurrentOrderTakingList:orderTakingList];
            [self performSegueWithIdentifier:@"segCreditCardAndOrderSummary" sender:self];
        }
    }
}

@end
