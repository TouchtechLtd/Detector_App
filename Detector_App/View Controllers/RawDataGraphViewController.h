//
//  RawDataGraphViewController.h
//  Detector_App
//
//  Created by Michael McAdam on 29/11/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelController.h"
#import "TrapDataClass.h"

@interface RawDataGraphViewController : UIViewController

@property (strong, nonatomic) ModelController *modelController;
@property raw_event_t                         rawEventData;

@end
