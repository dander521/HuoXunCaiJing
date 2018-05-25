//
//  RCHttpApiConst.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/24.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCHttpApiConst : NSObject


extern NSString * const appId;
extern NSString * const appSecret;

extern NSString * const httpHost;

/**  */
extern NSString * const getAccess;
/**  */
extern NSString * const postPincode;

/**  */
extern NSString * const getRegister;
/**  */
extern NSString * const postLogin;
/**  */
extern NSString * const postFindPwd;

/**  */
extern NSString * const getBanner;
/**  */
extern NSString * const getHXNoOrNewsCategory;
/**  */
extern NSString * const getNewsOrHXNoList;
/**  */
extern NSString * const getNewsOrHXNoDetail;
/**  */
extern NSString * const getAuthorInfo;
/**  */
extern NSString * const getProjectList;
/**  */
extern NSString * const getProjectDetail;
/**  */
extern NSString * const getFlashList;

/**  */
extern NSString * const getMyInfo;
/**  */
extern NSString * const postAttention;
/**  */
extern NSString * const getAttentionList;
/**  */
extern NSString * const postFeedback;
/**  */
extern NSString * const postModifySecret;
/**  */
extern NSString * const postModifyInfo;
/**  */
extern NSString * const postModifyPhone;
/**  */
extern NSString * const postModifyAvatar;

/**  */
extern NSString * const postCollection;
/**  */
extern NSString * const getShare;
/**  */
extern NSString * const postPraise;
/**  */
extern NSString * const getMyActionList;

extern NSString * const getVerifyType;
extern NSString * const postVerifyFile;
extern NSString * const postVerifyInfo;

extern NSString * const getMyVerifyInfo;
extern NSString * const getJuHe;

extern NSString * const getHeatList;
extern NSString * const postComment;
extern NSString * const getCommentList;
extern NSString * const postRemoveFans;
extern NSString * const postCommentPraise;

/********************V2************************/

extern NSString * const getBindWeChat;
extern NSString * const postBindPhone;
extern NSString * const getSugarGive;
extern NSString * const getSugarNotes;
extern NSString * const getSugarShareLog;
extern NSString * const getSugarRechargeLog;
extern NSString * const getMySugar;
extern NSString * const getSugarNotify;
extern NSString * const getPlacard;
extern NSString * const getUnbindWeChat;
extern NSString * const postBindWeChat;

extern NSString * const getRechargeRule;
extern NSString * const postRechargeAdd;

extern NSString * const getLatestNewsOrFlash;

extern NSString * const getDeleteAttention;
extern NSString * const getDeleteReadHistory;
extern NSString * const getIsReg;
/********************V2************************/

@end
