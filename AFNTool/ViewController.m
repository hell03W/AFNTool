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
    // Do any additional setup after loading the view, typically from a nib.
    [AFNTool baseUrlString:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=218.4.255.255"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self testGetRequest];
}

// get请求
- (void)testGetRequest
{
    [AFNTool requestStyle:AFNToolRequestStyleGET];
    
    [AFNTool requestWithUrlString:@"" params:nil success:^(NSDictionary *success) {
        NSLog(@"%@", success);
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
