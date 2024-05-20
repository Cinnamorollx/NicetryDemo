//
//  SceneDelegate.m
//  NicetryDemo
//
//  Created by 刘宇航 on 2024/5/15.
//

#import "SceneDelegate.h"
#import "ViewControllers/OrderViewController.h"
#import "ViewControllers/TodoViewController.h"
#import "ViewControllers/XHSViewController.h"
#import "ViewControllers/VideoFlowViewController.h"
@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    _window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    _window.backgroundColor = [UIColor whiteColor];
    
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    
    OrderViewController *ovc = [[OrderViewController alloc] init];
    ovc.tabBarItem.title = @"先点菜吧";
    ovc.tabBarItem.image = [UIImage imageNamed:@"shopping-cart"];
    
    TodoViewController *tdvc = [[TodoViewController alloc] init];
    tdvc.tabBarItem.title = @"ToDo List";
    tdvc.tabBarItem.image = [UIImage imageNamed:@"todo-list"];
    
    XHSViewController *xhs = [[XHSViewController alloc] init];
    xhs.tabBarItem.title = @"小红书";
    xhs.tabBarItem.image = [UIImage imageNamed:@"xhs"];
    
    VideoFlowViewController *vfvc = [[VideoFlowViewController alloc] init];
    vfvc.tabBarItem.title = @"视频流";
    vfvc.tabBarItem.image = [UIImage imageNamed:@"videos"];
    
    
    NSArray *controllers = @[ovc, tdvc, xhs, vfvc];
    NSMutableArray *navControllers = [NSMutableArray array];
    
    for (UIViewController *controller in controllers) {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        navController.tabBarItem = controller.tabBarItem;
        [navControllers addObject:navController];
    }
   
    tbc.viewControllers = navControllers;
    tbc.tabBar.translucent = YES;
    tbc.selectedIndex = 1;
    _window.rootViewController = tbc;
    [_window makeKeyAndVisible];
    
    
    
//    for (UIViewController *controller in controllers) {
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
//        [navControllers addObject:navController];
//    }
//    self.tabBarController.viewControllers = navControllers;
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
