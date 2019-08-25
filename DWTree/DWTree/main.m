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
#import "TreeAlgorithmTool.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        double StartTime = CACurrentMediaTime();
      
        PersonComparator *pComparator = [PersonComparator new];
        AVLSearchTree    *searchTree  = [[AVLSearchTree alloc] initTreeWithComparator:pComparator];
  
        NSMutableArray *tempArray    = [NSMutableArray array];
        for (int i=0; i<10000; i++) {
            int age = i;
            Person *p = [[Person alloc] initPersonWithAge:age];
            [searchTree addWithElement:p];
            [tempArray addObject:p];
        }
        
        [searchTree checkWithElement:tempArray[tempArray.count-1]];
        
        double launchTime = (CACurrentMediaTime() - StartTime);
        printf("start_Time:%f ms\n", launchTime);
        
//        [MJBinaryTrees println:searchTree];
    }
    return 0;
}
