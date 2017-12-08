//
//  UITableView+EmptyData.m
//  Action
//
//  Created by caokun on 15/11/4.
//  Copyright © 2015年 xingdongpai. All rights reserved.
//

#import "UITableView+EmptyData.h"

@implementation UITableView (EmptyData)

- (void)tableViewDisplayWitMsg:(NSString *)message ifNecessaryForRowCount:(NSUInteger)rowCount
{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = message;
        messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22];
        messageLabel.textColor = kColorDarkGray2;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        self.backgroundView = messageLabel;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (void)tableViewDisplayWithImage:(NSString *)imgName msg:(NSString *)message ifNecessaryForRowCount:(NSUInteger)rowCount{
    if (rowCount == 0) {
        //Controlling the Background of a UITableView
        //setting an image as the background of UITableView through four steps
        
        //1.set backgroundColor property of tableView to clearColor, so that background image is visible
        [self setBackgroundColor:[UIColor clearColor]];
        
        //2.create an UIImageView that you want to appear behind the table
        if (isNullString(imgName)) {
            imgName = @"emptyTableBG";
        }
        UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        
        //3.set the UIImageView’s frame to the same size of the tableView
        [tableBackgroundView setFrame: self.frame];
        
        //4.update tableView’s backgroundImage to the new UIImageView object
        [self setBackgroundView:tableBackgroundView];
    }
}

@end
