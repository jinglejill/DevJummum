//
//  UILabel+FontAppearance.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 18/6/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "UILabel+FontAppearance.h"
#import "Utility.h"


@implementation UILabel (FontAppearance)

- (void)setAppearanceFont:(UIFont *)font
{
    if (self.tag == 1001) {
        return;
    }
    
    BOOL isBold = (self.font.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold);
    const CGFloat* colors = CGColorGetComponents(self.textColor.CGColor);
    
    if (self.font.pointSize == 14)
    {
        // set font for UIAlertController title
//        self.font = [UIFont systemFontOfSize:11];
        self.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
    }
    else if (self.font.pointSize == 13)
    {
        // set font for UIAlertController message
//        self.font = [UIFont systemFontOfSize:11];
        self.font = [UIFont fontWithName:@"Prompt-Regular" size:13.0f];
    }
    else if (isBold)
    {
        // set font for UIAlertAction with UIAlertActionStyleCancel
//        self.font = [UIFont systemFontOfSize:12];
        self.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
    }
    else if ((*colors) == 1)
    {
        // set font for UIAlertAction with UIAlertActionStyleDestructive
//        self.font = [UIFont systemFontOfSize:13];
        self.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
    }
    else
    {
        // set font for UIAlertAction with UIAlertActionStyleDefault
//        self.font = [UIFont systemFontOfSize:14];
        self.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
    }
    
    self.tag = 1001;
}

- (UIFont *)appearanceFont
{
    return self.font;
}

@end
