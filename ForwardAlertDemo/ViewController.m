//
//  ViewController.m
//  ForwardAlertDemo
//
//  Created by Lester on 16/9/12.
//  Copyright © 2016年 Lester-iOS开发:98787555. All rights reserved.
//

#import "ViewController.h"
#import "ForwardAlert.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSArray *)data{
    return @[@[@"微信单个好友转发图片",@"微信单个好友转发文字",@"微信单个好友转发Gif"],@[@"微信多个好友转发图片",@"微信多个好友转发文字",@"微信多个好友转发Gif"]];
}

#pragma mark - TableView DataSource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"lester";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.data[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        switch (indexPath.row) {
            case 0:
            {
                [[[ForwardAlert alloc]initWithTitle:@"车当当信息科技" images:@[@"test.png"] content:@"testImage.jpg" contentType:Content_Image buttonHandler:^(NSInteger buttonClickIndex) {
                    
                }] show];
            }
                break;
            case 1:{
                [[[ForwardAlert alloc]initWithTitle:@"车当当信息科技" images:@[@"test.png"] content:@"9 月 8 日 (北美太平洋时间 2016 年 9 月 7 日上午 10 点)凌晨消息==9 月 8 日 (北美太平洋时间 2016 年 9 月 7 日上午 10 点)凌晨消息" contentType:Content_Text buttonHandler:^(NSInteger buttonClickIndex) {
                    
                }] show];
            }
                break;
            case 2:{
                [[[ForwardAlert alloc]initWithTitle:@"车当当信息科技" images:@[@"test.png"] content:@"testgif" contentType:Content_Gif buttonHandler:^(NSInteger buttonClickIndex) {
                    
                }] show];
            }
                break;
            default:
                break;
        }
    }
    else{
        switch (indexPath.row) {
            case 0:
            {
                [[[ForwardAlert alloc]initWithTitle:@"车当当信息科技" images:@[@"test.png",@"test.png",@"test.png",@"test.png",@"test.png"] content:@"testImage.jpg" contentType:Content_Image buttonHandler:^(NSInteger buttonClickIndex) {
                    
                }] show];
            }
                break;
            case 1:{
                [[[ForwardAlert alloc]initWithTitle:@"车当当信息科技" images:@[@"test.png",@"test.png",@"test.png",@"test.png",@"test.png",@"test.png",@"test.png"] content:@"9 月 8 日 (北美太平洋时间" contentType:Content_Text buttonHandler:^(NSInteger buttonClickIndex) {
                    
                }] show];
            }
                break;
            case 2:{
                [[[ForwardAlert alloc]initWithTitle:@"车当当信息科技" images:@[@"test.png",@"test.png",@"test.png",@"test.png",@"test.png",@"test.png",@"test.png"] content:@"testgif" contentType:Content_Gif buttonHandler:^(NSInteger buttonClickIndex) {
                    
                }] show];
            }
                break;
            default:
                break;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
