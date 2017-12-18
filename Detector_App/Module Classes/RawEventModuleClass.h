//
//  RawEventModuleClass.h
//  Detector_App
//
//  Created by Michael McAdam on 15/12/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RawEventModuleClass : NSObject

#define RAW_EVENT_SIZE 250
#define RAW_DATA_BLE_SIZE 4


typedef uint8_t raw_event_displayed_t;
typedef uint8_t raw_event_number_t;

typedef struct __attribute__((packed))
{
    int8_t x;
    int8_t y;
    int8_t z;
} lacceleration_8b_t;


typedef struct
{
    uint8_t                 sum;
    lacceleration_8b_t       acc;
} lraw_event_data_t;

typedef struct
{
    lraw_event_data_t    data[RAW_EVENT_SIZE];
    uint8_t             eventNumber;
    uint8_t             peakLevel;
    bool                processed;
} raw_event_t;

typedef struct
{
    lraw_event_data_t data[RAW_DATA_BLE_SIZE];
    uint8_t packetNumber;
    uint8_t eventNumber;
} lraw_event_data_packet_t;


@property (strong, nonatomic) NSMutableDictionary  *m_rawEventData;
@property raw_event_displayed_t                     m_eventDisplayed;
@property lraw_event_data_packet_t                   m_rawEventDataPacket;
@property raw_event_number_t                        m_eventNumber;
@property bool                                      m_transferring;


- (void) addEventPacket: (lraw_event_data_packet_t) event;
- (raw_event_t) getEvent: (uint8_t) requestedEvent;
- (bool) isTransferring;

@end
