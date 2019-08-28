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

/**
 * 添加节点总共分三种 大情况 (默认添加节点为红色) *
   ① 直接向黑节点添加 - 直接添加即可
   ② 添加节点的叔父节点为黑色 (对应到B树上就是，4阶B树节点已经有2个了) - 进行局部的 LL/RR/LR/RL 的旋转
   ③ 添加节点的叔父节点为红色 (对应到B树上就是，4阶B树节点已经有3个了, 会出现上溢现象)
      - a) 将新节点的 祖父节点染成红色 然后进行上溢操作
        b) 父节/叔父节点染成黑色
        c) 进行新节点+叔父节点分裂
        d) 将上溢的祖父节点进行 ② 旋转操作即可
 */
- (void)afterAddWithNode:(RBNode *)node{
    
    RBNode *parentNode  = (RBNode *)node.parentNode;            // 父节点
    RBNode *grandNode   = (RBNode *)node.parentNode.parentNode; // 祖父节点
    RBNode *uncleNode   = (RBNode *)[node getUncleNode];        // 叔父节点
    
    // 父节点为null, 既是根节点 染色成黑色
    if (IsNull(parentNode)) {
        [self __nodeDyeingWith:node color:BLACK];
        return;
    }
    
    // 处理 ① 情况 (其实不用处理)
    if ([self __isBlackWith:parentNode]) {
        return ;
    
    // 处理 ③ 情况 (叔父节点为红色, 出现上溢情况)
    }else if([self __isRedWith:uncleNode]){
        [self __nodeDyeingWith:parentNode color:BLACK];
        [self __nodeDyeingWith:uncleNode  color:BLACK];
        grandNode = [self __nodeDyeingWith:grandNode  color:RED];
        
        // 将祖父节点看成新添加的节点, 递归调用 afterAdd 进行节点调整
        [self afterAddWithNode:grandNode];
        return;
     
    // 处理 ② 情况 (叔父节点为黑色, 进行旋转操作)
    }else{
        // 祖父节点永远是要的染红
        [self __nodeRedWith:grandNode];
        
        // 判断父节点是 L 还是 R
        if ([parentNode isRightChild]) {    // R
            if ([node isRightChild]) {      // RR
                [self __nodeBlackWith:parentNode];
                
            }else{                          // RL
                [self __nodeBlackWith:node];
                [self __rightRotatingWithNode:parentNode];
            }
            
            // 祖父节点左旋转
            [self __leftRotatingWithNode:grandNode];
            
        }else{                              // L
            if ([node isRightChild]) {      // LR
                [self __nodeBlackWith:node];
                [self __leftRotatingWithNode:parentNode];
                
            }else{                          // LL
                [self __nodeBlackWith:parentNode];
            }
            
            // 祖父节点右旋转
            [self __rightRotatingWithNode:grandNode];
        }
    }
}


/** 删除节点后需要做的方法 */
- (void)afterRemoveWithNode:(RBNode *)node{
    
}


/** 创建node节点 默认返回 TreeNode 对象,  如果需要 子类特殊的节点，重写该方法 返回 自定义节点即可 */
- (id)createNodeWithParent:(id __nullable)parent element:(id __nullable)element{
    return [[RBNode alloc] initNodeWithParentNode:parent element:element];
}



#pragma mark - private method

/** 获取节点颜色 (空节点颜色为黑色) */
- (BOOL)__colorOfWith:(RBNode *)node{
    return IsNull(node) ? BLACK : node.color;
}


/** 检查节点是否为黑色 */
- (BOOL)__isBlackWith:(RBNode *)node{
    return [self __colorOfWith:node] == BLACK;
}


/** 检查节点是否为红色 */
- (BOOL)__isRedWith:(RBNode *)node{
    return [self __colorOfWith:node] == RED;
}


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



#pragma mark - 旋转操作

/** 左旋转 */
- (void)__leftRotatingWithNode:(RBNode *)node{
    if (IsNull(node)) return;
    
    RBNode *pNode  = (RBNode *)node.rightNode;
    RBNode *t2Node = (RBNode *)pNode.leftNode; // 为了对应笔记里画图命名 取名 t2
    node.rightNode  = t2Node;
    pNode.leftNode  = node;
    
    // 更新 旋转后各个节点直接关系
    [self __updateNodeRoleWithNode:node pNode:pNode t2Node:t2Node];
}


/** 右旋转 */
- (void)__rightRotatingWithNode:(RBNode *)node{
    if (IsNull(node)) return;
    
    RBNode *pNode  = (RBNode *)node.leftNode;
    RBNode *t2Node = (RBNode *)pNode.rightNode;  // 为了对应笔记里画图命名 取名 t2
    node.leftNode   = t2Node;
    pNode.rightNode = node;
    
    // 更新 旋转后各个节点直接关系
    [self __updateNodeRoleWithNode:node pNode:pNode t2Node:t2Node];
}


/** 按照角色更新 各个 节点的 父节点, 父节点的左右节点, 节点高度等信息 */
- (void)__updateNodeRoleWithNode:(RBNode *)node pNode:(RBNode *)pNode t2Node:(RBNode *)t2Node{
    
    // 进行 node, pNode, t2Node 父节点更新 (看着迷糊的话 自行画 节点旋转图脑补)
    pNode.parentNode = node.parentNode;
    if ([node isLeftChild]) {
        node.parentNode.leftNode = pNode;
        
    }else if([node isRightChild]){
        node.parentNode.rightNode = pNode;
        
        // 根节点
    }else{
        self.rootNode  = pNode;
    }
    
    // 其余俩个角色父节点更新
    if (!IsNull(t2Node)) {
        t2Node.parentNode = node;
    }
    
    node.parentNode   = pNode;
}




#pragma mark - print

- (id)root{
    return self.rootNode;
}


- (id)left:(RBNode *)node{
    return node.leftNode;
}


- (id)right:(RBNode *)node{
    return node.rightNode;
}


- (id)string:(RBNode *)node{
    return [NSString stringWithFormat:@"%@[%@]", node.element, (node.color ? @"⭕️":@"██")];
}



@end





#pragma mark - RB node

@implementation RBNode


/** 初始化 */
- (instancetype)initNodeWithParentNode:(TreeNode *__nullable)parentNode  element:(id __nullable)element{
    self.color = YES;       // 默认为红色
    return [super initNodeWithParentNode:parentNode element:element];
}


@end
