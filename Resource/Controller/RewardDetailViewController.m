//
//  RewardDetailViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 30/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RewardDetailViewController.h"
#import "RewardRedemptionViewController.h"
#import "CustomTableViewCellRewardDetail.h"
#import "CustomTableViewCellLabel.h"
#import "PromoCode.h"
#import "Branch.h"
#import "Setting.h"


@interface RewardDetailViewController ()
{
    RewardPoint *_rewardPointSpent;
    PromoCode *_promoCode;
    NSInteger _expandCollapse;//1=expand,0=collapse
}
@end

@implementation RewardDetailViewController
static NSString * const reuseIdentifierRewardDetail = @"CustomTableViewCellRewardDetail";
static NSString * const reuseIdentifierLabel = @"CustomTableViewCellLabel";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize rewardPoint;
@synthesize rewardRedemption;
@synthesize topViewHeight;
@synthesize bottomButtonHeight;
@synthesize btnRedeem;


-(IBAction)unwindToRewardDetail:(UIStoryboardSegue *)segue
{
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    bottomButtonHeight.constant = window.safeAreaInsets.bottom;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
    
    
    [btnRedeem setTitle:[Language getText:@"รับสิทธิ์"] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Language getText:@"แลกของรางวัล"];
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
        NSString *imageFileName = [NSString stringWithFormat:@"%@/JMM/Image/Reward/%@",strPath,rewardRedemption.imageUrl];
        imageFileName = [Utility isStringEmpty:rewardRedemption.imageUrl]?noImageFileName:imageFileName;
        UIImage *image = [Utility getImageFromCache:imageFileName];
        if(image)
        {
            cell.imgVwValue.image = image;
        }
        else
        {
            [self.homeModel downloadImageWithFileName:rewardRedemption.imageUrl type:4 branchID:0 completionBlock:^(BOOL succeeded, UIImage *image)
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
        
        
        cell.btnOrderNow.hidden = YES;
        cell.btnOrderNowTop.constant = 0;
        cell.btnOrderNowHeight.constant = 0;
        
        
        return cell;
    }
    else if(item == 1)
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
        CustomTableViewCellRewardDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRewardDetail];
        
        
        
        NSString *strPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *noImageFileName = [NSString stringWithFormat:@"%@/JMM/Image/NoImage.jpg",strPath];
        NSString *imageFileName = [NSString stringWithFormat:@"%@/JMM/Image/Reward/%@",strPath,rewardRedemption.imageUrl];
        imageFileName = [Utility isStringEmpty:rewardRedemption.imageUrl]?noImageFileName:imageFileName;
        UIImage *image = [Utility getImageFromCache:imageFileName];
        if(image)
        {
            cell.imgVwValue.image = image;
        }
        else
        {
            [self.homeModel downloadImageWithFileName:rewardRedemption.imageUrl type:4 branchID:0 completionBlock:^(BOOL succeeded, UIImage *image)
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
        
        
        
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height;
        
        
        cell.btnOrderNow.hidden = YES;
        cell.btnOrderNowTop.constant = 0;
        cell.btnOrderNowHeight.constant = 0;
        
       
        return 11+cell.imgVwValueHeight.constant+20+cell.lblHeaderHeight.constant+8+cell.lblSubTitleHeight.constant+8+18+11;
    }
    else
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segRewardRedemption"])
    {
        RewardRedemptionViewController *vc = segue.destinationViewController;
        vc.rewardPoint = rewardPoint;
        vc.rewardRedemption = rewardRedemption;
        vc.rewardPointSpent = _rewardPointSpent;
        vc.promoCode = _promoCode;
    }
}

- (IBAction)redeemReward:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    

    
    NSString *title = [Language getText:@"ยืนยันการรับสิทธิ์"];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:title
                                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
//                                 NSString *message = [Language getText:@"จำนวนแต้มสะสมไม่เพียงพอ"];
//                                 if(rewardPoint.point < rewardRedemption.point)
//                                 {
//                                     [self showAlert:@"" message:message];
//                                 }
//                                 else
                                 {
                                     UserAccount *userAccount = [UserAccount getCurrentUserAccount];
                                     _rewardPointSpent = [[RewardPoint alloc]initWithMemberID:userAccount.userAccountID receiptID:0 point:rewardRedemption.point status:-1 promoCodeID:0];
                                     [self.homeModel insertItems:dbRewardPoint withData:@[_rewardPointSpent,rewardRedemption] actionScreen:@"insert rewardPointSpent"];
                                     [self loadingOverlayView];
                                 }
                             }];
    
    [alert addAction:action1];
    
    
    NSString *title2 = [Language getText:@"ยกเลิก"];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:title2
                                                      style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                              {
                              }];
    [alert addAction:action2];
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        UIButton *button = sender;
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = button;
        popPresenter.sourceRect = button.bounds;
    }
    
    
    [self presentViewController:alert animated:YES completion:nil];

    
    // this has to be set after presenting the alert, otherwise the internal property __representer is nil
    UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
    UIColor *color = cSystem1;
    NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title attributes:attribute];

    UILabel *label = [[action1 valueForKey:@"__representer"] valueForKey:@"label"];
    label.attributedText = attrString;



    UIFont *font2 = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
    UIColor *color2 = cSystem4;
    NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:title2 attributes:attribute2];

    UILabel *label2 = [[action2 valueForKey:@"__representer"] valueForKey:@"label"];
    label2.attributedText = attrString2;
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToReward" sender:self];
}

-(void)itemsInsertedWithReturnData:(NSArray *)items
{
    [self removeOverlayViews];
    NSMutableArray *promoCodeList = items[0];
    if([promoCodeList count]>0)
    {
        rewardPoint.point -= rewardRedemption.point;
        _promoCode = promoCodeList[0];
        [self performSegueWithIdentifier:@"segRewardRedemption" sender:self];
    }
//    else
//    {
//        NSString *message = [Language getText:@"จำนวนสิทธิ์ครบแล้ว"];
//        [self showAlert:@"" message:message];
//    }
}

-(void)expandCollapse:(id)sender
{
    _expandCollapse = !_expandCollapse;
    [tbvData reloadData];
}
@end
