//
//  DeviceModuleClass.h
//  Detector_App
//
//  Created by Michael McAdam on 15/12/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModuleClass : NSObject

#define DEFAULT_TRAP_ID 0


typedef uint32_t    device_id_t;
typedef uint8_t     device_state_t;

typedef enum {
    IDLE_STATE,
    ACTIVE_STATE
} device_state_e;


typedef struct __attribute__((packed))
{
    uint8_t activate;
} device_control_t;


typedef struct __attribute__((packed))
{
    uint8_t major;
    uint8_t minor;
} lsoftware_version_t;


@property device_id_t           m_ID;
@property device_state_t        m_state;
@property device_control_t      m_control;
@property lsoftware_version_t    m_softwareVersion;

@end
