//
//  ModelController.m
//  Detector_App
//
//  Created by Michael McAdam on 8/11/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import "ModelController.h"
#import "TrapDataClass.h"

@interface ModelController () <BLEControllerDelegate>

@end

@implementation ModelController

@synthesize bleController = _bleController;
@synthesize trapDataController = _trapDataController;

- (void) start
{
    _bleController = [[BLEController alloc] init];
    [_bleController start];
    _bleController.delegate = self;
    _trapDataController = [[TrapDataController alloc] init];
    [_trapDataController start];
    
}

- (void) onBLEDisconnect
{
    [_trapDataController trapDisconnected];
}

- (void) gotData:(NSData *)data forUUID: (CBUUID* ) UUID
{

    if ([UUID.UUIDString isEqualToString:_bleController.deviceIDCharUUID.UUIDString])
    {
        [_trapDataController loadTrap: data];
        
        [_bleController setNotifyForUUID:_bleController.deviceIDCharUUID];

        [_bleController readDataForUUID:_bleController.deviceStateCharUUID];
        [_bleController readDataForUUID:_bleController.deviceSoftwareVersionCharUUID];
        [_bleController readDataForUUID:_bleController.timeCharUUID];
    }
     
    if ([UUID.UUIDString isEqualToString:_bleController.deviceStateCharUUID.UUIDString])
    {
        [_trapDataController setDeviceState: data];
        [_bleController setNotifyForUUID:_bleController.deviceStateCharUUID];
    }
     
    if ([UUID.UUIDString isEqualToString:_bleController.deviceSoftwareVersionCharUUID.UUIDString])
    {
        [_trapDataController setSoftwareVersion: data];
    }
     
    
     if ([UUID.UUIDString isEqualToString:_bleController.timeCharUUID.UUIDString])
     {
         [_trapDataController setTrapTime: data];
         
         [_bleController setNotifyForUUID:_bleController.timeCharUUID];
         [_bleController readDataForUUID:_bleController.detectorConfigCharUUID];
         [_bleController readDataForUUID:_bleController.detectorStateCharUUID];
         if (![_trapDataController isTrapTimeAbsSet])
         {
             [self setTrapTime];
         }
     }
    
    if ([UUID.UUIDString isEqualToString:_bleController.detectorStateCharUUID.UUIDString])
    {
        [_bleController setNotifyForUUID:_bleController.detectorStateCharUUID];
        [_trapDataController setDetectorState: data];
    }
     
     if ([UUID.UUIDString isEqualToString:_bleController.detectorConfigCharUUID.UUIDString])
     {
         [_trapDataController setDetectorConfig:data];

         [_bleController setNotifyForUUID:_bleController.detectorConfigCharUUID];
         [_bleController readDataForUUID:_bleController.detectorEventDisplayedCharUUID];
         [_bleController readDataForUUID:_bleController.rawEventDisplayedCharUUID];
     }
     
     
     
     if ([UUID.UUIDString isEqualToString:_bleController.detectorEventDisplayedCharUUID.UUIDString])
     {
         [_trapDataController setKillDisplayed:data];
     
         [_bleController setNotifyForUUID:_bleController.detectorEventDisplayedCharUUID];
         [_bleController setNotifyForUUID:_bleController.detectorEventDataCharUUID];
     
         if ([_trapDataController dataAvailable])
         {
             uint8_t nextKill = [_trapDataController getNextKillNumber];
             NSData *nextKillData = [NSData dataWithBytes:&nextKill length:sizeof(nextKill)];
             [_bleController writeData:nextKillData toUUID:_bleController.detectorEventDisplayedCharUUID];
         }
     }
     
     
     if ([UUID.UUIDString isEqualToString:_bleController.detectorEventDataCharUUID.UUIDString])
     {
         [_trapDataController addKill:data];
         if ([_trapDataController dataAvailable])
         {
             uint8_t nextKill = [_trapDataController getNextKillNumber];
             NSData *nextKillData = [NSData dataWithBytes:&nextKill length:sizeof(nextKill)];
             [_bleController writeData:nextKillData toUUID:_bleController.detectorEventDisplayedCharUUID];
         }
     }
     
    
     if ([UUID.UUIDString isEqualToString:_bleController.rawEventDisplayedCharUUID.UUIDString])
     {
         [_trapDataController setRawEventDisplayed:data];
         
         [_bleController setNotifyForUUID:_bleController.rawEventDisplayedCharUUID];
         [_bleController setNotifyForUUID:_bleController.rawEventDataCharUUID];
         
         if ([_trapDataController eventTransferFinished] && [_trapDataController eventDataAvailable])
         {
             uint8_t nextEvent = [_trapDataController getNextEventNumber];
             NSData *nextEventData = [NSData dataWithBytes:&nextEvent length:sizeof(nextEvent)];
             [_bleController writeData:nextEventData toUUID:_bleController.rawEventDisplayedCharUUID];
         }
     }
    
    if ([UUID.UUIDString isEqualToString:_bleController.rawEventDataCharUUID.UUIDString])
    {
        [_trapDataController addRawEventPacket:data];
        if ([_trapDataController eventTransferFinished] && [_trapDataController eventDataAvailable])
        {
            uint8_t nextEvent = [_trapDataController getNextEventNumber];
            NSData *nextEventData = [NSData dataWithBytes:&nextEvent length:sizeof(nextEvent)];
            [_bleController writeData:nextEventData toUUID:_bleController.rawEventDisplayedCharUUID];
        }
        
    }
    
}

- (void) foundAllUUIDs
{
    [_bleController readDataForUUID:_bleController.deviceIDCharUUID];
}


- (void) setTrapTime
{
    NSTimeInterval timeInMinutes = (long long)[[NSDate date] timeIntervalSince1970];
    current_time_t writeTime;
    writeTime.time = timeInMinutes / 60;
    writeTime.absSet = 1;
    
    NSData *timeData = [NSData dataWithBytes:&writeTime length:sizeof(writeTime)];
    
    [_bleController writeData: timeData toUUID:_bleController.timeCharUUID];
}


- (void )writeToConfig: (NSData*) data
{
    [_bleController writeData:data toUUID:_bleController.detectorConfigCharUUID];
}

- (void) activateTrap
{
    device_control_t tmpControl = { 0 };
    tmpControl.activate = 1;
    NSData *activateData = [NSData dataWithBytes:&tmpControl length:sizeof(tmpControl)];
    [_bleController writeData:activateData toUUID:_bleController.deviceControlCharUUID];
}

- (void) deactivateTrap
{
    device_control_t tmpControl = { 0 };
    tmpControl.activate = 2;
    NSData *activateData = [NSData dataWithBytes:&tmpControl length:sizeof(tmpControl)];
    [_bleController writeData:activateData toUUID:_bleController.deviceControlCharUUID];
}

- (void) setID: (uint32_t) newID
{
    NSData *idData = [NSData dataWithBytes:&newID length:sizeof(newID)];
    [_bleController writeData:idData toUUID:_bleController.deviceIDCharUUID];
    [_trapDataController changeIDTo: newID];

}




@end
