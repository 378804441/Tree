//
//  main.m
//  DWTree
//
//  Created by 丁巍 on 2019/8/18.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CABase.h>
#import "TestComparator.h"
#import "MJBinaryTrees.h"

#import "DWSearchTree.h"
#import "AVLSearchTree.h"
#import "RedBlackTree.h"
#import "TreeAlgorithmTool.h"

#define DEF_COUNT    10

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSArray *tempArray = @[@17, @54, @71, @97, @19, @83, @78, @67, @68, @3, @31, @27, @84];
        TestComparator *pComparator = [TestComparator new];
        DWSearchTree *searchTree;
        
        /** 二叉搜索树 */
        // searchTree  = [[DWSearchTree alloc] initTreeWithComparator:pComparator];
        
        /** AVL树 */
        // searchTree  = [[AVLSearchTree alloc] initTreeWithComparator:pComparator];
        
        /** 红黑树 */
        // searchTree  = [[RedBlackTree alloc] initTreeWithComparator:pComparator];
        
        for (int i=0; i<tempArray.count; i++) {
            [searchTree addWithElement:tempArray[i]];
        }
        
//        [searchTree removeWithElement:@17];
        
        [MJBinaryTrees println:searchTree];
        
    }
    return 0;
}
