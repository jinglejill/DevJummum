//
//  CreditCardViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 4/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CreditCardViewController.h"
#import "CustomTableViewCellImageLabelRemove.h"
#import "OmiseSDK.h"
#import "DevJummum-Swift.h"
#import "CreditCard.h"
#import "Setting.h"


@interface CreditCardViewController ()
{
    NSMutableArray *_creditCardList;
    CreditCard *_creditCard;
}
@end

@implementation CreditCardViewController
static NSString * const reuseIdentifierImageLabelRemove = @"CustomTableViewCellImageLabelRemove";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;


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
    
    
    NSString *title = [Setting getValue:@"065t" example:@"บัตรเครดิต/เดบิต"];
    lblNavTitle.text = title;
    tbvData.delegate = self;
    tbvData.dataSource = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierImageLabelRemove bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierImageLabelRemove];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    NSMutableDictionary *dicCreditCard = [[[NSUserDefaults standardUserDefaults] objectForKey:@"creditCard"] mutableCopy];

    if(dicCreditCard)
    {
        _creditCardList = [dicCreditCard objectForKey:userAccount.username];
        _creditCardList = [_creditCardList mutableCopy];
        if(_creditCardList && [_creditCardList count] > 0)
        {
            return 1;
        }
    }
    
    NSString *message = [Setting getValue:@"082m" example:@"คุณไม่ได้บันทึกบัตรเครดิตไว้"];
    UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
    noDataLabel.text             = message;
    noDataLabel.textColor        = cSystem4;
    noDataLabel.textAlignment    = NSTextAlignmentCenter;
    noDataLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
    tableView.backgroundView = noDataLabel;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return 0;
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [_creditCardList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCellImageLabelRemove *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageLabelRemove];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    NSData *encodedObject = _creditCardList[indexPath.item];
    _creditCard = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    
    
    
    NSInteger cardBrand = [OMSCardNumber brandForPan:_creditCard.creditCardNo];
    switch (cardBrand)
    {
        case OMSCardBrandJCB:
        {
            cell.imageView.image = [UIImage imageNamed:@"jcb.png"];
        }
            break;
        case OMSCardBrandAMEX:
        {
            cell.imageView.image = [UIImage imageNamed:@"americanExpress.png"];
        }
            break;
        case OMSCardBrandVisa:
        {
            cell.imageView.image = [UIImage imageNamed:@"visa.png"];
        }
            break;
        case OMSCardBrandMasterCard:
        {
            cell.imageView.image = [UIImage imageNamed:@"masterCard.png"];
        }
            break;
        default:
            break;
    }
    NSRange needleRange = NSMakeRange(12,4);
    NSString *secureCreditCardNo = [_creditCard.creditCardNo substringWithRange:needleRange];
    secureCreditCardNo = [NSString stringWithFormat:@"XXXX XXXX XXXX %@",secureCreditCardNo];
    
    cell.lblValue.text = secureCreditCardNo;
    [cell.btnRemove addTarget:self action:@selector(removeCreditCard:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    return cell;
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

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

-(void)removeCreditCard:(id)sender
{
//    UIButton *btnRemove = sender;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbvData];
    NSIndexPath *tappedIP = [tbvData indexPathForRowAtPoint:buttonPosition];
    NSData *encodedObject = _creditCardList[tappedIP.item];
    [_creditCardList removeObject:encodedObject];
    
    
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    NSMutableDictionary *dicCreditCard = [[[NSUserDefaults standardUserDefaults] objectForKey:@"creditCard"] mutableCopy];
    
    if(dicCreditCard)
    {
        if([_creditCardList count] == 0)
        {
            [dicCreditCard removeObjectForKey:userAccount.username];
        }
        else
        {
            [dicCreditCard setObject:_creditCardList forKey:userAccount.username];
        }
        [[NSUserDefaults standardUserDefaults] setValue:dicCreditCard forKey:@"creditCard"];
        [tbvData reloadData];
    }
    
    
    
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"creditCard"];
//    [tbvData reloadData];
}
@end
