//
//  YMTreeNode.m
//  YMTreeTableViewDemo
//
//  Created by dengjc on 16/7/28.
//  Copyright © 2016年 dengjc. All rights reserved.
//

#import "YMTreeNode.h"

@implementation YMTreeNode

- (instancetype)initWithName:(NSString*)name parent:(NSString*)parent depth:(NSInteger)depth expanded:(BOOL)expanded {
    if (self = [super init]) {
        _nodeName = name;
        _parentNode = parent;
        _nodeDepth = depth;
        _expanded = expanded;
    }
    return self;
}
@end
