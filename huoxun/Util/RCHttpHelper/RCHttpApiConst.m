//
//  RCHttpApiConst.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/24.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "RCHttpApiConst.h"

@implementation RCHttpApiConst

NSString * const appId = @"20180204535685871";
NSString * const appSecret = @"cY99zYY04zBfkGcqp2T0YTmcbFLTY6sguHHs+PzKDLH1Y9MKc+6pgKYGrkFzg5TNeJMFKM8sIYH7HayYyBFE3V1bcHXAgMBAAECggEAMeM7ZCUZqaqja5";

/** http host */
NSString * const httpHost = @"http://huoxun.com/api/v1";

/**  */
NSString * const getAccess = @"/sign";
/**  */
NSString * const postPincode = @"/sendcode";

/**  */
NSString * const getRegister = @"/register";
/**  */
NSString * const postLogin = @"/login";
/**  */
NSString * const postFindPwd = @"/find_pwd";

/**  */
NSString * const getBanner = @"/slider";
/**  */
NSString * const getHXNoOrNewsCategory = @"/hot_nav";
/**  */
NSString * const getNewsOrHXNoList = @"/hot_list";
/**  */
NSString * const getNewsOrHXNoDetail = @"/hot_detail";
/**  */
NSString * const getAuthorInfo = @"/heinfo";
/**  */
NSString * const getProjectList = @"/project_list";
/**  */
NSString * const getProjectDetail = @"/project_detail";
/**  */
NSString * const getFlashList = @"/fast";

/**  */
NSString * const getMyInfo = @"/myinfo";
/**  */
NSString * const postAttention = @"/attention";
/**  */
NSString * const getAttentionList = @"/attention_list";
/**  */
NSString * const postFeedback = @"/feedback";
/**  */
NSString * const postModifySecret = @"/set_pwd";
/**  */
NSString * const postModifyInfo = @"/set_myinfo";
/**  */
NSString * const postModifyPhone = @"/edit_phone";
/**  */
NSString * const postModifyAvatar = @"/set_face";

/**  */
NSString * const postCollection = @"/collect";
/**  */
NSString * const getShare = @"/share";
/**  */
NSString * const postPraise = @"/praise";
/**  */
NSString * const getMyActionList = @"/my_list";

NSString * const getVerifyType = @"/verified_type";
NSString * const postVerifyFile = @"/upload_img";
NSString * const postVerifyInfo = @"/verified";

NSString * const getMyVerifyInfo = @"/my_verified";
NSString * const getJuHe = @"/juhe";

NSString * const getHeatList = @"/heat_list";
NSString * const postComment = @"/add_comment";
NSString * const getCommentList = @"/comment_list";

NSString * const postRemoveFans = @"/remove_fans";
NSString * const postCommentPraise = @"/comment_praise";


/********************V2************************/

NSString * const getBindWeChat = @"/is_bound_wechat";
NSString * const postBindPhone = @"/bound_phone";
NSString * const getSugarGive = @"/sugar_give";
NSString * const getSugarNotes = @"/sugar_notes";
NSString * const getSugarShareLog = @"/sugar_sharelog";
NSString * const getSugarRechargeLog = @"/sugar_rechargelog";
NSString * const getMySugar = @"/sugar_mysugar";
NSString * const getSugarNotify = @"/sugar_notify";
NSString * const getPlacard = @"/placard";
NSString * const getUnbindWeChat = @"/unbound_wechat";
NSString * const postBindWeChat = @"/bound_wechat"; // openid   

NSString * const getRechargeRule = @"/recharge_rule";
NSString * const postRechargeAdd = @"/recharge_add";

NSString * const getLatestNewsOrFlash = @"/get_count";

NSString * const getDeleteAttention = @"/del_notify";
NSString * const getDeleteReadHistory = @"/del_history";
NSString * const getIsReg = @"/isreg";
/********************V2************************/

@end

