//
//  BViewController.m
//  DemoEdit
//
//  Created by CHLMA2015 on 2018/10/28.
//  Copyright © 2018年 MACHUNLEI. All rights reserved.
//

#import "BViewController.h"
#import <objc/runtime.h>



@interface BViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UIView *bottmView;

@property(nonatomic, strong) NSMutableSet *mSet;

@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 375, 667-64)];
    sc.contentSize = CGSizeMake(375*5, 667-64);
    sc.pagingEnabled = YES;
    [self.view addSubview:sc];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 667, 375, 100)];
    bottomView.backgroundColor = [UIColor redColor];
    self.bottmView = bottomView;
    [self.view addSubview:bottomView];
    
    for (int i= 0; i<5;i++) {
       
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(i*375, 0, 375, CGRectGetHeight(sc.frame)) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.tag = 100 + i;
        [sc addSubview:table];
    }
    
    [btn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(sc)];

    self.mSet = [NSMutableSet new];
    [self.mSet addObject:@(1)];
    [self.mSet addObject:@(2)];
    [self.mSet addObject:@(3)];
    
    
    [self addObserver:self forKeyPath:@"mSet" options:NSKeyValueObservingOptionNew context:nil];
    

    
    [[self mutableSetValueForKeyPath:@"mSet"] addObject:@(4)];
    [[self mutableSetValueForKeyPath:@"mSet"] addObject:@(5)];

    
}

- (void)editAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selected"]) {
        BOOL res = [change[NSKeyValueChangeNewKey] boolValue];
        UIScrollView *sc = (__bridge UIScrollView *)context;
        sc.scrollEnabled = !res;
        
        int place = sc.contentOffset.x/375;
        
        UITableView *tab = [sc viewWithTag:place+100];
        
        if (res) {
            
            [UIView animateWithDuration:0.25 animations:^{
                tab.frame = CGRectMake(tab.frame.origin.x, 0, 375, 667 - 64 - 100);
                self.bottmView.frame = CGRectMake(0, 667-100, 375, 100);
            }];
            
        }else{

            [UIView animateWithDuration:0.25 animations:^{
                tab.frame = CGRectMake(tab.frame.origin.x, 0, 375, 667 - 64);
                self.bottmView.frame = CGRectMake(0, 667, 375, 0);
            }];
            
        }
    }
    
    if ([keyPath isEqualToString:@"mSet"]) {
        
        
        NSLog(@"count = %d",self.mSet.count);
        
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[self mutableSetValueForKeyPath:@"mSet"] removeObject:@(indexPath.row)];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
