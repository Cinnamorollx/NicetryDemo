//
//  TodoViewController.m
//  NicetryDemo
//
//  Created by 刘宇航 on 2024/5/15.
//

#import "TodoViewController.h"
#import "../Models/Task.h"
#import "Masonry.h"
@interface TodoViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UITableView *todoTableView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *helloLabel;

@property (nonatomic, strong) NSMutableArray<Task *> *todoList;
@property (nonatomic, strong) NSMutableArray<Task *> *finishedList;

@end

@implementation TodoViewController

#pragma mark - Lifecycles

- (instancetype)init {
    self = [super init];
    if (self) {
        _todoList = [[NSMutableArray alloc] init];
        _finishedList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareViews];
    [self addConstraints];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayChanged) name:NSCalendarDayChangedNotification object:nil]; //没啥用，检测日期变了更新一下界面的日期,避免有人熬夜结果日期一直不变
    //TODO: 读取本地文件
//    [_todoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"todo-item-cell"];
    // 不register否则dequeue方法就不会返回nil，没法触发我的cell == nil 逻辑
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSCalendarDayChangedNotification object:nil];
}


#pragma mark - Views

- (void)prepareViews {
    self.navigationItem.title = @"Todo List";
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked)];
    self.navigationItem.rightBarButtonItem = add;
    UIBarButtonItem *history = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(checkHistory)];
    self.navigationItem.leftBarButtonItem = history;
    
    //mock data
    Task *mockTask = [[Task alloc] init];
    mockTask.taskName = @"LoveDang";
    mockTask.taskType = FinishedEveryday;
    [_todoList addObject:mockTask];
    
    Task *mockTask1 = [[Task alloc] init];
    mockTask1.taskName = @"cs2";
    mockTask1.taskType = FinishedTomorrow;
    [_todoList addObject:mockTask1];
    
    Task *mockTask2 = [[Task alloc] init];
    mockTask2.taskName = @"吃饭睡觉";
    mockTask2.taskType = FinishedNextWeek;
    [_todoList addObject:mockTask2];
    
    Task *mockTask3 = [[Task alloc] init];
    mockTask3.taskName = @"coding";
    mockTask3.taskType = FinishedThisWeekend;
    [_todoList addObject:mockTask3];
    
    Task *mockTask4 = [[Task alloc] init];
    mockTask4.taskName = @"hahaha";
    [_todoList addObject:mockTask4];
    
    
    
    _inputField = [[UITextField alloc] init];
    _inputField.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_inputField];
    _inputField.delegate = self;
    
    _todoTableView = [[UITableView alloc] init];
    [self.view addSubview:_todoTableView];
    _todoTableView.backgroundColor = [UIColor redColor];
    _todoTableView.delegate = self;
    _todoTableView.dataSource = self;
    _todoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _timeLabel = [[UILabel alloc] init];
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComp = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday) fromDate:today];
    NSArray *weekdays = @[@"", @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    _timeLabel.text = [NSString stringWithFormat:@"%ld月%ld日, %@",todayComp.month,todayComp.day, weekdays[todayComp.weekday]];
    [self.view addSubview:_timeLabel];
    
    _helloLabel = [[UILabel alloc] init];
    _helloLabel.text = @"Hello, 今天也要加油喔 ⛽️";
    _helloLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:_helloLabel];
    
    
}

- (void)addConstraints {
    [_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
    }];
    
    [_todoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(60);
        make.top.mas_equalTo(_timeLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(_inputField.mas_top).offset(-10);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    
    [_helloLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(5);
        make.left.mas_equalTo(self.view.mas_left).offset(20);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_helloLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.view.mas_left).offset(20);
    }];
}

#pragma mark - Methods

- (void) addButtonClicked {
    NSLog(@"add button clicked");
}

- (void) addItem {
    NSLog(@"add");
    NSString *newName = _inputField.text;
    NSLog(@"new task name: %@", newName);
    Task *newTask = [[Task alloc] init];
    newTask.taskName = newName;
    newTask.taskType = FinishedEveryday;
    [_todoList addObject:newTask];
}

- (void)dayChanged {
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComp = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday) fromDate:today];
    NSArray *weekdays = @[@"", @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    _timeLabel.text = [NSString stringWithFormat:@"%ld月%ld日, %@",todayComp.month,todayComp.day, weekdays[todayComp.weekday]];
}

- (void)checkHistory {
    NSLog(@"check history");
    //TODO: histroy page
}

- (void)saveFiles {
    //TODO: 当数组变化保存本地文件
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"task added %@",_inputField.text);
    _inputField.text = @"";
    [_inputField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(k)
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}


#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_todoTableView dequeueReusableCellWithIdentifier:@"todo-item-cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"todo-item-cell"];
        cell.layer.cornerRadius = 15.0;
        cell.backgroundColor = [UIColor whiteColor];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    Task *currentTask = self.todoList[indexPath.section];
    NSString *taskType;
    switch (currentTask.taskType) {
        case FinishedToday:
            taskType = @"今天";
            break;
        case FinishedEveryday:
            taskType = @"每天";
            break;
        case FinishedTomorrow:
            taskType = @"明天";
            break;
        case FinishedNextWeek:
            taskType = @"下周";
            break;
        case FinishedThisWeek:
            taskType = @"这周";
            break;
        case FinishedThisWeekend:
            taskType = @"这周末";
            break;
        case FinishedNone:
            taskType = @"";
            break;
    }
    
    cell.detailTextLabel.text = taskType;
    cell.textLabel.text = currentTask.taskName;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _todoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *marginView = [[UIView alloc] init];
    
    return marginView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - setter/getter


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
