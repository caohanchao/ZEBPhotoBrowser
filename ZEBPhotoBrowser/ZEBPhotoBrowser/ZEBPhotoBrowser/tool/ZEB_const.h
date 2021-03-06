//
//  const.h
//  ZEBPhotoBrowser
//
//  Created by zeb－Apple on 17/1/5.
//  Copyright © 2017年 zeb. All rights reserved.
//

#ifndef ZEBPhotoBrowser_const_h
#define ZEBPhotoBrowser_const_h

#define kScreenRect [UIScreen mainScreen].bounds
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenRatio kScreenWidth / kScreenHeight
#define kScreenMidX CGRectGetMaxX(kScreenRect)
#define kScreenMidY CGRectGetMaxY(kScreenRect)

#define filePath(fileName)  NSString  *filepath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource: ofType:nil]

#define isGifURL(Url) [Url hasSuffix:@"gif"] && [dict[@"thumbnailUrl"] hasPrefix:@"http"] || [dict[@"thumbnailUrl"] hasPrefix:@"https"]

#define isGifPicture(fileName) [fileName hasSuffix:@"gif"]

#endif
