//
//  BLEController.h
//  Detector_App
//
//  Created by Michael McAdam on 15/12/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@protocol BLEControllerDelegate;

@interface BLEController : NSObject


@property (strong, nonatomic) CBUUID *deviceInfoServiceUUID;
@property (strong, nonatomic) CBUUID *deviceIDCharUUID;
@property (strong, nonatomic) CBUUID *deviceControlCharUUID;
@property (strong, nonatomic) CBUUID *deviceStateCharUUID;
@property (strong, nonatomic) CBUUID *deviceSoftwareVersionCharUUID;

@property (strong, nonatomic) CBUUID *detectorServiceUUID;
@property (strong, nonatomic) CBUUID *detectorEventDataCharUUID;
@property (strong, nonatomic) CBUUID *detectorConfigCharUUID;
@property (strong, nonatomic) CBUUID *detectorEventDisplayedCharUUID;
@property (strong, nonatomic) CBUUID *detectorStateCharUUID;

@property (strong, nonatomic) CBUUID *timeServiceUUID;
@property (strong, nonatomic) CBUUID *timeCharUUID;

@property (strong, nonatomic) CBUUID *rawEventServiceUUID;
@property (strong, nonatomic) CBUUID *rawEventDataCharUUID;
@property (strong, nonatomic) CBUUID *rawEventDisplayedCharUUID;


@property bool isConnected;
@property (nonatomic, weak) id<BLEControllerDelegate> delegate;

- (void) start;

- (void) readDataForUUID: (CBUUID*) UUID;
- (void) setNotifyForUUID: (CBUUID*) UUID;
- (void) writeData: (NSData *) data toUUID: (CBUUID*) UUID;

@end

@protocol BLEControllerDelegate <NSObject>

- (void) BLEStarted;
- (void) onBLEDisconnect;
- (void) gotData:(NSData *)data forUUID: (CBUUID* ) UUID;
- (void) foundAllUUIDs;

@end
