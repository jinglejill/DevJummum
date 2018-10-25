//
//  HotDealDetailViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 26/6/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "HotDealDetailViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "CustomTableViewCellRewardDetail.h"
#import "CustomTableViewCellLabel.h"
#import "Branch.h"
#import "Setting.h"
#import "Message.h"
#import "Menu.h"
#import "SpecialPriceProgram.h"
#import "OrderTaking.h"
#import "DiscountGroupMenuMap.h"


@interface HotDealDetailViewController ()
{
    NSInteger _expandCollapse;//1=expand,0=collapse
}
@end

@implementation HotDealDetailViewController
static NSString * const reuseIdentifierRewardDetail = @"CustomTableViewCellRewardDetail";
static NSString * const reuseIdentifierLabel = @"CustomTableViewCellLabel";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize promotion;
@synthesize topViewHeight;


-(IBAction)unwindToHotDealDetail:(UIStoryboardSegue *)segue
{
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    NSString *title = [Setting getValue:@"060t" example:@"Hot Deal"];
    lblNavTitle.text = title;
    _expandCollapse = 1;
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierRewardDetail bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierRewardDetail];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabel bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabel];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if(item == 0)
    {
        CustomTableViewCellRewardDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRewardDetail];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        NSString *strPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *noImageFileName = [NSString stringWithFormat:@"%@/JMM/Image/NoImage.jpg",strPath];
        NSString *imageFileName = [NSString stringWithFormat:@"%@/JMM/Image/Promotion/%@",strPath,promotion.imageUrl];
        imageFileName = [Utility isStringEmpty:promotion.imageUrl]?noImageFileName:imageFileName;
        UIImage *image = [Utility getImageFromCache:imageFileName];
        if(image)
        {
            cell.imgVwValue.image = image;
        }
        else
        {
            [self.homeModel downloadImageWithFileName:promotion.imageUrl type:3 branchID:0 completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded)
                 {
                     [Utility saveImageInCache:image imageName:imageFileName];
                     cell.imgVwValue.image = image;
                 }
             }];
        }
        
        
        
        
        float imageWidth = cell.frame.size.width -2*16 > 375?375:cell.frame.size.width -2*16;
        cell.imgVwValueHeight.constant = imageWidth/16*9;
        cell.imgVwValue.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
        cell.lblHeader.text = promotion.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = promotion.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height;
        
        
        cell.imgRemark.hidden = YES;
        cell.lblRemark.hidden = YES;
        cell.lblRemark.text = @"";
        cell.lblRemarkTop.constant = 0;
        cell.lblRemarkHeight.constant = 0;
        
        
        if(promotion.discountGroupMenuID)
        {
            cell.btnOrderNow.hidden = NO;
            cell.btnOrderNowTop.constant = 7;
            cell.btnOrderNowHeight.constant = 30;
            [cell.btnOrderNow setTitle:[Language getText:@"สั่งเลย"] forState:UIControlStateNormal];
            [cell.btnOrderNow addTarget:self action:@selector(orderNow:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.btnOrderNow.hidden = YES;
            cell.btnOrderNowTop.constant = 0;
            cell.btnOrderNowHeight.constant = 0;
            [cell.btnOrderNow removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
        }
        
        
        
        return cell;
    }
    else if(item == 1)
    {
        CustomTableViewCellLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = [Language getText:@"ข้อกำหนด และเงื่อนไข"];
        cell.lblTextLabel.text = promotion.termsConditions;
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
        CustomTableViewCellRewardDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRewardDetail];
        
        
        
        NSString *strPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *noImageFileName = [NSString stringWithFormat:@"%@/JMM/Image/NoImage.jpg",strPath];
        NSString *imageFileName = [NSString stringWithFormat:@"%@/JMM/Image/Promotion/%@",strPath,promotion.imageUrl];
        imageFileName = [Utility isStringEmpty:promotion.imageUrl]?noImageFileName:imageFileName;
        UIImage *image = [Utility getImageFromCache:imageFileName];
        if(image)
        {
            cell.imgVwValue.image = image;
        }
        else
        {
            [self.homeModel downloadImageWithFileName:promotion.imageUrl type:3 branchID:0 completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded)
                 {
                     [Utility saveImageInCache:image imageName:imageFileName];
                     cell.imgVwValue.image = image;
                 }
             }];
        }
        
        
        
        float imageWidth = cell.frame.size.width -2*16 > 375?375:cell.frame.size.width -2*16;
        cell.imgVwValueHeight.constant = imageWidth/16*9;
        
        
        
        cell.lblHeader.text = promotion.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = promotion.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height;
        
        
        cell.imgRemark.hidden = YES;
        cell.lblRemark.hidden = YES;
        cell.lblRemark.text = @"";
        cell.lblRemarkTop.constant = 0;
        cell.lblRemarkHeight.constant = 0;
        
        
        if(promotion.discountGroupMenuID)
        {
            cell.btnOrderNow.hidden = NO;
            cell.btnOrderNowTop.constant = 7;
            cell.btnOrderNowHeight.constant = 30;
        }
        else
        {
            cell.btnOrderNow.hidden = YES;
            cell.btnOrderNowTop.constant = 0;
            cell.btnOrderNowHeight.constant = 0;
        }
        
        
        return 11+cell.imgVwValueHeight.constant+20+cell.lblHeaderHeight.constant+8+cell.lblSubTitleHeight.constant+cell.lblRemarkTop.constant+cell.lblHeaderHeight.constant+cell.btnOrderNowTop.constant+cell.btnOrderNowHeight.constant+11;
    }
    else
    {
        CustomTableViewCellLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabel];
        
        
        cell.lblTitle.text = [Language getText:@"ข้อกำหนด และเงื่อนไข"];
        cell.lblTextLabel.text = promotion.termsConditions;
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
    [self performSegueWithIdentifier:@"segUnwindToHotDeal" sender:self];
}

-(void)expandCollapse:(id)sender
{
    _expandCollapse = !_expandCollapse;
    [tbvData reloadData];
}

-(void)orderNow:(id)sender
{
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbMenu withData:@[@(promotion.mainBranchID), @(promotion.discountGroupMenuID)]];
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
                Menu *menu = [Menu getMenu:discountGroupMenuMap.menuID branchID:promotion.mainBranchID];
                SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:discountGroupMenuMap.menuID branchID:promotion.mainBranchID];
                float specialPrice = specialPriceProgram?specialPriceProgram.specialPrice:menu.price;
                
                for(int j=0; j<discountGroupMenuMap.quantity; j++)
                {
                    OrderTaking *orderTaking = [[OrderTaking alloc]initWithBranchID:promotion.mainBranchID customerTableID:0 menuID:discountGroupMenuMap.menuID quantity:1 specialPrice:specialPrice price:menu.price takeAway:0 takeAwayPrice:0 noteIDListInText:@"" notePrice:0 orderNo:0 status:1 receiptID:0];
                    [orderTakingList addObject:orderTaking];
                    [OrderTaking addObject:orderTaking];
                }
            }
            
            [OrderTaking setCurrentOrderTakingList:orderTakingList];
            [self performSegueWithIdentifier:@"segCreditCardAndOrderSummary" sender:self];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segCreditCardAndOrderSummary"])
    {
        Branch *branch = [Branch getBranch:promotion.mainBranchID];
        CreditCardAndOrderSummaryViewController *vc = segue.destinationViewController;
        vc.branch = branch;
        vc.customerTable = nil;
        vc.fromHotDealDetail = 1;
        vc.receipt = nil;
        vc.buffetReceipt = nil;
        vc.promotion = promotion;
    }
}
@end
