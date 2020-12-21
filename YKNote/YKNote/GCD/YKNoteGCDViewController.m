//
//  YKNoteGCDViewController.m
//  YKNote
//
//  Created by wanyakun on 2016/12/19.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteGCDViewController.h"
#import "YKNoteTimer.h"

@interface YKNoteGCDViewController ()

@property (nonatomic, strong) YKNoteTimer *yKNoteTimer;

@end

@implementation YKNoteGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"GCD";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    MyCreateTimer();
    
//    [self createTimer];
    
//    [self createYKNoteTimer];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 100, 50)];
    button.backgroundColor = UIColor.blueColor;
    [button setTitle:@"测试Barrier" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(testBarrier) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.yKNoteTimer invalidate];
}

#pragma mark - Test dispatch_barrier_async
- (void)testBarrier {
    dispatch_queue_t queue = dispatch_queue_create("YKNote-TestBarrier", DISPATCH_QUEUE_CONCURRENT);
    void(^blk)(void) =^{
        NSLog(@"task1 begin");
        sleep(2);
        NSLog(@"task1 end");
        NSLog(@"%p", [NSThread currentThread]);
    };
    dispatch_async(queue, blk);
    dispatch_async(queue, ^{
        NSLog(@"task2 bein");
        sleep(5);
        NSLog(@"task2 end");
        NSLog(@"%p", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"task3 begin");
        sleep(7);
        NSLog(@"task3 end");
        NSLog(@"%p", [NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier begin");
        sleep(1);
        NSLog(@"barrier end");
        NSLog(@"%p", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"task4 begin");
        sleep(2);
        NSLog(@"task4 end");
        NSLog(@"%p", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"task5 begin");
        sleep(5);
        NSLog(@"task5 end");
        NSLog(@"%p", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"task6 begin");
        sleep(7);
        NSLog(@"task6 end");
        NSLog(@"%p", [NSThread currentThread]);
    });

}

+ (void)testBarrierSync {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger i = 0; i < 10; i++) {
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"%zd",i);
        });
    }
    dispatch_barrier_sync(concurrentQueue, ^{
        NSLog(@"barrier");
    });
    NSLog(@"barrier after");
    for (NSInteger i = 10; i < 20; i++) {
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"%zd",i);
        });
    }
}

+ (void)testBarrierAsync {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger i = 0; i < 10; i++) {
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"%zd",i);
        });
    }
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@"barrier");
    });
    NSLog(@"barrier after");
    for (NSInteger i = 10; i < 20; i++) {
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"%zd",i);
        });
    }
}

+ (void)testAsyncBarrierSync {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger i = 0; i < 10; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"%zd",i);
        });
    }
    dispatch_barrier_sync(concurrentQueue, ^{
        NSLog(@"barrier");
    });
    NSLog(@"barrier after");
    for (NSInteger i = 10; i < 20; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"%zd",i);
        });
    }
}

+ (void)testAsyncBarrierAsync {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger i = 0; i < 10; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"%zd",i);
        });
    }
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@"barrier");
    });
    NSLog(@"barrier after");
    for (NSInteger i = 10; i < 20; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"%zd",i);
        });
    }
}

#pragma mark - Create YKNoteTimer
- (void)createYKNoteTimer {
    self.yKNoteTimer = [YKNoteTimer scheduledTimerWithTimeInterval:1 block:^{
        NSLog(@"YKNote action");
    } repeats:NO];
}


#pragma mark - Create A Timer
- (void)createTimer {
    __block int time = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            if (time == 0) {
                dispatch_source_cancel(timer);
            }
            NSLog(@"timer fired %d", time);
            time--;
        });
        dispatch_resume(timer);
    }
}


dispatch_source_t CreateDispatchTimer(uint64_t interval,
                                      uint64_t leeway,
                                      dispatch_queue_t queue,
                                      dispatch_block_t block) {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    
    return timer;
}

void MyCreateTimer() {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t aTimer = CreateDispatchTimer(1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC, queue, ^{
        NSLog(@"timer fired");
    });
    
    //store it somewhere for later use
    if (aTimer) {
        MyStoreTimer(aTimer);
    }
}

void MyPeriodicTask() {
    NSLog(@"timer fired");
}

void MyStoreTimer(dispatch_source_t aTimer) {
    
}

#pragma mark - Reading Data from a Descriptor

dispatch_source_t ProcessContentsOfFile(const char* fileName) {
    // Prepare the file for reading.
    int fd = open(fileName, O_RDONLY);
    if (fd == -1)
        return NULL;
    
    fcntl(fd, F_SETFL, O_NONBLOCK); // Avoid blocking the read operation
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t readSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, fd, 0, queue);
    
    if (!readSource) {
        close(fd);
        return NULL;
    }
    
    // Install the event handler
    dispatch_source_set_event_handler(readSource, ^{
        size_t estimated = dispatch_source_get_data(readSource) + 1;
        // Read the data into a text buffer.
        char *buffer = (char*)malloc(estimated);
        if (buffer) {
            ssize_t actual = read(fd, buffer, (estimated));
            Boolean done = MyProcessFileData(buffer, actual);
            
            // Release the buffer when done
            free(buffer);
            
            // If there is no more data, cancel the source.
            if (done) {
                dispatch_source_cancel(readSource);
            }
        }
    });
    
    // Install the cancellation handler
    dispatch_source_set_cancel_handler(readSource, ^{
        close(fd);
    });
    
    // Start reading the file.
    dispatch_resume(readSource);
    
    return readSource;
}

Boolean MyProcessFileData(char *buffer, size_t size) {
    return true;
}

#pragma mark - Writing Data to a Descriptor

dispatch_source_t WriteDataToFile(const char* fileName) {
    int fd = open(fileName, O_WRONLY | O_CREAT | O_TRUNC, (S_IRUSR | S_IWUSR | S_ISUID | S_ISGID));
    
    if (fd == -1)
        return NULL;
    
    fcntl(fd, F_SETFL);// Block during the write.
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t writeSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_WRITE, fd, 0, queue);
    
    if (!writeSource) {
        close(fd);
        return NULL;
    }
    
    dispatch_source_set_event_handler(writeSource, ^{
        size_t bufferSize = MyGetDataSize();
        void* buffer = malloc(bufferSize);
        
        size_t actual = MyGetData(buffer, bufferSize);
        
        write(fd, buffer, actual);
        
        free(buffer);
        
        // Cancel and release the dispatch source when done.
        dispatch_source_cancel(writeSource);
    });
    
    dispatch_source_set_cancel_handler(writeSource, ^{
        close(fd);
    });
    
    dispatch_resume(writeSource);
    
    return writeSource;
}

size_t MyGetDataSize() {
    //replace code
    return SIZE_MAX;
}

size_t MyGetData(void* buffer, size_t size) {
    //replace code
    return SIZE_MAX;
}

#pragma mark - Monitoring a File-System Object

dispatch_source_t MonitorNameChangesToFile(const char* fileName) {
    int fd = open(fileName, O_EVTONLY);
    if (fd == -1)
        return NULL;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fd, DISPATCH_VNODE_RENAME, queue);
    
    if (source) {
        // Copy the filename for later use.
        int length = strlen(fileName);
        char* newString = (char*)malloc(length + 1);
        newString = strcpy(newString, fileName);
        dispatch_set_context(source, newString);
        
        // Install the event handler to process the name change
        dispatch_source_set_event_handler(source, ^{
            const char* oldFilename = (char*)dispatch_get_context(source);
            MyUpdateFileName(oldFilename, fd);
        });
        
        // Install a cancellation handler to free the descriptor and the stored string.
        dispatch_source_set_cancel_handler(source, ^{
            char* fileStr = (char*)dispatch_get_context(source);
            free(fileStr);
            close(fd);
        });
        
        // Start processing events.
        dispatch_resume(source);
    } else
        close(fd);
    
    
    return source;
}

void MyUpdateFileName(const char* fileName, int fd) {
    //relpace code
}

#pragma mark - Monitoring Signals

void InstallSignalHandler() {
    // Make sure the signal does not terminate the application.
    signal(SIGHUP, SIG_IGN);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGHUP, 0, queue);
    
    if (source) {
        dispatch_source_set_event_handler(source, ^{
            MyProcessSIGHUP();
        });
        
        // Start processing signals
        dispatch_resume(source);
    }
}

void MyProcessSIGHUP() {
    //replace code
}

#pragma mark - Monitoring a Process

void MonitorParentProcess() {
    pid_t parentPID = getppid();
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC, parentPID, DISPATCH_PROC_EXIT, queue);
    
    if (source) {
        dispatch_source_set_event_handler(source, ^{
            MySetAppExitFlag();
            dispatch_source_cancel(source);
//            dispatch_release(source);
        });
        
        dispatch_resume(source);
    }
}

void MySetAppExitFlag() {
    //replace code
}

#pragma mark - Canceling a Dispatch Source

void RemoveDispatchSource(dispatch_source_t mySource) {
    dispatch_source_cancel(mySource);
//    dispatch_release(mySource); only ARC need
}

@end
