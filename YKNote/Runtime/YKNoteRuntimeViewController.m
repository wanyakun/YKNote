//
//  YKNoteRuntimeViewController.m
//  YKNote
//
//  Created by wanyakun on 2016/12/21.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteRuntimeViewController.h"
#import "YKNoteRuntimeObject.h"
#import <objc/runtime.h>

@interface YKNoteRuntimeViewController ()

@end

@implementation YKNoteRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Runtime";
    self.view.backgroundColor = [UIColor whiteColor];
    //Test Object Class
    [self testObjectClass];
    //Test Method Invoke
    [self testMethodInvoke];
    //Test Meta Class
    [self exeRegisterClassPair];
    //Test common method
    [self testCommonMethod];
    //Test associat object
    [self setTapActonWithBlock:^{
        NSLog(@"Test associat object");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


#pragma mark - Test Object Class
- (void)testObjectClass {
    id obj1 = [NSMutableArray alloc];
    id obj2 = [[NSMutableArray alloc] init];
    
    id obj3 = [NSArray alloc];
    id obj4 = [[NSArray alloc] init];
    
    id obj5 = [YKNoteRuntimeObject alloc];
    id obj6 = [[YKNoteRuntimeObject alloc] init];
    
    NSLog(@"obj1 class is %@", NSStringFromClass([obj1 class]));
    NSLog(@"obj2 class is %@", NSStringFromClass([obj2 class]));
    NSLog(@"obj3 class is %@", NSStringFromClass([obj3 class]));
    NSLog(@"obj4 class is %@", NSStringFromClass([obj4 class]));
    NSLog(@"obj5 class is %@", NSStringFromClass([obj5 class]));
    NSLog(@"obj6 class is %@", NSStringFromClass([obj6 class]));
}

#pragma mark - Test Method Invoke
- (void)testMethodInvoke {
    int (* computeNum)(id, SEL, int);
    computeNum = (int (*) (id, SEL, int))[self methodForSelector:@selector(testComputeWithNum:)];
    computeNum(self, @selector(testComputeWithNum:), 10);
}

- (void)testComputeWithNum:(NSInteger)num {
    NSLog(@"%ld", num);
}

#pragma mark - Test Meta Class
void TestMetaClass(id self, SEL _cmd) {
    NSLog(@"This object is %p", self);
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times give %p", i, currentClass);
        currentClass = object_getClass(currentClass);
    }
    
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
}

- (void)exeRegisterClassPair {
    Class YKNoteError = objc_getClass("YKNoteError");
    if (YKNoteError == nil) {
        YKNoteError = objc_allocateClassPair([NSError class], "YKNoteError", 0);
        class_addMethod(YKNoteError, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
        objc_registerClassPair(YKNoteError);
    }
    
    
    id yKNoteError = [[YKNoteError alloc] initWithDomain:@"YKNoteDomain" code:0 userInfo:nil];
    [yKNoteError performSelector:@selector(testMetaClass)];
}

#pragma mark - Common method
- (void)testCommonMethod {
    YKNoteRuntimeObject *object = [[YKNoteRuntimeObject alloc] init];
    unsigned int outCount = 0;
    
    Class cls = object.class;
    
    //类名
    NSLog(@"class name is %s address: %p", class_getName(cls), cls);
    NSLog(@"==========================================");
    
    //父类
    NSLog(@"super class name is %s address: %p", class_getName(class_getSuperclass(cls)), class_getSuperclass(cls));
    NSLog(@"==========================================");

    //是否是元类
    NSLog(@"YKNoteRuntimeObject is%@ meta-class", class_isMetaClass(cls) ? @"" : @" not");
    NSLog(@"==========================================");

    Class metaClass = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s", class_getName(cls), class_getName(metaClass));
    
    //实例变量大小
    NSLog(@"instance size:%zu", class_getInstanceSize(cls));
    NSLog(@"==========================================");

    //成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name: %s at index: %d, address:%p offset: %lu, space: %lu, typeEncoding:%s", ivar_getName(ivar), i, ivar, ivar_getOffset(ivar), sizeof(ivar), ivar_getTypeEncoding(ivar));
    }
    
    free(ivars);
    
    Ivar string = class_getInstanceVariable(cls, "_string");
    if (string != NULL) {
        NSLog(@"instance variable %s", ivar_getName(string));
    }
    NSLog(@"==========================================");

    //属性操作
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *attribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        NSLog(@"property's name: %s, attribute: %@", property_getName(property), attribute);
    }
    
    free(properties);
    
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s", property_getName(array));
    }
    NSLog(@"==========================================");

    //方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %s, SEL:%p, IMP:%p", sel_getName(method_getName(method)), method_getName(method), method_getImplementation(method));

    }
    
    free(methods);
    
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s", sel_getName(method_getName(method1)));
    }
    
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method %s", sel_getName(method_getName(classMethod)));
    }
    
    NSLog(@"YKNoteRuntimeObject is%@ response to selector: method3WithArg1:arg2:", class_respondsToSelector(cls, NSSelectorFromString(@"method3WithArg1:arg2:")) ? @"" :@" not");
    
    IMP imp = class_getMethodImplementation(cls, @selector(method2));
    imp();
    NSLog(@"==========================================");
    
    //协议操作
    Protocol * __unsafe_unretained *protocols = class_copyProtocolList(cls, &outCount);
    Protocol *protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    NSLog(@"YKNoteRuntimeObject is%@ respose to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    NSLog(@"==========================================");

}

#pragma mark - associate object
static char kYKNoteActionHandlerTapGestureKey;
static char kYKNoteActionHandlerTapBlockKey;
- (void)setTapActonWithBlock:(void(^)(void))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self.view, &kYKNoteActionHandlerTapGestureKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self.view addGestureRecognizer:gesture];
        objc_setAssociatedObject(self.view, &kYKNoteActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self.view, &kYKNoteActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self.view, &kYKNoteActionHandlerTapBlockKey);
        if (action) {
            action();
        }
    }
}

@end
