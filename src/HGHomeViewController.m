//
//  HGHomeViewController.m
//  HGLocationServiceDemo
//
//  Created by HamGuy on 7/24/14.
//  Copyright (c) 2014 ___DXY___. All rights reserved.
//

#import "HGHomeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "HGAnnotation.h"

@interface HGHomeViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *longtudeLabel;
@property (nonatomic, weak) IBOutlet UILabel *latitudelabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;

@property (nonatomic, weak) IBOutlet MKMapView* mapView;

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, weak) IBOutlet UISwitch *threeDSwitch;

@property (nonatomic, strong) MKMapCamera* mapCamera;
@property (nonatomic, assign) CLLocationCoordinate2D currentCordinate;


@end

@implementation HGHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.pitchEnabled = YES;
    self.mapView.showsBuildings = YES;
    [self startLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(IBAction)locationNow:(id)sender{
    [self startLocation];
}

-(IBAction)swithchValueChanged:(UISwitch *)sender{
    
//    CLLocationCoordinate2D eye = CLLocationCoordinate2DMake(self.currentCordinate.latitude, self.currentCordinate.longitude+.020);
//    MKMapCamera *mapCamera = [MKMapCamera cameraLookingAtCenterCoordinate:self.currentCordinate
//                                                        fromEyeCoordinate:eye
//                                                              eyeAltitude:700];
    self.mapView.pitchEnabled = YES;
    self.mapCamera.centerCoordinate = self.mapView.userLocation.coordinate;
    self.mapCamera = self.mapView.camera;
    self.mapCamera.heading = sender.on ? 45 : 0;
    self.mapCamera.altitude = 100;
    self.mapCamera.pitch = sender.on ? 135 : 0.0;
    if (self.mapView.mapType != MKMapTypeStandard) {
        self.mapCamera.pitch = 0;
        self.mapCamera.heading = 0;
    }
    
    [self.mapView setCamera:self.mapCamera animated:YES];

}

-(IBAction)changeMapModel:(UISegmentedControl *)segmentedControl{
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
    self.threeDSwitch.on = NO;
    [self swithchValueChanged:self.threeDSwitch];
    self.threeDSwitch.enabled = segmentedControl.selectedSegmentIndex == 0;
}

#pragma mark - Getter
-(CLLocationManager *)locationManager{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.distanceFilter = 500;
    }
    return _locationManager;
}


#pragma mark - Private
-(void)startLocation{
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startMonitoringSignificantLocationChanges];
    }else{
        
    }
 
}

-(void)setLocationInfo:(CLLocationCoordinate2D)coordinate{
    self.longtudeLabel.text = [NSString stringWithFormat:@"%.10f",coordinate.longitude];
    self.latitudelabel.text = [NSString stringWithFormat:@"%.10f",coordinate.latitude];
    
    NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder?output=json&location=%.10f,%.10f",coordinate.latitude,coordinate.longitude];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    self.detailLabel.text = dict[@"result"][@"formatted_address"];
}

#pragma mark - CLLocation Manager Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations lastObject];
    [self setLocationInfo:location.coordinate];
    [manager stopMonitoringSignificantLocationChanges];
    
    [self.mapView setCenterCoordinate:location.coordinate animated:YES];
    HGAnnotation *anootation  = [[HGAnnotation alloc] initWithCoordinate:location.coordinate title:self.detailLabel.text];
    
    //add anootation
    if (self.detailLabel.text.length>0 ) {
        NSLog(@"add anootation");
        [self.mapView addAnnotation:anootation];
        [self.mapView selectAnnotation:anootation animated:YES];
    }
    self.currentCordinate = location.coordinate;
}


#pragma mark - MAPViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSLog(@"didUpdateUserLocation celled");
    
    
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 300, 300);
    [mapView setRegion:region animated:YES];
    
    [self setCurrentCordinate:loc];
    HGAnnotation *anootation  = [[HGAnnotation alloc] initWithCoordinate:loc title:self.detailLabel.text];
    
    //add anootation
    if (self.detailLabel.text.length>0 ) {
        NSLog(@"add anootation");
        [self.mapView addAnnotation:anootation];
        [self.mapView selectAnnotation:anootation animated:YES];
    }

    
}



@end
