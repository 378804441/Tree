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
        for (int i=0; i<10; i++) {
            Person *p = [[Person alloc] initPersonWithAge:random()%1000];
            [searchTree addWithElement:p];
            [tempArray addObject:p];
        }
        
        
        [MJBinaryTrees println:searchTree];
        
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~");
        [searchTree removeWithElement:tempArray[1]];
        
        [MJBinaryTrees println:searchTree];
        
        //        [searchTree levelOrderTraversalWithVisitorBlock:^(id  _Nonnull visitorData) {
        //            NSLog(@"~~~~~~~~~  %@", @([((Person *)visitorData) getAge]));
        //        }];
        
    }
    return 0;
}
