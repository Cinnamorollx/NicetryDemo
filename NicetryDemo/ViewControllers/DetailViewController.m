//
//  DetailViewController.m
//  NicetryDemo
//
//  Created by 刘宇航 on 2024/5/16.
//

#import "DetailViewController.h"
#import "Masonry.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _name;
    [self fetchImage];
}

- (void)viewWillAppear:(BOOL)animated {
   
}

- (void)fetchImage {
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_async(q, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSURL *url = [NSURL URLWithString: strongSelf.strURL];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *img = [UIImage imageWithData:imageData];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
            imgView.frame = self.view.frame;
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.userInteractionEnabled = YES;
            imgView.center = strongSelf.view.center;
            [strongSelf.view addSubview: imgView];
            UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:strongSelf action:@selector(handlePinch:)];
            [imgView addGestureRecognizer:pinch];
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:strongSelf action:@selector(handlePan:)];
            [imgView addGestureRecognizer:pan];
        });
    });
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    pinch.scale = 1.0; //每次都重置回1.0，否则会被累计越来越小
}

-(void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.view];
    pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self.view];
}

//- (instancetype)init {
//    NSLog(@"forbidden methods, use initWithData:");
//    return nil;
//}

//- initWithData: {
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
