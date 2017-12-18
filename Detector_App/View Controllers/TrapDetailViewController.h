//
//  TrapDetailViewController.h
//  Detector_App
//
//  Created by Michael McAdam on 20/11/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelController.h"
#import "TrapDataClass.h"


@interface TrapDetailViewController : UIViewController

@property (strong, nonatomic) ModelController *modelController;
@property (strong, nonatomic) TrapDataClass   *trapDetails;


@end
