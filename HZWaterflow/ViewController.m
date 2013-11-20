//
//  ViewController.m
//  pubuliu
//
//  Created by Hilen on 7/13/13.
//  Copyright (c) 2013 KZ. All rights reserved.
//

#import "ViewController.h"
#import "PSCollectionView.h"
#import "MouthCell.h"
#import "PersonCell.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface ViewController (){
    NSString *type;
    NSMutableArray *arrayOne;
}

@end

@implementation ViewController

- (void)addNavigationBarAction{
    //定义左侧按钮 custom the left BarButtonItem
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    [left setTitle:@"Mouth" forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 90, 40);
    [left addTarget:self action:@selector(switchMouth) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:left];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    //定义右侧按钮 custom the right BarButtonItem
    UIButton *right = [UIButton buttonWithType:UIButtonTypeSystem];
    [right setTitle:@"Person" forState:UIControlStateNormal];
    right.frame = CGRectMake(0, 0, 90, 40);
    [right addTarget:self action:@selector(switchPerson) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:right];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavigationBarAction];
    type = @"mouth"; //default is mouth
    
    //init waterFlowView
    self.waterFLowView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    self.waterFLowView.delegate = self; // This is for UIScrollViewDelegate
    self.waterFLowView.collectionViewDelegate = self;
    self.waterFLowView.collectionViewDataSource = self;
    self.waterFLowView.backgroundColor = [UIColor clearColor];
    self.waterFLowView.autoresizingMask = ~UIViewAutoresizingNone;
    
    //waterFlow header
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    header.backgroundColor = [UIColor yellowColor];
    self.waterFLowView.headerView = header;

    //waterFlow footer
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 50)];
    label.text = @"Loading...";
    self.waterFLowView.footerView = label;
    
    // Specify number of columns for both
    self.waterFLowView.numColsPortrait = 2;
//    self.waterFLowView.numColsLandscape = 4;   //This is for iPad
    [self.view addSubview:self.waterFLowView];
    
    [self addRefreshView];
}

- (void)addRefreshView{
    self.slimeView = [[SRRefreshView alloc] init];
    self.slimeView.delegate = self;
    self.slimeView.slimeMissWhenGoingBack = YES;
    self.slimeView.slime.bodyColor = RGBCOLOR(30, 119, 250);
    self.slimeView.slime.skinColor = RGBCOLOR(30, 119, 250);
    [self.waterFLowView addSubview:self.slimeView];
    [self.slimeView setLoadingWithexpansion];  //上来就刷新
    [self refreshNewData];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.slimeView scrollViewDidScroll];
    
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    if (scrollOffset == 0) {
        NSLog(@"scroll to the top");
    }else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight) {
        NSLog(@"scroll to the bottom");
        [self loadMOreData];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.slimeView scrollViewDidEndDraging];
}

#pragma mark - SRRefreshView delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    NSLog(@"refresh");
    [self refreshNewData];
}

#pragma mark - New fresh & load more method
- (void)refreshNewData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [arrayOne removeAllObjects];
        arrayOne = [[NSMutableArray alloc]init];
        for (int i = 0; i < 5; i++) {
            [arrayOne addObject:[NSString stringWithFormat:@"%d",i]];
        }
        /*
         
         *do some thing stuff to load the data
         *你可以在这里加载本地数据
         
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            /*
             *when the data is finishing load ,slimeView will hide.
             *当数据加载完毕，隐藏slimeView
             */
            [self.slimeView endRefresh];   //after 3 seconds, the slimeView will hide
            [self.waterFLowView reloadData];
        });
    });
}

- (void)loadMOreData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        sleep(3);
        for (int i = 0; i < 5; i++) {
            [arrayOne addObject:[NSString stringWithFormat:@"%d",i]];
        }
        /*
         *do some thing stuff to load the data
         *你可以在这里加载本地数据
         
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            /*
             *when the data is finishing load ,slimeView will hide.
             *当数据加载完毕，隐藏slimeView
             */
            [self.slimeView endRefresh];   //after 3 seconds, the slimeView will hide
            [self.waterFLowView reloadData];
        });
    });
}


#pragma mark - PSCollectionView delegate & dataSource

- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index {
    if ([type isEqualToString:@"mouth"]) {
        return [PersonCell class];
    }else if ([type isEqualToString:@"person"]){
        return [MouthCell class];
    }
    return nil;
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index{
    NSLog(@"you select cell index:%ld",(long)index);
}

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    return arrayOne.count;
}

- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index {
    NSString *item = [arrayOne objectAtIndex:index]; // your dataModel
    
    if ([type isEqualToString:@"mouth"]) {
        MouthCell *cell = (MouthCell *)[self.waterFLowView dequeueReusableViewForClass:[MouthCell class]];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MouthCell" owner:self options:nil];
            cell = (MouthCell *)[nib objectAtIndex:0];
        }
        cell.name.text = item;
        [cell collectionView:_waterFLowView fillCellWithObject:item atIndex:index];
        return cell;
        
    }else if ([type isEqualToString:@"person"]){
        PersonCell *cell = (PersonCell *)[self.waterFLowView dequeueReusableViewForClass:[PersonCell class]];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PersonCell" owner:self options:nil];
            cell = (PersonCell *)[nib objectAtIndex:0];
        }
        cell.name.text = item;
        [cell collectionView:_waterFLowView fillCellWithObject:item atIndex:index];
        return cell;
    }
    return nil;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    NSString *item = [arrayOne objectAtIndex:index];
    if ([type isEqualToString:@"mouth"]) {
        return [MouthCell rowHeightForObject:item inColumnWidth:_waterFLowView.colWidth];
    }else if ([type isEqualToString:@"person"]){
        return [PersonCell rowHeightForObject:item inColumnWidth:_waterFLowView.colWidth];
    }
    return 0;
}


#pragma mark - Button method
- (void)switchMouth{
    type = @"mouth";
    self.waterFLowView.numColsPortrait = 2;
    [self.waterFLowView reloadData];
}

- (void)switchPerson{
    type = @"person";
    self.waterFLowView.numColsPortrait = 1;
    [self.waterFLowView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
