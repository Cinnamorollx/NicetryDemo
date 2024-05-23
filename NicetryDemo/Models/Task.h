//
//  Task.h
//  NicetryDemo
//
//  Created by 刘宇航 on 2024/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface Task : NSObject

typedef enum {
    FinishedNone = 0,
    FinishedToday,
    FinishedTomorrow,
    FinishedThisWeekend,
    FinishedThisWeek,
    FinishedNextWeek,
    FinishedEveryday
} TaskType;

@property (nonatomic, strong) NSString *taskName;
@property (nonatomic, assign) TaskType taskType;
@property (nonatomic, assign) BOOL done;

@end

NS_ASSUME_NONNULL_END
