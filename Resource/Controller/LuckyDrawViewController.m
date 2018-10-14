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
#import "Card.h"
#import "DiscountGroupMenuMap.h"


@interface LuckyDrawViewController ()
{
    UIImageView* _imgVwWaiting;
    UIImageView *_imgVwGiftPrize;
    UIImageView *_imgVwRidCloseOpen;
    RewardRedemption *_rewardRedemption;
    UILabel *_voucher;
    UIButton *_btnHome;
    UIButton *_btnOrderNow;
    UIImageView* _imgVwSmallGiftBox;
    NSInteger _numberOfGift;
    UILabel *_lblGiftNum;
    UITapGestureRecognizer *_tapGiftBox;
    
    UITapGestureRecognizer *_tapPauseResume;
    BOOL _toggleTap;
    UITapGestureRecognizer *_tapPauseResumeRidCloseOpen;
    BOOL _toggleTapRidCloseOpen;
    UITapGestureRecognizer *_tapPauseResumeDownloadWaiting;
    BOOL _toggleTapDownloadWaiting;
    
    NSMutableArray *_arrRankCard;
    BOOL _viewDidAppear;
    BOOL _luckyDrawDownloaded;
    CAKeyframeAnimation *_animationWaiting;
    NSMutableArray *_animationImages;
    
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
    
    
    if(!_viewDidAppear)
    {
        _viewDidAppear = YES;
        
        
        //gift prize
        _imgVwGiftPrize = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                _imgVwGiftPrize.center = self.view.center;
        
        
        //rid close open while waiting for dbRewardRedemptionLuckyDraw
        _imgVwWaiting = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _imgVwWaiting.center = self.view.center;
        
        
        _animationImages = [[NSMutableArray alloc]init];
        NSInteger steps = 2;
        for(int i=0; i<steps; i++)
        {
            NSString *imageName = [NSString stringWithFormat:@"giftBox%@%05d.jpg",@"Boo",(i+1)];
            UIImage *imageRunning = [UIImage imageNamed:imageName];
            [_animationImages addObject:(NSObject *)(imageRunning.CGImage)];
        }
        
        
        
        _animationWaiting = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        _animationWaiting.calculationMode = kCAAnimationDiscrete;
        _animationWaiting.duration = 0.5;
        _animationWaiting.values = _animationImages;
        _animationWaiting.repeatCount = 1;
        _animationWaiting.removedOnCompletion = NO;
        _animationWaiting.fillMode = kCAFillModeForwards;
        _animationWaiting.delegate = self;
        [_imgVwWaiting.layer addAnimation:_animationWaiting forKey:@"downloadWaiting"];
        [self.view addSubview:_imgVwWaiting];
        [self.homeModel downloadItems:dbRewardRedemptionLuckyDraw withData:receipt];
        
        
        if(!_tapPauseResumeDownloadWaiting)
        {
            _tapPauseResumeDownloadWaiting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedDownloadWaiting)];
            _tapPauseResumeDownloadWaiting.numberOfTapsRequired = 1;
            [_imgVwWaiting setUserInteractionEnabled:YES];
            [_imgVwWaiting addGestureRecognizer:_tapPauseResumeDownloadWaiting];
        }

        //btnHome
        {
            float btnOrderNowWidth = 60;
            _btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btnHome setTitle:@"< Home" forState:UIControlStateNormal];
            [_btnHome setTitleColor:cSystem5 forState:UIControlStateNormal];
            _btnHome.titleLabel.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            _btnHome.backgroundColor = [UIColor clearColor];
            _btnHome.contentHorizontalAlignment = NSTextAlignmentLeft;
            _btnHome.frame = CGRectMake(16, 80-8-44, btnOrderNowWidth, 44);
            [_btnHome addTarget:self action:@selector(unwindToHotDeal) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
//    return;
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
        
//        _discountGroupMenuMapList = items[2];
        
 
        _luckyDrawDownloaded = YES;
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
                NSString *message = [Language getText:@"ทางร้านไม่ได้เปิดระบบการสั่งอาหารด้วยตนเองตอนนี้ ขออภัยในความไม่สะดวกค่ะ"];
                [self showAlert:@"" message:message];
            }
            else
            {
                NSMutableArray *discountGroupMenuMapList = items[6];
                NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
                for(int i=0; i<[discountGroupMenuMapList count]; i++)
                {
                    DiscountGroupMenuMap *discountGroupMenuMap = discountGroupMenuMapList[i];
                    Menu *menu = [Menu getMenu:discountGroupMenuMap.menuID branchID:_rewardRedemption.mainBranchID];
                    SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:discountGroupMenuMap.menuID branchID:_rewardRedemption.mainBranchID];
                    float specialPrice = specialPriceProgram?specialPriceProgram.specialPrice:menu.price;
                    
                    
                    for(int j=0; j<discountGroupMenuMap.quantity; j++)
                    {
                        OrderTaking *orderTaking = [[OrderTaking alloc]initWithBranchID:receipt.branchID customerTableID:0 menuID:discountGroupMenuMap.menuID quantity:1 specialPrice:specialPrice price:menu.price takeAway:0 takeAwayPrice:0 noteIDListInText:@"" notePrice:0 orderNo:0 status:1 receiptID:0];
                        [orderTakingList addObject:orderTaking];
                    }
                }
                                
                [OrderTaking setCurrentOrderTakingList:orderTakingList];
                [self performSegueWithIdentifier:@"segCreditCardAndOrderSummary" sender:self];
            }
        }
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if(theAnimation == [_imgVwGiftPrize.layer animationForKey:@"giftPrize"])
    {
        if (flag)
        {
            if(!_voucher)
            {
                _voucher = [[UILabel alloc]init];
                _voucher.font = [UIFont fontWithName:@"Prompt-SemiBold" size:28];
                _voucher.textColor = cSystem1;
                _voucher.textAlignment = NSTextAlignmentCenter;
                _voucher.layer.shadowColor = [UIColor whiteColor].CGColor;
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
            
            
            if(_rewardRedemption.discountGroupMenuID)
            {
                float btnOrderNowWidth = 60;
                if(!_btnOrderNow)
                {
                    _btnOrderNow = [UIButton buttonWithType:UIButtonTypeCustom];
                    [_btnOrderNow setBackgroundImage:[UIImage imageNamed:@"orderNow.png"] forState:UIControlStateNormal];
                    _btnOrderNow.frame = CGRectMake(self.view.frame.size.width-30-btnOrderNowWidth, _voucher.frame.origin.y-btnOrderNowWidth+11, btnOrderNowWidth, btnOrderNowWidth);
                    [_btnOrderNow addTarget:self action:@selector(orderNow) forControlEvents:UIControlEventTouchUpInside];
                    //shadow
                    _btnOrderNow.layer.shadowColor = [UIColor lightGrayColor].CGColor;
                    _btnOrderNow.layer.shadowOffset = CGSizeMake(0, 1);
                    _btnOrderNow.layer.shadowRadius = 1;
                    _btnOrderNow.layer.shadowOpacity = 0.8f;
                    _btnOrderNow.layer.masksToBounds = NO;
                }
                [self.view addSubview:_btnOrderNow];
            }
            
            
            //gift box
            if(_numberOfGift>0)
            {
                if(!_imgVwSmallGiftBox)
                {
                    NSInteger giftWidth = 80;
                    NSInteger giftYPosition = 60;
                    _imgVwSmallGiftBox = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-16-giftWidth, giftYPosition, giftWidth, giftWidth)];
                    
                    UIImage *imageNormal = [UIImage imageNamed:@"jummumGiftBoxNormal.png"];
                    UIImage *imagePop = [UIImage imageNamed:@"jummumGiftBoxPop.png"];

                    _imgVwSmallGiftBox.animationImages = [NSArray arrayWithObjects:imageNormal,imagePop,nil];
                    _imgVwSmallGiftBox.animationDuration = 1.0f;
                    _imgVwSmallGiftBox.animationRepeatCount = 0;
                }
                
                [_imgVwSmallGiftBox startAnimating];
                [self.view addSubview: _imgVwSmallGiftBox];
                
                
                //add singleTap
                if(!_tapGiftBox)
                {
                    _tapGiftBox = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGiftBox)];
                    _tapGiftBox.numberOfTapsRequired = 1;
                    [_imgVwSmallGiftBox setUserInteractionEnabled:YES];
                    [_imgVwSmallGiftBox addGestureRecognizer:_tapGiftBox];
                }
                
                
                
                //uilabel
                if(!_lblGiftNum)
                {
                    _lblGiftNum = [[UILabel alloc]init];
                    _lblGiftNum.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                    _lblGiftNum.textColor = [UIColor whiteColor];
                    _lblGiftNum.numberOfLines = 1;
                    _lblGiftNum.textAlignment = NSTextAlignmentCenter;
                }
                _lblGiftNum.text = [NSString stringWithFormat:@"%ld more",_numberOfGift];
                [_lblGiftNum sizeToFit];
                CGRect frame = _lblGiftNum.frame;
                frame.size.width = frame.size.width+2*5;
                _lblGiftNum.frame = frame;
                
                _lblGiftNum.center = _imgVwSmallGiftBox.center;
                CGRect frame2 = _lblGiftNum.frame;
                frame2.origin.y = _imgVwSmallGiftBox.frame.origin.y+_imgVwSmallGiftBox.frame.size.height+4;
                _lblGiftNum.frame = frame2;
                
                //rounded corner
                _lblGiftNum.layer.backgroundColor = cRibbon.CGColor;
                _lblGiftNum.layer.cornerRadius = 10;
                _lblGiftNum.layer.masksToBounds = NO;
                
                //shadow
                _lblGiftNum.layer.shadowColor = [UIColor whiteColor].CGColor;
                _lblGiftNum.layer.shadowOffset = CGSizeMake(0, 1);
                _lblGiftNum.layer.shadowRadius = 1;
                _lblGiftNum.layer.shadowOpacity = 0.8f;
                _lblGiftNum.layer.masksToBounds = NO;

                
                [self.view addSubview:_lblGiftNum];
            }
        }
    }
    else if(theAnimation == [_imgVwRidCloseOpen.layer animationForKey:@"ridCloseOpen"])
    {
        if(flag)
        {
            [_imgVwRidCloseOpen removeFromSuperview];
            
//            if(!_imgVwGiftPrize)
//            {
//                _imgVwGiftPrize = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//                _imgVwGiftPrize.center = self.view.center;
//            }
//            else
            {
                [_imgVwGiftPrize.layer removeAllAnimations];
            }
            
            NSMutableArray *arrImage;
            switch (_rewardRedemption.rewardRank) {
                case 1:
                    arrImage = [Card getExcellentCard];
                break;
                case 2:
                    arrImage = [Card getAwesomeCard];
                break;
                case 3:
                    arrImage = [Card getGoodCard];
                break;
                case 4:
                    arrImage = [Card getBooCard];
                break;
                default:
                break;
            }
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
            animation.calculationMode = kCAAnimationDiscrete;
            animation.duration = 3;//[animationImages count] / 24.0; // 24 frames per second
            animation.values = arrImage;
            animation.repeatCount = 1;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.delegate = self;
            [_imgVwGiftPrize.layer addAnimation:animation forKey:@"giftPrize"];
            [self.view addSubview:_imgVwGiftPrize];
            
            
            if(!_tapPauseResume)
            {
                _tapPauseResume = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedGiftPrize)];
                _tapPauseResume.numberOfTapsRequired = 1;
                [_imgVwGiftPrize setUserInteractionEnabled:YES];
                [_imgVwGiftPrize addGestureRecognizer:_tapPauseResume];
            }
        }
    }
    else if(theAnimation == [_imgVwWaiting.layer animationForKey:@"downloadWaiting"])
    {
        if(flag)
        {
            if(_luckyDrawDownloaded)
            {
                _luckyDrawDownloaded = NO;
                [_imgVwWaiting.layer removeAllAnimations];
                [_imgVwWaiting removeFromSuperview];
                
                
                
                //rid open close
                if(!_imgVwRidCloseOpen)
                {
                    _imgVwRidCloseOpen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    _imgVwRidCloseOpen.center = self.view.center;
                }
                else
                {
                    [_imgVwRidCloseOpen.layer removeAllAnimations];
                }
                
                
                NSMutableArray *animationImages = [[NSMutableArray alloc]init];
                NSInteger steps = 2;
                for(int i=0; i<steps; i++)
                {
                    NSString *imageName = [NSString stringWithFormat:@"giftBox%@%05d.jpg",@"Boo",(i+1)];
                    UIImage *imageRunning = [UIImage imageNamed:imageName];
                    [animationImages addObject:(NSObject *)(imageRunning.CGImage)];
                }
                
                
                
                CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
                animation.calculationMode = kCAAnimationDiscrete;
                animation.duration = 0.5;
                animation.values = animationImages;
                animation.repeatCount = 1;
                animation.removedOnCompletion = NO;
                animation.fillMode = kCAFillModeForwards;
                animation.delegate = self;
                [_imgVwRidCloseOpen.layer addAnimation:animation forKey:@"ridCloseOpen"];
                [self.view addSubview:_imgVwRidCloseOpen];
                
                
                if(!_tapPauseResumeRidCloseOpen)
                {
                    _tapPauseResumeRidCloseOpen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedRidCloseOpen)];
                    _tapPauseResumeRidCloseOpen.numberOfTapsRequired = 1;
                    [_imgVwRidCloseOpen setUserInteractionEnabled:YES];
                    [_imgVwRidCloseOpen addGestureRecognizer:_tapPauseResumeRidCloseOpen];
                }
            }
            else
            {
                NSLog(@"downloadWaiting stop _luckyDrawDownloaded no");
                [_imgVwWaiting.layer addAnimation:_animationWaiting forKey:@"downloadWaiting"];
            }
        }
    }
}

-(void)tapDetectedGiftPrize
{
    NSLog(@"tapDetectedGiftPrize");
    if(!_toggleTap)
    {
        CFTimeInterval pausedTime = [_imgVwGiftPrize.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        _imgVwGiftPrize.layer.speed = 0.0;
        _imgVwGiftPrize.layer.timeOffset = pausedTime;
    }
    else
    {
        CFTimeInterval pausedTime = [_imgVwGiftPrize.layer timeOffset];
        _imgVwGiftPrize.layer.speed = 1.0;
        _imgVwGiftPrize.layer.timeOffset = 0.0;
        _imgVwGiftPrize.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [_imgVwGiftPrize.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        _imgVwGiftPrize.layer.beginTime = timeSincePause;
    }
    _toggleTap = !_toggleTap;
}

-(void)tapDetectedDownloadWaiting
{
    NSLog(@"tapDetectedDownloadWaiting");
    if(!_toggleTapDownloadWaiting)
    {
        CFTimeInterval pausedTime = [_imgVwWaiting.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        _imgVwWaiting.layer.speed = 0.0;
        _imgVwWaiting.layer.timeOffset = pausedTime;
    }
    else
    {
        CFTimeInterval pausedTime = [_imgVwWaiting.layer timeOffset];
        _imgVwWaiting.layer.speed = 1.0;
        _imgVwWaiting.layer.timeOffset = 0.0;
        _imgVwWaiting.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [_imgVwWaiting.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        _imgVwWaiting.layer.beginTime = timeSincePause;
    }
    _toggleTapDownloadWaiting = !_toggleTapDownloadWaiting;
}

-(void)tapDetectedRidCloseOpen
{
    NSLog(@"tapDetectedRidCloseOpen");
    if(!_toggleTapRidCloseOpen)
    {
        CFTimeInterval pausedTime = [_imgVwRidCloseOpen.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        _imgVwRidCloseOpen.layer.speed = 0.0;
        _imgVwRidCloseOpen.layer.timeOffset = pausedTime;
    }
    else
    {
        CFTimeInterval pausedTime = [_imgVwRidCloseOpen.layer timeOffset];
        _imgVwRidCloseOpen.layer.speed = 1.0;
        _imgVwRidCloseOpen.layer.timeOffset = 0.0;
        _imgVwRidCloseOpen.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [_imgVwRidCloseOpen.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        _imgVwRidCloseOpen.layer.beginTime = timeSincePause;
    }
    _toggleTapRidCloseOpen = !_toggleTapRidCloseOpen;
}

-(void)unwindToHotDeal
{
    [self performSegueWithIdentifier:@"segUnwindToHotDeal" sender:self];
}

-(void)orderNow
{
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbMenu withData:@[@(_rewardRedemption.mainBranchID),@(_rewardRedemption.discountGroupMenuID)]];
}

-(void)tapGiftBox
{
    [_voucher removeFromSuperview];
    [_imgVwGiftPrize removeFromSuperview];
    [_btnOrderNow removeFromSuperview];
    [_btnHome removeFromSuperview];
    [_imgVwSmallGiftBox removeFromSuperview];
    _toggleTap = NO;
    
    
    
    [_imgVwWaiting.layer addAnimation:_animationWaiting forKey:@"downloadWaiting"];
    [self.view addSubview: _imgVwWaiting];
    [self.homeModel downloadItems:dbRewardRedemptionLuckyDraw withData:receipt];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segCreditCardAndOrderSummary"])
    {
        Branch *branch = [Branch getBranch:_rewardRedemption.mainBranchID];
        CreditCardAndOrderSummaryViewController *vc = segue.destinationViewController;
        vc.branch = branch;        
        vc.customerTable = [CustomerTable getCustomerTable:receipt.customerTableID];
        vc.fromLuckyDraw = 1;
        vc.receipt = nil;
        vc.buffetReceipt = nil;
        vc.rewardRedemption = _rewardRedemption;
    }
}
@end
