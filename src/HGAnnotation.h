//
//  HGAnnotation.h
//  HGLocationServiceDemo
//
//  Created by HamGuy on 7/24/14.
//  Copyright (c) 2014 ___DXY___. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface HGAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;

@end
