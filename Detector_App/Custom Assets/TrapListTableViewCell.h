//
//  TrapListTableViewCell.h
//  Detector_App
//
//  Created by Michael McAdam on 20/11/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrapListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *trapImage;
@property (weak, nonatomic) IBOutlet UILabel *activeStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *trapID;
@property (weak, nonatomic) IBOutlet UILabel *killNum;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateTime;
@end
