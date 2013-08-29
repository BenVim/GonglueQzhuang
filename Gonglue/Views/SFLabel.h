//
//  SFLabel.h
//  Gonglue
//
//  Created by jiajun on 3/1/13.
//  Copyright (c) 2013 Gonglue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFLabel : UILabel

-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;

@property(nonatomic) UIEdgeInsets insets;

@end