//
//  ViewController.m
//  KVODemo
//
//  Created by 郭凯 on 2016/11/29.
//  Copyright © 2016年 guokai. All rights reserved.
//

#import "ViewController.h"
#import "MyKVO.h"
#import "ChatViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) MyKVO *myKVO;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myKVO = [[MyKVO alloc] init];
    [self.myKVO addObserver:self forKeyPath:@"num" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"num"] && object == self.myKVO) {
        self.label.text = [NSString stringWithFormat:@"当前的num值为：%@",[change valueForKey:@"new"]];
    }
}

- (IBAction)changeNum:(id)sender {
    
    self.myKVO.num = self.myKVO.num + 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self removeObserver:self forKeyPath:@"num" context:nil];
}

- (IBAction)pushVC:(id)sender {
    ChatViewController *chat = [[ChatViewController alloc] init];
    
    [self.navigationController pushViewController:chat animated:YES];
}


@end
