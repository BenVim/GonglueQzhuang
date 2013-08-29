//
//  SFQuestionListCell.h
//  Gonglue
//
//  Created by jiajun on 2/28/13.
//  Copyright (c) 2013 Gonglue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFQuestionListCell : UITableViewCell

- (void)updateQuestionInfo:(NSDictionary *)info;

@end

@interface UITableView (SFQuestionListTableView)

- (SFQuestionListCell *)questionListCell;
- (SFQuestionListCell *)questionListLoadingCell;

@end
