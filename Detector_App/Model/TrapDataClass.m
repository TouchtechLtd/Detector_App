//
//  TrapDataClass.m
//  Detector_App
//
//  Created by Michael McAdam on 15/12/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import "TrapDataClass.h"


@implementation TrapDataClass

@synthesize device      = _device;
@synthesize detector    = _detector;
@synthesize time        = _time;
@synthesize rawEvent    = _rawEvent;

@synthesize lastConnectionTime = _lastConnectionTime;

- init
{
    self = [super init];
    if (self) {
        _device =       [[DeviceModuleClass alloc] init];
        _detector =     [[DetectorModuleClass alloc] init];
        _time =         [[TimeModuleClass alloc] init];
        _rawEvent =     [[RawEventModuleClass alloc] init];
        _lastConnectionTime = [[NSDate alloc] init];
    }
    return self;
}

@end
