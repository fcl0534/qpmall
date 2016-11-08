//
//  QPMPaymentSeparateView.m
//  Trendpower
//
//  Created by 张帅 on 16/11/7.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "QPMPaymentSeparateView.h"

#import "QPMPaymentSeparateModel.h"

#import "QPMPaymentSeparateCell.h"

static NSString *cellID = @"QPMPaymentSeparateCell";

@interface QPMPaymentSeparateView ()<UITableViewDataSource,UITableViewDelegate,QPMPaymentSeparateCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *showView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QPMPaymentSeparateView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QPMPaymentSeparateCell class]) bundle:nil] forCellReuseIdentifier:cellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    QPMPaymentSeparateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.models[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - QPMPaymentSeparateCellDelegate
- (void)toSettleAccounts:(NSInteger)sellerId {
    if ([self.delegate respondsToSelector:@selector(toSettleAccounts:)]) {
        [self.delegate toSettleAccounts:sellerId];
    }
}

#pragma mark - event response
- (IBAction)closeView:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, K_UIScreen_HEIGHT, K_UIScreen_WIDTH, K_UIScreen_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, K_UIScreen_HEIGHT-K_UIScreen_HEIGHT/2, K_UIScreen_WIDTH, K_UIScreen_HEIGHT);
    } completion:^(BOOL finished) {

    }];
}

-(void)hide {

    [self removeFromSuperview];
}

@end
