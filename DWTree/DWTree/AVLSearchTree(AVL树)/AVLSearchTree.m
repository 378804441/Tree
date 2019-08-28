//
//  AVLSearchTree.m
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/17.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "AVLSearchTree.h"

@implementation AVLSearchTree


#pragma mark - super method

/** 想二叉搜索树添加节点成功后处理方法, 进行恢复平衡操作 */
- (void)afterAddWithNode:(id)node{
    while ((node = ((AVLNode *)node).parentNode) != nil) {
        // 平衡
        if ([self __isBalanceWithNode:node]) {
            // 更新下节点高度
            [self __updateHeightWithNode:node];

        // 失衡 (找到第一个补平衡点就可以)
        }else{
            [self __reBalanceWithNode:node];
            break;
        }
    }
}


/** 删除节点后续处理动作 */
- (void)afterRemoveWithNode:(id)node{
    while ((node = ((AVLNode *)node).parentNode) != nil) {
        // 平衡
        if ([self __isBalanceWithNode:node]) {
            [self __updateHeightWithNode:node];
            
        // 失衡
        }else{
            [self __reBalanceWithNode:node];
        }
    }
}


/** 创建node节点 默认返回 TreeNode 对象,  如果需要 子类特殊的节点，重写该方法 返回 自定义节点即可 */
- (id)createNodeWithParent:(id __nullable)parent element:(id __nullable)element{
    return [[AVLNode alloc] initNodeWithParentNode:parent element:element];
}



#pragma mark - private method

/** 检测是否失衡 YES-平衡 NO-失衡 */
- (BOOL)__isBalanceWithNode:(AVLNode *)node{
    return [node balanceFactor] > 1 ? NO : YES;
}


/** 更新节点高度 (节点高度 = 左,右 节点最高的 + 1) */
- (void)__updateHeightWithNode:(AVLNode *)node{
    [node updateHeight];
}


/** 进行恢复节点之间平衡 */
- (void)__reBalanceWithNode:(AVLNode *)gNode{
    AVLNode *pNode = [gNode tallerChild];    // ② 节点
    AVLNode *nNode = [pNode tallerChild];    // ③ 节点
    
    // 开始判断 是 LL / RR / LR / RL
    if ([pNode isLeftChild]) {  // L
        if ([nNode isLeftChild]) {        // LL
            [self __rightRotatingWithNode:gNode];
        }else{                            // LR (右旋转 -> 左旋转)
            [self __leftRotatingWithNode:pNode];
            [self __rightRotatingWithNode:gNode];
        }
        
    }else{                      // R
        if ([nNode isLeftChild]) {        // RL (左旋转 -> 右旋转)
            [self __rightRotatingWithNode:pNode];
            [self __leftRotatingWithNode:gNode];
        }else{                            // RR
            [self __leftRotatingWithNode:gNode];
        }
    }
    
    
}



#pragma mark - 按照 左/右 旋转逻辑进行 独立拆分逻辑

/** 左旋转 */
- (void)__leftRotatingWithNode:(AVLNode *)node{
    if (IsNull(node)) return;
    
    AVLNode *pNode  = (AVLNode *)node.rightNode;
    AVLNode *t2Node = (AVLNode *)pNode.leftNode; // 为了对应笔记里画图命名 取名 t2
    node.rightNode  = t2Node;
    pNode.leftNode  = node;
    
    // 更新 旋转后各个节点直接关系
    [self __updateNodeRoleWithNode:node pNode:pNode t2Node:t2Node];
}


/** 右旋转 */
- (void)__rightRotatingWithNode:(AVLNode *)node{
    if (IsNull(node)) return;
    
    AVLNode *pNode  = (AVLNode *)node.leftNode;
    AVLNode *t2Node = (AVLNode *)pNode.rightNode;  // 为了对应笔记里画图命名 取名 t2
    node.leftNode   = t2Node;
    pNode.rightNode = node;
    
    // 更新 旋转后各个节点直接关系
    [self __updateNodeRoleWithNode:node pNode:pNode t2Node:t2Node];
}


/** 按照角色更新 各个 节点的 父节点, 父节点的左右节点, 节点高度等信息 */
- (void)__updateNodeRoleWithNode:(AVLNode *)node pNode:(AVLNode *)pNode t2Node:(AVLNode *)t2Node{
    
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
    
    // 更新节点高度
    [self __updateHeightWithNode:node];
    [self __updateHeightWithNode:pNode];
}



#pragma mark - 按照 最终旋转后的结果规律 统一处理旋转逻辑

/**
 * 结果推导, 越过 左旋右旋方法
 * otherNodes : @[a, b, c, d]
 */
- (void)__rotatingWithNode:(AVLNode *)node1 node2:(AVLNode *)node2 node3:(AVLNode *)node3 otherNodes:(NSArray *)otherNodes{
    /**
     不管怎么旋转最终结果都会会是同一种结构。 所有可以将旋转逻辑统一处理。
     注意 : a b c d  是  ③->②->①  顺序的 失衡节点 的 另一个节点 (其余情况 其实都一致)
              ┌─--①─┐                   ┌─----①----─┐
              │      d                   │           │
          ┌─--②─┐                   ┌─--②--─┐   ┌─--③--─┐
          │      c                   │       │    │       │
        ┌─③─┐                        a      b     c      d
        a    b
                            ====>
     */
    
    // 进行角色分配
    AVLNode *aNode;
    AVLNode *bNode;
    AVLNode *cNode;
    AVLNode *dNode;
    for (int i=0; i<otherNodes.count; i++) {
        AVLNode *node = otherNodes[i];
        if (i == 0) {
            aNode = node;
        }else if(i == 1){
            bNode = node;
        }else if(i == 2){
            cNode = node;
        }else if(i == 3){
            dNode = node;
        }
    }
    
#pragma mark - 感觉 这么写 意义不大，更容易让逻辑混乱，所以不往下写了。沿用 左旋右旋。
}


@end




@implementation AVLNode

#pragma mark - public method

/** 获取该节点平衡因子 */
- (NSInteger)balanceFactor{
    AVLNode *leftNode  = (AVLNode *)self.leftNode;
    AVLNode *rightNode = (AVLNode *)self.rightNode;
    NSInteger leftH    = IsNull(leftNode)  ? 0 : leftNode.height;
    NSInteger rightH   = IsNull(rightNode) ? 0 : rightNode.height;
    return labs(leftH - rightH);
}


/** 更新节点高度 (节点高度 = 左,右 节点最高的 + 1) */
- (void)updateHeight{
    AVLNode *leftNode  = (AVLNode *)self.leftNode;
    AVLNode *rightNode = (AVLNode *)self.rightNode;
    NSInteger leftH    = IsNull(leftNode)  ? 0 : leftNode.height;
    NSInteger rightH   = IsNull(rightNode) ? 0 : rightNode.height;
    self.height        = MAX(leftH, rightH) + 1;
}


/** 获取该节点 左右节点中 高度最高的节点 (如果相同，返回同方向的节点) */
- (AVLNode *)tallerChild{
    AVLNode *leftNode  = (AVLNode *)self.leftNode;
    AVLNode *rightNode = (AVLNode *)self.rightNode;
    NSInteger leftH    = IsNull(leftNode)  ? 0 : leftNode.height;
    NSInteger rightH   = IsNull(rightNode) ? 0 : rightNode.height;
    if (leftH > rightH) {
        return leftNode;
    }
    if(leftH < rightH){
        return rightNode;
    }
    return [self isLeftChild] ? leftNode : rightNode;
}


- (NSInteger)height{
    if (_height == 0) {
        _height = 1;
    }
    return _height;
}


@end
