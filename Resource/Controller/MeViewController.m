//
//  MeViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 11/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MeViewController.h"
#import "TosAndPrivacyPolicyViewController.h"
#import "ReceiptSummaryViewController.h"
#import "CommentViewController.h"
#import "BasketViewController.h"
#import "BranchSearchViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "CreditCardViewController.h"
#import "CustomerTableSearchViewController.h"
#import "HotDealDetailViewController.h"
#import "MenuSelectionViewController.h"
#import "MyRewardViewController.h"
#import "NoteViewController.h"
#import "PaymentCompleteViewController.h"
#import "PersonalDataViewController.h"
#import "RecommendShopViewController.h"
#import "RewardDetailViewController.h"
#import "RewardRedemptionViewController.h"
#import "SelectPaymentMethodViewController.h"
#import "TosAndPrivacyPolicyViewController.h"
#import "CustomTableViewCellImageText.h"
#import "CustomTableViewCellProfile.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "LogIn.h"


@interface MeViewController ()
{
    NSArray *_meList;
    NSArray *_meImageList;
    NSArray *_aboutUsList;
    NSArray *_aboutUsImageList;
    NSArray *_logOutList;
    NSArray *_logOutImageList;
    NSInteger _pageType;
}
@end

@implementation MeViewController
static NSString * const reuseIdentifierImageText = @"CustomTableViewCellImageText";
static NSString * const reuseIdentifierProfile = @"CustomTableViewCellProfile";


@synthesize tbvMe;
@synthesize topViewHeight;


-(IBAction)unwindToMe:(UIStoryboardSegue *)segue
{
    self.showOrderDetail = 0;
    if([[segue sourceViewController] isKindOfClass:[CommentViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[BasketViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[BranchSearchViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[CreditCardAndOrderSummaryViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[CreditCardViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[CustomerTableSearchViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[HotDealDetailViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[MenuSelectionViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[MyRewardViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[NoteViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[PaymentCompleteViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[PersonalDataViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[RecommendShopViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[RewardDetailViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[RewardRedemptionViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[SelectPaymentMethodViewController class]] ||
       [[segue sourceViewController] isKindOfClass:[TosAndPrivacyPolicyViewController class]]
       )
    {
        CustomViewController *vc = segue.sourceViewController;
        self.showOrderDetail = vc.showOrderDetail;
        self.selectedReceipt = vc.selectedReceipt;
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.showOrderDetail)
    {
        [self segueToReceiptSummaryAuto];
    }
}

-(void)loadView
{
    [super loadView];
    
    _meList = @[@"ประวัติการสั่งอาหาร",@"บัตรเครดิต/เดบิต",@"ข้อกำหนดและเงื่อนไข",@"นโยบายความเป็นส่วนตัว"];
    _meImageList = @[@"history.png",@"creditCard.png",@"termsOfService.png",@"privacyPolicy.png"];
    _aboutUsList = @[@"แนะนำร้านอาหาร",@"แนะนำติชม",@"ติดต่อ JUMMUM",@"Log out"];
    _aboutUsImageList = @[@"recommendShop.png",@"comment.png",@"contactUs.png",@"logOut.png"];
    _logOutList = @[@"Log out"];
    _logOutImageList = @[@"logOut.png"];
    tbvMe.delegate = self;
    tbvMe.dataSource = self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierImageText bundle:nil];
        [tbvMe registerNib:nib forCellReuseIdentifier:reuseIdentifierImageText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierProfile bundle:nil];
        [tbvMe registerNib:nib forCellReuseIdentifier:reuseIdentifierProfile];
    }
    
    
    //------
    CustomTableViewCellProfile *cell = [tbvMe dequeueReusableCellWithIdentifier:reuseIdentifierProfile];

    
    cell.imgValue.layer.cornerRadius = 35;
    cell.imgValue.layer.masksToBounds = YES;
    cell.imgValue.layer.borderWidth = 0;
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    cell.lblEmail.text = userAccount.email;
    
    
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    float topPadding = window.safeAreaInsets.top;
    CGRect frame = cell.frame;
    frame.origin.x = 0;
    frame.origin.y = topPadding == 0?20:topPadding;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = 90;
    cell.frame = frame;
    [self.view addSubview:cell];
    
    
    
    [cell.singleTapGestureRecognizer addTarget:self action:@selector(handleSingleTap:)];
    [cell.vwContent addGestureRecognizer:cell.singleTapGestureRecognizer];
    cell.singleTapGestureRecognizer.numberOfTapsRequired = 1;
    ////-----------
    
    
    NSLog(@"test tbvData y,height: %f,%f",tbvMe.frame.origin.y,tbvMe.frame.size.height);
}


///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvMe])
    {
        if (section == 0)
        {
            return [_meList count];
        }
        else if (section == 1)
        {
            return [_aboutUsList count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvMe])
    {
        if (section == 0)
        {
            CustomTableViewCellImageText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.imgVwIcon.image = [UIImage imageNamed:_meImageList[item]];
            cell.lblText.text = _meList[item];
            cell.lblText.textColor = cSystem1;
            return cell;
        }
        else if (section == 1)
        {
            CustomTableViewCellImageText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.imgVwIcon.image = [UIImage imageNamed:_aboutUsImageList[item]];
            cell.lblText.text = _aboutUsList[item];
            cell.lblText.textColor = cSystem1;
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:tbvMe])
    {
        if(indexPath.section == 0)
        {
            switch (indexPath.item)
            {
                    //                _meList = @[@"ประวัติการสั่งอาหาร",@"ข้อมูลส่วนตัว",@"แต้มสะสม",@"My Credit Cards"];
                case 0:
                {
                    NSLog(@"did select receipt summary");
                    dispatch_async(dispatch_get_main_queue(),^ {
                        [self performSegueWithIdentifier:@"segReceiptSummary" sender:self];
                    });
                    
                }
                    break;
                case 1:
                {
                    [self performSegueWithIdentifier:@"segCreditCard" sender:self];
                }
                    break;
                case 2:
                {
                    _pageType = 1;
                    [self performSegueWithIdentifier:@"segTosAndPrivacyPolicy" sender:self];
                }
                    break;
                case 3:
                {
                    _pageType = 2;
                    [self performSegueWithIdentifier:@"segTosAndPrivacyPolicy" sender:self];
                }
                    break;
                default:
                    break;
            }
        }
        else if(indexPath.section == 1)
        {
            switch (indexPath.item)
            {
                case 0:
                {
                    [self performSegueWithIdentifier:@"segRecommendShop" sender:self];
                }
                    break;
                case 1:
                {
                    [self performSegueWithIdentifier:@"segComment" sender:self];
                }
                    break;
                case 2:
                {
                    _pageType = 3;
                    [self performSegueWithIdentifier:@"segTosAndPrivacyPolicy" sender:self];
                }
                    break;
                case 3:
                {
                    [self loadingOverlayView];
                    [FBSDKAccessToken setCurrentAccessToken:nil];
                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"logInSession"];
                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"rememberMe"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"rememberEmail"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"rememberPassword"];
                    
                    
                    
                    [self removeMemberData];
                    [self removeOverlayViews];
                    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
                    LogIn *logIn = [[LogIn alloc]initWithUsername:userAccount.username status:-1 deviceToken:[Utility deviceToken]];
                    [self.homeModel insertItems:dbLogOut withData:logIn actionScreen:@"log out in Me screen"];
                    [self showAlert:@"" message:@"ออกจากระบบสำเร็จ" method:@selector(unwindToLogIn)];
                }
                    break;
                default:
                    break;
            }
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 8;//CGFLOAT_MIN;
    }
    return tableView.sectionHeaderHeight;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segTosAndPrivacyPolicy"])
    {
        TosAndPrivacyPolicyViewController *vc = segue.destinationViewController;
        vc.pageType = _pageType;
    }
    else if([[segue identifier] isEqualToString:@"segReceiptSummary"])
    {
        ReceiptSummaryViewController *vc = segue.destinationViewController;
        vc.showOrderDetail = self.showOrderDetail;
        vc.selectedReceipt = self.selectedReceipt;
    }
}

-(void)unwindToLogIn
{
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self performSegueWithIdentifier:@"segPersonalData" sender:self];
}

-(void)segueToReceiptSummaryAuto
{
    [self performSegueWithIdentifier:@"segReceiptSummary" sender:self];
}
@end
