//
//  DWSearchTree.m
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/6.
//  Copyright © 2019 丁巍. All rights reserved.
//

/** 搜索二叉树的特性
    ① 任意的一个节点的值都 大于左子节点 的值
    ② 任意的一个节点的值都 小于右子节点 的值
    ③ 节点需要具有统一的科比对性
    ④ 节点值不能为null
 */

#import "DWSearchTree.h"
#import "TreeAlgorithmTool.h"


@interface DWSearchTree()

/** 比较器 */
@property (nonatomic, strong) id <DWComparatorProtocol>comparator;

@end


@implementation DWSearchTree


/**
 * 初始化方法
 * comparator : 自定义比较器
 */
- (instancetype)initTreeWithComparator:(id <DWComparatorProtocol>)comparator{
    self = [super init];
    if (self) {
        self.comparator = comparator;
    }
    return self;
}


/** 元素数量 */
- (NSInteger)size{
    return _size;
}


/** 是否为空 */
- (BOOL)isEmpty{
    return self.size == 0;
}


/** 清空所有元素 */
- (void)clear{
    self.rootNode = nil;
    self.size = 0;
}


/** 添加元素 */
- (void)addWithElement:(id)element{
    [self __elementNotNullCheckWithElement:element];
    
    // 树上没有任何节点, 添加第一个节点
    if (IsNull(self.rootNode)) {
        self.rootNode = [self createNodeWithParent:nil element:element];
        self.size++;
        
        // 调用添加节点成功后的 虚方法
        [self afterAddWithNode:self.rootNode];
        return;
    }
    
    
    /**
     cmp
     负数, 当前年龄小于传进来的年龄
     正数, 当前年龄大于传来的年龄
     0,   俩个年龄相同
     */
    TreeNode *tempNode   = self.rootNode;
    TreeNode *parentNode = self.rootNode;
    NSInteger cmp = 0;
    
    while (tempNode) {
        cmp = [self __compareWithE1:element e2:tempNode.element];
        parentNode = tempNode;  // 父节点
        
        if (cmp > 0) {
            tempNode = parentNode.rightNode;
            
        }else if(cmp < 0){
            tempNode = parentNode.leftNode;
            
        }else{
            return;
        }
    }
    
    TreeNode *newNode = [self createNodeWithParent:parentNode element:element];
    if (cmp > 0) {
        parentNode.rightNode = newNode;
        
    }else if(cmp < 0){
        parentNode.leftNode = newNode;
    }
    
    _size++;
    
    // 调用添加节点成功后的 虚方法
    [self afterAddWithNode:newNode];
}


/** 删除元素 */
- (void)removeWithElement:(id)element{
    TreeNode *node = [self __getNodeWithElement:element];
    [self __removeNode:node];
}


/** 按照 element 获取节点 */
- (TreeNode *)checkWithElement:(id)element{
    return [self __getNodeWithElement:element];
}


/** 查看元素是否存在 */
- (BOOL)contatinsWithElement:(id)element{
    return YES;
}


#pragma mark - public method

/** 层序遍历 */
- (void)levelOrderTraversalWithVisitorBlock:(void (^)(id _Nonnull visitorData))visitorBlock{
    [TreeAlgorithmTool levelOrderTraversalWithNode:self.rootNode VisitorBlock:visitorBlock];
}

/** 中序遍历 */
- (void)inorderTraversal{
    [TreeAlgorithmTool inorderTraversalWithNode:self.rootNode];
}



#pragma mark - 虚方法

/** 添加节点后需要做的方法, 子类自定义去实现 (例 : 二叉树进行节点插入后 AVL树需要进行 旋转平衡逻辑就可以重写该方法) */
- (void)afterAddWithNode:(TreeNode *)node{}

/** 删除节点后需要做的方法, 子类自定义去实现 (例 : 二叉树进行节点插入后 AVL树需要进行 旋转平衡逻辑就可以重写该方法) */
- (void)afterRemoveWithNode:(id)node{}

/** 创建node节点 默认返回 TreeNode 对象,  如果需要 子类特殊的节点，重写该方法 返回 自定义节点即可 */
- (id)createNodeWithParent:(id __nullable)parent element:(id __nullable)element{
    return [[TreeNode alloc] initNodeWithParentNode:parent element:element];
}



#pragma mark - private method

- (void)__removeNode:(TreeNode *)node{
    if (IsNull(node)) return;
    
    _size--;
    
    // 度为2的节点
    if ([node chackingNodeDegree] == 2) {
        // 找到后继节点
        TreeNode *s = [TreeAlgorithmTool predecessorWithNode:node type:TreePredecessorType_after];
        
        // 用后继节点的值 覆盖 node的 element
        node.element = s.element;
        node = s;
    }
    
    // 度为 1 / 0  (用子节点进行替换原结点)
    TreeNode *replacement = IsNull(node.leftNode) ? node.rightNode : node.leftNode;
    if (replacement != nil) {
        // 更改父节点指向  （A:）
        replacement.parentNode = node.parentNode;
        
        // 根节点
        if (IsNull(node.parentNode)){
            self.rootNode = replacement;
            
        }else if (node == node.parentNode.leftNode) {
            node.parentNode.leftNode = replacement;
            
        }else if(node == node.parentNode.rightNode){
            node.parentNode.rightNode = replacement;
        }
        
        /** 这里注意一下 :
            这里传的并不是 真正被删除的节点，而是删除后取代的节点。
            这样做是为了减少添加 红黑树 而多设一个 处理 抽象方法。
            这样做会不会影响 AVL树 删除后自平衡代码？ 不会, 因为AVL树的 删除后自平衡 是通过被删除节点 找到他的父节点
            进行遍历动作。而 这里 replacement 节点 在  （A:）  这个位置 已经将父节点指向更改掉了。所以不会影响
         */
        [self afterRemoveWithNode:replacement];
        
    // 根节点
    } else if(IsNull(node.parentNode)){
        self.rootNode = nil;
        
        // 删除完节点，后续处理
        [self afterRemoveWithNode:node];
        
    // 叶子节点
    }else{
        if (node == node.parentNode.leftNode) {
            node.parentNode.leftNode  = nil;
            
        }else if (node == node.parentNode.rightNode){
            node.parentNode.rightNode = nil;
        }
        
        // 删除完节点，后续处理
        [self afterRemoveWithNode:node];
    }
}


/**
 俩对象进行比对
 负数, 当前年龄小于传进来的年龄
 正数, 当前年龄大于传来的年龄
 0,   俩个年龄相同
 */
- (NSInteger)__compareWithE1:(id)e1 e2:(id)e2{
    NSAssert(!IsNull(self.comparator), @"请添加比对器 (DWComparatorProtocol) 协议");
    return [self.comparator comparableWithObjc1:e1 objc2:e2];
}


/** 检测element是否为空 */
- (void)__elementNotNullCheckWithElement:(id)element{
    NSAssert(!IsNull(element), @"element不能为空");
}


/** 按照element 查找节点 */
- (TreeNode *)__getNodeWithElement:(id)element{
    TreeNode *node = self.rootNode;
   
    while (node != nil) {
        NSInteger results = [self __compareWithE1:element e2:node.element];
        if (results == 0) {
            return node;
            
        }else if(results > 0){
            node = node.rightNode;
            
        }else{
            node = node.leftNode;
        }
    }
    
    return nil;
}



#pragma mark - print

- (id)root{
    return self.rootNode;
}


- (id)left:(TreeNode *)node{
    return node.leftNode;
}


- (id)right:(TreeNode *)node{
    return node.rightNode;
}


- (id)string:(TreeNode *)node{
    return node.element;
}

@end
