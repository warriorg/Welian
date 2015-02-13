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
    IProjectDetailInfo *_projectModel;
}
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"ProjectIndustryCell";

- (void)jiexidata:(NSArray *)dataarray
{
    [_alldataArray removeAllObjects];
    NSMutableArray *allArray = [NSMutableArray arrayWithArray:dataarray];
    [allArray insertObject:@{@"id":@(-1),@"name":@"不限"} atIndex:0];
    BOOL isAll = NO;
    for (NSDictionary *indDic in allArray) {
        IInvestIndustryModel *indust = [[IInvestIndustryModel alloc] init];
        [indust setIndustryid:[indDic objectForKey:@"id"]];
        [indust setIndustryname:[indDic objectForKey:@"name"]];
        if (_projectModel.industrys.count) {
            NSString *buxianname = [_projectModel getindustrysName][0];
            if ([buxianname isEqualToString:@"不限"]) {
                isAll = YES;
            }else{
                for (NSString *nameStr in [_projectModel getindustrysName]) {
                    if ([[nameStr deleteTopAndBottomKonggeAndHuiche] isEqualToString:[indDic objectForKey:@"name"]]) {
                        [indust setIsSelect:YES];
                    }
                }
            }
            if (isAll) {
                [indust setIsSelect:YES];
            }
        }
        
        [_alldataArray addObject:indust];
    }
    [self.collectionView reloadData];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout withType:(NSInteger)type withData:(IProjectDetailInfo *)projectModel
{
   self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _type = type;
        _projectModel = projectModel;
        _alldataArray = [NSMutableArray array];
        if (type==1) {
            [self setTitle:@"项目领域"];
            YTKKeyValueItem *item = [[WLDataDBTool sharedService] getYTKKeyValueItemById:KInvestIndustryTableName fromTable:KInvestIndustryTableName];
            NSArray *itemArray = item.itemObject;
            [self jiexidata:itemArray];
            [WLHttpTool getIndustryParameterDic:@{} success:^(id JSON) {
                [self jiexidata:JSON];
            } fail:^(NSError *error) {
                
            }];
        }else if (type==2){
            [self setTitle:@"融资阶段"];
            // 1.获得路径
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"FinancingStagePlist" withExtension:@"plist"];
            // 2.读取数据
            NSArray *stageData = [NSArray arrayWithContentsOfURL:url];
            for (NSDictionary *stageDic in stageData) {
                IInvestStageModel *stageM = [[IInvestStageModel alloc] init];
                [stageM setStage:[stageDic objectForKey:@"stage"]];
                [stageM setStagename:[stageDic objectForKey:@"stagename"]];
                [_alldataArray addObject:stageM];
            }
            if (projectModel.stage) {
                NSInteger stage = projectModel.stage.integerValue;
                IInvestStageModel *seleStageM = _alldataArray[stage];
                [seleStageM setIsSelect:YES];
                [_alldataArray replaceObjectAtIndex:stage withObject:seleStageM];
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
    if (_type ==1) {
        [cell.selectBut setSelected:!cell.selectBut.selected];
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
        if (!cell.selectBut.selected) {
            for (NSInteger row = 0; row<_alldataArray.count; row++) {
                IInvestStageModel *stageM = _alldataArray[row];
                if (stageM.isSelect) {
                    ProjectIndustryCell *cell = (ProjectIndustryCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                    [cell.selectBut setSelected:NO];
                    [stageM setIsSelect:NO];
                    [_alldataArray replaceObjectAtIndex:row withObject:stageM];
                }
            }
        }else{
        
        }
        [cell.selectBut setSelected:!cell.selectBut.selected];
        [stageM setIsSelect:cell.selectBut.selected];
        [_alldataArray replaceObjectAtIndex:indexPath.row withObject:stageM];
    }
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectIndustryCell *cell = (ProjectIndustryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_type ==1) {
        [cell.selectBut setSelected:!cell.selectBut.selected];
        IInvestIndustryModel *model = _alldataArray[indexPath.row];
        [model setIsSelect:cell.selectBut.selected];
        [_alldataArray replaceObjectAtIndex:indexPath.row withObject:model];
    }else if (_type ==2){
        IInvestStageModel *stageM = _alldataArray[indexPath.row];
        if (!cell.selectBut.selected) {
            for (NSInteger row = 0; row<_alldataArray.count; row++) {
                IInvestStageModel *stageM = _alldataArray[row];
                if (stageM.isSelect) {
                    ProjectIndustryCell *cell = (ProjectIndustryCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                    [cell.selectBut setSelected:NO];
                    [stageM setIsSelect:NO];
                    [_alldataArray replaceObjectAtIndex:row withObject:stageM];
                }
            }
        }else{
            
        }
        [cell.selectBut setSelected:!cell.selectBut.selected];
        [stageM setIsSelect:cell.selectBut.selected];
        [_alldataArray replaceObjectAtIndex:indexPath.row withObject:stageM];

    }
    return YES;
}

#pragma mark - 保存数据并返回
- (void)saveData
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"isSelect == 1"];
    NSMutableArray *arrayPre = [[NSArray arrayWithArray:_alldataArray] filteredArrayUsingPredicate: pre];
    if (!arrayPre.count) {
        [WLHUDView showErrorHUD:@"请选择"];
        return;
    }
    if (_type==1) {
        for (IInvestIndustryModel *industM in arrayPre) {
            if ([industM.industryname isEqualToString:@"不限"]) {
                if (self.investBlock) {
                    self.investBlock(@[industM]);
                }
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
    }else if (_type==2){
        
    }
    if (self.investBlock) {
        self.investBlock(arrayPre);
    }
    [self.navigationController popViewControllerAnimated:YES];
    DLog(@"%@",arrayPre);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
