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
#import "DWSearchTreeProtocol.h"
#import "Person.h"
#import "TreeAlgorithmTool.h"


@interface DWSearchTree()

/** 比较器 */
@property (nonatomic, strong) id <DWComparatorProtocol>comparator;

@end


@implementation DWSearchTree

- (instancetype)init{
    return [self initTreeWithComparator:nil];
}


/**
 * 初始化方法
 * comparator : 自定义比较器
 */
- (instancetype)initTreeWithComparator:(id <DWComparatorProtocol> __nullable)comparator{
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
        cmp = [self.comparator comparableWithE1:element e2:tempNode.element];
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
        // 更改父节点指向
        replacement.parentNode = node.parentNode;
        
        // 根节点
        if (IsNull(node.parentNode)){
            self.rootNode = replacement;
            
        }else if (node == node.parentNode.leftNode) {
            node.parentNode.leftNode = replacement;
            
        }else if(node == node.parentNode.rightNode){
            node.parentNode.rightNode = replacement;
        }
        
    // 根节点
    } else if(IsNull(node.parentNode)){
        self.rootNode = nil;
        
    // 叶子节点
    }else{
        if (node == node.parentNode.leftNode) {
            node.parentNode.leftNode  = nil;
            
        }else if (node == node.parentNode.rightNode){
            node.parentNode.rightNode = nil;
        }
    }
}



/**
 俩对象进行比对
 负数, 当前年龄小于传进来的年龄
 正数, 当前年龄大于传来的年龄
 0,   俩个年龄相同
 */
- (NSInteger)compareWithE1:(id)e1 e2:(id)e2{
    if (!IsNull(self.comparator)) {
        return [self.comparator comparableWithE1:e1 e2:e2];
    }
    
    // 没有指定自定义比较器, 用默认的比较器 (DWSearchTreeProtocol)
    NSAssert([e1 conformsToProtocol:@protocol(DWSearchTreeProtocol)], @"添加对象请遵循 DWSearchTreeProtocol 协议");
    
    id <DWSearchTreeProtocol>tempE1 = e1;
    return [tempE1 comparableTo:e2];
}


/** 检测element是否为空 */
- (void)__elementNotNullCheckWithElement:(id)element{
    NSAssert(!IsNull(element), @"element不能为空");
}


/** 按照element 查找节点 */
- (TreeNode *)__getNodeWithElement:(id)element{
    TreeNode *node = self.rootNode;
   
    while (node != nil) {
        NSInteger results = [self compareWithE1:element e2:node.element];
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
    return @([((Person *)node.element) getAge]);
}

@end
