//
//  MainViewController.m
//  Detector_App
//
//  Created by Michael McAdam on 8/11/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import "MainViewController.h"
#import "TrapDetailViewController.h"
#import "ModelController.h"
#import "TrapListTableViewCell.h"
#import "TrapDataClass.h"


@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;
@property (strong, nonatomic) NSTimer* tableTimer;

@property (strong, nonatomic) ModelController *modelController;
@property (weak, nonatomic) IBOutlet UITableView *eventTable;
- (IBAction)downLoadButton:(id)sender;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _modelController = [[ModelController alloc] init];
    [_modelController start];
    
    
    
    _tableTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"trapDetailSegue"])
    {
        NSIndexPath *indexPath = [self.eventTable indexPathForCell:sender];
        
        NSArray *keys = [_modelController.trapDataController.trapList allKeys];
        NSString *aKey = [keys objectAtIndex:indexPath.row];
        TrapDataClass *aTrap = [_modelController.trapDataController.trapList objectForKey:aKey];
        

        TrapDetailViewController *vc = [segue destinationViewController];
        vc.modelController = _modelController;
        vc.trapDetails = aTrap;
    
    }
}

-(IBAction)disconnectUnwind:(UIStoryboardSegue *)segue {
}


    
- (void) updateTimer {
    
    if (_modelController.bleController.isConnected)
    {
        _connectedLabel.text = @"Connected";
    }
    else
    {
        _connectedLabel.text = @"Searching...";
    }
    
    [_eventTable reloadData];
}



#pragma mark - UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_modelController.trapDataController.trapList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"eventCell";
    TrapListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSArray *keys = [_modelController.trapDataController.trapList allKeys];
    NSString *aKey = [keys objectAtIndex:indexPath.row];
    
    
    if ([aKey intValue] == DEFAULT_TRAP_ID)
    {
        [self newTrapConnected: [aKey intValue]];
        return cell;
    }
     
    
    TrapDataClass *aTrap = [_modelController.trapDataController.trapList objectForKey:aKey];
    
    //cell.trapID.text =  [NSString stringWithFormat:@"%x",    aTrap.m_trapInfo.trapID];
    cell.trapID.text = aKey;
    cell.killNum.text = [NSString stringWithFormat:@"%d",   aTrap.detector.m_killNumber];
    
    if (aTrap.device.m_state == IDLE_STATE)
    {
        cell.activeStateLabel.text = @"Inactive";
        cell.activeStateLabel.textColor = [UIColor colorWithRed:128/255.0
                                                          green:0.0
                                                           blue:0.0
                                                          alpha:1.0];
    }
    else if (aTrap.device.m_state == ACTIVE_STATE)
    {
        cell.activeStateLabel.text = @"Active";
        cell.activeStateLabel.textColor = [UIColor colorWithRed:0.0
                                                          green:128/255.0
                                                           blue:64/255.0
                                                          alpha:1.0];
    }
    else
    {
        cell.activeStateLabel.text = @"Error";
        cell.activeStateLabel.textColor = [UIColor colorWithRed:255/255.0
                                                          green:0.0
                                                           blue:0.0
                                                          alpha:1.0];
    }
    
    if (aTrap.isConnected)
    {
        cell.trapImage.highlighted = true;
    }
    else
    {
        cell.trapImage.highlighted = false;
    }
    
    NSDateFormatter *dateFormatterYear = [[NSDateFormatter alloc] init];
    [dateFormatterYear setDateFormat:@"HH:mm dd/MM/yy"];
    cell.lastUpdateTime.text = [dateFormatterYear stringFromDate:aTrap.lastConnectionTime];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Entered commitEditingStyle");
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this

        
        NSArray *keys = [_modelController.trapDataController.trapList allKeys];
        NSString *aKey = [keys objectAtIndex:indexPath.row];
        
        [_modelController.trapDataController.trapList removeObjectForKey:aKey];
        
        [tableView reloadData]; // tell table to refresh now
    }
}



- (IBAction)downLoadButton:(id)sender
{
    NSError *error;
    
    id trapListJson = [_modelController jsonObject];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:trapListJson
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self writeStringToFile: jsonString];
    }
    NSLog(@"Downloaded");
}


-(void) writeStringToFile:(NSString*) aString
{
    // Build the path, and create if needed.
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSDateFormatter *dateFormatterYear = [[NSDateFormatter alloc] init];
    [dateFormatterYear setDateFormat:@"HH:mm-dd/MM/yy"];
    //NSString* fileName = [NSString stringWithFormat:@"%@.json", [dateFormatterYear stringFromDate:[NSDate date]]];
    
    NSString* fileName = @"TrapDataOutputFile.json";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    // The main act...
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
    
}




-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    uint32_t textValue = [[textField.text stringByAppendingString:string] intValue];
    return textValue < 1000 && textValue > 0;
}


- (void) newTrapConnected: (uint32_t) oldID
{
    [_tableTimer invalidate];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Trap Connected - Set ID" message:@"Value must be less than 1000" preferredStyle:UIAlertControllerStyleAlert];
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
                                                            _tableTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
                                                            [_eventTable reloadData];
                                                        }];
    
    
    [alertController addAction:setIDAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
