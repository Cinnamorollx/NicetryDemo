//
//  OrderViewController.m
//  NicetryDemo
//
//  Created by 刘宇航 on 2024/5/15.
//

#import "OrderViewController.h"
#import "Masonry/Masonry.h"
#import "DetailViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) UIImageView *kanaImage;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end



@implementation OrderViewController


#pragma mark - init views

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    [self prepareViews];
    [self addConstraints];
}

- (void)prepareViews {
    self.navigationItem.title = @"先点菜吧";
    _leftTableView = [[UITableView alloc] init];
    _rightTableView = [[UITableView alloc] init];
    [_leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"left-cell"];
    [_rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"right-cell"];
    _leftTableView.delegate = _rightTableView.delegate = self;
    _leftTableView.dataSource = _rightTableView.dataSource = self;
    [self.view addSubview:_leftTableView];
    [self.view addSubview:_rightTableView];
    
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    _rightTableView.separatorInset = UIEdgeInsetsZero;
    
    UIImage *img = [UIImage imageNamed:@"kana_shock"];
    _kanaImage = [[UIImageView alloc] initWithImage:img];
    _kanaImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_kanaImage];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.text = @"两个tableview实现类似点餐界面";
    _textLabel.font = [UIFont systemFontOfSize:12];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_textLabel];
    
}

- (void)addConstraints {
    [_leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH/4);
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(100);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
    [_rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftTableView.mas_right);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(100);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
    [_kanaImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);;
        make.height.mas_equalTo(100);
        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(self.view.frame.size.width/2);
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(self.view.frame.size.width/2);
    }];
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(tableView == _leftTableView) {
        NSLog(@"yes left");
        cell = [_leftTableView dequeueReusableCellWithIdentifier:@"left-cell"];
        cell.textLabel.text = _dataDict.allKeys[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    } else {
        NSLog(@"yes right %ld", indexPath.row);
        cell = [_rightTableView dequeueReusableCellWithIdentifier:@"right-cell"];
        cell.separatorInset = UIEdgeInsetsZero;
        UIListContentConfiguration *config = [cell defaultContentConfiguration];
        config.imageProperties.maximumSize = CGSizeMake(140, 140);
//        config.textLabel.text = _dataDict.allValues[indexPath.section][indexPath.row][0];
//        config.textLabel.font = [UIFont systemFontOfSize:14];
        config.text = _dataDict.allValues[indexPath.section][indexPath.row][0];
        config.textProperties.font = [UIFont systemFontOfSize:14];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:_dataDict.allValues[indexPath.section][indexPath.row][1]];
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data) {
                NSLog(@"fetch success");
                dispatch_async(dispatch_get_main_queue(), ^{
                    config.image = [UIImage imageWithData:data];
                    cell.contentConfiguration = config;
                });
            } else {
                NSLog(@"fetch error");
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.contentConfiguration = config;
                });
            }
                              
        }];
        [task resume];
        
        
       
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _leftTableView) {
        NSLog(@"%lu",self.dataDict.allKeys.count);
        return self.dataDict.allKeys.count;
    } else {
        NSArray *arr = [_dataDict valueForKey:_dataDict.allKeys[section]];
        NSLog(@"%lu",self.dataDict.allKeys.count);
        return arr.count;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == _rightTableView) {
        return self.dataDict.allValues.count;
    }
    return 1;
}




#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        return 50;
    } else {
        return 150;
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == _rightTableView) {
        return self.dataDict.allKeys[section];
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == _rightTableView) {
        NSInteger num = _rightTableView.indexPathsForVisibleRows.firstObject.section;
        [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:num inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _leftTableView) {
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        DetailViewController *detail = [[DetailViewController alloc] init];
        detail.name = _dataDict.allValues[indexPath.section][indexPath.row][0];
        detail.strURL = _dataDict.allValues[indexPath.section][indexPath.row][1];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - getters & setters
//mock data getter method
- (NSMutableDictionary *)dataDict {
    if(!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
        [_dataDict setObject:@[@[@"黎明杀机",@"https://media.st.dl.eccdnx.com/steam/apps/381210/header.jpg?t=1715700452"],@[@"Deceit",@"https://media.st.dl.eccdnx.com/steam/apps/466240/header.jpg?t=1710352642"],@[@"恐鬼症",@"https://media.st.dl.eccdnx.com/steam/apps/739630/header.jpg?t=1702309974"],@[@"杀戮天使",@"https://media.st.dl.eccdnx.com/steam/apps/537110/header_schinese.jpg?t=1674468422"]] forKey:@"恐怖游戏"];
        [_dataDict setObject:@[@[@"炉石传说",@"https://static0.gamerantimages.com/wordpress/wp-content/uploads/Hearthstone-Loading-Screen.jpg?q=50&fit=contain&w=1140&h=&dpr=1.5"],@[@"游戏王",@"https://static.wikia.nocookie.net/yugioh/images/9/9b/YugiohOriginalManga-VOL08-JP.jpg/revision/latest?cb=20101121154030"],@[@"影之诗",@"https://upload.wikimedia.org/wikipedia/en/5/5e/Shadowverse.jpg"],@[@"皇室战争",@"https://i1.sndcdn.com/artworks-000254527034-8cgdw8-t500x500.jpg"],@[@"酒馆战棋",@"https://image.uc.cn/s/wemedia/s/upload/2021/f4f778e4518c41e19077c35c07543f5b.jpg"]] forKey:@"卡牌游戏"];
        
        [_dataDict setObject:@[@[@"弹丸论破",@"https://media.st.dl.eccdnx.com/steam/apps/567640/header.jpg?t=1715701301"],@[@"命运石之门",@"https://media.st.dl.eccdnx.com/steam/apps/412830/header_schinese.jpg?t=1715703398"],@[@"逆转裁判",@"https://media.st.dl.eccdnx.com/steam/apps/787480/header.jpg?t=1712623869"]] forKey:@"文字游戏"];
        
        [_dataDict setObject:@[@[@"CS2",@"https://media.st.dl.eccdnx.com/steam/apps/730/header_schinese.jpg?t=1698860631"],@[@"LOL",@"https://tse4-mm.cn.bing.net/th/id/OIP-C.KqZMdW2jG_q3__J0UCEP6gHaEK?w=302&h=180&c=7&r=0&o=5&dpr=2&pid=1.7"],@[@"Valorant",@"https://tse1-mm.cn.bing.net/th/id/OIP-C.GSnO2Eie9NtsS83kIh-67QHaEK?w=271&h=180&c=7&r=0&o=5&dpr=2&pid=1.7"],@[@"DOTA2",@"https://media.st.dl.eccdnx.com/steam/apps/570/header.jpg?t=1714502360"]] forKey:@"竞技游戏"];
        
        
    }
    return _dataDict;
}

@end
