//
//  ViewController.m
//  Daxiami
//
//  Created by 田明甫 on 2017/7/3.
//  Copyright © 2017年 大虾咪. All rights reserved.
//

#import "ViewController.h"
#import "TmfCalendarView.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIImageView *imageView =[[UIImageView alloc]init];
    imageView.frame =  CGRectMake(0, 84, kScreenWidth, kScreenHeight-80);
    imageView.image = [UIImage imageNamed:@"lxx1"];
    [self.view addSubview:imageView];

    
    TmfCalendarView *calendarView = [[TmfCalendarView alloc] initWithFrame:self.view.bounds];
    calendarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:calendarView];
    
    
//    UIColor *taskColor = [UIColor colorWithRed:0.98f green:0.92f blue:0.80f alpha:1.0f];
//    UIButton *taskBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 150, 280, 160)];
//    taskBtn.backgroundColor = taskColor;
//    
//    CALayer *bottomBorder = [CALayer layer];
//    float height=taskBtn.frame.size.height-1.0f;
//    float width=taskBtn.frame.size.width;
//    bottomBorder.frame = CGRectMake(0.0f, height, width, 1.0f);
//    bottomBorder.backgroundColor = [UIColor redColor].CGColor;
//    [taskBtn.layer addSublayer:bottomBorder];
//    [self.view addSubview:taskBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end













