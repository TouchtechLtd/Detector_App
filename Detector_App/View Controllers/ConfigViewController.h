//
//  ViewController.h
//  Detector_App
//
//  Created by Michael McAdam on 20/09/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelController.h"
#import "TrapDataClass.h"

@interface ConfigViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *configTitle;

@property (weak, nonatomic) ModelController *modelController;

@property detector_config_t m_eventConfig;


@property (weak, nonatomic) IBOutlet UILabel *triggerThresholdOutput;
@property (weak, nonatomic) IBOutlet UISlider *triggerThresholdSlider;
- (IBAction)triggerThresholdSliderAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *moveThresholdOutput;
@property (weak, nonatomic) IBOutlet UISlider *moveThresholdSlider;
- (IBAction)moveThresholdSliderAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *triggerDurationOutput;
@property (weak, nonatomic) IBOutlet UISlider *triggerDurationSlider;
- (IBAction)triggerDurationSliderAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *moveDurationOutput;
@property (weak, nonatomic) IBOutlet UISlider *moveDurationSlider;
- (IBAction)moveDurationSliderAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *triggerBufferLengthOutput;
@property (weak, nonatomic) IBOutlet UISlider *triggerBufferLengthSlider;
- (IBAction)triggerBufferLengthSliderAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *moveBufferLengthOutput;
@property (weak, nonatomic) IBOutlet UISlider *moveBufferLengthSlider;
- (IBAction)moveBufferLengthSliderAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *setBufferLengthOutput;
@property (weak, nonatomic) IBOutlet UISlider *setBufferLengthSlider;
- (IBAction)setBufferLengthSliderAction:(id)sender;

- (IBAction)updateButtonAction:(id)sender;


@end

