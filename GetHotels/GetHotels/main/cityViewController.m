//
//  cityViewController.m
//  HotelReservation
//
//  Created by admin1 on 2017/8/26.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "cityViewController.h"
#import "cityModel.h"
@interface cityViewController (){
    NSInteger page;
    NSInteger totalPage;
}
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (strong,nonatomic) NSMutableArray *arr;
@end

@implementation cityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    [self networkRequest];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)naviConfig{
    //设置导航条标题文字
    //self.navigationItem.title = @"发布活动";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
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

//执行网络请求
- (void)networkRequest{
    //设置接口地址
    NSString *request = @"/findCity";
    //设置接口入参
    NSDictionary *parameter = @{@"id":@(page)};
    //开始请求
    [RequestAPI requestURL:request withParameters:parameter andHeader:nil byMethod:kGet andSerializer:kJson success:^(id responseObject) {
        //成功以后要做的事情在此处执行
        NSLog(@"responseObject = %@",responseObject);
        
        
        if ([responseObject[@"result"] integerValue] == 1){
            //业务逻辑成功的情况下
            NSDictionary *result = responseObject[@"content"];
            NSArray *models = result[@"hotCity"];
            NSDictionary *pagingInfo = result[@"pagingInfo"];
            totalPage = [pagingInfo[@"totalPage"]integerValue];
            
            for (NSDictionary *dict in models) {
                //用ActivityModel类中定义的初始化方法nitWithDictionary:将便利的来的字典转换成为ActivityModel 对象
                cityModel *activityModel = [[cityModel alloc]initWithDictionary:dict];
                //将上述实例化好的activityModel对象插入——arr数组中
                [_arr addObject:activityModel];
            }
            //刷新表格
            [_cityTableView reloadData];
            
        }else{
            //业务逻辑失败的情况下
            NSString *orrorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:orrorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情在此处执行
        NSLog(@"statusCode = %ld",(long)statusCode);
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
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
