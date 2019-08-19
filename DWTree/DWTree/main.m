//
//  main.m
//  DWTree
//
//  Created by 丁巍 on 2019/8/18.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonComparator.h"
#import "Person.h"
#import "MJBinaryTrees.h"

#import "DWSearchTree.h"
#import "AVLSearchTree.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        PersonComparator *pComparator = [PersonComparator new];
        
        AVLSearchTree *searchTree = [[AVLSearchTree alloc] initTreeWithComparator:pComparator];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        NSArray *tempAgeArray = @[@7, @98, @75, @24, @9, @72, @6, @71, @29, @74, @58, @26, @69, @8, @96, @76, @25, @48];

        for (int i=0; i<tempAgeArray.count; i++) {
            Person *p = [[Person alloc] initPersonWithAge:[tempAgeArray[i] integerValue]];
            [searchTree addWithElement:p];
            [tempArray addObject:p];
        }

//         [self inorderTraversal];
        [MJBinaryTrees println:searchTree];
    }
    return 0;
}
