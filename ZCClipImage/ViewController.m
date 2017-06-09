//
//  ViewController.m
//  ZCClipImage
//
//  Created by 张智超 on 2017/6/8.
//  Copyright © 2017年 GeezerChao. All rights reserved.
//

#import "ViewController.h"
#import "PuzzleViewController.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)UIButton *button;

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.button = ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake(0, 0, 100, 50);
        b.center = self.view.center;
        b.backgroundColor = [UIColor cyanColor];
        [b setTitle:@"选图" forState:UIControlStateNormal];
        [b setTintColor:[UIColor whiteColor]];
        [b addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:b];
        b;
    });
}

- (void)buttonClick:(UIButton *)button {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        NSLog(@"支持相片库");
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    NSLog(@"image==%@",image);
    NSLog(@"editingInfo==%@",editingInfo);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (image.size.width==image.size.height) {
            PuzzleViewController *vc = [[PuzzleViewController alloc] init];
            vc.image = image;
            [self presentViewController:vc animated:YES completion:nil];
        }
        else {
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"这里需要正方形图片" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            [vc addAction:sure];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
