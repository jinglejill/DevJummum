//
//  ConfirmDisputeViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 10/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "ConfirmDisputeViewController.h"
#import "DisputeFormViewController.h"
#import "Setting.h"


@interface ConfirmDisputeViewController ()

@end

@implementation ConfirmDisputeViewController
@synthesize lblDisputeMessage;
@synthesize vwAlertHeight;
@synthesize lblDisputeMessageHeight;
@synthesize vwAlert;
@synthesize fromType;
@synthesize receipt;
@synthesize btnConfirm;
@synthesize btnCancel;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    lblDisputeMessageHeight.constant = lblDisputeMessage.frame.size.height;
    vwAlertHeight.constant = 80+38+38+44+lblDisputeMessage.frame.size.height;
    [self setButtonDesign:btnConfirm];
    [self setButtonDesign:btnCancel];
    
    
    [btnConfirm setTitle:[Language getText:@"ใช่"] forState:UIControlStateNormal];
    [btnCancel setTitle:[Language getText:@"ไม่"] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSString *strMessageHeader;
    NSString *strMessageSubTitle;
    if(fromType == 1)
    {
        strMessageHeader = [Language getText:@"Oop!"];
        strMessageSubTitle = [Language getText:@"คุณสามารถเรียกพนักงานเพื่อสอบถามหรือแก้ไขก่อนการยกเลิก หากคุณต้องการยกเลิก สามารถกดที่ปุ่มใช่"];
    }
    else
    {
        strMessageHeader = [Language getText:@"Oop!"];
        strMessageSubTitle = [Language getText:@"คุณสามารถเรียกพนักงานเพื่อสอบถามหรือแก้ไขก่อนการส่งคำร้อง หากคุณต้องการส่งคำร้อง สามารถกดที่ปุ่มใช่"];
    }
    UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:17];
    UIColor *color = cSystem4;
    NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
    NSMutableAttributedString *attrStringHeader = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",strMessageHeader] attributes:attribute];
    
    
    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:15];
    UIColor *color2 = cSystem4;
    NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strMessageSubTitle attributes:attribute2];
    
    
    [attrStringHeader appendAttributedString:attrString];
    
    
    
    lblDisputeMessage.attributedText = attrStringHeader;
    [lblDisputeMessage sizeToFit];
    
    
    vwAlert.layer.cornerRadius = 10;
    vwAlert.layer.masksToBounds = YES;
}

- (IBAction)yesDispute:(id)sender
{
    if(fromType == 1)
    {
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        
        
        [self loadingOverlayView];
        [self.homeModel downloadItems:dbReceipt withData:receipt];
    }
    else
    {
        [self performSegueWithIdentifier:@"segDisputeForm" sender:self];
    }
}

- (IBAction)noDispute:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToOrderDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segDisputeForm"])
    {
        DisputeFormViewController *vc = segue.destinationViewController;
        vc.fromType = fromType;
        vc.receipt = receipt;
    }
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbReceipt)
    {
        [self removeOverlayViews];
        NSMutableArray *receiptList = items[0];
        Receipt *downloadReceipt = receiptList[0];
        if(downloadReceipt.status == 5 || downloadReceipt.status == 6)
        {
            receipt.status = downloadReceipt.status;
            receipt.statusRoute = downloadReceipt.statusRoute;
            NSString *message = [Language getText:@"ร้านค้ากำลังปรุงอาหารให้คุณอยู่ค่ะ โปรดรอสักครู่นะคะ"];
            NSString *message2 = [Language getText:@"อาหารได้ส่งถึงคุณแล้วค่ะ"];
            NSString *strMessage = downloadReceipt.status == 5?message:message2;            
            [self showAlert:@"" message:strMessage method:@selector(noDispute:)];            
        }
        else
        {
            [self performSegueWithIdentifier:@"segDisputeForm" sender:self];
        }
    }
}

-(void)unwindToOrderDetail
{
    [self performSegueWithIdentifier:@"segUnwindToOrderDetail" sender:self];
}
@end
