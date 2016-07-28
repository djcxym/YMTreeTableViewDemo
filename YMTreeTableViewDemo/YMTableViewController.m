//
//  YMTableViewController.m
//  YMTreeTableViewDemo
//
//  Created by dengjc on 16/7/28.
//  Copyright © 2016年 dengjc. All rights reserved.
//

#import "YMTableViewController.h"
#import "YMTreeNode.h"

@interface YMTableViewController ()

@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,strong) NSDictionary *contents;

@end

@implementation YMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 50;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    NSString *file = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    _contents = [NSDictionary dictionaryWithContentsOfFile:file];
    _data = [[self queryDataWithParent:@"" andDepth:1] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    YMTreeNode *node = _data[indexPath.row];
    cell.textLabel.text = node.nodeName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indentationLevel = node.nodeDepth;
    cell.indentationWidth = 10.0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YMTreeNode *node = _data[indexPath.row];
    if (node.expanded) {//已展开，则收回
        NSInteger startPosition = indexPath.row+1;
        NSInteger endPosition = startPosition;
        for (NSInteger i=startPosition; i<_data.count; i++) {
            YMTreeNode *subNode = _data[i];
            if (subNode.nodeDepth<=node.nodeDepth) {
                endPosition = i;
                break;
            }
            endPosition++;
        }
        if (endPosition == startPosition) {
            [self alert];
        } else {
            [_data removeObjectsInRange:NSMakeRange(startPosition, endPosition -  startPosition)];
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (NSUInteger i=startPosition; i<endPosition; i++) {
                NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:tempIndexPath];
            }
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
    } else {//未展开，则展开
        NSArray *dataInsert = [self queryDataWithParent:node.nodeName andDepth:node.nodeDepth + 1];
        if (dataInsert.count == 0) {
            [self alert];
        } else {
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (NSInteger i = 0; i<dataInsert.count; i++) {
                YMTreeNode *node = dataInsert[i];
                [self.data insertObject:node atIndex:indexPath.row + i + 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row + i + 1 inSection:0]];
            }
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            //        [self.tableView reloadData];
        }
    }
    node.expanded = !node.expanded;
}

- (NSArray*)queryDataWithParent:(NSString*)parent andDepth:(NSInteger)depth {
    NSMutableArray *result = [NSMutableArray array];
    id tempData = [_contents objectForKey:[NSString stringWithFormat:@"%ld",depth]];
    if ([tempData isKindOfClass:[NSDictionary class]]) {
        tempData = [tempData objectForKey:parent];
    }
    for (NSString *name in tempData) {
        YMTreeNode *node = [[YMTreeNode alloc]initWithName:name parent:parent depth:depth expanded:NO];
        [result addObject:node];
    }
    return result;
}

- (void)alert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"到根结点了" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
