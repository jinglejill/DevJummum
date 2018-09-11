//
//  LuckyDrawViewController.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 8/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"
#import "Receipt.h"


@interface LuckyDrawViewController : CustomViewController<CAAnimationDelegate>
@property (strong, nonatomic) Receipt *receipt;
-(IBAction)unwindToLuckyDraw:(UIStoryboardSegue *)segue;
@end
