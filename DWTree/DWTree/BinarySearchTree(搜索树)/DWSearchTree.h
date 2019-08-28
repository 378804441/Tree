//
//  DWSearchTree.h
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/6.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNode.h"
#import "DWComparatorProtocol.h"
#import "MJBinaryTreeInfo.h"


NS_ASSUME_NONNULL_BEGIN

#define IsNull(obj)   (obj == nil || [obj isEqual:[NSNull null]])

@interface DWSearchTree : NSObject<MJBinaryTreeInfo>


#pragma mark - public property

/** 树size */
@property (nonatomic, assign) NSInteger size;

/** 根节点 */
@property (nonatomic, strong) TreeNode  * __nullable rootNode;



#pragma mark - public method

/**
 * 初始化方法
 * comparator : 自定义比较器
 */
- (instancetype)initTreeWithComparator:(id <DWComparatorProtocol>)comparator;

/** 添加元素 */
- (void)addWithElement:(id)element;

/** 层序遍历 */
- (void)levelOrderTraversalWithVisitorBlock:(void (^)(id _Nonnull visitorData))visitorBlock;

/** 中序遍历 */
- (void)inorderTraversal;

/** 删除元素 */
- (void)removeWithElement:(id)element;

/** 按照 element 获取节点 */
- (TreeNode *)checkWithElement:(id)element;


#pragma mark - 虚方法

/** 添加节点后需要做的方法, 子类自定义去实现 (例 : 二叉树进行节点插入后 AVL树需要进行 旋转平衡逻辑就可以重写该方法) */
- (void)afterAddWithNode:(id)node;

/** 删除节点后需要做的方法, 子类自定义去实现 (例 : 二叉树进行节点插入后 AVL树需要进行 旋转平衡逻辑就可以重写该方法) */
- (void)afterRemoveWithNode:(id)node;

/** 创建node节点 默认返回 TreeNode 对象,  如果需要 子类特殊的节点，重写该方法 返回 自定义节点即可 */
- (id)createNodeWithParent:(id __nullable)parent element:(id __nullable)element;


@end


NS_ASSUME_NONNULL_END
