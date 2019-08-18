//
//  DWQueue.m
//  Queue(队列)
//
//  Created by 丁巍 on 2019/7/25.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "DWQueue.h"
#import "DWDoublyLinkedList.h"


@interface DWQueue()

@property (nonatomic, assign) NSInteger size;

/** 双向链表 */
@property (nonatomic, strong) DWDoublyLinkedList *linkList;

@end


@implementation DWQueue


- (instancetype)init{
    self = [super init];
    if (self) {
        self.linkList = [[DWDoublyLinkedList alloc] init];
    }
    return self;
}

#pragma mark - public method

/** 获取队列大小 */
- (NSInteger)getSize{
    return self.size;
}


/** 是否为空 */
- (BOOL)isEmpty{
    return self.size == 0;
}


/** 入队 */
- (void)enQueue:(id)element{
    [self.linkList addLastWithElement:element];
    self.size++;
}


/** 出队 */
- (id)deQueue{
    self.size--;
    return [self.linkList removeWithIndex:0];
}


/** 获取队列头元素 */
- (id)front{
    return [self.linkList getNodeWithIndex:0];
}


/** 清空队列 */
- (void)clear{
    
}


/** 打印队列中所有信息 */
- (void)printQueue{
    [self.linkList printAllLinkeListWithIndex:0];
}


@end
