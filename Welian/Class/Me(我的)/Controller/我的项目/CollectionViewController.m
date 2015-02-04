//
//  CollectionViewController.m
//  Welian
//
//  Created by dong on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "CollectionViewController.h"
#import "ProjectIndustryCell.h"
#import "IInvestIndustryModel.h"
#import "IInvestStageModel.h"

@interface CollectionViewController ()
{
    NSMutableArray *_alldataArray;
    NSInteger _type;
}
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"ProjectIndustryCell";

- (void)jiexidata:(NSArray *)dataarray
{
    [_alldataArray removeAllObjects];
    IInvestIndustryModel *industA = [[IInvestIndustryModel alloc] init];
    [industA setIndustryid:@(-1)];
    [industA setIndustryname:@"不限"];
    [_alldataArray insertObject:industA atIndex:0];
    for (NSDictionary *indDic in dataarray) {
        IInvestIndustryModel *indust = [[IInvestIndustryModel alloc] init];
        [indust setIndustryid:[indDic objectForKey:@"id"]];
        [indust setIndustryname:[indDic objectForKey:@"name"]];
        [_alldataArray addObject:indust];
    }
    [self.collectionView reloadData];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout withType:(NSInteger)type
{
   self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _type = type;
        [self setTitle:@"项目领域"];
        _alldataArray = [NSMutableArray array];
        if (type==1) {
            YTKKeyValueItem *item = [[WLDataDBTool sharedService] getYTKKeyValueItemById:KInvestIndustryTableName fromTable:KInvestIndustryTableName];
            NSArray *itemArray = item.itemObject;
            [self jiexidata:itemArray];
            [WLHttpTool getIndustryParameterDic:@{} success:^(id JSON) {
                [self jiexidata:JSON];
            } fail:^(NSError *error) {
                
            }];
        }else if (type==2){
            // 1.获得路径
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"InvestStagePlist" withExtension:@"plist"];
            // 2.读取数据
            NSArray *stageData = [NSArray arrayWithContentsOfURL:url];

            for (NSDictionary *stageDic in stageData) {
                IInvestStageModel *stageM = [[IInvestStageModel alloc] init];
                [stageM setStage:[stageDic objectForKey:@"stage"]];
                [stageM setStagename:[stageDic objectForKey:@"stagename"]];
                [_alldataArray addObject:stageM];
            }
            [self.collectionView reloadData];

        }
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveData)];
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView setBackgroundColor:WLLineColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProjectIndustryCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)saveData
{
    
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _alldataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectIndustryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (_type==1) {
        IInvestIndustryModel *model = _alldataArray[indexPath.row];
        [cell.titLabel setText:model.industryname];
        [cell.selectBut setSelected:model.isSelect];
    }else if (_type ==2){
        IInvestStageModel *stageM = _alldataArray[indexPath.row];
        [cell.titLabel setText:stageM.stagename];
        [cell.selectBut setSelected:stageM.isSelect];
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectIndustryCell *cell = (ProjectIndustryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.selectBut setSelected:!cell.selectBut.selected];
    if (_type ==1) {
        IInvestIndustryModel *model = _alldataArray[indexPath.row];
        if ([model.industryname isEqualToString:@"不限"]) {
            for (NSInteger i = 0; i<_alldataArray.count; i++) {
                IInvestIndustryModel *invmodel = _alldataArray[i];
                [invmodel setIsSelect:cell.selectBut.selected];
                [_alldataArray replaceObjectAtIndex:i withObject:invmodel];
            }
            [self.collectionView reloadData];
            return NO;
        }else{
            IInvestIndustryModel *buxian = _alldataArray[0];
            if ([buxian.industryname isEqualToString:@"不限"]&&buxian.isSelect) {
                [buxian setIsSelect:cell.selectBut.selected];
                [_alldataArray replaceObjectAtIndex:0 withObject:buxian];
                ProjectIndustryCell *cell = (ProjectIndustryCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                [cell.selectBut setSelected:buxian.isSelect];
            }
            [model setIsSelect:cell.selectBut.selected];
            [_alldataArray replaceObjectAtIndex:indexPath.row withObject:model];
        }
    }else if (_type ==2){
        IInvestStageModel *stageM = _alldataArray[indexPath.row];
        [stageM setIsSelect:cell.selectBut.selected];
        [_alldataArray replaceObjectAtIndex:indexPath.row withObject:stageM];
    }
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectIndustryCell *cell = (ProjectIndustryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.selectBut setSelected:!cell.selectBut.selected];
    if (_type ==1) {
        IInvestIndustryModel *model = _alldataArray[indexPath.row];
        [model setIsSelect:cell.selectBut.selected];
        [_alldataArray replaceObjectAtIndex:indexPath.row withObject:model];
    }else if (_type ==2){
        IInvestStageModel *stageM = _alldataArray[indexPath.row];
        [stageM setIsSelect:cell.selectBut.selected];
        [_alldataArray replaceObjectAtIndex:indexPath.row withObject:stageM];
    }
    
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
