//
//  TrapDataController.m
//  Detector_App
//
//  Created by Michael McAdam on 15/12/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import "TrapDataController.h"

@interface TrapDataController ()


@end

@implementation TrapDataController

@synthesize trapList = _trapList;


- (void) start
{
    self.trapList =  [[NSMutableDictionary alloc] init];
}



- (void) loadTrap: (NSData*) data
{
    device_id_t deviceID;
    [data getBytes:&deviceID length:sizeof(deviceID)];
    NSLog(@"Trap ID: %d", deviceID);
    
    NSString *trapIDString = [NSString stringWithFormat:@"%d", deviceID];
    
    _currentTrap = _trapList[trapIDString];
    if (!_currentTrap)
    {
        TrapDataClass *newClass = [[TrapDataClass alloc] init];
        [self.trapList setObject:newClass forKey:trapIDString];
        _currentTrap = _trapList[trapIDString];
    }
    
    _currentTrap.device.m_ID = deviceID;
    _currentTrap.lastConnectionTime = [NSDate date];
    _currentTrap.isConnected = true;
}


- (void) setDeviceState: (NSData*) data
{
    device_state_t deviceState;
    [data getBytes:&deviceState length:sizeof(deviceState)];
    _currentTrap.device.m_state = deviceState;
}

- (void) setSoftwareVersion: (NSData*) data
{
    lsoftware_version_t deviceSoftwareVersion;
    [data getBytes:&deviceSoftwareVersion length:sizeof(deviceSoftwareVersion)];
    _currentTrap.device.m_softwareVersion = deviceSoftwareVersion;
}

- (void) setTrapTime: (NSData*) data
{
    current_time_t trapTime;
    [data getBytes:&trapTime length:sizeof(trapTime)];
    NSLog(@"Current Trap Time: %u, Abs Set: %d", trapTime.time, trapTime.absSet);
    _currentTrap.time.m_time = trapTime;
}

- (bool) isTrapTimeAbsSet
{
    return _currentTrap.time.m_time.absSet == 1;
}

- (void) setDetectorConfig: (NSData*) data
{
    NSLog(@"Setting Detector Config");
    detector_config_t detectorConfig;
    [data getBytes:&detectorConfig length:sizeof(detectorConfig)];
    _currentTrap.detector.m_detectorConfig = detectorConfig;
}

- (void) setKillDisplayed: (NSData*) data
{
    detector_event_displayed_t killDisplayed;
    [data getBytes:&killDisplayed length:sizeof(killDisplayed)];
    
    NSLog(@"Setting Kill Displayed - Value: %d", killDisplayed);
    _currentTrap.detector.m_eventDisplayed = killDisplayed;
    if (killDisplayed > _currentTrap.detector.m_killNumber)
    {
        _currentTrap.detector.m_killNumber = killDisplayed;
    }
}

- (void) setDetectorState: (NSData*) data
{
    detector_state_t detectorState;
    [data getBytes:&detectorState length:sizeof(detectorState)];
    _currentTrap.detector.m_state = detectorState;
}



- (void) addKill: (NSData*) data
{
    detector_data_t detectorData;
    [data getBytes:&detectorData length:sizeof(detectorData)];
    
    NSLog(@"Adding kill number: %d", detectorData.killNumber);
    [_currentTrap.detector addKill: detectorData];
}


- (void) setRawEventDisplayed: (NSData*) data
{
    raw_event_displayed_t eventDisplayed;
    [data getBytes:&eventDisplayed length:sizeof(eventDisplayed)];
    
    NSLog(@"Setting Event Displayed - Value: %d", eventDisplayed);
    _currentTrap.rawEvent.m_eventDisplayed = eventDisplayed;
    if (eventDisplayed > _currentTrap.rawEvent.m_eventNumber)
    {
        _currentTrap.rawEvent.m_eventNumber = eventDisplayed;
    }
}

- (void) addRawEventPacket: (NSData*) data
{
    lraw_event_data_packet_t m_rawDataPacket;
    [data getBytes:&m_rawDataPacket length:sizeof(m_rawDataPacket)];
    NSLog(@"Adding raw data packet: %d for event number: %d", m_rawDataPacket.packetNumber, m_rawDataPacket.eventNumber);
    [_currentTrap.rawEvent addEventPacket: m_rawDataPacket];
}

- (bool) eventDataAvailable
{
    return ([_currentTrap.rawEvent.m_rawEventData count] < _currentTrap.rawEvent.m_eventNumber);
}

- (unsigned long) getNextEventNumber
{
    return ([_currentTrap.rawEvent.m_rawEventData count] + 1);
}

- (bool) dataAvailable
{
    return ([_currentTrap.detector.m_eventData count] < _currentTrap.detector.m_killNumber);
}

- (bool) eventTransferFinished
{
    return ![_currentTrap.rawEvent isTransferring];
}

- (unsigned long) getNextKillNumber
{
    return ([_currentTrap.detector.m_eventData count] + 1);
}


- (void) changeIDTo: (uint32_t) newID
{
    NSString *oldIDString = [NSString stringWithFormat:@"%d", _currentTrap.device.m_ID];
    NSString *newIDString = [NSString stringWithFormat:@"%d", newID];
    
    id objectToPreserve = [self.trapList objectForKey:oldIDString];
    [self.trapList setObject:objectToPreserve forKey:newIDString];
    [self.trapList removeObjectForKey:oldIDString];
}

- (void) trapDisconnected
{
    _currentTrap.isConnected = false;
    _currentTrap = nil;
}

/*



- (id) jsonObject
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [self.trapList enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj respondsToSelector:@selector(jsonObject)])
            [dictionary setObject:[obj jsonObject] forKey:key];
    }];
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

*/

@end
