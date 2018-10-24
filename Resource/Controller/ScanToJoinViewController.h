//
//  ScanToJoinViewController.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface ScanToJoinViewController : CustomViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet UIView *vwPreview;


- (IBAction)goBack:(id)sender;

@end
