//
//  KMMWebUploadController.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMWebUploadController.h"

#import "KMMWebIntroduceView.h"


@interface KMMWebUploadController ()

@property (nonatomic,strong) KMMWebIntroduceView *introduceView;

@end

@implementation KMMWebUploadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"网站传课";
    
    self.introduceView = [[[NSBundle mainBundle] loadNibNamed:@"KMMWebIntroduceView" owner:nil options:nil] lastObject];
    
    self.introduceView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.introduceView];
    
    UIButton *customBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10.5, 20)];
    [customBtn setImage:[UIImage imageNamed:@"icon-fh"] forState:UIControlStateNormal];
    
    WEAK_SELF(self);
    [customBtn bk_whenTapped:^{
        STRONG_SELF(self);
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    
    
}

@end
