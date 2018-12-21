//
//  ScanToJoinViewController.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "ScanToJoinViewController.h"


@interface ScanToJoinViewController ()
{
    BOOL _alreadyDetect;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;


-(BOOL)startReading;
-(void)stopReading;
@end

@implementation ScanToJoinViewController

@synthesize lblNavTitle;
@synthesize topViewHeight;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
    
    
    
    [self stopReading];
    dispatch_async(dispatch_get_main_queue(), ^
   {
       [self startReading];
   });
    

    //Get Preview Layer connection
    AVCaptureConnection *previewLayerConnection=_videoPreviewLayer.connection;

    if ([previewLayerConnection isVideoOrientationSupported])
    {
        [previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title = [Language getText:@"สแกน QR Code เพื่อร่วมสั่งอาหาร"];
    lblNavTitle.text = title;
    
    
    _captureSession = nil;
    [self loadBeepSound];
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
    
    if (metadataObjects && [metadataObjects count] > 0 && !_alreadyDetect)
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
        {      
            NSString *decryptedMessage = [metadataObj stringValue];

            
            _alreadyDetect = YES;
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            [self loadingOverlayView];
            [self.homeModel insertItems:dbOrderJoiningScanQr withData:@[decryptedMessage,@(userAccount.userAccountID)] actionScreen:@"insert order joining in scan to join screen"];
        }
    }
}

-(void)itemsInsertedWithReturnData:(NSArray *)items
{
    [self removeOverlayViews];
    NSMutableArray *orderJoiningList = items[0];
    if([orderJoiningList count] > 0)
    {
        [self goBack:nil];
    }
    else
    {
        [self showAlert:@"" message:[Language getText:@"QR Code สำหรับร่วมสั่งอาหารไม่ถูกต้อง"] method:@selector(setAlreadyDetectToNo)];
    }
}

-(void)setAlreadyDetectToNo
{
    _alreadyDetect = NO;
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToJoinOrder" sender:self];
}
@end
