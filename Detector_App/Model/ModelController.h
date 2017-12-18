//
//  ModelController.h
//  Detector_App
//
//  Created by Michael McAdam on 8/11/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TrapDataController.h"
#import "BLEController.h"



@interface ModelController : NSObject {
  
    @public uint8_t numberOfKills;

}
@property (nonatomic, strong) TrapDataController *trapDataController;
@property (strong, nonatomic) BLEController *bleController;


- (void)writeToConfig: (NSData *) data;

- (void) activateTrap;
- (void) deactivateTrap;
- (void) setID: (uint32_t) newID;


- (void) start;



-(id) jsonObject;

@end

