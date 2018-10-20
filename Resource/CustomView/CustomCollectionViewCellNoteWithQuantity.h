//
//  CustomCollectionViewCellNoteWithQuantity.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 18/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellNoteWithQuantity : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnDeleteQuantity;
@property (strong, nonatomic) IBOutlet UIButton *btnAddQuantity;
@property (strong, nonatomic) IBOutlet UITextField *txtQuantity;
@property (strong, nonatomic) IBOutlet UILabel *lblNoteName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;
@end
