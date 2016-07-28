//
//  YMTreeNode.h
//  YMTreeTableViewDemo
//
//  Created by dengjc on 16/7/28.
//  Copyright © 2016年 dengjc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMTreeNode : NSObject

@property (nonatomic,copy) NSString *nodeName;

@property (nonatomic,copy) NSString *parentNode;

@property (nonatomic,assign) NSInteger nodeDepth;

@property (nonatomic,assign) BOOL expanded;

- (instancetype)initWithName:(NSString*)name parent:(NSString*)parent depth:(NSInteger)depth expanded:(BOOL)expanded;

@end
