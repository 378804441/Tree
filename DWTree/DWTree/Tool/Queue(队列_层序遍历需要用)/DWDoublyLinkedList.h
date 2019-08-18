//
//  DWDoublyLinkedList.h
//  Queue(队列)
//
//  Created by 丁巍 on 2019/7/25.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DWDoublyLinkedList : NSObject

/** 获取指定节点内容 */
- (id)getNodeWithIndex:(NSInteger)index;

/** 插入到尾结点 */
- (void)addLastWithElement:(id)element;

/** 插入节点 */
- (void)addWithElement:(id)element index:(NSInteger)index;

/** 删除尾结点 */
- (id)removeLastNode;

/** 删除指定节点 */
- (id)removeWithIndex:(NSInteger)index;

/** 获取链表大小 */
- (NSInteger)getSize;

/** 是否为空 */
- (BOOL)isEmpty;

/** 打印出所有链表里的元素 */
- (void)printAllLinkeListWithIndex:(NSInteger)index;

@end



@interface NodeClass : NSObject

/** 下一个节点 */
@property (nonatomic, strong) NodeClass * __nullable nextNode;

/** 上一个节点 */
@property (nonatomic, strong) NodeClass * __nullable prevNode;

/** 存储内容 */
@property (nonatomic, strong) id         __nullable element;

/** 初始化 */
- (instancetype)initNodeWithPrevNode:(NodeClass *__nullable)prevNode  element:(id __nullable)element nextNode:(NodeClass * __nullable)nextNode;

@end

NS_ASSUME_NONNULL_END
