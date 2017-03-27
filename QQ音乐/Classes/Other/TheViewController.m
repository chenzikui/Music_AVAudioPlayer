//
//  TheViewController.m
//  QQ音乐
//
//  Created by 陈自奎 on 17/3/23.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import "TheViewController.h"
#import "XMGPlayingViewController.h"

@interface TheViewController ()

@end

@implementation TheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gotoNext:(id)sender {
    
    //将我们的storyBoard实例化，“Main”为StoryBoard的名称
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MusicPlayerView" bundle:nil];
    
    //将第二个控制器实例化，"SecondViewController"为我们设置的控制器的ID
    XMGPlayingViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"XMGPlayingViewController"];
    
    //跳转事件
    [self presentViewController:secondViewController animated:YES completion:^{
        
    }];
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
