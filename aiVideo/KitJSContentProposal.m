//
//  ContentProposal.m
//  aiVideo
//
//  Created by asdsjw on 16/10/2.
//  Copyright © 2016年 asdsjw. All rights reserved.
//

#import "KitJSContentProposal.h"

@interface KitJSContentProposal ()

@end

@implementation KitJSContentProposal

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"标题:%@",self.title);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//原来的preferredFocusedView已经废弃
//打开窗口时候第一个焦点的视图
- (NSArray<id<UIFocusEnvironment>> *)preferredFocusEnvironments {
    
    return @[lastVideoBut];
}

// ----------
// | ----   |
// | |  |   |
// ----------
//一定要配置的,不然推送上去的视图无法操作
//设置的播放器的大小
- (CGRect)preferredPlayerViewFrame {
    return CGRectMake(0, 0, 1920, 800);
}

- (IBAction)lastVideoBut:(id)sender {
    [self dismissContentProposalForAction:AVContentProposalActionAccept animated:true completion:nil];
}

- (IBAction)returnToVideoBut:(id)sender {
    [self dismissContentProposalForAction:AVContentProposalActionDefer animated:true completion:nil];
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
