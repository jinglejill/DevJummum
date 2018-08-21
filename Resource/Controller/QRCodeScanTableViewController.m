//
//  QRCodeScanTableViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "QRCodeScanTableViewController.h"
#import "MenuSelectionViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "Utility.h"
#import "Branch.h"
#import "CustomerTable.h"
#import "Setting.h"
#import "Message.h"


@interface QRCodeScanTableViewController ()
{
    Branch *_selectedBranch;
    CustomerTable *_selectedCustomerTable;
    BOOL _fromOrderItAgain;
}
//@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;


-(BOOL)startReading;
-(void)stopReading;
@end

@implementation QRCodeScanTableViewController
@synthesize lblNavTitle;
@synthesize fromCreditCardAndOrderSummaryMenu;
@synthesize customerTable;
@synthesize btnBack;
@synthesize btnBranchSearch;
@synthesize topViewHeight;


-(IBAction)unwindToQRCodeScanTable:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isMemberOfClass:[CreditCardAndOrderSummaryViewController class]])
    {
        CreditCardAndOrderSummaryViewController *vc = segue.sourceViewController;
        _selectedBranch = vc.branch;
        _selectedCustomerTable = nil;    
        _fromOrderItAgain = YES;
    }
}

- (IBAction)branchSearch:(id)sender
{
    [self performSegueWithIdentifier:@"segBranchSearch" sender:self];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCreditCardAndOrderSummary" sender:self];
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
    
    
    NSString *title = [Setting getValue:@"057t" example:@"สแกน QR Code เลขโต๊ะ"];
    lblNavTitle.text = title;
    btnBack.hidden = fromCreditCardAndOrderSummaryMenu?NO:YES;
    btnBranchSearch.hidden = !btnBack.hidden;
    
    _captureSession = nil;
    [self loadBeepSound];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];

}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
    if(_fromOrderItAgain)
    {
        _fromOrderItAgain = NO;
        [self performSegueWithIdentifier:@"segMenuSelection" sender:self];
        return;
    }
    
    
    [self startButtonClicked];
    
    
    //Get Preview Layer connection
    AVCaptureConnection *previewLayerConnection=_videoPreviewLayer.connection;
    
    if ([previewLayerConnection isVideoOrientationSupported])
        [previewLayerConnection setVideoOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

-(void)loadBeepSound
{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayer prepareToPlay];
    }
}

-(void)startButtonClicked
{
    [self startReading];
}

-(BOOL)startReading
{
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input)
    {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_vwPreview.layer.bounds];
    [_vwPreview.layer addSublayer:_videoPreviewLayer];
    
    _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    [_captureSession startRunning];
    
    return YES;
}

-(void)stopReading
{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects && [metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
        {
            _selectedBranch = nil;
            _selectedCustomerTable = nil;
            NSString *decryptedMessage = [metadataObj stringValue];

            [self stopReading];
            [self.homeModel downloadItems:dbBranchAndCustomerTableQR withData:decryptedMessage];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segMenuSelection"])
    {
        MenuSelectionViewController *vc = segue.destinationViewController;
        vc.branch = _selectedBranch;
        vc.customerTable = _selectedCustomerTable;
    }
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbBranchAndCustomerTableQR)
    {
        NSMutableArray *branchList = items[0];
        NSMutableArray *customerTableList = items[1];
        if([branchList count] == 0 || [customerTableList count] == 0)
        {
            [self showAlert:@"" message:@"QR Code ไม่ถูกต้อง"];
            [self startReading];
        }
        else
        {
            [Utility updateSharedObject:items];
            _selectedBranch = branchList[0];
            _selectedCustomerTable = customerTableList[0];
            if(fromCreditCardAndOrderSummaryMenu)
            {
                customerTable = customerTableList[0];
                dispatch_async(dispatch_get_main_queue(), ^
               {
                   [self performSegueWithIdentifier:@"segUnwindToCreditCardAndOrderSummary" sender:self];
               });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^
               {
                   [self performSegueWithIdentifier:@"segMenuSelection" sender:self];
               });
            }
        }
    }
}
@end

