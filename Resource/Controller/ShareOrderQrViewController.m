//
//  ShareOrderQrViewController.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 23/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "ShareOrderQrViewController.h"
#import "CustomTableViewCellImageLabel.h"
#import "EncryptedMessage.h"
#import "Branch.h"


@interface ShareOrderQrViewController ()
{
    EncryptedMessage *_encryptedMessage;
    NSTimer *timer;
    NSInteger _timeToCountDown;
}
@end

@implementation ShareOrderQrViewController
static NSString * const reuseIdentifierImageLabel = @"CustomTableViewCellImageLabel";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;
@synthesize shareOrderReceiptID;


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
    
    
    NSString *title = [Language getText:@"QR Code สำหรับสั่งบุฟเฟ่ต์"];
    lblNavTitle.text = title;
    tbvData.dataSource = self;
    tbvData.delegate = self;
    tbvData.scrollEnabled = NO;
    tbvData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierImageLabel bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierImageLabel];
    }
    
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbOrderJoiningShareQr withData:@(shareOrderReceiptID)];
}

- (IBAction)goBack:(id)sender
{
    self.showReceiptSummary = 1;
    [self performSegueWithIdentifier:@"segUnwindToMainTabBar" sender:self];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CustomTableViewCellImageLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(_encryptedMessage)
    {
        cell.imgValue.image = [self generateQRCodeWithString:_encryptedMessage.encryptedMessage scale:5];
        
        
        _timeToCountDown = 5*60;
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    else
    {
//        cell.imgValue.image = [UIImage imageNamed:@"loading.png"];
        cell.lblText.text = @"00:00:00";
    }
    Receipt *receipt = [Receipt getReceipt:shareOrderReceiptID];
    Branch *branch = [Branch getBranch:receipt.branchID];
    cell.lblBranchName.text = branch?[NSString stringWithFormat:[Language getText:@"ร้าน %@"],branch.name]:@"";
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
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
    
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbOrderJoiningShareQr)
    {
        [self removeOverlayViews];
        NSMutableArray *encryptedMessageList = items[0];
        _encryptedMessage = encryptedMessageList[0];
        [tbvData reloadData];
    }
}

-(void)updateTimer:(NSTimer *)timer {
    _timeToCountDown -= 1;
    _timeToCountDown = _timeToCountDown<0?0:_timeToCountDown;
    [self populateLabelwithTime:_timeToCountDown];
    if(_timeToCountDown == 0)
    {
        [timer invalidate];
    }
}

- (void)populateLabelwithTime:(NSInteger)seconds
{
    
    NSInteger minutes = seconds / 60;
    NSInteger hours = minutes / 60;
    
    seconds -= minutes * 60;
    minutes -= hours * 60;

    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCellImageLabel *cell = [tbvData cellForRowAtIndexPath:indexPath];
    cell.lblText.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
}
@end
