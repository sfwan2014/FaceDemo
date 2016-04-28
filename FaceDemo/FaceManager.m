//
//  FaceManager.m
//  FaceDemo
//
//  Created by sfwan on 15/12/10.
//  Copyright © 2015年 sfwan. All rights reserved.
//

#import "FaceManager.h"
#import "FaceItem.h"

@implementation FaceManager

+(NSArray *)resourceWithName:(NSString *)fileName{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
    return array;
}

+(NSArray *)faceListWithName:(NSString *)fileName{
    
    NSArray *array = [self resourceWithName:fileName];
    
    NSMutableArray *faces = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        FaceItem *item = [[FaceItem alloc] init];
        NSString *image = dic[@"image"];
        NSString *content = dic[@"content"];
        NSString *code = dic[@"code"];
        
        item.code = code;
        item.image = image;
        item.content = content;
        
        [faces addObject:item];
    }
    return faces;
}



@end
