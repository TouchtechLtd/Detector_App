//
//  DetectorModuleClass.h
//  Detector_App
//
//  Created by Michael McAdam on 15/12/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeModuleClass.h"

@interface DetectorModuleClass : NSObject

typedef enum {
    WAIT_STATE,
    EVENT_BUFFER_STATE,
    DETECT_MOVE_STATE,
    MOVING_STATE
} detector_state_e;


typedef struct __attribute__((packed))
{
    uint8_t             peak_level;
    uint32_t            trap_id;
    int8_t              temperature;
    uint8_t             killNumber;
    current_time_t      timestamp;
    uint8_t             rawEventData;
} detector_data_t;


typedef struct __attribute__((packed))
{
    uint16_t    triggerThreshold;
    uint16_t    moveThreshold;
    uint8_t     triggerDuration;
    uint8_t     moveDuration;
    uint16_t    triggerBufferLength;
    uint16_t    moveBufferLength;
    uint16_t    setBufferLength;
} detector_config_t;


typedef uint8_t detector_event_displayed_t;
typedef uint8_t detector_state_t;

typedef uint8_t detector_kill_number_t;


@property detector_config_t                         m_detectorConfig;
@property (strong, nonatomic) NSMutableDictionary  *m_eventData;
@property detector_event_displayed_t                m_eventDisplayed;
@property detector_state_t                          m_state;
@property detector_kill_number_t                    m_killNumber;


- (void) addKill: (detector_data_t) kill;
- (detector_data_t) getKill: (int) killNumber;

@end
