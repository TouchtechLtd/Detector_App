//
//  DetectorModuleClass.m
//  Detector_App
//
//  Created by Michael McAdam on 15/12/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import "DetectorModuleClass.h"

@implementation DetectorModuleClass


- init
{
    self = [super init];
    _m_eventData = [[NSMutableDictionary alloc] init];
    return self;
}


- (void) addKill: (detector_data_t) kill
{
    NSNumber *killID = [NSNumber numberWithInt:kill.killNumber];
    NSData *killWrapper = [NSData dataWithBytes:&kill length:sizeof(kill)];
    _m_eventData[killID] = killWrapper;
}

- (detector_data_t) getKill: (int) killNumber
{
    NSNumber *killID = [NSNumber numberWithInt: killNumber];
    
    NSData *killData = _m_eventData[killID];
    
    detector_data_t detectorData = { 0 };
    if (killData)
    {
        [killData getBytes:&detectorData length:sizeof(detectorData)];
    }
    return detectorData;
}


@end
