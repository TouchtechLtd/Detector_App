//
//  RawDataViewController.m
//  Detector_App
//
//  Created by Michael McAdam on 22/11/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import "RawDataViewController.h"

@interface RawDataViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *rawDataTableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *rawDataTitle;

@end

@implementation RawDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rawDataTitle.title = [NSString stringWithFormat:@"Kill %d Raw Data", _rawEventData.eventNumber];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(rawDataUpdateTimer) userInfo:nil repeats:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



- (void) rawDataUpdateTimer {
    [_rawDataTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return RAW_EVENT_SIZE;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"rawTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    //NSArray *keys = [trapDetails.killList allKeys];
    //NSNumber *aKey = [keys objectAtIndex:indexPath.row];
    //NSValue *dataPoint = [_rawEventData.m_rawEventData objectForKey:[NSNumber numberWithLong:indexPath.row + 1]];
    //raw_event_data_t rawDataPoint;
    //[dataPoint getValue:&rawDataPoint];
    
    lraw_event_data_t dataPoint = _rawEventData.data[indexPath.row + 1];
    
    cell.textLabel.text = [NSString stringWithFormat: @"X:%d, Y:%d, Z:%d, Sum:%d", dataPoint.acc.x, dataPoint.acc.y, dataPoint.acc.z, dataPoint.sum];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
 

@end
