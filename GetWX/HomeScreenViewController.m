//
//  HomeScreenViewController.m
//  GetWX
//
//  Created by Jason Hoffman on 9/28/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "HomeScreenViewController.h"

@interface HomeScreenViewController ()

@property (nonatomic, weak) NSURLSession *urlSession;
@property (nonatomic, weak) NSString *airport;

@end

@implementation HomeScreenViewController

- (void)loadView
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fetchFeed)];
    doubleTap.numberOfTapsRequired = 2;
    
}


- (void)fetchFeed
{
    NSString *requestString = [NSString stringWithFormat:@"http://user:key.flightaware.com/json/FlightXML2/Metar?airport=%@", _airport];
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", json);
    }];
    
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
