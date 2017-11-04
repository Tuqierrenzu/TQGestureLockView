//
//  TQViewController.m
//  TQGestureLockViewDemo
//
//  Created by TQTeam on 11/03/2017.
//  Copyright (c) 2017 TQTeam. All rights reserved.
//

#import "TQViewController.h"
#import "TQViewController1.h"
#import "TQViewController2.h"

@interface TQViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;;

@end

@implementation TQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navBarInitialization];
    
    [self dataInitialization];
    
    [self subviewsInitialization];
}


- (void)navBarInitialization
{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;
}

- (void)dataInitialization
{
    _titles = [NSMutableArray array];
    _classNames = [NSMutableArray array];
    
    [self addTitle:@"设置手势密码" class:@"TQViewController1"];
    [self addTitle:@"验证手势密码" class:@"TQViewController2"];
}

- (void)addTitle:(NSString *)title class:(NSString *)className
{
    [_titles addObject:title];
    [_classNames addObject:className];
}

- (void)subviewsInitialization
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delaysContentTouches = NO;
        _tableView.rowHeight = 70;
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        _tableView.tableFooterView = [UIView new];
    }
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = _classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *vc = [[class alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.navigationItem.title = _titles[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

