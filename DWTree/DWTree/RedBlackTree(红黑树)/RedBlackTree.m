//
//  RedBlackTree.m
//  DWTree
//
//  Created by 丁巍 on 2019/8/25.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "RedBlackTree.h"

#define RED     YES           // 红色
#define BLACK   NO            // 黑色


@implementation RedBlackTree


#pragma mark - super method

/** 添加节点后需要做的方法 */
- (void)afterAddWithNode:(id)node{
    
}

/** 删除节点后需要做的方法 */
- (void)afterRemoveWithNode:(id)node{
    
}

/** 创建node节点 默认返回 TreeNode 对象,  如果需要 子类特殊的节点，重写该方法 返回 自定义节点即可 */
//- (id)createNodeWithParent:(id __nullable)parent element:(id __nullable)element{
//    return
//}



#pragma mark - private method


/** 将节点染成红色 */
- (RBNode *)__nodeRedWith:(RBNode *)node{
    return [self __nodeDyeingWith:node color:RED];
}


/** 将节点染成黑色 */
- (RBNode *)__nodeBlackWith:(RBNode *)node{
    return [self __nodeDyeingWith:node color:BLACK];
}


/**
 * 进行节点染色
 * node  : rb 节点
 * color : 要染色的颜色 YES-红色 NO-黑色
 */
- (RBNode *)__nodeDyeingWith:(RBNode *)node color:(BOOL)color{
    node.color = color;
    return node;
}


@end







#pragma mark - RB node

@implementation RBNode


@end
