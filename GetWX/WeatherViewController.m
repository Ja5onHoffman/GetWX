//
//  WeatherViewController.m
//  GetWX
//
//  Created by Jason Hoffman on 9/28/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "WeatherViewController.h"
#import <CoreLocation/CoreLocation.h>

#define kGOOLE_API_KEY @key
#define FLIGHTAWARE_API_KEY @key
#define SITA_API_KEY @key
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface WeatherViewController () <NSURLSessionDataDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, weak) NSString *airport;
@property (nonatomic, weak) NSString *code;
@property (nonatomic, weak) NSString *weather;
@property (nonatomic) float lat;
@property (nonatomic) float lon;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *airportLabel;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation WeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"init");
    self = [super initWithNibName:@"WeatherViewController" bundle:nil];
    
    if (self) {
        
        NSLog(@"self init");
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        [self startLocation];
    }
    
    return self;
}

/*
- (void)loadView
{
    [super loadView];
    
    NSLog(@"loadView");

}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startLocation
{
    NSLog(@"startLocation");
    // Create the location manager if this object does not
    // already have one.
    if (nil == _locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Also, NSLocationWhenInUseUsageDescription added to Info.plist for iOS 8
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

// LocationManager is updating more than once
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocation");
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    
    _lat = location.coordinate.latitude;
    _lon = location.coordinate.longitude;
    
    NSLog(@"%f", location.coordinate.latitude);
    NSLog(@"%f", location.coordinate.longitude);
    
    [self querySITA];
    [self.locationManager stopUpdatingLocation];
}

- (void)fetchWX
{
    NSLog(@"fetchWX");
    NSLog(@"_airport: %@", _airport);
    NSString *requestString = [NSString stringWithFormat:@"http://jasonandrewhoffman:%@flightxml.flightaware.com/json/FlightXML2/Metar?airport=%@", FLIGHTAWARE_API_KEY, _airport];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
          // NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
          NSArray *wx = [jsonObject objectForKey:@"MetarResult"];
          NSLog(@"%@", wx);
        }
    }];
    
    [dataTask resume];

}

// Google Places is the wrong tool for now
// Simple API that allows lat/lon lookup. Ok to test with
- (void)querySITA
{
    NSLog(@"qerySita");
    NSString *url = [NSString stringWithFormat:@"https://airport.api.aero/airport/nearest/%f/%f?user_key=%@", _lat, _lon, SITA_API_KEY];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
            NSData *json = [data subdataWithRange:NSMakeRange(9, data.length - 10)];
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%lu", data.length - 10);
        
            _code = [jsonObject valueForKeyPath:@"airports.code"][0];
            _airportLabel.text = _code;
            _airport = _code;
            [self fetchWX];

            NSLog(@"_code: %@", _code);
    }];
    
    [dataTask resume];
}

    
@end


