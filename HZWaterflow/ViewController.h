//
//  ViewController.h
//  pubuliu
//
//  Created by Hilen on 7/13/13.
//  Copyright (c) 2013 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"
#import "SRRefreshView.h"

@interface ViewController : UIViewController<UIScrollViewDelegate,PSCollectionViewDataSource,PSCollectionViewDelegate,SRRefreshDelegate>{

}
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong,nonatomic) PSCollectionView *waterFLowView;

@end
