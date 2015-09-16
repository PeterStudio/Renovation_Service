//
//  MyInfoViewController.m
//  Renovation
//
//  Created by duwen on 15/6/3.
//  Copyright (c) 2015年 peterstudio. All rights reserved.
//

#import "MyInfoViewController.h"
#import "UserModel.h"

#import "UIImageView+WebCache.h"

@interface MyInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;

@property (strong, nonatomic) UserInfoModel * uModel;
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";
    // Do any additional setup after loading the view from its nib.
    self.uModel = [[UserInfoModel alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USERINFO] error:nil];
    _headIV.layer.masksToBounds = YES;
    _headIV.layer.cornerRadius = 25.0f;
    [_headIV sd_setImageWithURL:[NSURL URLWithString:self.uModel.headUrl] placeholderImage:[UIImage imageNamed:@"user_head02"]];
    _nameLab.text = self.uModel.name;
    _addressLab.text = self.uModel.address;

}


- (IBAction)sexButtonAction:(id)sender {
    UIButton * btn = sender;
    if (btn == _boyBtn) {
        _boyBtn.selected = YES;
        _girlBtn.selected = NO;
    }else{
        _boyBtn.selected = NO;
        _girlBtn.selected = YES;
    }
}

- (IBAction)tapView:(id)sender {
    [self.view endEditing:YES];
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
