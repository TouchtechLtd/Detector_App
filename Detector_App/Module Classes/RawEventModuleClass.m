//
//  RawEventModuleClass.m
//  Detector_App
//
//  Created by Michael McAdam on 15/12/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import "RawEventModuleClass.h"

@implementation RawEventModuleClass


- init
{
    self = [super init];
    _m_rawEventData = [[NSMutableDictionary alloc] init];
    return self;
}

- (void) addEventPacket: (lraw_event_data_packet_t) event
{
    NSNumber *eventID = [NSNumber numberWithInt:event.eventNumber];
    
    NSData *storedEvent = _m_rawEventData[eventID];
    raw_event_t detectorData = { 0 };
    if (storedEvent)
    {
        [storedEvent getBytes:&detectorData length:sizeof(detectorData)];
    }
    else
    {
        detectorData.eventNumber = event.eventNumber;
        self.m_transferring = true;
    }
    
    for (int i = 0; i < RAW_DATA_BLE_SIZE; i++)
    {
        detectorData.data[event.packetNumber*RAW_DATA_BLE_SIZE + i] = event.data[i];
    }
    
    if (event.packetNumber == 250/RAW_DATA_BLE_SIZE - 1)
    {
        self.m_transferring = false;
    }
    NSData *eventWrapper = [NSData dataWithBytes:&detectorData length:sizeof(detectorData)];
    _m_rawEventData[eventID] = eventWrapper;
}


- (raw_event_t) getEvent: (uint8_t) requestedEvent
{
    NSNumber *eventID = [NSNumber numberWithInt: requestedEvent];
    NSData *storedEvent = _m_rawEventData[eventID];
    
    raw_event_t rawEventData = { 0 };
    if (storedEvent)
    {
        [storedEvent getBytes:&rawEventData length:sizeof(rawEventData)];
    }
    return rawEventData;
}

- (bool) isTransferring
{
    return _m_transferring;
}
@end
