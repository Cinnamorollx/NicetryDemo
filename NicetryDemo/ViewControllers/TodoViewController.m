//
//  TodoViewController.m
//  NicetryDemo
//
//  Created by 刘宇航 on 2024/5/15.
//

#import "TodoViewController.h"
#import "../Views/TodoItemTableViewCell.h"
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareViews];
    [self addConstraints];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayChanged) name:NSCalendarDayChangedNotification object:nil]; //没啥用，检测日期变了更新一下界面的日期,避免有人熬夜结果日期一直不变
    //TODO: 读取本地文件
    [_todoTableView registerClass:[TodoItemTableViewCell class] forCellReuseIdentifier:@"todo-item-cell"];
    
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
    
    _inputField = [[UITextField alloc] init];
    _inputField.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_inputField];
    
    _todoTableView = [[UITableView alloc] init];
    [self.view addSubview:_todoTableView];
    _todoTableView.backgroundColor = [UIColor redColor];
    
    _timeLabel = [[UILabel alloc] init];
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComp = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday) fromDate:today];
    NSArray *weekdays = @[@"", @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    _timeLabel.text = [NSString stringWithFormat:@"%ld月%ld日, %@",todayComp.month,todayComp.day, weekdays[todayComp.weekday]];
    [self.view addSubview:_timeLabel];
    
    _helloLabel = [[UILabel alloc] init];
    _helloLabel.text = @"Hello, 今天也要加油喔⛽️😇";
    _helloLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:_helloLabel];
    
    Task *mockTask = [[Task alloc] init];
    mockTask.taskName = @"LoveDang";
    mockTask.taskType = FinishedEveryday;
    [_todoList addObject:mockTask];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"task added");
    return YES;
}

- (void)saveFiles {
    //TODO: 当数组变化保存本地文件
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodoItemTableViewCell *cell = [_todoTableView dequeueReusableCellWithIdentifier:@"todo-item-cell"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _todoList.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
