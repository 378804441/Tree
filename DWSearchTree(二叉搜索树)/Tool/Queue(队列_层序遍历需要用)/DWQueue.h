//
//  DWQueue.h
//  Queue(队列)
//
//  Created by 丁巍 on 2019/7/25.
//  Copyright © 2019 丁巍. All rights reserved.
//
//  队列


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DWQueue : NSObject

/** 获取队列大小 */
- (NSInteger)getSize;

/** 是否为空 */
- (BOOL)isEmpty;

/** 入队 */
- (void)enQueue:(id)element;

/** 出队 */
- (id)deQueue;

/** 获取队列头元素 */
- (id)front;

/** 清空队列 */
- (void)clear;

/** 打印队列中所有信息 */
- (void)printQueue;

@end

NS_ASSUME_NONNULL_END
