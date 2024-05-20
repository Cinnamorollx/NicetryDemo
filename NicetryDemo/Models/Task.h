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
    FinishedToday = 0,
    FinishedTomorrow,
    FinishedThisWeekend,
    FinishedThisWeek,
    FinishedNextWeek,
    FinishedEveryday
} TaskType;

@property (nonatomic, strong) NSString *taskName;
@property (nonatomic, assign) TaskType taskType;


@end

NS_ASSUME_NONNULL_END
