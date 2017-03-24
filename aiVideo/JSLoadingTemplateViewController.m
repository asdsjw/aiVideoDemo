//
//  LoadingTemplateControllerElementViewController.m
//  aiVideo
//
//  Created by asdsjw on 16/8/25.
//  Copyright © 2016年 asdsjw. All rights reserved.
//

#import "JSLoadingTemplateViewController.h"

@interface JSLoadingTemplateViewController ()

@end

@implementation JSLoadingTemplateViewController
@synthesize titleLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"UIActivityIndicatorView");
    BOOL ModeBool = _nightBool;
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    //关闭自动排版
    label.translatesAutoresizingMaskIntoConstraints = false;
    label.text = titleLabel;
    //标题透明色
    if(ModeBool)
    {
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    }else {
        label.textColor = [UIColor colorWithWhite:0.0 alpha:0.55];
    }
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    //标题横向居中
    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0].active = YES;
    
    UIActivityIndicatorView *loadIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if(ModeBool)
    {
        loadIndicatorView.color = [UIColor colorWithWhite:1.0 alpha:0.6];
    }else {
        loadIndicatorView.color = [UIColor colorWithWhite:0.0 alpha:0.55];
    }
    loadIndicatorView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:loadIndicatorView];
    //活动指示在标题top位置,加上自身高度,constant正数往下
    [loadIndicatorView.topAnchor constraintEqualToAnchor:label.topAnchor constant:loadIndicatorView.bounds.size.height].active = true;
    
    [NSLayoutConstraint constraintWithItem:loadIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0].active = YES;
    //活动指示纵向居中,减去自身高度,constant负数往上
    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-loadIndicatorView.bounds.size.height].active = YES;
    //高效延时方式,NSEC_PER_SEC代码1秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [loadIndicatorView startAnimating];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
