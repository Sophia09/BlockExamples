//
//  ViewController.h
//  BlockExamples
//
//  Created by Li Sai on 22/3/2017.
//  Copyright © 2017 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * Block as a typedef
 * typedef returnType (^typeName)(parameters);
 * typeName variableName = ^returnType(parameters){};
 */
typedef NSString *  _Nullable (^myBlockType)(NSString * _Nullable name);
_Nullable myBlockType myBlockVariable = ^ NSString *(NSString *name) {
    return name;
};

@interface ViewController : UIViewController

/*
 * Block as a property
 * @property(nullable, nonatomic, copy) returnType (^blockName)(parameters)
 */
@property(nonatomic, copy, nullable) NSString * _Nullable (^propertyName)( NSString * _Nullable name);

/*
 * block as a method parameter
 * (returnType(^)(parameters))blockName
 */

- (void)aMethodWithBlockParameter:(NSString * _Nullable (^_Nullable)(NSString * _Nullable name))blockName;

@end

