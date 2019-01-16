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
#import "CustomTableViewHeaderFooterButtonButton.h"
#import "GBPrimeQr.h"


@interface ShowQRToPayViewController ()
{
    NSInteger _numberOfGift;
    UIImage *_imgQRToPay;
}
@end

@implementation ShowQRToPayViewController
static NSString * const reuseIdentifierQRToPay = @"CustomTableViewCellQRToPay";
static NSString * const reuseIdentifierHeaderFooterButtonButton = @"CustomTableViewHeaderFooterButtonButton";
@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;
@synthesize receipt;
@synthesize bottomButtonHeight;
@synthesize fromReceiptSummary;
@synthesize btnBack;
@synthesize btnBackFalse;
@synthesize receiptID;


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
    gbPrimeQR.amount = receipt.netTotal;
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
             //save to camera roll and display message
             UIImageWriteToSavedPhotosAlbum(image, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
         }
         else
         {
            [self blinkAlertMsg:[Language getText:@"ไม่สามารถสร้าง QR ได้ กรุณาลองใหม่อีกครั้งค่ะ"]];
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
        [footerView.btnSave setTitle:[Language getText:@"แชร์ QR"] forState:UIControlStateNormal];
        [footerView.btnSave addTarget:self action:@selector(shareQR:) forControlEvents:UIControlEventTouchUpInside];
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
    NSInteger receiptIDPayByTransfer = receiptID?receiptID:receipt.receiptID;
    [self.homeModel downloadItems:dbReceiptAndLuckyDraw withData:@(receiptIDPayByTransfer)];
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error)
    {
        // Do anything needed to handle the error or display it to the user
    }
    else
    {
        // .... do anything you want here to handle
        // .... when the image has been saved in the photo album
        [self blinkAlertMsg:[Language getText:@"QR Code ได้ถูกบันทึกลงในเครื่องเรียบร้อยแล้ว"]];
    }
}

-(void)shareQR:(id)sender
{
    NSArray *activityItems = @[_imgQRToPay];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityViewControntroller.popoverPresentationController.sourceView = self.view;
        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }
    [self presentViewController:activityViewControntroller animated:true completion:nil];
}
@end
