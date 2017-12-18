//
//  ViewController.m
//  Detector_App
//
//  Created by Michael McAdam on 20/09/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import "ConfigViewController.h"

@interface ConfigViewController ()


@end

@implementation ConfigViewController


//@synthesize modelController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_triggerThresholdSlider    setValue:(int)(_m_eventConfig.triggerThreshold)     animated:NO];
    [_moveThresholdSlider       setValue:(int)(_m_eventConfig.moveThreshold)        animated:NO];
    [_triggerDurationSlider     setValue:(int)(_m_eventConfig.triggerDuration)      animated:NO];
    [_moveDurationSlider        setValue:(int)(_m_eventConfig.moveDuration)         animated:NO];
    [_triggerBufferLengthSlider setValue:(int)(_m_eventConfig.triggerBufferLength)  animated:NO];
    [_moveBufferLengthSlider    setValue:(int)(_m_eventConfig.moveBufferLength)     animated:NO];
    [_setBufferLengthSlider     setValue:(int)(_m_eventConfig.setBufferLength)      animated:NO];
    
    self.triggerThresholdOutput.text =      [NSString stringWithFormat:@"%d",  (int)_triggerThresholdSlider.value];
    self.moveThresholdOutput.text =         [NSString stringWithFormat:@"%d",  (int)_moveThresholdSlider.value];
    self.triggerDurationOutput.text =       [NSString stringWithFormat:@"%d",  (int)_triggerDurationSlider.value];
    self.moveDurationOutput.text =          [NSString stringWithFormat:@"%d",  (int)_moveDurationSlider.value];
    self.triggerBufferLengthOutput.text =   [NSString stringWithFormat:@"%d",  (int)_triggerBufferLengthSlider.value];
    self.moveBufferLengthOutput.text =      [NSString stringWithFormat:@"%d",  (int)_moveBufferLengthSlider.value];
    self.setBufferLengthOutput.text =       [NSString stringWithFormat:@"%d",  (int)_setBufferLengthSlider.value];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    

- (IBAction)triggerThresholdSliderAction:(id)sender {
    int step = 10;
    [_triggerThresholdSlider setValue:((int)((_triggerThresholdSlider.value + step/2) / step) * step) animated:NO];
    self.triggerThresholdOutput.text = [NSString stringWithFormat:@"%d", (int)_triggerThresholdSlider.value];
    _m_eventConfig.triggerThreshold = _triggerThresholdSlider.value;
}

- (IBAction)moveThresholdSliderAction:(id)sender {
    int step = 10;
    [_moveThresholdSlider setValue:((int)((_moveThresholdSlider.value + step/2) / step) * step) animated:NO];
    self.moveThresholdOutput.text = [NSString stringWithFormat:@"%d", (int)_moveThresholdSlider.value];
    _m_eventConfig.moveThreshold = _moveThresholdSlider.value;
}

- (IBAction)triggerDurationSliderAction:(id)sender {
    int step = 20;
    [_triggerDurationSlider setValue:((int)((_triggerDurationSlider.value + step/2) / step) * step) animated:NO];
    self.triggerDurationOutput.text = [NSString stringWithFormat:@"%d", (int)_triggerDurationSlider.value];
    _m_eventConfig.triggerDuration = _triggerDurationSlider.value;
}

- (IBAction)moveDurationSliderAction:(id)sender {
    int step = 20;
    [_moveDurationSlider setValue:((int)((_moveDurationSlider.value + step/2) / step) * step) animated:NO];
    self.moveDurationOutput.text = [NSString stringWithFormat:@"%d", (int)_moveDurationSlider.value];
    _m_eventConfig.moveDuration = _moveDurationSlider.value;
}

- (IBAction)triggerBufferLengthSliderAction:(id)sender {
    int step = 500;
    [_triggerBufferLengthSlider setValue:((int)((_triggerBufferLengthSlider.value + step/2) / step) * step) animated:NO];
    self.triggerBufferLengthOutput.text = [NSString stringWithFormat:@"%d", (int)_triggerBufferLengthSlider.value];
    _m_eventConfig.triggerBufferLength = _triggerBufferLengthSlider.value;
}

- (IBAction)moveBufferLengthSliderAction:(id)sender {
    int step = 500;
    [_moveBufferLengthSlider setValue:((int)((_moveBufferLengthSlider.value + step/2) / step) * step) animated:NO];
    self.moveBufferLengthOutput.text = [NSString stringWithFormat:@"%d", (int)_moveBufferLengthSlider.value];
    _m_eventConfig.moveBufferLength = _moveBufferLengthSlider.value;
}

- (IBAction)setBufferLengthSliderAction:(id)sender {
    int step = 500;
    [_setBufferLengthSlider setValue:((int)((_setBufferLengthSlider.value + step/2) / step) * step) animated:NO];
    self.setBufferLengthOutput.text = [NSString stringWithFormat:@"%d", (int)_setBufferLengthSlider.value];
    _m_eventConfig.setBufferLength = _setBufferLengthSlider.value;
}


-(IBAction) updateButtonAction:(id)sender
{
    NSData *configData = [NSData dataWithBytes:&_m_eventConfig length:sizeof(_m_eventConfig)];
    NSLog(@"Writing config data: %@", configData);
    [_modelController writeToConfig:configData];
}

 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    //[self.currentPeripheral writeValue:configData forCharacteristic:eventConfigChar  type:CBCharacteristicWriteWithResponse];

{

}


@end
