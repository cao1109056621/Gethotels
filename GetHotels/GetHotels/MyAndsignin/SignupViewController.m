//
//  SignupViewController.m
//  ActivityList
//
//  Created by admin1 on 2017/8/19.
//  Copyright © 2017年 self. All rights reserved.
//

#import "SignupViewController.h"
#import "UserModel.h"
@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *surepasswordTextField;
- (IBAction)registrationBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *shadowImageView;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setShadow];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setShadow {
    
    _shadowImageView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _shadowImageView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _shadowImageView.layer.shadowOpacity = 0.7f;//阴影透明度，默认0
    _shadowImageView.layer.shadowRadius = 4.f;//阴影半径，默认3
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registrationBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_usernameTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入您的手机号" andTitle:nil onView:self];
        return;
    }
    if (_passwordTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入密码" andTitle:nil onView:self];
        return;
    }
      if (_surepasswordTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请在确认密码输入框输入密码" andTitle:nil onView:self];
        return;
    }

    if (_surepasswordTextField.text != _passwordTextField.text ) {
        [Utilities popUpAlertViewWithMsg:@"请输入与密码输入框相同的密码" andTitle:nil onView:self];
        _surepasswordTextField.text = @"";
        return;
    }
    if (_passwordTextField.text.length < 6 || _passwordTextField.text.length > 18) {
        [Utilities popUpAlertViewWithMsg:@"您输入的密码必须在6—18位之间" andTitle:nil onView:self];
        return;
    }
    //判断某个字符串中是否每个字符都是数字
    if (_usernameTextField.text.length < 11 || [_usernameTextField.text rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet]invertedSet]].location != NSNotFound) {
        [Utilities popUpAlertViewWithMsg:@"您输入不小于11位的手机号码" andTitle:nil onView:self];
        return;
    }
    //无输入异常的情况
    [self readyForEncoding];
    
}
- (void)readyForEncoding{
    // 创建菊花膜
    _aiv = [Utilities getCoverOnView:self.view];
    //开始请求
    [RequestAPI requestURL:@"/register" withParameters:@{@"tel":_usernameTextField.text,@"pwd":_passwordTextField.text} andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        [_aiv stopAnimating];
        if([responseObject[@"result"] integerValue] == 1){
            [Utilities popUpAlertViewWithMsg:@"注册成功" andTitle:@"提示" onView:self];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"statusCode = %ld", (long)statusCode);
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}
//按键盘上的return健收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
