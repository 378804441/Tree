//
//  DWSearchTreeProtocol.h
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/8.
//  Copyright © 2019 丁巍. All rights reserved.
//

//  比对协议

@protocol DWSearchTreeProtocol <NSObject>
@optional

/** 自定义比对方法 */
- (int)comparableTo:(id)element;

@end
