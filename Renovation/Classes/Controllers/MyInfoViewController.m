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
#import "SVProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

#import "AppService.h"
#import "BaseModel.h"

@interface MyInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    NSString * sex;
    CGRect rect;
    NSString * headPath;
}
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;

@property (strong, nonatomic) UserInfoModel * uModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headTopLayoutConstraint;


@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";
    sex = @"0";
    rect = self.view.frame;
    self.uModel = [[UserInfoModel alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USERINFO] error:nil];
    _headIV.layer.masksToBounds = YES;
    _headIV.layer.cornerRadius = 25.0f;
    if ([self.uModel.headUrl isAbsolutePath]) {
        [_headIV setImage:[UIImage imageWithContentsOfFile:self.uModel.headUrl]];
    }else{
        [_headIV sd_setImageWithURL:[NSURL URLWithString:self.uModel.headUrl] placeholderImage:[UIImage imageNamed:@"user_head02"]];
    }
    _phoneLab.text = self.uModel.tel;
    _nameLab.text = self.uModel.name;
    _addressLab.text = self.uModel.address;

    
    UIBarButtonItem * bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = bar;
}


- (void)submit{
    if (!headPath) {
        [SVProgressHUD showErrorWithStatus:@"请上传头像"];
        return;
    }
    
    if (_nameTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    self.uModel.name = _nameTF.text;
    
    if (_addressTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入地址"];
        return;
    }
    self.uModel.address = _addressLab.text;
    [SVProgressHUD showWithStatus:@"保存中" maskType:SVProgressHUDMaskTypeClear];
    [[AppService sharedManager] request_modifyInfo_Http_userId:self.uModel.userId name:_nameTF.text address:_addressTF.text sex:sex file:headPath success:^(id responseObject) {
        BaseModel * baseModel = responseObject;
        if ([RETURN_CODE_SUCCESS isEqualToString:baseModel.retcode]) {
            [SVProgressHUD showSuccessWithStatus:baseModel.retinfo];
            [[NSUserDefaults standardUserDefaults] setObject:[self.uModel toDictionary] forKey:USERINFO];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:baseModel.retinfo];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
    }];
    
}

- (IBAction)sexButtonAction:(id)sender {
    UIButton * btn = sender;
    if (btn == _boyBtn) {
        sex = @"0";
        _boyBtn.selected = YES;
        _girlBtn.selected = NO;
    }else{
        sex = @"1";
        _boyBtn.selected = NO;
        _girlBtn.selected = YES;
    }
}

- (IBAction)phoneTouch:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000000878"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (IBAction)tapView:(id)sender {
    [self.view endEditing:YES];
//    self.view.frame = CGRectMake(rect.origin.x, rect.origin.y + 64, rect.size.width, rect.size.height);
    _topLayoutConstraint.constant = 0;
    _headTopLayoutConstraint.constant = 25;
}

- (IBAction)headImgTap:(id)sender {
    [self tapView:nil];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"相机拍摄",@"相册库", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    self.view.frame = CGRectMake(rect.origin.x, rect.origin.y - 100, rect.size.width, rect.size.height);
    _topLayoutConstraint.constant = -120;
    _headTopLayoutConstraint.constant = 25 - 120;
    [self.view layoutIfNeeded];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self tapView:nil];
    return YES;
}


/**
 *  获取图片缓存的完整路径
 *
 *  @param file 文件名称
 *
 *  @return 图片完整路径
 */
- (NSString *)dataPath:(NSString *)file
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:USERIMAGEVIEWFILES];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddhhmmss";
    NSString *oldTime = [dateFormatter stringFromDate:now];
    
    NSString *result = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.jpg",file,oldTime]];
    return result;
}

/**
 *  图片方向纠正
 *
 *  @param srcImg 原图片
 *
 *  @return 纠正后的图片
 */
- (UIImage *)fixOrientation:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp)
        return srcImg;
    
    NSLog(@"fix image orientaion");
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



/**
 *  添加本地相册隐私检查提示
 *
 *  @param str 提示内容
 */
- (void)addAlertViewWithInfo:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
        {
            [self addAlertViewWithInfo:[NSString stringWithFormat:@"请在iPhone的“设置-隐私-照片”选项中，允许%@访问你的手机相册",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]]];
            return;
        }
    }
    
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        //先设定sourceType为相机，然后判断相机是否可用，不可用将sourceType设定为相片库
        sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (buttonIndex == 1){
        //相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
}



#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIImage *image = [self fixOrientation:[info objectForKey:UIImagePickerControllerEditedImage]];
    [_headIV setImage:image];
    NSData * imageData = UIImageJPEGRepresentation(image, 1.0);
    self.uModel.headUrl = headPath= [self dataPath:@"head"];
    [imageData writeToFile:headPath atomically:YES];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    // Handle the end of the image write process
    if (error){
        [SVProgressHUD showErrorWithStatus:@"照片存入本地错误，请重试"];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
