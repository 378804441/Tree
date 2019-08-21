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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        double StartTime = CACurrentMediaTime();
        
        PersonComparator *pComparator = [PersonComparator new];
        
        AVLSearchTree *searchTree = [[AVLSearchTree alloc] initTreeWithComparator:pComparator];
        
        NSMutableArray *tempArray = [NSMutableArray array];
//        NSArray *tempAgeArray = @[@7, @98, @75, @24, @9, @72, @6];
        
        
        NSMutableArray *tempAgeArray = [NSMutableArray array];
        for (int i=0; i<100000; i++) {
            [tempAgeArray addObject:@(random() * 100000)];
        }
        

        for (int i=0; i<tempAgeArray.count; i++) {
            Person *p = [[Person alloc] initPersonWithAge:[tempAgeArray[i] integerValue]];
            [searchTree addWithElement:p];
            [tempArray addObject:p];
        }
        
        
        
        double launchTime = (CACurrentMediaTime() - StartTime);
        printf("start_Time:%f ms\n", launchTime);
        
//         [self inorderTraversal];
        [MJBinaryTrees println:searchTree];
    }
    return 0;
}
