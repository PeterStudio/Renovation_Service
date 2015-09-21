//
//  PersionViewController.m
//  Renovation
//
//  Created by duwen on 15/5/22.
//  Copyright (c) 2015年 peterstudio. All rights reserved.
//

#import "PersionViewController.h"
#import "MoreViewController.h"
#import "MyAppointmentViewController.h"
#import "MyRepairViewController.h"
#import "NearWorkersViewController.h"
#import "MyInfoViewController.h"
#import "UserModel.h"
#import "UIButton+WebCache.h"
#import "ServiceAgreementViewController.h"

@interface PersionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *yifukuanLab;
@property (weak, nonatomic) IBOutlet UILabel *zaishigongLab;
@property (weak, nonatomic) IBOutlet UILabel *yiwangongLab;

@property (strong, nonatomic) UserInfoModel * uModel;
@end

@implementation PersionViewController

//- (void)viewDidAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
//}
//
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.uModel = [[UserInfoModel alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USERINFO] error:nil];
    _headBtn.layer.masksToBounds = YES;
    _headBtn.layer.cornerRadius = 25.0f;
    if ([self.uModel.headUrl isAbsolutePath]) {
        [_headBtn setImage:[UIImage imageWithContentsOfFile:self.uModel.headUrl] forState:UIControlStateNormal];
    }else{
        [_headBtn sd_setImageWithURL:[NSURL URLWithString:self.uModel.headUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_head02"]];
    }
    _nameLab.text = self.uModel.name;
    _addressLab.text = self.uModel.address;
    
}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"个人中心";
    
//    self.uModel = [[UserInfoModel alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USERINFO] error:nil];
//    _headBtn.layer.masksToBounds = YES;
//    _headBtn.layer.cornerRadius = 25.0f;
//    [_headBtn sd_setImageWithURL:[NSURL URLWithString:self.uModel.headUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_head02"]];
//    _nameLab.text = self.uModel.name;
//    _addressLab.text = self.uModel.address;
    _yifukuanLab.text = @"0笔";
    _zaishigongLab.text = @"0个";
    _yiwangongLab.text = @"0个";
    
    if (UIScreenHeight == 480) {
        _heightConstraint1.constant = _heightConstraint2.constant = 15;
    }
    // Do any additional setup after loading the view from its nib.
}



- (IBAction)persionInfoTouch:(id)sender {
    MyInfoViewController * vc = [[MyInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)myRepairButtonClick:(id)sender {
    MyRepairViewController * vc = [[MyRepairViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)AppointmentRecordButtonClick:(id)sender {
    MyAppointmentViewController * vc = [[MyAppointmentViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)myInformationButtonClick:(id)sender {
    MyInfoViewController * vc = [[MyInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)contractTermsButtonClick:(id)sender {
    ServiceAgreementViewController * vc = [[ServiceAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)nearWorkersButtonClick:(id)sender {
    NearWorkersViewController * vc = [[NearWorkersViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)moreButtonClick:(id)sender {
    MoreViewController * vc = [[MoreViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)callButtonClick:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000000878"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
