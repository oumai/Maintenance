//
//  KMMAboutUsController.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMAboutUsController.h"
#import "KMMAoutUsView.h"
@interface KMMAboutUsController ()

@end

@implementation KMMAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    KMMAoutUsView *aboutUsView = [[[NSBundle mainBundle] loadNibNamed:@"KMMAoutUsView" owner:nil options:nil] lastObject];
    aboutUsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    aboutUsView.backgroundColor = BASE_BACKGROUND_COLOR;
    [self.view addSubview:aboutUsView];
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
