//
//  ViewController.m
//  Day 4 tutorial
//
//  Created by Didara Pernebayeva on 17.06.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "ViewController.h"
#import <SimpleAuth/SimpleAuth.h>
#import "PhotoCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSMutableArray *photos;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    if (self.accessToken == nil) {
        [SimpleAuth authorize:@"instagram" completion:^ (NSDictionary *responseObject, NSError *error) {
        
            self.accessToken= responseObject [@"credentials"] [@"token"];
            [userDefaults setObject: self.accessToken forKey: @"accessToken"];
            [userDefaults synchronize];
            NSLog (@"saved credentials");
            
            [self downloadImage];
        
        }];
    }else {
        
            NSLog(@"using previous credentials");
            [self downloadImage];
        }
    }

    // Do any additional setup after loading the view, typically from a nib.


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - helper methods 

-(void) downloadImage
{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat: @"https://api.instagram.com/v1/tags/KZ/media/recent?access_token=%@", self.accessToken];
  //  NSLog (@"%@", urlString);
    
    NSURL *url = [[NSURL alloc] initWithString: urlString];
    
    NSLog(@"%s, Started downloading", __FUNCTION__);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
       
        NSLog(@"%s, Ended", __FUNCTION__);
        
        NSData *data = [[NSData alloc] initWithContentsOfURL: location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: nil];
        NSLog(@" response dictionary is : %@", responseDictionary);

        self.photos = responseDictionary[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            
            
        });
    
    }];
    

    [task resume];
}

                       
#pragma mark - UICollectionView methods;

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.photos count];
}
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
        forIndexPath:indexPath];
    

  //   cell.imageView.image = [UIImage imageNamed:@"lookImage.jpeg"];
    

    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.photo = photo;
    
    return cell;
}




@end

