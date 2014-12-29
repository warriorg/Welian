//
//  InvestCollectionVC.m
//  Welian
//
//  Created by dong on 14/12/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestCollectionVC.h"
#import "InvestCollectionCell.h"
#import "IInvestIndustryModel.h"
#import "IInvestStageModel.h"
#import "InvestStages.h"
#import "InvestIndustry.h"

@interface InvestCollectionVC () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _type;
    NSMutableArray *_alldataArray;
    NSArray *_selectCells;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation InvestCollectionVC

static NSString * const reuseIdentifier = @"Cell";

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setMinimumLineSpacing:1];
        [flowLayout setMinimumInteritemSpacing:0.5];
        [flowLayout setItemSize:CGSizeMake([MainScreen bounds].size.width/2-0.5, 50)];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_collectionView setBackgroundColor:WLLineColor];
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [self.view addSubview:_collectionView];

    }
    return _collectionView;
}

- (instancetype)initWithType:(NSInteger)type
{
    self = [super init];
    if (self) {
        _type = type;

        _alldataArray = [NSMutableArray array];
        // 注册cell
        [self.collectionView registerNib:[UINib nibWithNibName:@"InvestCollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        if (type==1) { // 投资领域
            [self setTitle:@"投资领域"];
            _selectCells = [LogInUser getNowLogInUser].rsInvestIndustrys.allObjects;
            [WLHttpTool getIndustryParameterDic:@{} success:^(id JSON) {
                for (NSDictionary *indDic in JSON) {
                    IInvestIndustryModel *indust = [[IInvestIndustryModel alloc] init];
                    [indust setIndustryid:[indDic objectForKey:@"id"]];
                    [indust setIndustryname:[indDic objectForKey:@"name"]];
                    if ([InvestIndustry getInvestIndustryWithName:indust.industryname]) {
                        [indust setIsSelect:YES];
                    }
                    [_alldataArray addObject:indust];
                }
                [self.collectionView reloadData];
            } fail:^(NSError *error) {

            }];
            
        }else if (type ==2){ // 投资阶段
            [self setTitle:@"投资阶段"];
            _selectCells = [LogInUser getNowLogInUser].rsInvestStages.allObjects;
            // 1.获得路径
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"InvestStagePlist" withExtension:@"plist"];
            
            // 2.读取数据
            NSArray *stageData = [NSArray arrayWithContentsOfURL:url];
            for (NSDictionary *stageDic in stageData) {
                IInvestStageModel *stageM = [[IInvestStageModel alloc] init];
                [stageM setStage:[stageDic objectForKey:@"stage"]];
                [stageM setStagename:[stageDic objectForKey:@"stagename"]];
                if ([InvestStages getInvestStagesWithStage:stageM.stagename]) {
                    [stageM setIsSelect:YES];
                }
                [_alldataArray addObject:stageM];
            }
            [self.collectionView reloadData];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveData)];
}

- (void)saveData
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (_type ==1) {
        return _alldataArray.count+1;
    }else if (_type ==2){
        return _alldataArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InvestCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    
    if (_type==1) {
        if (indexPath.row ==0) {
            [cell.titeLabel setText:@"全部"];
        }else{
            if (_alldataArray.count) {
                
                IInvestIndustryModel *indusM = _alldataArray[indexPath.row-1];
                [cell.titeLabel setText:indusM.industryname];
                [cell setSelected:indusM.isSelect];
            }
        }
        
    }else if (_type ==2){
        IInvestStageModel *stageM = _alldataArray[indexPath.row];
        [cell.titeLabel setText:stageM.stagename];
        [cell setSelected:stageM.isSelect];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%@",indexPath);
    if (indexPath.row==0) {
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%@",indexPath);
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    InvestCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    if (!cell.highlighted) {
//        return YES;
//    }
//    return NO;
//}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    InvestCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    if (cell.selected) {
//        return YES;
//    }
//    return NO;
//}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
