//
//  ViewController.m
//  4.看视频
//
//  Created by apple on 2020/7/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ViewController.h"

#import "SeeVideosViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    SeeVideosViewController * seeVideosVC = [SeeVideosViewController new];
//    seeVideosVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:seeVideosVC animated:YES completion:nil];
    [self.navigationController pushViewController:seeVideosVC animated:YES];
}

@end
