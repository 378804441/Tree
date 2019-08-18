//
//  DWDoublyLinkedList.m
//  Queue(队列)
//
//  Created by 丁巍 on 2019/7/25.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "DWDoublyLinkedList.h"

@interface DWDoublyLinkedList()

/** 链表大小 */
@property (nonatomic, assign) NSInteger size;

/** 头结点 */
@property (nonatomic, strong) NodeClass *firstNode;

/** 尾节点 */
@property (nonatomic, strong) NodeClass *lastNode;

@end


@implementation DWDoublyLinkedList


#pragma mark - public method


/** 打印出所有链表里的元素 */
- (void)printAllLinkeListWithIndex:(NSInteger)index{
    NSMutableString *str = [[NSString stringWithFormat:@"size=%ld  [", self.size] mutableCopy];
    NodeClass *node = self.firstNode;
    
    for (int i=0; i<self.size; i++) {
        
        if (i != 0) {
            [str appendString:@", "];
        }
        
        [str appendFormat:@"%@", node.element];
        
        node = node.nextNode;
    }
    
    [str appendFormat:@"]"];
    
    NSLog(@"链表内所有数据   :   %@", str);
}


/** 获取指定节点内容 */
- (id)getNodeWithIndex:(NSInteger)index{
    return [self __getNodeWithIndex:index].element;
}


/** 插入到尾结点 */
- (void)addLastWithElement:(id)element{
    [self addWithElement:element index:self.size];
}


/** 插入节点 */
- (void)addWithElement:(id)element index:(NSInteger)index{
    [self __rangeCheckWithIndex:index];
    
    // 尾节点
    if (index == self.size) {
        NodeClass *lastNode = self.lastNode;
        
        self.lastNode = [[NodeClass alloc] initNodeWithPrevNode:lastNode element:element nextNode:nil];
        
        // 链表尾空的话  直接  头结点 跟 尾结点相同
        if (lastNode == nil) {
            self.firstNode = self.lastNode;
        }else{
            lastNode.nextNode = self.lastNode;
        }
        
    }else{
        
        NodeClass *nextNode = [self __getNodeWithIndex:index];
        NodeClass *prevNode = nextNode.prevNode;
        NodeClass *newNode  = [[NodeClass alloc] initNodeWithPrevNode:prevNode element:element nextNode:nextNode];
        
        // 插入到头结点
        if (index == 0) {
            self.firstNode    = newNode;
        }else{
            prevNode.nextNode = newNode;
        }
        
        nextNode.prevNode   = newNode;
    }
    
    self.size++;
}


/** 删除尾结点 */
- (id)removeLastNode{
    return [self removeWithIndex:self.size];
}


/** 删除指定节点 */
- (id)removeWithIndex:(NSInteger)index{
    [self __rangeCheckWithIndex:index];
    
    NodeClass *node = [self __getNodeWithIndex:index];
    NodeClass *prevNode = node.prevNode;
    NodeClass *nextNode = node.nextNode;
    
    // 头结点
    if (prevNode == nil) {
        self.firstNode = nextNode;
        
    // 非头结点
    } else {
        prevNode.nextNode = nextNode;
    }
    
    
    // 尾结点
    if (nextNode == nil) {
        self.lastNode = prevNode;
        
    // 非尾结点
    } else {
        nextNode.prevNode = prevNode;
    }
    
    self.size--;
    return node.element;
    
}


/** 获取链表大小 */
- (NSInteger)getSize{
    return self.size;
}


/** 是否为空 */
- (BOOL)isEmpty{
    return !self.size;
}



#pragma mark - private method

/** 检查索引合法性 */
- (void)__rangeCheckWithIndex:(NSInteger)index{
    if (index < 0 ) {
        index = 0;
    }else if (index > self.size) {
        index = self.size;
    }
}


/** 获取指定节点 */
- (NodeClass *)__getNodeWithIndex:(NSInteger)index{
    [self __rangeCheckWithIndex:index];
    
    NodeClass *node;
    // 前半段
    if (index < self.size/2) {
        node = self.firstNode;
        for (int i=0; i<index; i++) {
            node = node.nextNode;
        }
        
        // 后半段
    }else{
        node = self.lastNode;
        for (long i=self.size-1; i>index; i--) {
            node = node.prevNode;
        }
    }
    
    return node;
}


@end



@implementation NodeClass

- (instancetype)initNodeWithPrevNode:(NodeClass *__nullable)prevNode  element:(id __nullable)element nextNode:(NodeClass * __nullable)nextNode{
    self = [super init];
    if (self) {
        self.prevNode = prevNode;
        self.element  = element;
        self.nextNode = nextNode;
    }
    return self;
}

@end
