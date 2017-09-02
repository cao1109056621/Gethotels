//
//  ViewController.m
//  Hotel
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewCell.h"
#import "UserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSArray *arr;
@property (weak, nonatomic) IBOutlet UIImageView *avatrImage;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _arr = @[@{@"everyImage":@"hotel",@"everyName":@"我的酒店"},@{@"everyImage":@"fly",@"everyName":@"我的航空"},@{@"everyImage":@"message",@"everyName":@"我的消息"},@{@"everyImage":@"setting",@"everyName":@"账户设置"},@{@"everyImage":@"agreement",@"everyName":@"使用协议"},@{@"everyImage":@"contact",@"everyName":@"联系客服"}];
    _myTableView.tableFooterView = [UIView new];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Utilities loginCheck]) {
        //已登陆
        _loginBtn.hidden = YES;
        _usernameLbl.hidden = NO;
        UserModel *user = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
        [_avatrImage sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon"]];
        _usernameLbl.text = user.nickname;
    }else{
        //未登陆
        _loginBtn.hidden = NO;
        _usernameLbl.hidden = YES;
        _avatrImage.image = [UIImage imageNamed:@"555"];
        _usernameLbl.text = @"未登陆";
    }
    
}

#pragma mark - table view
//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr.count;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotelcell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _arr[indexPath.section];
    cell.everyImage.image = [UIImage imageNamed:dict[@"everyImage"]];
    cell.everyName.text = dict[@"everyName"];
    return cell;
}

//设置细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ViewController *detailView = [[ViewController alloc]init];
//    [self.navigationController pushViewController:detailView animated:NO];
////    [tableView deselectRowAtIndexPath:indexPath animated:YES];
////    [self performSegueWithIdentifier:@"myInfoToSafety" send er:self];
//}
@end
