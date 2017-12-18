//
//  RawDataGraphViewController.m
//  Detector_App
//
//  Created by Michael McAdam on 29/11/17.
//  Copyright © 2017 Goodnature. All rights reserved.
//

#import "RawDataGraphViewController.h"
#import "Charts-Swift.h"

@interface RawDataGraphViewController () <ChartViewDelegate>
@property (weak, nonatomic) IBOutlet LineChartView *rawDataView;

@property (strong, nonatomic) NSMutableArray *xValues;
@property (strong, nonatomic) NSMutableArray *yValues;
@property (strong, nonatomic) NSMutableArray *zValues;
@property (strong, nonatomic) NSMutableArray *sumValues;
@property (weak, nonatomic) IBOutlet UINavigationItem *graphTitle;

- (IBAction)xButton:(id)sender;
- (IBAction)yButton:(id)sender;
- (IBAction)zButton:(id)sender;
- (IBAction)sumButton:(id)sender;

@end

@implementation RawDataGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _rawDataView.chartDescription.enabled = NO;
    _rawDataView.rightAxis.enabled = NO;
    _rawDataView.legend.enabled = NO;
    _rawDataView.xAxis.labelPosition = XAxisLabelPositionBottom;
    
    _rawDataView.dragEnabled = YES;
    [_rawDataView setScaleEnabled:YES];
    _rawDataView.pinchZoomEnabled = YES;
    _rawDataView.drawGridBackgroundEnabled = NO;
    
    _rawDataView.delegate = self;
    _rawDataView.noDataText = @"Please Select Data";
    
    _xValues =   [NSMutableArray array];
    _yValues =   [NSMutableArray array];
    _zValues =   [NSMutableArray array];
    _sumValues = [NSMutableArray array];
    
    for (int i = 0; i < RAW_EVENT_SIZE; i++)
    {
        [_xValues addObject: [[ChartDataEntry alloc] initWithX:i y:_rawEventData.data[i].acc.x]];
        [_yValues addObject: [[ChartDataEntry alloc] initWithX:i y:_rawEventData.data[i].acc.y]];
        [_zValues addObject: [[ChartDataEntry alloc] initWithX:i y:_rawEventData.data[i].acc.z]];
        [_sumValues addObject: [[ChartDataEntry alloc] initWithX:i y:_rawEventData.data[i].sum]];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setData: (NSMutableArray* ) values withColour: (UIColor *) colour
{
    
    LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithValues:values];
    
    [dataSet setColor:colour];
    dataSet.drawCirclesEnabled = NO;
    
    LineChartData *data = [[LineChartData alloc] initWithDataSet:dataSet];
    
    _rawDataView.data = data;
}

- (IBAction)xButton:(id)sender {
    _graphTitle.title = @"X";
    [self setData: _xValues withColour: UIColor.blueColor];
}

- (IBAction)yButton:(id)sender {
    _graphTitle.title = @"Y";
    [self setData: _yValues withColour:UIColor.redColor];
}

- (IBAction)zButton:(id)sender {
    _graphTitle.title = @"Z";
    [self setData: _zValues withColour:[UIColor colorWithRed:0/255.0 green:128/255.0 blue:64/255.0 alpha:1.0]];
}

- (IBAction)sumButton:(id)sender {
    _graphTitle.title = @"Sum";
    [self setData: _sumValues withColour:UIColor.darkGrayColor];
}
 
@end
