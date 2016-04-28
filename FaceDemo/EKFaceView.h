//
//  EKFaceView.h
//  FaceDemo
//
//  Created by sfwan on 15/12/10.
//  Copyright © 2015年 sfwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceItem, EKFaceView;

@protocol FaceViewDelegate <NSObject>

-(void)faceView:(EKFaceView *)faceView didSelectAtItem:(FaceItem *)item;
-(void)faceView:(EKFaceView *)faceView didDeleteAtItem:(FaceItem *)item;
-(void)faceViewDidSend:(EKFaceView *)faceView;

@end

@interface EKFaceView : UIView

@property (nonatomic, assign) id <FaceViewDelegate>delegate;

@end
