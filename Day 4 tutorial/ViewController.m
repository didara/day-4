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
            
            [self downloadImages];
        
        }];
    }else {
        
            NSLog(@"using previous credentials");
        
        }
    }

    // Do any additional setup after loading the view, typically from a nib.


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - helper methods 

-(void) downloadImages
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat: @"https://api.instagram.com/v1/tags/Didara/media/recent?access_token=%@", self.accessToken];
  //  NSLog (@"%@", urlString);
    
    NSURL *url = [[NSURL alloc] initWithString: urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
    //    NSLog(@"response is :%@, response");
        NSData *data = [[NSData alloc] initWithContentsOfURL: location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: nil];
        
        NSLog(@"response dictionary is: %@", responseDictionary);
        
        
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
    return 10;
}
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
        forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"lookImage.jpeg"];
    return cell;
}




@end

