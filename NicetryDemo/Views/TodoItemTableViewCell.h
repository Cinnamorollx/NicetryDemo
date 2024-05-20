//
//  TodoItemTableViewCell.h
//  NicetryDemo
//
//  Created by 刘宇航 on 2024/5/20.
//

#import <UIKit/UIKit.h>
#import "../Models/Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface TodoItemTableViewCell : UITableViewCell

@property (nonatomic, strong) Task * task;

@end

NS_ASSUME_NONNULL_END
