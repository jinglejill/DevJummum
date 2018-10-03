//
//  QRCodeScanTableViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CustomerTable.h"


@interface QRCodeScanTableViewController : CustomViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UIView *vwPreview;
@property (nonatomic) NSInteger fromCreditCardAndOrderSummaryMenu;
@property (strong, nonatomic) CustomerTable *customerTable;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *btnBranchSearch;
@property (nonatomic) BOOL alreadySeg;



- (IBAction)branchSearch:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)unwindToQRCodeScanTable:(UIStoryboardSegue *)segue;
@end
