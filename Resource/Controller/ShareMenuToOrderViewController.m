//
//  ShareMenuToOrderViewController.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "ShareMenuToOrderViewController.h"
#import "CustomTableViewCellImageLabel.h"
#import "EncryptedMessage.h"
#import "Branch.h"


@interface ShareMenuToOrderViewController ()
{
    EncryptedMessage *_encryptedMessage;
}
@end

@implementation ShareMenuToOrderViewController
static NSString * const reuseIdentifierImageLabel = @"CustomTableViewCellImageLabel";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;
@synthesize saveReceipt;
@synthesize saveOrderTakingList;
@synthesize saveOrderNoteList;


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
    
    
    NSString *title = [Language getText:@"QR Code รายการอาหารที่ต้องการสั่ง"];
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
    [self.homeModel insertItemsJson:dbSaveOrder withData:@[saveReceipt,saveOrderTakingList,saveOrderNoteList] actionScreen:@"share menu to order"];
    
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCreditCardAndOrderSummary" sender:self];
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
    }
    
    
    Branch *branch = [Branch getBranch:saveReceipt.branchID];
    cell.lblBranchName.text = branch?[NSString stringWithFormat:[Language getText:@"ร้าน %@"],branch.name]:@"";
    cell.lblText.text = [Utility dateToString:[Utility currentDateTime] toFormat:@"d MMM yy HH:mm"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 224;
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

-(void)itemsInsertedWithReturnData:(NSArray *)items
{
    [self removeOverlayViews];
    NSMutableArray *encryptedMessageList = items[0];
    _encryptedMessage = encryptedMessageList[0];
    [tbvData reloadData];
}

@end
