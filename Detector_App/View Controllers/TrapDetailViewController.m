//
//  TrapDetailViewController.m
//  Detector_App
//
//  Created by Michael McAdam on 20/11/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import "TrapDetailViewController.h"
#import "TrapDetailViewCell.h"
#import "RawDataGraphViewController.h"
#import "ConfigViewController.h"

@interface TrapDetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *trapDetailTable;
@property (weak, nonatomic) IBOutlet UINavigationItem *trapDetailTitle;
@property (weak, nonatomic) IBOutlet UILabel *trapIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *killNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detectorStateLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *activateButtonOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *trapImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *setIDOutlet;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;


- (IBAction)activateButton:(id)sender;
- (IBAction)setIDButton:(id)sender;

@end

@implementation TrapDetailViewController


//@synthesize modelController;
@synthesize trapDetails;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self updateTimer];
    
    _trapIDLabel.text = [NSString stringWithFormat:@"Trap: %d", trapDetails.device.m_ID];

    NSDateFormatter *dateFormatterYear = [[NSDateFormatter alloc] init];
    [dateFormatterYear setDateFormat:@"HH:mm dd/MM/yy"];
    _lastUpdateTimeLabel.text =  [dateFormatterYear stringFromDate:trapDetails.lastConnectionTime];
    
    _trapDetailTitle.title = [NSString stringWithFormat:@"Trap: %d", trapDetails.device.m_ID];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    _versionLabel.text = [NSString stringWithFormat:@"%d.%d",
                          trapDetails.device.m_softwareVersion.major,
                          trapDetails.device.m_softwareVersion.minor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) updateTimer {
    
    _killNumberLabel.text = [NSString stringWithFormat:@"%d",   trapDetails.detector.m_killNumber];
    
    switch (trapDetails.device.m_state) {
        case IDLE_STATE:
            _mainStateLabel.text = @"Inactive";
            _mainStateLabel.textColor = [UIColor colorWithRed:128/255.0
                                                        green:0.0
                                                         blue:0.0
                                                        alpha:1.0];
            break;
            
        case ACTIVE_STATE:
            _mainStateLabel.text = @"Active";
            _mainStateLabel.textColor = [UIColor colorWithRed:0.0
                                                        green:128/255.0
                                                         blue:64/255.0
                                                        alpha:1.0];
            break;
            
            
        default:
            _mainStateLabel.text = @"Error";
            _mainStateLabel.textColor = [UIColor colorWithRed:255/255.0
                                                        green:0.0
                                                         blue:0.0
                                                        alpha:1.0];
            break;
    }
    
    switch (trapDetails.detector.m_state)
    {
        case WAIT_STATE:
            _detectorStateLabel.text = @"Waiting";
            break;
        case EVENT_BUFFER_STATE:
            _detectorStateLabel.text = @"Triggered";
            break;
        case DETECT_MOVE_STATE:
            _detectorStateLabel.text = @"Waiting for move";
            break;
        case MOVING_STATE:
            _detectorStateLabel.text = @"Moving";
            break;
    }
    
    if (trapDetails.isConnected == true)
    {
        _trapImage.highlighted = true;
    }
    else
    {
        _trapImage.highlighted = false;
    }

    [self setButtonText];
    [_trapDetailTable reloadData];
}


- (void) setButtonText
{
    if (trapDetails.isConnected == false)
    {
        _activateButtonOutlet.title = @"";
        _setIDOutlet.title = @"";
    }
    else
    {
        _setIDOutlet.title = @"Set ID";
        switch (trapDetails.device.m_state)
        {
            case IDLE_STATE:
                _activateButtonOutlet.title = @"Activate";
                break;
                
            case ACTIVE_STATE:
                _activateButtonOutlet.title = @"Deactivate";
                break;
        }
    }
    
    _trapDetailTitle.title = [NSString stringWithFormat:@"Trap: %d", trapDetails.device.m_ID];
    _trapIDLabel.text = [NSString stringWithFormat:@"Trap: %d", trapDetails.device.m_ID];
    
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"rawDataSegue"]) {
        
        NSIndexPath *indexPath = [self.trapDetailTable indexPathForCell:sender];
        
        
        RawDataGraphViewController *vc = [segue destinationViewController];
        vc.modelController = _modelController;
        //vc.rawEventData = [trapDetails.rawEvent.m_rawEventData objectForKey:[NSNumber numberWithLong:indexPath.row + 1]];
        detector_data_t selectedKill = [trapDetails.detector getKill:indexPath.row + 1];
        vc.rawEventData = [trapDetails.rawEvent getEvent:selectedKill.rawEventData];
    }
    
    if([segue.identifier isEqualToString:@"configSegue"]) {
               
        ConfigViewController *vc = [segue destinationViewController];
        vc.modelController = _modelController;
        vc.m_eventConfig = trapDetails.detector.m_detectorConfig;
    }
     
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [trapDetails.detector.m_eventData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"killDetailCell";
    TrapDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    /*
    NSArray *keys = [trapDetails.detector.m_eventData allKeys];
    NSNumber *aKey = [keys objectAtIndex:indexPath.row];
    detector_data_t *killData = [trapDetails.detector.m_eventData objectForKey:[NSNumber numberWithLong:indexPath.row + 1]];
     */
    detector_data_t killData = [trapDetails.detector getKill:indexPath.row + 1];
    
    cell.killNum.text = [NSString stringWithFormat:@"%d",  killData.killNumber];
    cell.peakValue.text = [NSString stringWithFormat:@"%d", killData.peak_level];
    cell.temperature.text = [NSString stringWithFormat:@"%d", killData.temperature];
    
    //NSTimeZone *tz = [NSTimeZone defaultTimeZone];

    NSDate *killDate = [NSDate dateWithTimeIntervalSince1970:(killData.timestamp.time * 60)] ;
    
    NSDateFormatter *dateFormatterYear = [[NSDateFormatter alloc] init];
    [dateFormatterYear setDateFormat:@"dd MMM yyyy"];
    cell.dateStamp.text = [dateFormatterYear stringFromDate:killDate];
    
    NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc] init];
    [dateFormatterTime setDateFormat:@"HH:mm"];
    cell.timeStamp.text = [dateFormatterTime stringFromDate:killDate];
    
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (IBAction)activateButton:(id)sender
{

    switch (trapDetails.device.m_state)
    {
        case IDLE_STATE:
            [_modelController activateTrap];
            break;
            
        case ACTIVE_STATE:
            [_modelController deactivateTrap];
            break;
    }
    
}


-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    uint32_t textValue = [[textField.text stringByAppendingString:string] intValue];
    return textValue < 1000 && textValue > 0;
}


- (IBAction)setIDButton:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set ID" message:@"Value must be less than 1000" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter New ID";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.delegate = self;
    }];
    
    UIAlertAction* setIDAction = [UIAlertAction actionWithTitle:@"Set ID"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action){
                                                            uint32_t newID = [alertController.textFields[0].text intValue];
                                                            NSLog(@"input was '%d'", newID);
                                                            [_modelController setID: newID];

                                                        }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:setIDAction];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
