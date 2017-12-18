//
//  TimeModuleClass.h
//  Detector_App
//
//  Created by Michael McAdam on 15/12/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeModuleClass : NSObject


typedef struct __attribute__((packed)) {
    uint32_t time;
    uint8_t   absSet;
} current_time_t;


@property current_time_t m_time;


@end
