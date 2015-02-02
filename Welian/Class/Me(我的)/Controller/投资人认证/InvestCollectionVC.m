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

@interface InvestCollectionVC () <UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSInteger _type;
    NSMutableArray *_alldataArray;
    NSMutableArray *_selectCells;
    NSMutableArray *_reuqstDataArray;
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

- (void)jiexidata:(NSArray *)dataarray
{
    [_alldataArray removeAllObjects];
    [_selectCells removeAllObjects];
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    InvestIndustry *firstIndustry = [loginUser getInvestIndustryWithName:@"不限"];
    if (firstIndustry) {
        for (NSDictionary *indDic in dataarray) {
            IInvestIndustryModel *indust = [[IInvestIndustryModel alloc] init];
            [indust setIndustryid:[indDic objectForKey:@"id"]];
            [indust setIndustryname:[indDic objectForKey:@"name"]];
            [indust setIsSelect:YES];
            [_selectCells addObject:indust];
            [_alldataArray addObject:indust];
        }
        IInvestIndustryModel *industA = [[IInvestIndustryModel alloc] init];
        [industA setIndustryid:@(-1)];
        [industA setIndustryname:@"不限"];
        [industA setIsSelect:YES];
        [_alldataArray insertObject:industA atIndex:0];
        
    }else{
        for (NSDictionary *indDic in dataarray) {
            IInvestIndustryModel *indust = [[IInvestIndustryModel alloc] init];
            [indust setIndustryid:[indDic objectForKey:@"id"]];
            [indust setIndustryname:[indDic objectForKey:@"name"]];
            if ([loginUser getInvestIndustryWithName:indust.industryname]) {
                
                [indust setIsSelect:YES];
                [_selectCells addObject:indust];
            }
            [_alldataArray addObject:indust];
        }
        IInvestIndustryModel *industA = [[IInvestIndustryModel alloc] init];
        [industA setIndustryid:@(-1)];
        [industA setIndustryname:@"不限"];
        [_alldataArray insertObject:industA atIndex:0];
    }
    
}

- (instancetype)initWithType:(NSInteger)type
{
    self = [super init];
    if (self) {
        _type = type;
        _alldataArray = [NSMutableArray array];
        _selectCells = [NSMutableArray array];
        _reuqstDataArray = [NSMutableArray array];
        // 注册cell
        [self.collectionView registerNib:[UINib nibWithNibName:@"InvestCollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        if (type==1) { // 投资领域
            YTKKeyValueItem *item = [[WLDataDBTool sharedService] getYTKKeyValueItemById:KInvestIndustryTableName fromTable:KInvestIndustryTableName];
            NSArray *itemArray = item.itemObject;
            [self jiexidata:itemArray];
            
            [self setTitle:@"投资领域"];
            [WLHttpTool getIndustryParameterDic:@{} success:^(id JSON) {
                [self jiexidata:JSON];
                [self.collectionView reloadData];
            } fail:^(NSError *error) {

            }];
            
        }else if (type ==2){ // 投资阶段
            [self setTitle:@"投资阶段"];
            // 1.获得路径
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"InvestStagePlist" withExtension:@"plist"];
            
            // 2.读取数据
            NSArray *stageData = [NSArray arrayWithContentsOfURL:url];
            [_selectCells removeAllObjects];
            for (NSDictionary *stageDic in stageData) {
                IInvestStageModel *stageM = [[IInvestStageModel alloc] init];
                [stageM setStage:[stageDic objectForKey:@"stage"]];
                [stageM setStagename:[stageDic objectForKey:@"stagename"]];
                if ([[LogInUser getCurrentLoginUser] getInvestStagesWithStage:stageM.stagename]) {
                    [stageM setIsSelect:YES];
                    [_selectCells addObject:stageM];
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
    NSMutableDictionary *ruqstDic = [NSMutableDictionary dictionary];
    [_reuqstDataArray removeAllObjects];
    if (_type ==1) {
        InvestCollectionCell *cell = (InvestCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        if (cell.checkImageView.selected) {
            [_reuqstDataArray addObject:@{@"industryid":@(-1),@"industryname":@"不限"}];
        }else{
            for (IInvestIndustryModel *indust in _selectCells) {
                [_reuqstDataArray addObject:@{@"industryid":indust.industryid,@"industryname":indust.industryname}];
            }
        }
        [ruqstDic setObject:_reuqstDataArray forKey:@"industry"];
    }else if (_type ==2){
        for (IInvestStageModel *stageM in _selectCells) {
            [_reuqstDataArray addObject:@{@"stage":stageM.stage}];
        }
        [ruqstDic setObject:_reuqstDataArray forKey:@"stages"];
    }
    [WLHttpTool investAuthParameterDic:ruqstDic success:^(id JSON) {
        if (_type ==1) {
            [LogInUser getCurrentLoginUser].rsInvestIndustrys = nil;
             InvestCollectionCell *cell = (InvestCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            if (cell.checkImageView.selected) {
                IInvestIndustryModel *industrM = [[IInvestIndustryModel alloc]init];
                [industrM setIndustryid:@(-1)];
                [industrM setIndustryname:@"不限"];
                [InvestIndustry createInvestIndustry:industrM];
            }else{
                for (IInvestIndustryModel *industryM in _selectCells) {
                    [InvestIndustry createInvestIndustry:industryM];
                }
            }
            
        }else if (_type ==2){
            [LogInUser getCurrentLoginUser].rsInvestStages = nil;
            for (IInvestStageModel *stageM in _selectCells) {
                [InvestStages createInvestStages:stageM];
            }
        }
        if (self.investBlock) {
            self.investBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSError *error) {
        
    }];

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
        return _alldataArray.count;
    }else if (_type ==2){
        return _alldataArray.count;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    InvestCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.ClickBut addTarget:self action:@selector(didSelectItemAtIndexPath:event:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_type==1) {

        if (_alldataArray.count) {
            
            IInvestIndustryModel *indusM = _alldataArray[indexPath.row];
            [cell.titeLabel setText:indusM.industryname];
            [cell.checkImageView setSelected:indusM.isSelect];
            [cell.ClickBut setSelected:indusM.isSelect];
        }
        
    }else if (_type ==2){
        IInvestStageModel *stageM = _alldataArray[indexPath.row];
        [cell.titeLabel setText:stageM.stagename];
        [cell.checkImageView setSelected:stageM.isSelect];
        [cell.ClickBut setSelected:stageM.isSelect];
    }
    
    return cell;
}

- (void)didSelectItemAtIndexPath:(UIButton *)but event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:currentTouchPosition];
    if (indexPath) {
        [but setSelected:!but.selected];
        
        InvestCollectionCell *cell = (InvestCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        if (_type ==1) {
            [cell.checkImageView setSelected:but.selected];
            if (indexPath.row ==0) {
                [_selectCells removeAllObjects];
                    for (NSInteger i = 0; i<_alldataArray.count; i++) {
                        IInvestIndustryModel *indusM = _alldataArray[i];
                        [indusM setIsSelect:cell.checkImageView.selected];
                        if (cell.checkImageView.selected) {
                            [_selectCells addObject:indusM];
                        }
                        [_alldataArray replaceObjectAtIndex:i withObject:indusM];
                }
                [self.collectionView reloadData];
                
            }else{
                InvestCollectionCell *onecell = (InvestCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                if (onecell.checkImageView.selected) {
                    [_selectCells removeObjectAtIndex:0];
                }
                [onecell.checkImageView setSelected:NO];
                IInvestIndustryModel *oneindusM = _alldataArray[0];
                [oneindusM setIsSelect:NO];
                [_alldataArray replaceObjectAtIndex:0 withObject:oneindusM];

                IInvestIndustryModel *indusM = _alldataArray[indexPath.row];
                if (cell.checkImageView.selected) {
                    [indusM setIsSelect:YES];
                    [_selectCells addObject:indusM];
                    
                }else{
                    [indusM setIsSelect:NO];
                    [_selectCells removeObject:indusM];
                }
                [_alldataArray replaceObjectAtIndex:indexPath.row withObject:indusM];
            }
            
        }else if (_type ==2){
            [cell.checkImageView setSelected:but.selected];
            IInvestStageModel *StageM = _alldataArray[indexPath.row];
            if (cell.checkImageView.selected) {
                [StageM setIsSelect:YES];
                [_selectCells addObject:StageM];
                
            }else{
                [StageM setIsSelect:NO];
                [_selectCells removeObject:StageM];
            }
            [_alldataArray replaceObjectAtIndex:indexPath.row withObject:StageM];
        }

    }
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
