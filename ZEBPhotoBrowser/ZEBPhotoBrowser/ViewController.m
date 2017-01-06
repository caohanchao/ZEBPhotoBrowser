//
//  ViewController.m
//  ZEBPhotoBrowser Demo
//
//  Created by zeb－Apple on 17/1/5.
//  Copyright © 2017年 zeb－Apple. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCell.h"
#import "ZEBPhotoBrowser.h"
#import <UIImageView+WebCache.h>
#import <UIImage+GIF.h>
#import "ZEB_const.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>
{
    BOOL _localImage;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *originalImages;
@property (nonatomic, strong) NSMutableArray *URLStrings;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _URLStrings = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    [self getWebImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


#pragma mark collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _localImage ? _images.count : _URLStrings.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    if (_localImage) {
        cell.imageView.image = self.images[indexPath.row];
    }
    else {
//        NSString *gif = @"gif";
        NSDictionary *dict = _URLStrings[indexPath.row];
        NSString *url =dict[@"thumbnailUrl"];
        if (isGifPicture(url)) {
            if (isGifURL(url)) {
//                UIImage * image = [UIImage sd_animatedGIFNamed:<#(NSString *)#>]
            } else {
//                NSString  *filepath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:url ofType:nil];
//                NSData *data = [NSData dataWithContentsOfFile:filepath];
                cell.imageView.image = [UIImage sd_animatedGIFNamed:[[url componentsSeparatedByString:@"."] firstObject]];
            }
            
        }else {
            
            [cell.imageView sd_setImageWithURL:dict[@"thumbnailUrl"]];
        }
        
    }
    
    return cell;
}

#pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_localImage) {
        [ZEBPhotoBrowser showFromImageView:cell.imageView withImages:self.originalImages atIndex:indexPath.row];
    }
    else {
        [ZEBPhotoBrowser showFromImageView:cell.imageView withURLStrings:_URLStrings placeholderImage:[UIImage imageNamed:@"placeholder"] atIndex:indexPath.row dismiss:nil];
    }
}




- (IBAction)refresh:(id)sender {
    [self getWebImages];
    _localImage = NO;
    [self.collectionView reloadData];
}


#pragma mark - private 

- (void)getWebImages {
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//    NSURL *url = [NSURL URLWithString:@"http://api.tietuku.cn/v2/api/getrandrec?key=bJiYx5aWk5vInZRjl2nHxmiZx5VnlpZkapRuY5RnaGyZmsqcw5NmlsObmGiXYpU="];
//    
//    NSURLRequest *repuest = [NSURLRequest requestWithURL:url];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:repuest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSMutableArray *urlS = [NSMutableArray array];
//        for (NSDictionary *dict in result) {
//            NSString *linkurl = dict[@"linkurl"];
//            
//            [urlS addObject:linkurl];
//        }
        NSArray *arr = @[@"http://112.74.129.54/tax00/M00/03/00/QUIPAFhrFr2AGq9gAHpmYv-oGuI491.JPG?type=1&width=10&height=10&size=8021602",@"http://112.74.129.54/tax00/M00/03/00/QUIPAFhrFr2AGq9gAHpmYv-oGuI491.JPG?type=1&width=10&height=10&size=8021602",@"qqqq.gif"];
        [_URLStrings addObjectsFromArray:[self getArray:arr]];
     [self.collectionView reloadData];

        
//    }];
//    [task resume];
}
- (NSArray *)getArray:(NSArray *)arr {

    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSString *string in arr) {
        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
        if ([string containsString:@"?type=1"]) {
          NSArray *arr = [string componentsSeparatedByString:@"?"];
            NSArray *sizeArr = [string componentsSeparatedByString:@"&"];
            NSString *size = [sizeArr lastObject];
            size = [size substringFromIndex:5];
            [parm setObject:[arr firstObject] forKey:@"originalUrl"];
            [parm setObject:string forKey:@"thumbnailUrl"];
            [parm setObject:size forKey:@"size"];
        }else {
            [parm setObject:string forKey:@"thumbnailUrl"];
        }
        [tempArr addObject:parm];
    }
    return tempArr;
}
@end
