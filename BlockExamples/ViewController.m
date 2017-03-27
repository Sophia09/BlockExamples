//
//  ViewController.m
//  BlockExamples
//
//  Created by Li Sai on 22/3/2017.
//  Copyright © 2017 Test. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    myBlockVariable(@"typedef");
    
    [self callMethodWithBlockParameter];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
