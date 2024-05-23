//
//  Task.m
//  NicetryDemo
//
//  Created by 刘宇航 on 2024/5/20.
//

#import "Task.h"

@implementation Task

- (instancetype)init {
    self = [super init];
    if (self) {
        self.done = NO;
        self.taskName = @"";
        self.taskType = FinishedNone;
    }
    return self;
}

@end
