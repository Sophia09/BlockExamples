//
//  ViewController.m
//  BlockExamples
//
//  Created by Li Sai on 22/3/2017.
//  Copyright © 2017 Test. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "NewTarget.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    myBlockVariable(@"typedef");
    
    [self callMethodWithBlockParameter];
    
    [self testNotFoundMethod];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Block Private Methods


- (void)defineBlock {
    // returnType (^blockName)(params) = ^returnType(params)
    NSString * (^localVariableBlock)(NSString *name) = ^NSString *(NSString *name) {
        return @"This is a block as local variable";
    };
    localVariableBlock(@"localBockWithReturn");
    
    void (^localBlockWithoutReturn)(NSString *name) = ^(NSString *name) {
        
    };
    localBlockWithoutReturn(@"localBlockWithoutReturn");
}

- (void)callMethodWithBlockParameter {
    /*
     * [obj aMethodWithBlockParameter:^returnType(parameters){}];
     */
    [self aMethodWithBlockParameter:^NSString *(NSString *name) {
        NSLog(@"%@", name);
        return name;
    }];
}

- (void)aMethodWithBlockParameter:(NSString * _Nullable (^_Nullable)(NSString * _Nullable))blockName {
    
    NSString *myName = blockName(@"Sophia");
    NSLog(@"My name is %@", myName);
}

#pragma mark - MethodNotFound Private Methods

- (void)testNotFoundMethod {
    /*
     step1: 执行对象中的 resolveInstanceMethod: 函数，如果返回 YES 则执行对象的 IMP；
     返回 NO 执行 step2
     */
    // invoke sel: resolveInstanceMethod:
    [self performSelector:NSSelectorFromString(@"testMethod")];
    
   /*
     step2: 调用 forwardingTargetForSelector: 函数，根据 selector 决定是否返回 target。
             如果返回值为 nil，则执行 step3
  */
    // invoke sel: forwardingTargetForSelector:
    [self performSelector:NSSelectorFromString(@"testNewTarget")];
    
    /*
     step3: 调用 methodSignatureForSelector: 函数，返回 NSMethodSignature
     step4: 系统利用 step3 返回的 signature, 生成一个 NSInvocation 对象，调用 forwardInvocation: 函数，完成消息转发
     */
    // invoke sel: methodSignatureForSelector: & forwardInvocation:
    [self performSelector:NSSelectorFromString(@"testForwardInvocation")];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *methodName = NSStringFromSelector(sel);
    if ([methodName isEqualToString:@"testMethod"]) {
        // 添加 imp
        class_addMethod([self class], sel, (IMP)myMethod, "v@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

void myMethod(id self, SEL _cmd) {
    NSLog(@"testMethod imp");
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *methodName = NSStringFromSelector(aSelector);
    if ([methodName isEqualToString:@"testNewTarget"]) {
        // 交给 NewTarget 对象处理 aSelector
        NewTarget *target = [[NewTarget alloc] init];
        return target;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([NewTarget instancesRespondToSelector:aSelector]) {
            signature = [NewTarget instanceMethodSignatureForSelector:aSelector];
        }
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([NewTarget instancesRespondToSelector:anInvocation.selector]) {
        NewTarget *target = [[NewTarget alloc] init];
        [anInvocation invokeWithTarget:target];
    }
}

@end
