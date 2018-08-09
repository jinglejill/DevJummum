//
//  SelectPaymentMethodViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 14/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SelectPaymentMethodViewController.h"
#import "CustomTableViewCellImageLabelRemove.h"
#import "OmiseSDK.h"
#import "DevJummum-Swift.h"
#import "CreditCard.h"
#import "Setting.h"


@interface SelectPaymentMethodViewController ()
{
    NSMutableArray *_creditCardList;
}
@end

@implementation SelectPaymentMethodViewController
static NSString * const reuseIdentifierImageLabelRemove = @"CustomTableViewCellImageLabelRemove";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize creditCard;
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
    
    
    NSString *title = [Setting getValue:@"077t" example:@"เลือกช่องทางชำระเงิน"];
    lblNavTitle.text = title;
    tbvData.delegate = self;
    tbvData.dataSource = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierImageLabelRemove bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierImageLabelRemove];
    }
    
    
    
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    NSMutableDictionary *dicCreditCard = [[[NSUserDefaults standardUserDefaults] objectForKey:@"creditCard"] mutableCopy];
    _creditCardList = [dicCreditCard objectForKey:userAccount.username];
    _creditCardList = [_creditCardList mutableCopy];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    
    
    
    return  [_creditCardList count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if(item == [_creditCardList count])
    {
        UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        
        cell.textLabel.text = @"เพิ่มบัตรเครดิต";
        cell.textLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
        cell.textLabel.textColor = cSystem4;
        
        return cell;
    }
    else
    {
        NSData *encodedObject = _creditCardList[item];
        CreditCard *creditCard = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        CustomTableViewCellImageLabelRemove *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageLabelRemove];
        NSInteger cardBrand = [OMSCardNumber brandForPan:creditCard.creditCardNo];
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
        
        
        
        NSString *strCreditCardNo = [Utility hideCreditCardNo:creditCard.creditCardNo];
        cell.lblValue.text = strCreditCardNo;
        cell.lblValue.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
        
        
        
        if(creditCard.primaryCard)
        {
            [cell.btnRemove setTitle:@"✓" forState:UIControlStateNormal];
        }
        else
        {
            [cell.btnRemove setTitle:@"" forState:UIControlStateNormal];
        }
        
        
        return cell;
    }
    
    return nil;
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
    NSInteger item = indexPath.item;
    if(item == [_creditCardList count])
    {
        creditCard = [[CreditCard alloc]init];
        creditCard.saveCard = 1;
        [self performSegueWithIdentifier:@"segUnwindToCreditCardAndOrderSummary" sender:self];
    }
    else
    {
        NSData *encodedObject = _creditCardList[item];
        creditCard = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        creditCard.primaryCard = 1;
        [CreditCard updatePrimaryCard:creditCard creditCardList:_creditCardList];
        
        [self performSegueWithIdentifier:@"segUnwindToCreditCardAndOrderSummary" sender:self];
    }
}
- (IBAction)dismissViewController:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCreditCardAndOrderSummary" sender:self];
}
@end
