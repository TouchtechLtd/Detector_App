//
//  TrapDetailViewCell.h
//  Detector_App
//
//  Created by Michael McAdam on 20/11/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrapDetailViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateStamp;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *killNum;
@property (weak, nonatomic) IBOutlet UILabel *peakValue;
@property (weak, nonatomic) IBOutlet UILabel *temperature;

@end
