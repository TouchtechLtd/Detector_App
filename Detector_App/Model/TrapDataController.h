//
//  TrapDataController.h
//  Detector_App
//
//  Created by Michael McAdam on 15/12/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrapDataClass.h"

@interface TrapDataController : NSObject

@property (strong, nonatomic) NSMutableDictionary *trapList;
@property (strong, nonatomic) TrapDataClass *currentTrap;

- (void) start;

- (void) loadTrap: (NSData*) data;
- (void) setDeviceState: (NSData*) data;
- (void) setSoftwareVersion: (NSData*) data;
- (void) setTrapTime: (NSData*) data;
- (bool) isTrapTimeAbsSet;
- (void) setDetectorConfig: (NSData*) data;
- (void) setKillDisplayed: (NSData*) data;
- (void) setDetectorState: (NSData*) data;
- (void) addKill: (NSData*) data;

- (void) setRawEventDisplayed: (NSData*) data;
- (void) addRawEventPacket: (NSData*) data;
- (bool) eventDataAvailable;
- (unsigned long) getNextEventNumber;

- (bool) eventTransferFinished;

- (bool) dataAvailable;
- (unsigned long) getNextKillNumber;

-(void) changeIDTo: (uint32_t) newID;
- (void) trapDisconnected;
@end
