//
//  main.m
//  DWTree
//
//  Created by 丁巍 on 2019/8/18.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CABase.h>
#import "PersonComparator.h"
#import "Person.h"
#import "MJBinaryTrees.h"

#import "DWSearchTree.h"
#import "AVLSearchTree.h"
#import "RedBlackTree.h"
#import "TreeAlgorithmTool.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        PersonComparator *pComparator = [PersonComparator new];
        RedBlackTree     *searchTree  = [[RedBlackTree alloc] initTreeWithComparator:pComparator];
  
        NSArray *tempArray = @[@21, @61, @24, @85, @80, @86, @50, @100, @84, @20, @41, @94, @46, @2, @34, @93];
        for (int i=0; i<tempArray.count; i++) {
            NSInteger age = [tempArray[i] integerValue];
            Person *p = [[Person alloc] initPersonWithAge:age];
            [searchTree addWithElement:p];
        }
        
        [MJBinaryTrees println:searchTree];
    }
    return 0;
}
