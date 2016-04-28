//
//  EKFaceView.m
//  FaceDemo
//
//  Created by sfwan on 15/12/10.
//  Copyright © 2015年 sfwan. All rights reserved.
//

#import "EKFaceView.h"
#import "FaceManager.h"
#import "FaceItemView.h"

#define kBottomViewHeight  35
#define kPagePointHeight    10

@interface EKFaceView ()<UIScrollViewDelegate>

@end

@implementation EKFaceView{
    UIScrollView *_scrollView;
    NSMutableArray *_faceItemViews;
    UIPageControl *_pageControl;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        [self _initBaseView];
        
        [self _initBottomView];
        
        [self _initFaceItemView];
    }
    return self;
}

-(NSArray *)faceItemList{
    NSArray *array = [FaceManager faceListWithName:@"face.plist"];
    
    return array;
}

-(void)_initBaseView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kBottomViewHeight - kPagePointHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}

-(void)_initBottomView{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kBottomViewHeight - kPagePointHeight, self.frame.size.width, kPagePointHeight)];
    _pageControl.numberOfPages = 4;
    [self addSubview:_pageControl];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kBottomViewHeight, self.frame.size.width, kBottomViewHeight)];
    bottomView.backgroundColor = [UIColor grayColor];
    [self addSubview:bottomView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((bottomView.frame.size.width - 40 - 8), (bottomView.frame.size.height - 26)/2.0, 40, 26);
    button.backgroundColor = [UIColor colorWithRed:0.4 green:0.3 blue:0.9 alpha:1];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5.0;
    [button setTitle:@"发送" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [bottomView addSubview:button];
}

-(void)_initFaceItemView{
    _faceItemViews = [NSMutableArray array];
    NSArray *faces = self.faceItemList;
    
    int maxRow = 3;
    int maxCol = 7;
    CGFloat itemWidth = _scrollView.frame.size.width / maxCol;
    CGFloat itemHeight = _scrollView.frame.size.height / maxRow;
    
    int page = (int)faces.count/(3*7);
    if (faces.count%(3*7)>0) {
        page ++;
    }
    _pageControl.numberOfPages = page;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * page, _scrollView.frame.size.height);
    
    int index = 0;
    int count = 0;
    for (int p = 0; p < page; p++) {
        CGFloat pf = _scrollView.frame.size.width * p;
        for (int row = 0; row < maxRow; row++) {
            for (int col = 0; col < maxCol; col++) {
                if (index < [faces count]) {
                    
                    if (count == 20 + 20 * p) {
                        continue;
                    } else {
                        
                        FaceItemView *button = [FaceItemView buttonWithType:UIButtonTypeCustom];
                        [button setBackgroundColor:[UIColor clearColor]];
                        [button setFrame:CGRectMake(pf + col * itemWidth, row * itemHeight, itemWidth, itemHeight)];
                        button.tag = row * maxCol + col;
                        [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                        [_scrollView addSubview:button];
                        
                        FaceItem *item = faces[index];
                        [button setImage:[UIImage imageNamed:item.image] forState:UIControlStateNormal];
                        
                        button.item = item;
                        
                        index ++;
                    }
                    
                    
                    count++;
                }
                else{
                    break;
                }
            }
        }
        
        FaceItem *item = [[FaceItem alloc] init];
        item.code = @"delete";
        item.image = @"cancel";
        item.content = @"delete";
        
        FaceItemView *button = [FaceItemView buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setFrame:CGRectMake(pf + (maxCol-1) * itemWidth, (maxRow-1) * itemHeight, itemWidth, itemHeight)];
        [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        [button setImage:[UIImage imageNamed:item.image] forState:UIControlStateNormal];
        
        button.item = item;
    }
    
}

#pragma mark - -button action
-(void)selected:(FaceItemView *)button{
    if ([button.item.code isEqualToString:@"delete"]) {
        if ([self.delegate respondsToSelector:@selector(faceView:didDeleteAtItem:)]) {
            [self.delegate faceView:self didDeleteAtItem:button.item];
        }
    } else{
        if ([self.delegate respondsToSelector:@selector(faceView:didSelectAtItem:)]) {
            [self.delegate faceView:self didSelectAtItem:button.item];
        }
    }
    
    
}

-(void)sendAction:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(faceViewDidSend:)]) {
        [self.delegate faceViewDidSend:self];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        CGFloat width = scrollView.frame.size.width;
        CGFloat contentOfsetX = scrollView.contentOffset.x;
        
        int page = contentOfsetX/width;
        _pageControl.currentPage = page;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat width = scrollView.frame.size.width;
    CGFloat contentOfsetX = scrollView.contentOffset.x;
    
    int page = contentOfsetX/width;
    _pageControl.currentPage = page;
}

@end
