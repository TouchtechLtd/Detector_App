//
//  TrapDataClass.h
//  Detector_App
//
//  Created by Michael McAdam on 15/12/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModuleClass.h"
#import "TimeModuleClass.h"
#import "DetectorModuleClass.h"
#import "RawEventModuleClass.h"

@interface TrapDataClass : NSObject


@property (strong, nonatomic) DeviceModuleClass         *device;
@property (strong, nonatomic) TimeModuleClass           *time;
@property (strong, nonatomic) DetectorModuleClass       *detector;
@property (strong, nonatomic) RawEventModuleClass       *rawEvent;
@property (strong, nonatomic) NSDate         *lastConnectionTime;

@property bool isConnected;

@end
