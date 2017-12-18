//
//  RawDataViewController.h
//  Detector_App
//
//  Created by Michael McAdam on 22/11/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelController.h"
#import "TrapDataClass.h"

@interface RawDataViewController : UIViewController

@property (strong, nonatomic) ModelController *modelController;
@property raw_event_t                         rawEventData;

@end
