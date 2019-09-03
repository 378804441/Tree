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
    
    RBNode *grandNode   = (RBNode *)node.parentNode.parentNode; // 祖父节点 并 染成红色
    grandNode = [self __nodeRedWith:grandNode];
    
    RBNode *uncleNode   = (RBNode *)[node getUncleNode];        // 叔父节点
    
    // 父节点为null, 既是根节点 染色成黑色 (包含上溢成为根节点)
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
        
        // 将祖父节点看成新添加的节点, 递归调用 afterAdd 进行节点调整
        [self afterAddWithNode:grandNode];
        return;
     
    // 处理 ② 情况 (叔父节点为黑色, 进行旋转操作)
    }else{
        
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


/**
 * 删除节点后需要做的方法
 * ① 删除红色节点, 不需要做任何处理
 * ② 删除黑色节点, 有三种情况
 *    a. 删除有俩个 red 子节点的 black 节点 (度为2的节点)
 *        α. 不存在。平衡二叉树中, 删除掉度为2的节点, 其实删除的是其 前驱 Or 后继 节点。 只不过是把 前驱 Or 后继 节点上的值赋值给了 当前节点而已。
 *    b. 删除拥有一个 red 子节点的 black 节点 :
 *        α. 判断条件 : 用以替代的子节点颜色是否为 red （二叉平衡树, 删除度为1的节点, 直接让该节点的子节点来进行节点替换）
 *           将替代的子节点染成 black, 即可保持红黑树性质
 *    c. 删除的节点是 black 叶子节点
 *        α. 删除的是根节点, 不处理
 *        β. 发生了下溢现象
 *           1. 兄弟节点是 black 的
 *              A. 如果可以跟兄弟节点借的话, 进行旋转操作 (兄弟节点 - 左, 右, 左右  有红色子节点)
 *                   旋转后中心节点继承 parent 的颜色
 *                   旋转后左右节点染成 black
 *              B. 兄弟节点不能借 (兄弟节点 没有一个 red)
 *                   将 sibling 染成 red, parent 染成 black, 进行融合
 *           2. 兄弟节点是 red 的
 *              A. 将 兄弟节点染成 black, 将父节点染成 red
 *              B. 让兄弟节点的子节点通过旋转成为删除节点的兄弟节点 (侄子节点成为兄弟节点), 然后进行兄弟节点是 black 时候删除处理逻辑
 */
- (void)afterRemoveWithNode:(RBNode *)node{
    
//    if([self __isRedWith:node]) return;
    
    // ② - b - α
    if ([self __isRedWith:node]) {
        [self __nodeBlackWith:node];
        return;
    }

    
    RBNode *parentNode  = (RBNode *)node.parentNode;            // 父节点
    
    // 通过 node(被删除节点)的父节点 左右节点, 来判断 node曾经是该父节点的 左节点还是右节点
    BOOL left = IsNull(parentNode.leftNode) || [node isLeftChild];
    RBNode *siblingNode = (RBNode *)(left ? parentNode.rightNode : parentNode.leftNode);  // 兄弟节点
    
    // ② - c - α
    if (IsNull(parentNode)) return;
    
    // 先判断删除节点 是 左节点还是右节点 (因为旋转是对称的)
    
    if (left) {  // 被删除节点在左边
        // ② - c - β - 2
        if ([self __isRedWith:siblingNode]) {
            // ② - c - β - 2 - A
            [self __nodeBlackWith:siblingNode];
            [self __nodeRedWith:parentNode];
            [self __leftRotatingWithNode:parentNode];
            // 更换兄弟节点
            siblingNode = (RBNode *)parentNode.rightNode;
        }
        
        // ② - c - β - 1 - B
        if ([self __isBlackWith:(RBNode *)siblingNode.leftNode] && [self __isBlackWith:(RBNode *)siblingNode.rightNode]) {
            BOOL parentBlack = [self __isBlackWith:parentNode];
            [self __nodeRedWith:siblingNode];
            [self __nodeBlackWith:parentNode];
            
            // 父节点是黑色, 父节点没有兄弟节点 既 有可能也发生下溢现象, 进行递归矫正
            if (parentBlack) {
                [self afterRemoveWithNode:parentNode];
            }
            
            // ② - c - β - 1 - A
        }else{
            /** 判断兄弟节点 左节点 是否是黑色, 黑的的话 先进行 兄弟节点左旋转
             让他变成 LL 情况, 然后就可以跟其他俩种情况 公用 LL旋转代码了 **/
            if ([self __isBlackWith:(RBNode *)siblingNode.leftNode]) {
                [self __rightRotatingWithNode:siblingNode];
                // 该次旋转后 兄弟节点 有变化
                siblingNode = (RBNode *)parentNode.rightNode;
            }
            
            // 先染色
            [self __nodeDyeingWith:siblingNode color:[self __colorOfWith:parentNode]];
            [self __nodeBlackWith:(RBNode *)siblingNode.leftNode];
            [self __nodeRedWith:parentNode];
            
            // 统一成 需要LL 的情况了, 进行父节点右旋转
            [self __leftRotatingWithNode:parentNode];
        }
        
        
    }else{       // 被删除节点在右边
        
        // ② - c - β - 2
        if ([self __isRedWith:siblingNode]) {
            // ② - c - β - 2 - A
            [self __nodeBlackWith:siblingNode];
            [self __nodeRedWith:parentNode];
            [self __rightRotatingWithNode:parentNode];
            // 更换兄弟节点
            siblingNode = (RBNode *)parentNode.leftNode;
        }
        
        // ② - c - β - 1 - B
        if ([self __isBlackWith:(RBNode *)siblingNode.leftNode] && [self __isBlackWith:(RBNode *)siblingNode.rightNode]) {
            BOOL parentBlack = [self __isBlackWith:parentNode];
            [self __nodeRedWith:siblingNode];
            [self __nodeBlackWith:parentNode];
            
            // 父节点是黑色, 父节点没有兄弟节点 既 有可能也发生下溢现象, 进行递归矫正
            if (parentBlack) {
                [self afterRemoveWithNode:parentNode];
            }
            
        // ② - c - β - 1 - A
        }else{
            /** 判断兄弟节点 左节点 是否是黑色, 黑的的话 先进行 兄弟节点左旋转
                让他变成 LL 情况, 然后就可以跟其他俩种情况 公用 LL旋转代码了 **/
            if ([self __isBlackWith:(RBNode *)siblingNode.leftNode]) {
                [self __leftRotatingWithNode:siblingNode];
                // 该次旋转后 兄弟节点 有变化
                siblingNode = (RBNode *)parentNode.leftNode;
            }
            
            // 先染色
            [self __nodeDyeingWith:siblingNode color:[self __colorOfWith:parentNode]];
            [self __nodeBlackWith:(RBNode *)siblingNode.leftNode];
            [self __nodeRedWith:parentNode];
            
            // 统一成 需要LL 的情况了, 进行父节点右旋转
            [self __rightRotatingWithNode:parentNode];
        }
        
    }
    
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
