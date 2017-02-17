//
//  YKNoteOperationViewController.m
//  YKNote
//
//  Created by wanyakun on 2016/11/30.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteOperationViewController.h"
#import "YKNoteNonConcurrentOperation.h"
#import "YKNoteConcurrentOperation.h"

@interface YKNoteOperationViewController ()

@end

@implementation YKNoteOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSOperation";
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
    //创建操作
    NSOperation *invocationOperation = [self createInvocationOperation];
    NSOperation *blockOperation = [self createBlockOperation];
    YKNoteNonConcurrentOperation *yKNoteNonConcurrentOperation = [[YKNoteNonConcurrentOperation alloc] initWithData:@"YKNoteNonConcurrentOperation data"];
    YKNoteConcurrentOperation *yKNoteConcurrentOperation = [[YKNoteConcurrentOperation alloc] init];
    //添加依赖关系
    [blockOperation addDependency:yKNoteConcurrentOperation];
    //手动执行
//    [invocationOperation start];
//    [blockOperation start];
//    [yKNoteNonConcurrentOperation start];
//    [yKNoteConcurrentOperation start];
    
//    [yKNoteConcurrentOperation cancel];
    //添加到队列中
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:invocationOperation];
    [operationQueue addOperation:blockOperation];
    [operationQueue addOperation:yKNoteNonConcurrentOperation];
    
//    NSOperationQueue *otherOperationQueue = [[NSOperationQueue alloc] init];
//    [otherOperationQueue addOperation:yKNoteConcurrentOperation];
    [yKNoteConcurrentOperation start];
    [yKNoteConcurrentOperation waitUntilFinished];
    
    NSLog(@"view did load finish!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


#pragma mark - private method
- (NSOperation *)createInvocationOperation {
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationTaskMethod) object:nil];
    BOOL isConcurrent = invocationOperation.concurrent;
    NSLog(@"invocation operation default concurrent:%d", isConcurrent);
    return invocationOperation;
}

- (void)invocationOperationTaskMethod {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSThread currentThread]);
}

- (NSOperation *)createBlockOperation {
    //块操作对象提交它所有的块到一个默认优先级的并发调度队列
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"add Execution block %s %@", __PRETTY_FUNCTION__, [NSThread currentThread]);
    }];
    return blockOperation;
}


@end
