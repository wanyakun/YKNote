//
//  YKNoteBlockDemo.m
//  YKNoteDemo
//
//  Created by wanyakun on 2016/11/3.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKNoteBlockNoteObject.h"

/**
 *  Block实体形式如下：^(传入参数列){行为主体};
 */
void block1() {
    int result = ^(int a){
        return a*a;
    } (5);
    NSLog(@"block1 -> %d", result);
}

/**
 *  Block Pointer是这样定义的：回传值(^名字)(参数列);
 */
void block2() {
    int (^block)(int);
    block = ^(int a){
        return a*a;
    };
    int result = block(6);
    NSLog(@"block2 -> %d", result);
}

/**
 *  Block里面可以读取同一类型的outA的值，result is 11
 */
void block3() {
    int outA = 8;
    int (^block)(int) = ^(int a) {
        return outA + a;
    };
    int result = block(3);
    NSLog(@"block3 -> result = %d", result);
}

/**
 *   调用过程void block4, 其中第二句调用__block4_block_impl_0构造函数初始化结构体：__block4_block_impl_0((void *)__block4_block_func_0, &__block4_block_desc_0_DATA, outA)得到__block4_block_impl_0类型变量赋值给block，然后执行block->FuncPtr。事实上，使用clang编译后得到的C代码，发现结构体函数使用_outA初始化结构体中的outA变量，然后再改变outA的值，在真正调用FuncPtr的时候是使用结构体中的outA的值，所以改变outA的值，result仍是11
 struct __block4_block_impl_0 {
 struct __block_impl impl;
 struct __block4_block_desc_0* Desc;
 int outA;
 __block4_block_impl_0(void *fp, struct __block4_block_desc_0 *desc, int _outA, int flags=0) : outA(_outA) {
 impl.isa = &_NSConcreteStackBlock;
 impl.Flags = flags;
 impl.FuncPtr = fp;
 Desc = desc;
 }
 };
 static int __block4_block_func_0(struct __block4_block_impl_0 *__cself, int a) {
 int outA = __cself->outA; // bound by copy
 
 return outA + a;
 }
 
 static struct __block4_block_desc_0 {
 size_t reserved;
 size_t Block_size;
 } __block4_block_desc_0_DATA = { 0, sizeof(struct __block4_block_impl_0)};
 void block4() {
 int outA = 8;
 int (*block)(int) = ((int (*)(int))&__block4_block_impl_0((void *)__block4_block_func_0, &__block4_block_desc_0_DATA, outA));
 outA = 5;
 int result = ((int (*)(__block_impl *, int))((__block_impl *)block)->FuncPtr)((__block_impl *)block, 3);
 NSLog((NSString *)&__NSConstantStringImpl__var_folders_0y_zzzq899s2js3g0f8d71jvbnm0000gp_T_main_2d0f53_mi_3, result);
 }
 */
void block4() {
    int outA = 8;
    int (^block)(int) = ^(int a) {
        return outA + a;
    };
    outA = 5;
    int result = block(3);
    NSLog(@"block4 -> result = %d", result);
}



/**
 *  block主体中用到的变量如果是个指针，它的值在block中是可以被改变的， mutableArray在block中被更改，变为{@"one", @"two"}, clang中代码发现是指针传递，保存到结构体中的mutableArray
 struct __block5_block_impl_0 {
 struct __block_impl impl;
 struct __block5_block_desc_0* Desc;
 NSMutableArray *mutableArray;
 __block5_block_impl_0(void *fp, struct __block5_block_desc_0 *desc, NSMutableArray *_mutableArray, int flags=0) : mutableArray(_mutableArray) {
 impl.isa = &_NSConcreteStackBlock;
 impl.Flags = flags;
 impl.FuncPtr = fp;
 Desc = desc;
 }
 };
 static void __block5_block_func_0(struct __block5_block_impl_0 *__cself) {
 NSMutableArray *mutableArray = __cself->mutableArray; // bound by copy
 
 ((void (*)(id, SEL))(void *)objc_msgSend)((id)mutableArray, sel_registerName("removeLastObject"));
 }
 static void __block5_block_copy_0(struct __block5_block_impl_0*dst, struct __block5_block_impl_0*src) {_Block_object_assign((void*)&dst->mutableArray, (void*)src->mutableArray, 3);}
 
 static void __block5_block_dispose_0(struct __block5_block_impl_0*src) {_Block_object_dispose((void*)src->mutableArray, 3);}
 
 static struct __block5_block_desc_0 {
 size_t reserved;
 size_t Block_size;
 void (*copy)(struct __block5_block_impl_0*, struct __block5_block_impl_0*);
 void (*dispose)(struct __block5_block_impl_0*);
 } __block5_block_desc_0_DATA = { 0, sizeof(struct __block5_block_impl_0), __block5_block_copy_0, __block5_block_dispose_0};
 void block5() {
 NSMutableArray *mutableArray = ((NSMutableArray *(*)(id, SEL, ObjectType, ...))(void *)objc_msgSend)((id)objc_getClass("NSMutableArray"), sel_registerName("arrayWithObjects:"), (id)(NSString *)&__NSConstantStringImpl__var_folders_0y_zzzq899s2js3g0f8d71jvbnm0000gp_T_main_2d0f53_mi_4, (NSString *)&__NSConstantStringImpl__var_folders_0y_zzzq899s2js3g0f8d71jvbnm0000gp_T_main_2d0f53_mi_5, (NSString *)&__NSConstantStringImpl__var_folders_0y_zzzq899s2js3g0f8d71jvbnm0000gp_T_main_2d0f53_mi_6, __null);
 void (*block)() = ((void (*)())&__block5_block_impl_0((void *)__block5_block_func_0, &__block5_block_desc_0_DATA, mutableArray, 570425344));
 ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
 NSLog((NSString *)&__NSConstantStringImpl__var_folders_0y_zzzq899s2js3g0f8d71jvbnm0000gp_T_main_2d0f53_mi_7, mutableArray);
 }
 */
void block5() {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithObjects:@"one", @"two", @"three", nil];
    void (^block)() = ^() {
        [mutableArray removeLastObject];
    };
    block();
    NSLog(@"block5 -> array:%@", mutableArray);
}

/**
 *  直接存取static类型的变量，甚至可以直接在block里面修改outA的值，clang中发现是使用outA指针引用，保存到结构体中的outA指针，在__block6_block_func_0中也是使用的指针，所以能够改变outA的值
 struct __block6_block_impl_0 {
 struct __block_impl impl;
 struct __block6_block_desc_0* Desc;
 int *outA;
 __block6_block_impl_0(void *fp, struct __block6_block_desc_0 *desc, int *_outA, int flags=0) : outA(_outA) {
 impl.isa = &_NSConcreteStackBlock;
 impl.Flags = flags;
 impl.FuncPtr = fp;
 Desc = desc;
 }
 };
 static int __block6_block_func_0(struct __block6_block_impl_0 *__cself, int a) {
 int *outA = __cself->outA; // bound by copy
 
 (*outA)++;
 return (*outA) + a;
 }
 
 static struct __block6_block_desc_0 {
 size_t reserved;
 size_t Block_size;
 } __block6_block_desc_0_DATA = { 0, sizeof(struct __block6_block_impl_0)};
 void block6() {
 static int outA = 8;
 int (*block)(int) = ((int (*)(int))&__block6_block_impl_0((void *)__block6_block_func_0, &__block6_block_desc_0_DATA, &outA));
 outA = 5;
 int result = ((int (*)(__block_impl *, int))((__block_impl *)block)->FuncPtr)((__block_impl *)block, 3);
 NSLog((NSString *)&__NSConstantStringImpl__var_folders_0y_zzzq899s2js3g0f8d71jvbnm0000gp_T_main_2d0f53_mi_8, result);
 
 }
 */
void block6() {
    static int outA = 8;
    int (^block)(int) = ^(int a) {
        outA++;
        return outA + a;
    };
    outA = 5;
    int result = block(3);
    NSLog(@"block6 -> result = %d", result);
    
}

/**
 *  在某个变量前面如果加上修饰字__block的话，这个变量就称作block variable，那么多在block里面就可以任意修改此变量的值，clang编译后的代码可以看出，outA会被封装为__Block_byref_outA_0结构体，并通过指针引用传递到block结构体内部
 struct __Block_byref_outA_0 {
 void *__isa;
 __Block_byref_outA_0 *__forwarding;
 int __flags;
 int __size;
 int outA;
 };
 
 struct __block7_block_impl_0 {
 struct __block_impl impl;
 struct __block7_block_desc_0* Desc;
 __Block_byref_outA_0 *outA; // by ref
 __block7_block_impl_0(void *fp, struct __block7_block_desc_0 *desc, __Block_byref_outA_0 *_outA, int flags=0) : outA(_outA->__forwarding) {
 impl.isa = &_NSConcreteStackBlock;
 impl.Flags = flags;
 impl.FuncPtr = fp;
 Desc = desc;
 }
 };
 static int __block7_block_func_0(struct __block7_block_impl_0 *__cself, int a) {
 __Block_byref_outA_0 *outA = __cself->outA; // bound by ref
 
 (outA->__forwarding->outA)++;
 return (outA->__forwarding->outA) + a;
 }
 static void __block7_block_copy_0(struct __block7_block_impl_0*dst, struct __block7_block_impl_0*src) {_Block_object_assign((void*)&dst->outA, (void*)src->outA, 8);}
 
 static void __block7_block_dispose_0(struct __block7_block_impl_0*src) {_Block_object_dispose((void*)src->outA, 8);}
 
 static struct __block7_block_desc_0 {
 size_t reserved;
 size_t Block_size;
 void (*copy)(struct __block7_block_impl_0*, struct __block7_block_impl_0*);
 void (*dispose)(struct __block7_block_impl_0*);
 } __block7_block_desc_0_DATA = { 0, sizeof(struct __block7_block_impl_0), __block7_block_copy_0, __block7_block_dispose_0};
 void block7() {
 __attribute__((__blocks__(byref))) __Block_byref_outA_0 outA = {(void*)0,(__Block_byref_outA_0 *)&outA, 0, sizeof(__Block_byref_outA_0), 8};
 int (*block)(int) = ((int (*)(int))&__block7_block_impl_0((void *)__block7_block_func_0, &__block7_block_desc_0_DATA, (__Block_byref_outA_0 *)&outA, 570425344));
 int result = ((int (*)(__block_impl *, int))((__block_impl *)block)->FuncPtr)((__block_impl *)block, 3);
 NSLog((NSString *)&__NSConstantStringImpl__var_folders_0y_zzzq899s2js3g0f8d71jvbnm0000gp_T_main_2d0f53_mi_9, result);
 }
 */
void block7() {
    __block int outA = 8;
    int (^block)(int) = ^(int a) {
        outA++;
        return outA + a;
    };
    int result = block(3);
    NSLog(@"block7 -> result = %d", result);
}

void block8() {
    __block NSMutableArray *mutableArray = [NSMutableArray arrayWithObjects:@"one", @"two", @"three", nil];
    void (^block)() = ^() {
        [mutableArray removeLastObject];
    };
    block();
    NSLog(@"block8 -> array:%@", mutableArray);
}

void block9() {
    __block int val = 0;
    void (^blk)(void)= ^{
        ++val;
    };
    ++val;
    blk();
    NSLog(@"%d", val);
}

//typedef void(^blk_t)(id obj);
//blk_t blk;
//
//void captureObject() {
//    id array = [[NSMutableArray alloc] init];
//    blk = ^(id obj) {
//        [array addObject:obj];
//        NSLog(@"array count = %ld", [array count]);
//    };
//}
//
//
//void block10() {
//    captureObject();
//
//    blk([[NSObject alloc] init]);
//    blk([[NSObject alloc] init]);
//    blk([[NSObject alloc] init]);
//}


typedef void (^eBlock)();
eBlock exampleE_getBlock() {
    char e = 'E';
    void (^block)() = ^{
        printf("%c\n", e);
    };
    return block;
}

void exampleE() {
    eBlock block = exampleE_getBlock();
    block();
}

void memory1() {
    NSMutableString *str = [@"string1" mutableCopy];
    NSMutableString *str2 = [str mutableCopy];
    [str appendString:@"__str"];
    [str appendString:@"__str2"];
    
    NSLog(@"str1:%@    str2:%@", str, str2);
    NSLog(@"str1:%p    str2:%p", str, str2);
    
}

//int main(int argc, const char * argv[]) {
//    @autoreleasepool {
//        // insert code here...
//        NSLog(@"Hello, World!");
//
//        //        block1();
//        //        block2();
//        //        block3();
//        //        block4();
//        //        block5();
//        //        block6();
//        //        block7();
//        //        block8();
//        //        block9();
//        //        block10();
//        //        exampleE();
//        //
//        id blockNoteObject = [[YKNoteBlockNoteObject alloc] init];
//        NSLog(@"%@", blockNoteObject);
//
//        memory1();
//    }
//    return 0;
//}
