//
//  HXCoinModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/7.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCoinModel : NSObject

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *rank;
// 市值
@property (nonatomic, strong) NSString *price_usd;
@property (nonatomic, strong) NSString *price_btc;
//@property (nonatomic, strong) NSString *24h_volume_usd;
@property (nonatomic, strong) NSString *market_cap_usd;
@property (nonatomic, strong) NSString *available_supply;
@property (nonatomic, strong) NSString *total_supply;
@property (nonatomic, strong) NSString *percent_change_1h;
// 涨跌幅
@property (nonatomic, strong) NSString *percent_change_24h;
@property (nonatomic, strong) NSString *percent_change_7d;
@property (nonatomic, strong) NSString *last_updated;
// 币种价格
@property (nonatomic, strong) NSString *price_cny;
//@property (nonatomic, strong) NSString *24h_volume_cny;
@property (nonatomic, strong) NSString *market_cap_cny;
@property (nonatomic, strong) NSString *history;
// 成交额
@property (nonatomic, strong) NSString *bargain;


@end
