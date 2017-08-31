//
//  SigninViewController.m
//  ActivityList
//
//  Created by admin1 on 2017/8/19.
//  Copyright © 2017年 self. All rights reserved.
//

#import "SigninViewController.h"
#import "UserModel.h"
@interface SigninViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;
- (IBAction)signInAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *shadowImageView;

@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    [self uilayout];
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


- (void)naviConfig{
    //设置导航条标题文字
    //self.navigationItem.title = @"发布活动";
    //设置导航条的颜色（风格颜色）
    //self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(beckAction)];
    self.navigationItem.leftBarButtonItem = left;
}

//用Model的方式返回上一页
-(void)beckAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)uilayout{
    //判断是否存在记忆体
    if (![[Utilities  getUserDefaults:@"Username"] isKindOfClass:[NSNull class]]) {
        if ([Utilities  getUserDefaults:@"Username"] != nil) {
            //将它显示在用户名输入框中
            _usernameTextField.text = [Utilities getUserDefaults:@"Username"];
        }
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signInAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_usernameTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请 输入您的手机号" andTitle:nil onView:self];
        return;
    }
    if (_passwordTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入密码" andTitle:nil onView:self];
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
    /*NSString *urlstr=@"https://gethotels.fisheep.com.cn/login";
    NSDictionary *param=@{@"tel":_usernameTextField.text,@"pwd":_passwordTextField.text};
    AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manger POST:urlstr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        [_aiv stopAnimating];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        [_aiv stopAnimating];
    }];
  */
    //开始请求
    [RequestAPI requestURL:@"/login" withParameters:@{@"tel":_usernameTextField.text,@"pwd":_passwordTextField.text} andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        [_aiv stopAnimating];
           if ([responseObject[@"result"] integerValue] == 1) {
               NSDictionary *result = responseObject[@"content"];
               UserModel *user = [[UserModel alloc]initWithDictionary:result];
               //将登陆获取到的用户信息打包存储到单立化全局变量中
               [[StorageMgr singletonStorageMgr]addKey:@"MemberInfo" andValue:user];
               //单独将用户的ID也存储进单例化全局变量来作为用户是否已经登陆的判断依据，同时也方便其他所有页面更快捷的使用用户Id这个参数
               [[StorageMgr singletonStorageMgr] addKey:@"MemberId" andValue:user.memberId];
        //收起有可能没有收回去的键盘（如果键盘还打开着让它收回去）
        [self.view endEditing:YES];
        //清空密码输入框里的内容
        _passwordTextField.text = @"";
        //记忆用户名
        [Utilities setUserDefaults:@"Username" content:_usernameTextField.text];
        //用model的方式返回上一页
        [self dismissViewControllerAnimated:YES completion:nil];
           }else{
               NSString *orrorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
               [Utilities popUpAlertViewWithMsg:orrorMsg andTitle:nil onView:self];
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
