//
//  LuckyDrawViewController.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 8/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "LuckyDrawViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "RewardRedemption.h"
#import "Message.h"
#import "Setting.h"
#import "Menu.h"
#import "SpecialPriceProgram.h"
#import "OrderTaking.h"
#import "Branch.h"


@interface LuckyDrawViewController ()
{
    UIImageView* _animatedImageView;
    UIImageView *_animatedImgVwGift;
    RewardRedemption *_rewardRedemption;
    UILabel *_voucher;
    UIButton *_btnHome;
    UIButton *_btnOrderNow;
    UIImageView* _imgVwSmallGiftBox;
    NSInteger _numberOfGift;
    UITapGestureRecognizer *_singleTap;
    UILabel *_lblGiftNum;
    
}
@end

@implementation LuckyDrawViewController
@synthesize receipt;


-(IBAction)unwindToLuckyDraw:(UIStoryboardSegue *)segue
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.homeModel downloadItems:dbRewardRedemptionLuckyDraw withData:receipt];
    
    
    
    
    
    if(_animatedImageView)
    {
        [_animatedImageView startAnimating];
        [self.view addSubview: _animatedImageView];
        [self.view addSubview:_btnHome];
    }
    else
    {
        _animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _animatedImageView.center = self.view.center;
        
        
        UIImage *imageExpand = [UIImage imageNamed:@"giftBoxBoo00001.jpg"];
        imageExpand = [self imageWithImage:imageExpand convertToSize:self.view.frame.size];
        UIImage *imageContract = [UIImage imageNamed:@"giftBoxBoo00002.jpg"];
        imageContract = [self imageWithImage:imageContract convertToSize:self.view.frame.size];
        _animatedImageView.animationImages = [NSArray arrayWithObjects:imageExpand,
                                              imageContract,
                                              nil];
        
        _animatedImageView.animationDuration = 1.0f;
        _animatedImageView.animationRepeatCount = 0;
        [_animatedImageView startAnimating];
        [self.view addSubview: _animatedImageView];
    }
    
    //btnHome
    {
        float btnOrderNowWidth = 60;
        _btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnHome setTitle:@"< Home" forState:UIControlStateNormal];
        [_btnHome setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnHome.titleLabel.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
        _btnHome.backgroundColor = [UIColor clearColor];
        _btnHome.contentHorizontalAlignment = NSTextAlignmentLeft;
        _btnHome.frame = CGRectMake(16, 80-8-44, btnOrderNowWidth, 44);
        [_btnHome addTarget:self action:@selector(unwindToHotDeal) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbRewardRedemptionLuckyDraw)
    {
        if([items count] == 0)
        {
            [self.view addSubview:_btnHome];
            return;
        }
        
        NSMutableArray *rewardRedemptionList = items[0];
        _rewardRedemption = rewardRedemptionList[0];
        
        NSMutableArray *luckyDrawTicketList = items[1];
        _numberOfGift = [luckyDrawTicketList count];
        
        
        
        
        [_animatedImageView stopAnimating];
        [_animatedImageView removeFromSuperview];
        
        
        if(!_animatedImgVwGift)
        {
            _animatedImgVwGift = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            _animatedImgVwGift.center = self.view.center;
        }
        else
        {
            [_animatedImgVwGift.layer removeAllAnimations];
        }
        
        NSString *rankCard;
        switch (_rewardRedemption.rewardRank) {
            case 1:
                rankCard = @"Excellent";
                break;
            case 2:
                rankCard = @"Awesome";
                break;
            case 3:
                rankCard = @"Good";
                break;
            case 4:
                rankCard = @"Boo";
                break;
            default:
                break;
        }
        NSMutableArray *animationImages = [[NSMutableArray alloc]init];
        NSInteger steps = 23;
        for(int i=0; i<steps; i++)
        {
            NSString *imageName = [NSString stringWithFormat:@"giftBox%@%05d.jpg",rankCard,(i+1)];
            UIImage *imageRunning = [UIImage imageNamed:imageName];
            imageRunning = [self imageWithImage:imageRunning convertToSize:self.view.frame.size];
            [animationImages addObject:(NSObject *)(imageRunning.CGImage)];
        }
//        NSArray *durations = @[@"1",@"1",@"1",@"1",@"1",@"1",
//                               @"0.5",@"0.5",@"0.5",@"0.5",
//                               @"1",@"1",
//                               @"1.5",@"1.5",@"1.5",
//                               @"1",@"1",
//                               @"0.5",@"0.5",@"0.5",@"0.5",@"0.5",@"0.5"
//                               ];
//        NSInteger startPeriod = 0;
//        NSInteger previousPeriod = 0;
//        NSInteger previousDurations = 0;
//        NSMutableArray *startTimes = [NSMutableArray arrayWithCapacity: steps];
//        for (int i = 0; i< steps; i++)
//        {
//            float currentDuration = [durations[i] floatValue];
//            if(previousDurations != currentDuration)
//            {
//                startPeriod = 0;
//                previousPeriod = i-1;
//            }
//
//            if(previousPeriod>=0)
//            {
//                startTimes[i] = @([startTimes[previousPeriod] floatValue] + [durations[previousPeriod] floatValue] + startPeriod * currentDuration);
//            }
//            else
//            {
//                startTimes[i] = @(startPeriod * currentDuration);
//            }
//
//            startPeriod++;
//            previousDurations = currentDuration;
//        }
//
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        animation.calculationMode = kCAAnimationDiscrete;
        animation.duration = 6;//[animationImages count] / 24.0; // 24 frames per second
//        animation.keyTimes = startTimes;
        animation.values = animationImages;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        [_animatedImgVwGift.layer addAnimation:animation forKey:@"animation"];
        [self.view addSubview:_animatedImgVwGift];
    }
    else if(homeModel.propCurrentDB == dbMenu)
    {
        HomeModel *homeModel = (HomeModel *)objHomeModel;
        if(homeModel.propCurrentDB == dbMenu)
        {
            [Utility updateSharedObject:items];
            NSMutableArray *messageList = [items[0] mutableCopy];
            Message *message = messageList[0];
            if(![message.text integerValue])
            {
                NSString *message = [Setting getValue:@"124m" example:@"ทางร้านไม่ได้เปิดระบบการสั่งอาหารด้วยตนเองตอนนี้ ขออภัยในความไม่สะดวกค่ะ"];
                [self showAlert:@"" message:message];
            }
            else
            {
                Menu *menu = [Menu getMenu:_rewardRedemption.discountMenuID branchID:_rewardRedemption.mainBranchID];
                SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:_rewardRedemption.discountMenuID branchID:_rewardRedemption.mainBranchID];
                float specialPrice = specialPriceProgram?specialPriceProgram.specialPrice:menu.price;
                
                
                OrderTaking *orderTaking = [[OrderTaking alloc]initWithBranchID:_rewardRedemption.mainBranchID customerTableID:0 menuID:_rewardRedemption.discountMenuID quantity:1 specialPrice:specialPrice price:menu.price takeAway:0 noteIDListInText:@"" orderNo:0 status:1 receiptID:0];
                
                
                NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
                [orderTakingList addObject:orderTaking];
                [OrderTaking setCurrentOrderTakingList:orderTakingList];
                [self performSegueWithIdentifier:@"segCreditCardAndOrderSummary" sender:self];
            }
        }
    }
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if(theAnimation == [_animatedImgVwGift.layer animationForKey:@"contents"])
    {
        if (flag)
        {
            NSLog(@"animation stop");
            if(!_voucher)
            {
                _voucher = [[UILabel alloc]init];
                _voucher.font = [UIFont fontWithName:@"Prompt-SemiBold" size:28];
                _voucher.textColor = cSystem1;
                _voucher.textAlignment = NSTextAlignmentCenter;
                _voucher.layer.shadowColor = [UIColor whiteColor].CGColor;//[UIColor greenColor].CGColor;
                _voucher.layer.shadowOpacity = 0.8;
                _voucher.layer.shadowRadius = 6;
                _voucher.layer.shadowOffset = CGSizeZero;
                _voucher.layer.masksToBounds = NO;
                _voucher.numberOfLines = 2;
            }
            
            _voucher.text = _rewardRedemption.header;
            CGRect frame = _voucher.frame;
            frame.size.width = self.view.frame.size.width-2*16;
            frame.size.height = 100;
            _voucher.frame = frame;
            _voucher.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.73);
            [self.view addSubview:_voucher];
            
            
            //btnHome
            [self.view addSubview:_btnHome];
            
            
            if(_rewardRedemption.discountMenuID)
            {
                float btnOrderNowWidth = 60;
                if(!_btnOrderNow)
                {
                    _btnOrderNow = [UIButton buttonWithType:UIButtonTypeCustom];
                    [_btnOrderNow setBackgroundImage:[UIImage imageNamed:@"orderNow.png"] forState:UIControlStateNormal];
                    _btnOrderNow.frame = CGRectMake(self.view.frame.size.width-30-btnOrderNowWidth, _voucher.frame.origin.y-btnOrderNowWidth+11, btnOrderNowWidth, btnOrderNowWidth);
                    [_btnOrderNow addTarget:self action:@selector(orderNow) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.view addSubview:_btnOrderNow];
            }
            
            
            //gift box
            if(_numberOfGift>0)
            {
                if(!_imgVwSmallGiftBox)
                {
                    NSInteger giftWidth = 60;
                    NSInteger giftYPosition = 70;
                    _imgVwSmallGiftBox = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-16-giftWidth, giftYPosition, giftWidth, giftWidth)];
                    
                    UIImage *imageNormal = [UIImage imageNamed:@"jummumGiftBoxNormal.png"];
                    imageNormal = [self imageWithImage:imageNormal convertToSize:CGSizeMake(giftWidth,giftWidth)];
                    
                    UIImage *imagePop = [UIImage imageNamed:@"jummumGiftBoxPop.png"];
                    imagePop = [self imageWithImage:imagePop convertToSize:CGSizeMake(giftWidth,giftWidth)];
                    
                    _imgVwSmallGiftBox.animationImages = [NSArray arrayWithObjects:imageNormal,imagePop,nil];
                    _imgVwSmallGiftBox.animationDuration = 1.0f;
                    _imgVwSmallGiftBox.animationRepeatCount = 0;
                }
                
                [_imgVwSmallGiftBox startAnimating];
                [self.view addSubview: _imgVwSmallGiftBox];
                
                
                //add singleTap
                if(!_singleTap)
                {
                    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGiftBox)];
                    _singleTap.numberOfTapsRequired = 1;
                    [_imgVwSmallGiftBox setUserInteractionEnabled:YES];
                    [_imgVwSmallGiftBox addGestureRecognizer:_singleTap];
                }
                
                
                
                //uilabel
                if(!_lblGiftNum)
                {
                    _lblGiftNum = [[UILabel alloc]init];
                    _lblGiftNum.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                    _lblGiftNum.textColor = [UIColor blackColor];
                    _lblGiftNum.numberOfLines = 1;
                    _lblGiftNum.textAlignment = NSTextAlignmentCenter;
                }
                _lblGiftNum.text = [NSString stringWithFormat:@"%ld more",_numberOfGift];
                [_lblGiftNum sizeToFit];
                CGRect frame = _lblGiftNum.frame;
                frame.size.width = frame.size.width+2*4;
                _lblGiftNum.frame = frame;
                
                _lblGiftNum.center = _imgVwSmallGiftBox.center;
                CGRect frame2 = _lblGiftNum.frame;
                frame2.origin.y = _imgVwSmallGiftBox.frame.origin.y+_imgVwSmallGiftBox.frame.size.height+8;
                _lblGiftNum.frame = frame2;
                _lblGiftNum.backgroundColor = [UIColor whiteColor];
                _lblGiftNum.layer.cornerRadius = 12;
                _lblGiftNum.layer.masksToBounds = YES;
                [self.view addSubview:_lblGiftNum];
            }
        }
    }
    else if(theAnimation == [_animatedImgVwGift.layer animationForKey:@"ridOpenClose"])
    {
        if(flag)
        {
            
        }
    }
}

-(void)unwindToHotDeal
{
    [self performSegueWithIdentifier:@"segUnwindToHotDeal" sender:self];
}

-(void)orderNow
{
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbMenu withData:@[@(_rewardRedemption.mainBranchID), @(_rewardRedemption.discountMenuID)]];
}

-(void)tapGiftBox
{
    [_voucher removeFromSuperview];
    [_animatedImgVwGift removeFromSuperview];
    [_btnOrderNow removeFromSuperview];
    
    
    [_imgVwSmallGiftBox stopAnimating];
    [_imgVwSmallGiftBox removeFromSuperview];
    
    
    [self viewDidAppear:NO];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segCreditCardAndOrderSummary"])
    {
        Branch *branch = [Branch getBranch:_rewardRedemption.mainBranchID];
        CreditCardAndOrderSummaryViewController *vc = segue.destinationViewController;
        vc.branch = branch;
        vc.customerTable = nil;
        vc.fromLuckyDraw = 1;
        vc.receipt = nil;
        vc.buffetReceipt = nil;
        vc.rewardRedemption = _rewardRedemption;
    }
}
@end
