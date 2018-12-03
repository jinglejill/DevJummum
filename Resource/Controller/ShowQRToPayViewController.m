//
//  ShowQRToPayViewController.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 2/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "ShowQRToPayViewController.h"
#import "PaymentCompleteViewController.h"
#import "CustomTableViewCellQRToPay.h"
//#import "CustomTableViewHeaderFooterButton.h"
#import "CustomTableViewHeaderFooterButtonButton.h"
#import "GBPrimeQr.h"


@interface ShowQRToPayViewController ()
{
    UIImage *_imgQRToPay;
    NSInteger _numberOfGift;
}
@end

@implementation ShowQRToPayViewController
static NSString * const reuseIdentifierQRToPay = @"CustomTableViewCellQRToPay";
//static NSString * const reuseIdentifierHeaderFooterButton = @"CustomTableViewHeaderFooterButton";
static NSString * const reuseIdentifierHeaderFooterButtonButton = @"CustomTableViewHeaderFooterButtonButton";
@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;
@synthesize receipt;
@synthesize bottomButtonHeight;
@synthesize fromReceiptSummary;
@synthesize btnBack;
@synthesize btnBackFalse;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    bottomButtonHeight.constant = window.safeAreaInsets.bottom;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
    
    if(!fromReceiptSummary)
    {
        //hide back button
        btnBackFalse.hidden = YES;
        btnBack.hidden = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Language getText:@"สแกน QR เพื่อโอนเงิน"];
    lblNavTitle.text = title;
    
    
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvData.scrollEnabled = NO;
    tbvData.separatorColor = [UIColor clearColor];
    tbvData.separatorStyle = UITableViewCellSeparatorStyleNone;

    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierQRToPay bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierQRToPay];
    }
//    {
//        UINib *nib = [UINib nibWithNibName:reuseIdentifierHeaderFooterButton bundle:nil];
//        [tbvData registerNib:nib forHeaderFooterViewReuseIdentifier:reuseIdentifierHeaderFooterButton];
//    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierHeaderFooterButtonButton bundle:nil];
        [tbvData registerNib:nib forHeaderFooterViewReuseIdentifier:reuseIdentifierHeaderFooterButtonButton];
    }
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    CustomTableViewCellQRToPay *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierQRToPay];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSString *GBPrimeQRPostUrl = [Setting getSettingValueWithKeyName:@"GBPrimeQRPostUrl"];
    NSString *GBPrimeQRToken = [Setting getSettingValueWithKeyName:@"GBPrimeQRToken"];
    NSString *responseUrl = [Setting getSettingValueWithKeyName:@"ResponseUrl"];
    NSString *backgroundUrl = [Setting getSettingValueWithKeyName:@"BackgroundUrl"];
    
    NSString *strCurrentDate = [Utility dateToString:[Utility currentDateTime] toFormat:@"yyyyMMdd"];
    GBPrimeQr *gbPrimeQR = [[GBPrimeQr alloc]init];
    gbPrimeQR.postUrl = GBPrimeQRPostUrl;
    gbPrimeQR.token = GBPrimeQRToken;
    gbPrimeQR.amount = 1.07;//test receipt.netTotal;
    gbPrimeQR.referenceNo = [NSString stringWithFormat:@"%@%@",strCurrentDate,receipt.receiptNoID];
    gbPrimeQR.payType = @"F";
    gbPrimeQR.responseUrl = responseUrl;
    gbPrimeQR.backgroundUrl = backgroundUrl;
    gbPrimeQR.merchantDefined1 = [NSString stringWithFormat:@"%ld", receipt.receiptID];
    gbPrimeQR.merchantDefined2 = [NSString stringWithFormat:@"%ld", receipt.branchID];
    gbPrimeQR.merchantDefined3 = [Utility deviceToken];
    gbPrimeQR.merchantDefined4 = [NSString stringWithFormat:@"%ld", receipt.memberID];
    gbPrimeQR.merchantDefined5 = receipt.receiptNoID;
    gbPrimeQR.detail = [NSString stringWithFormat:@"%ld", receipt.customerTableID];
    
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadQRToPay:gbPrimeQR completionBlock:^(BOOL succeeded, UIImage *image)
     {
         if (succeeded)
         {
            cell.imgVwQRToPay.backgroundColor = cSystem1;
             cell.imgVwQRToPay.contentMode = UIViewContentModeScaleAspectFit;
             cell.imgVwQRToPay.image = image;
             
             _imgQRToPay = image;
         }
     }];
     return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    float footerHeight = fromReceiptSummary?57:103;
    return self.view.frame.size.height - topViewHeight.constant - bottomButtonHeight.constant - 44 - footerHeight;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.separatorInset = UIEdgeInsetsMake(0.0f, self.view.bounds.size.width, 0.0f, CGFLOAT_MAX);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    

}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if([tableView isEqual:tbvData])
    {
        CustomTableViewHeaderFooterButtonButton *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifierHeaderFooterButtonButton];
    
        footerView.layer.backgroundColor = cSystem1.CGColor;
        [footerView.btnSave setTitle:[Language getText:@"บันทึก QR Code ลงอัลบั้ม"] forState:UIControlStateNormal];
        [footerView.btnSave addTarget:self action:@selector(saveToCameraRoll:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = footerView.btnSave.frame;
        frame.origin.x = 16;
        frame.size.width = self.view.frame.size.width - 16*2;
        frame.size.height = 38;
        footerView.btnSave.frame = frame;
        [self setButtonDesign:footerView.btnSave];
    
    
        if(fromReceiptSummary)
        {
            footerView.btnHome.hidden = YES;
        }
        else
        {
            footerView.btnHome.hidden = NO;
            [footerView.btnHome setTitle:[Language getText:@"< กลับสู่เมนูหลัก"] forState:UIControlStateNormal];
            [footerView.btnHome addTarget:self action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];
        }
    
        return footerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float height = 103;
    if(fromReceiptSummary)
    {
        height = 57;
    }
    return height;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segPaymentComplete"])
    {
        PaymentCompleteViewController *vc = segue.destinationViewController;
        vc.receipt = receipt;
        vc.numberOfGift = _numberOfGift;
    }
}

-(void)saveToCameraRoll:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(_imgQRToPay, nil, nil, nil);
}

-(void)backToHome:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMainTabBar" sender:self];
}

-(void)goBack:(id)sender
{
    if(fromReceiptSummary == 1)
    {
        [self performSegueWithIdentifier:@"segUnwindToReceiptSummary" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"segUnwindToCreditCardAndOrderSummary" sender:self];
    }
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbReceiptAndLuckyDraw)
    {
        NSMutableArray *receiptList = items[0];
        NSMutableArray *luckyDrawTicket = items[1];
        receipt = receiptList[0];
        if(receipt.status == 2)
        {
            _numberOfGift = [luckyDrawTicket count];        
            [self performSegueWithIdentifier:@"segPaymentComplete" sender:self];
        }
    }
}

-(void)reloadVc
{
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbReceiptAndLuckyDraw withData:receipt];
}
@end
