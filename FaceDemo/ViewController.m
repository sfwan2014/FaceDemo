//
//  ViewController.m
//  FaceDemo
//
//  Created by sfwan on 15/12/10.
//  Copyright © 2015年 sfwan. All rights reserved.
//

#import "ViewController.h"
#import "EKFaceView.h"
#import "Utility.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    EKFaceView *face = [[EKFaceView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, [UIScreen mainScreen].bounds.size.width, 200)];
    [self.view addSubview:face];
    
    NSString *content = @"[微笑][微笑][微笑][微笑][微笑]哈哈[屎][微笑][龇牙][大哭][委屈]";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.numberOfLines = 0;
    float textMaxWidth = kWidth-40-kPadding *2-60;
    
    NSMutableAttributedString *attr = [Utility emotionStrWithString:content plistName:@"face.plist" y:-8];
    CGFloat height = [Utility heightOfCellWithMessage:content];
    label.frame = CGRectMake(0, 50, textMaxWidth, height);
    [self.view addSubview:label];
    
    label.attributedText = attr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
