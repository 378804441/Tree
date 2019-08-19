//
//  AVLSearchTree.m
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/17.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "AVLSearchTree.h"
#import "Person.h"

@implementation AVLSearchTree



#pragma mark - private method

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


/** 创建node节点 默认返回 TreeNode 对象,  如果需要 子类特殊的节点，重写该方法 返回 自定义节点即可 */
- (id)createNodeWithParent:(id __nullable)parent element:(id __nullable)element{
    return [[AVLNode alloc] initNodeWithParentNode:parent element:element];
}


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
    
#pragma mark - 按照最终旋转后结果规律，统一处理逻辑 (与下面方式 其实都一样，只不过这样写代码量会少一些)
    [self __rotatingWithNode:gNode node2:pNode node3:nNode];
    return;
    
#pragma mark - 按照 左/右 旋转拆分旋转逻辑
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
- (void)__rotatingWithNode:(AVLNode *)node1 node2:(AVLNode *)node2 node3:(AVLNode *)node3{
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
//    AVLNode *aNode = node3.leftNode;
//    AVLNode *bNode = node3.rightNode;
//    AVLNode *aNode = node3.leftNode;
//    AVLNode *aNode = node3.leftNode;
    
    
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
