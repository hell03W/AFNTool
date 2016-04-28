# AFNTool

***
###前言
最近做的项目中, 网络请求多了一点, 项目中也用到了各种类型的网络请求, 我们项目中使用的是AFNetWorking网络请求框架, 使用时候发现, 这个框架并没有给出比如: 多个网络请求相互依赖按照一定顺序执行, 多个任务分组执行, 同步执行, 于是自己通过查看AFN源码, 自己对这个网络框架进行了二次开发, 新添加了一些新的方法.

**如有任何疑问和建议, 欢迎交流 !**

###新功能
1. 更`简单`的使用网络请求
	* 不需要再每次都创建对象, 设置request格式和response格式, 设置请求方式, 程序中只需要设置一次, 在整个程序运行时都有效.
2. 按照添加任务的顺序, `依次执行`
3. 添加`n`个任务, `分组执行`
4. `同步`执行任务

### AFNTool解读
AFNTool工具类继承自`AFHTTPRequestOperationManager`, 因此AFHTTPRequestOperationManager中的方法通过AFNTool的对象也是可以调用了, 如果你必须使用AFHTTPRequestOperationManager才能解决的问题, 也可以直接使用AFNTool的对象调用AFHTTPRequestOperationManager的方法.

AFNTool有几个基本的请求设置方法.如下所示:

```Objective-C
//单例对象
+ (AFNTool *)shareAFNTool;

// 设置网络请求方式
+ (void)requestStyle:(AFNToolRequestStyle)requestStyle;  //默认 POST

//设置baseUrlString
+ (void)baseUrlString:(NSString *)baseUrlString;

//设置超时时间
+ (void)setTimeoutInterval:(NSInteger)second;
```

AFNTool中包含一个 `static NSString *baseUrl = @""; // 设置baseUrl` , 可以在这里设置一个baseURL, 如果其他如要更换ip, 直接在这里更换一次即可.

### AFNTool使用示例
**1, 基本设置和使用方法**

```Objective-C
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
```

**2, 按顺序执行任务**

```Objective-C
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

```

**3, 按照分组执行任务**

```Objective-C
// 按分组执行任务  本例: 前3个一组, 中间5个一组, 最后2个一组
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
```

**4, 同步执行任务**

```Objective-C
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
```


### 补充
iOS9以后使用http请求需要在plist中增加允许

```
<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
</dict>
```