//
//  BLEController.m
//  Detector_App
//
//  Created by Michael McAdam on 15/12/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import "BLEController.h"


@interface BLEController () <CBCentralManagerDelegate, CBPeripheralDelegate>

    @property (nonatomic, strong) CBCentralManager *centralManager;
    @property NSMutableArray *discoveredPeripherals;
    @property CBPeripheral  *currentPeripheral;
    @property NSMutableDictionary *trapCharacteristics;

@end


@implementation BLEController


@synthesize deviceInfoServiceUUID   = _deviceInfoServiceUUID;
@synthesize deviceIDCharUUID        = _deviceIDCharUUID;
@synthesize deviceControlCharUUID   = _deviceControlCharUUID;
@synthesize deviceStateCharUUID     = _deviceStateCharUUID;
@synthesize deviceSoftwareVersionCharUUID = _deviceSoftwareVersionCharUUID;

@synthesize detectorServiceUUID     = _detectorServiceUUID;
@synthesize detectorEventDataCharUUID = _detectorEventDataCharUUID;
@synthesize detectorConfigCharUUID      = _detectorConfigCharUUID;
@synthesize detectorEventDisplayedCharUUID = _detectorEventDisplayedCharUUID;
@synthesize detectorStateCharUUID       = _detectorStateCharUUID;

@synthesize timeServiceUUID     = _timeServiceUUID;
@synthesize timeCharUUID        = _timeCharUUID;

@synthesize rawEventServiceUUID         = _rawEventServiceUUID;
@synthesize rawEventDataCharUUID        = _rawEventDataCharUUID;
@synthesize rawEventDisplayedCharUUID   = _rawEventDisplayedCharUUID;

-(void) start
{
    _deviceInfoServiceUUID =             [CBUUID UUIDWithString:@"0000DE11-1212-EFDE-1523-785FEF13D123"];
    _deviceIDCharUUID =                  [CBUUID UUIDWithString:@"0000DE12-1212-EFDE-1523-785FEF13D123"];
    _deviceControlCharUUID =             [CBUUID UUIDWithString:@"0000DE13-1212-EFDE-1523-785FEF13D123"];
    _deviceStateCharUUID =               [CBUUID UUIDWithString:@"0000DE14-1212-EFDE-1523-785FEF13D123"];
    _deviceSoftwareVersionCharUUID =     [CBUUID UUIDWithString:@"0000DE15-1212-EFDE-1523-785FEF13D123"];
    
    _detectorServiceUUID =               [CBUUID UUIDWithString:@"0000DEAD-1212-EFDE-1523-785FEF13D123"];
    _detectorEventDataCharUUID =         [CBUUID UUIDWithString:@"0000DEED-1212-EFDE-1523-785FEF13D123"];
    _detectorConfigCharUUID =            [CBUUID UUIDWithString:@"0000D1ED-1212-EFDE-1523-785FEF13D123"];
    _detectorEventDisplayedCharUUID =    [CBUUID UUIDWithString:@"0000D2ED-1212-EFDE-1523-785FEF13D123"];
    _detectorStateCharUUID =             [CBUUID UUIDWithString:@"0000D3ED-1212-EFDE-1523-785FEF13D123"];
    
    _timeServiceUUID =                   [CBUUID UUIDWithString:@"0000F1AE-1212-EFDE-1523-785FEF13D123"];
    _timeCharUUID =                      [CBUUID UUIDWithString:@"0000F1AF-1212-EFDE-1523-785FEF13D123"];
    
    _rawEventServiceUUID =               [CBUUID UUIDWithString:@"0000D00D-1212-EFDE-1523-785FEF13D123"];
    _rawEventDataCharUUID =              [CBUUID UUIDWithString:@"0000D10D-1212-EFDE-1523-785FEF13D123"];
    _rawEventDisplayedCharUUID =         [CBUUID UUIDWithString:@"0000D20D-1212-EFDE-1523-785FEF13D123"];
    
    self.centralManager =           [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.discoveredPeripherals =    [[NSMutableArray alloc] init];
    self.trapCharacteristics =  [[NSMutableDictionary alloc] init];
    
}



- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
            
        case CBManagerStatePoweredOn: {
            
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
            
            NSDictionary *options = @{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES };
            [self.centralManager scanForPeripheralsWithServices:@[_detectorServiceUUID]
                                                        options:options];
            
             break; }
            
        case CBManagerStateResetting:
            NSLog(@"CoreBluetooth BLE hardware is resetting");
            break;
            
        case CBManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE state is unauthorized");
            break;
            
        case CBManagerStateUnknown:
            NSLog(@"CoreBluetooth BLE state is unknown");
            break;
            
        case CBManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
            break;
            
        default:
            break;
    }
}


- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@"Found peripheral");
    //[_discoveredPeripherals addObject:peripheral];
    self.currentPeripheral = peripheral;
    peripheral.delegate = self;
    [self.centralManager connectPeripheral:peripheral options:nil];

}


- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral {
    
    [self.centralManager stopScan];
    NSLog(@"Connection successfull to peripheral: %@",peripheral);
    

    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    
    
}


- (void) centralManager:(CBCentralManager *) central
didDisconnectPeripheral:(nonnull CBPeripheral *)peripheral
                  error:(nullable NSError *)error
{
    id<BLEControllerDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(onBLEDisconnect)]) {
        [strongDelegate onBLEDisconnect];
    }
    
    NSDictionary *options = @{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES };
    [self.centralManager scanForPeripheralsWithServices:@[_detectorServiceUUID]
                                                options:options];
}


- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Connection failed to peripheral: %@",peripheral);
    
    //Do something when a connection to a peripheral failes.
}



- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error {
    [self.centralManager stopScan];
   
    for (CBService *service in peripheral.services)
    {
        [peripheral discoverCharacteristics:nil forService:service];
    }
    
}


- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {
    
        for (CBCharacteristic *characteristic in service.characteristics)
    {
        _trapCharacteristics[characteristic.UUID.UUIDString] = characteristic;
    }

    static int i = 0;
    i++;
    if (i >= 4)
    {
        i = 0;
        id<BLEControllerDelegate> strongDelegate = self.delegate;
        
        // Our delegate method is optional, so we should
        // check that the delegate implements it
        if ([strongDelegate respondsToSelector:@selector(foundAllUUIDs)]) {
            [strongDelegate foundAllUUIDs];
        }
    }
    
}


- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    id<BLEControllerDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(gotData:forUUID:)]) {
        [strongDelegate gotData:characteristic.value forUUID:characteristic.UUID];
    }
    
}


- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error changing notification state: %@",
              [error localizedDescription]);
    }
}


- (void) readDataForUUID: (CBUUID*) UUID
{
    [_currentPeripheral readValueForCharacteristic:_trapCharacteristics[UUID.UUIDString]];
}

- (void) setNotifyForUUID: (CBUUID*) UUID
{
    CBCharacteristic *requestedChar = _trapCharacteristics[UUID.UUIDString];
    if (!requestedChar.isNotifying)
    {
        [_currentPeripheral setNotifyValue:YES forCharacteristic:requestedChar];
    }
}
     
 - (void) writeData: (NSData *) data toUUID: (CBUUID*) UUID
 {
     [_currentPeripheral writeValue:data forCharacteristic:_trapCharacteristics[UUID.UUIDString]  type:CBCharacteristicWriteWithResponse];
 }





@end
