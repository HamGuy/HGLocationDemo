//
//  HGAnnotation.m
//  HGLocationServiceDemo
//
//  Created by HamGuy on 7/24/14.
//  Copyright (c) 2014 ___DXY___. All rights reserved.
//

#import "HGAnnotation.h"

@implementation HGAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _title = title;
    }
    return self;
}
@end
