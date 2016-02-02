//
//  ViewController.m
//  AFNTool
//
//  Created by  www.6dao.cc on 16/1/31.
//  Copyright © 2016年 www.what-forever.com. All rights reserved.
//

#import "ViewController.h"
#import "AFNTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    http://121.196.233.59:8080/
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self testGetRequest];
//    [self testRequestSync];
//    [self testRequestInOrder];
//    [self testRequestInGroup];
}

// 按顺序执行任务  本例: 前3个一组, 中间5个一组, 最后2个一组
- (void)testRequestInGroup
{
    for (int i = 0; i < 10; i++) {
        [AFNTool addRequestWithHTTPMethod:@"GET" UrlString:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=218.4.255.255" params:@{} success:^(NSDictionary *success) {
            NSLog(@"success = %d", i);
        } failure:^(NSError *error) {
            NSLog(@"error = %d", i);
        }];
    }
    [AFNTool executeOperationsWithDependency:@"3", @"5", nil];
}

// 按顺序执行任务
- (void)testRequestInOrder
{
    for (int i = 0; i < 10; i++) {
        [AFNTool addRequestWithHTTPMethod:@"GET" UrlString:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=218.4.255.255" params:@{} success:^(NSDictionary *success) {
            NSLog(@"success = %d", i);
        } failure:^(NSError *error) {
            NSLog(@"error = %d", i);
        }];
    }
    [AFNTool executeOperationsInOrder];
}

// 测试同步请求
- (void)testRequestSync
{
    [AFNTool requestStyle:AFNToolRequestStyleGET];
    [AFNTool baseUrlString:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=218.4.255.255"];
    [AFNTool addRequestWithHTTPMethod:@"GET" UrlString:@"" params:@{} success:^(NSDictionary *success) {
        NSLog(@"success = %@", success);
    } failure:^(NSError *error) {
        
    }];
    
    [AFNTool executeSync];
    NSLog(@"abcdefg");
}

// 测简单的网络请求方式, 公共接口
- (void)testGetRequest
{
    //1, 获取单例对象
    AFNTool *afn = [AFNTool shareAFNTool];
    //2, 设置普通请求的请求方式
    [AFNTool requestStyle:AFNToolRequestStyleGET]; //如果是post请求, 请设置为post即可
    //3, 设置baseURL
    [AFNTool baseUrlString:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=218.4.255.255"];
    //4, 设置连接超时的时长, 超时时候处理  可以在AFNTool中处理
    [AFNTool setTimeoutInterval:10];
    
    [AFNTool requestWithUrlString:@"" params:nil success:^(NSDictionary *success) {
        NSLog(@"%@", success);
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    //取消所有的网络请求, 此方法对一般的请求有效, 但是对按顺序请求, 分组请求, 同步请求无效, 如需要这方面的功能, 欢迎交流.
//    [AFNTool cancleRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
