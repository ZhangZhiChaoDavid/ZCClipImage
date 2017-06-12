//
//  PuzzleViewController.m
//  ZCClipImage
//
//  Created by 张智超 on 2016/6/8.
//  Copyright © 2016年 GeezerChao. All rights reserved.
//

#import "PuzzleViewController.h"
#define Main_Screen             [[UIScreen mainScreen] bounds].size
#define AnimationInterval       0.4f
#define imageInterval           3.0
#define imageFFF                self.image.size.width/3
#define imageViewFFF            (Main_Screen.width-14-4*imageInterval)/3

@interface PuzzleViewController ()

{
    NSInteger _tagMemory;
    CGRect _frameMemory;
}
@property(nonatomic,strong)UILabel *labelWhite;
@property(nonatomic,strong)UILabel *labelCount;
@property(nonatomic,assign)NSInteger count;

@end

@implementation PuzzleViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(140, Main_Screen.width-14+30+30+95, 170, 30);
    backButton.backgroundColor = [UIColor greenColor];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7, 30, Main_Screen.width-14, Main_Screen.width-14)];
    label.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, Main_Screen.width-14+30+30, 125, 125)];
    imageView.image = self.image;
    [self.view addSubview:imageView];
    
    self.labelCount = [[UILabel alloc] initWithFrame:CGRectMake(140, Main_Screen.width-14+30+30, 170, 30)];
    self.labelCount.backgroundColor = [UIColor cyanColor];
    self.labelCount.text = @"请滑动您的手指或点击拼图~";
    self.labelCount.font = [UIFont systemFontOfSize:13];
    self.labelCount.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.labelCount];
    
    for (int i = 0; i<9; i ++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(7+i%3*((imageViewFFF)+3)+3, 30+i/3*((imageViewFFF)+3)+3, (imageViewFFF), (imageViewFFF))];
        CGRect rect = CGRectMake(i/3*(imageFFF), i%3*(imageFFF), (imageFFF), (imageFFF));
        
        UIImage *ig = self.image;
        UIImage *subImage = [self clipImage:ig inRect:rect];
        image.image = subImage;
        image.userInteractionEnabled = YES;
        image.tag = 100 + i;
        [self.view addSubview:image];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClick:)];
        [image addGestureRecognizer:tap];
        
        if (i == 8) {
            _labelWhite = [[UILabel alloc] initWithFrame:image.frame];
            _labelWhite.backgroundColor = [UIColor whiteColor];
            _labelWhite.tag = 100 + i;
            [self.view addSubview:_labelWhite];
            [image removeFromSuperview];
        }
    }
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSWipe:)];
    upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:upSwipe];
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSWipe:)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:downSwipe];
    
    
}

-(void)downSWipe:(UISwipeGestureRecognizer *)downSwipe {
    
    if (_labelWhite.tag!=100&&_labelWhite.tag!=101&&_labelWhite.tag!=102) {
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:_labelWhite.tag - 3];
        
        if (imageView) {
            [self changeImage:imageView];
        }
    }
    
}

-(void)upSWipe:(UISwipeGestureRecognizer *)upSwipe {
    
    if (_labelWhite.tag!=106&&_labelWhite.tag!=107&&_labelWhite.tag!=108) {
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:_labelWhite.tag + 3];
        
        if (imageView) {
            [self changeImage:imageView];
        }
    }
    
}

-(void)rightSwipe:(UISwipeGestureRecognizer *)rightSwipe {
    
    if (_labelWhite.tag!=100&&_labelWhite.tag!=103&&_labelWhite.tag!=106) {
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:_labelWhite.tag - 1];
        
        if (imageView) {
            [self changeImage:imageView];
        }
    }
}

-(void)leftSwipe:(UISwipeGestureRecognizer *)leftSwipe {
    
    if (_labelWhite.tag!=102&&_labelWhite.tag!=105&&_labelWhite.tag!=108) {
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:_labelWhite.tag + 1];
        
        if (imageView) {
            [self changeImage:imageView];
        }
    }
}

-(void)tagClick:(UITapGestureRecognizer *)tap {
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:tap.view.tag];
    
    int labelX = _labelWhite.frame.origin.x;
    int labelY = _labelWhite.frame.origin.y;
    int imageX = imageView.frame.origin.x;
    int imageY = imageView.frame.origin.y;
    if ((labelX==imageX && (_labelWhite.tag==imageView.tag-3||_labelWhite.tag==imageView.tag+3)) ||
        (labelY==imageY && (_labelWhite.tag==imageView.tag-1||_labelWhite.tag==imageView.tag+1))    ) {
        
        [self changeImage:imageView];
    }
}

-(void)backClick:(UIButton *)button {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *)clipImage:(UIImage *)image inRect:(CGRect)rect {
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *subImage = [UIImage imageWithCGImage:imageRef];
    
    return subImage;
}

-(void)changeImage:(UIImageView *)imageView {
    
    [UIView animateWithDuration:AnimationInterval animations:^{
        _frameMemory = _labelWhite.frame;
        _labelWhite.frame = imageView.frame;
        imageView.frame = _frameMemory;
        _frameMemory = CGRectZero;
        
        _tagMemory = imageView.tag;
        imageView.tag = _labelWhite.tag;
        _labelWhite.tag = _tagMemory;
        _tagMemory = 0;
        
        _count ++;
        self.labelCount.text = [NSString stringWithFormat:@"您变换图片次数:%ld",(long)_count];
    }];
}


@end
