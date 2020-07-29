//
//  SeeVideosViewController.m
//  4.看视频
//
//  Created by apple on 2020/7/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "SeeVideosViewController.h"

#import "EyeCatchingWaiterCell.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFDouYinControlView.h"

@interface SeeVideosViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFDouYinControlView *controlView;
@property (nonatomic, copy) NSArray * mp4UrlArray;

@end

@implementation SeeVideosViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.tableView];
    [self getData];
}
- (void)getData{
    self.player.assetURLs = self.mp4UrlArray;
    [self.tableView reloadData];
    __weak typeof(self) weakSelf = self;
    [self.player zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        [weakSelf playTheVideoAtIndexPath:indexPath];
    }];
}
/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self.player playTheIndexPath:indexPath];
    [self.controlView resetControlView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mp4UrlArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EyeCatchingWaiterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EyeCatchingWaiterCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath];
}

#pragma mark - UIScrollViewDelegate  列表播放必须实现
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}
#pragma mark --- 懒加载
- (ZFDouYinControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFDouYinControlView new];
    }
    return _controlView;
}
- (ZFPlayerController *)player{
    if (_player == nil) {
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
        _player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
        _player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch;
        _player.allowOrentitaionRotation = NO;
        _player.WWANAutoPlay = YES;
        _player.playerDisapperaPercent = 1.0;
        _player.controlView = self.controlView;
        __weak typeof(self) weakSelf = self;
        _player.playerDidToEnd = ^(id  _Nonnull asset) {    // 播放结束后重新播放
            [weakSelf.player.currentPlayerManager replay];
        };
        _player.presentationSizeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, CGSize size) {   // 视频画面显示的模式
            if (size.width >= size.height) {
                weakSelf.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
            } else {
                weakSelf.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
            }
        };
        /// 停止的时候找出最合适的播放
        _player.zf_scrollViewDidEndScrollingCallback = ^(NSIndexPath * _Nonnull indexPath) {
            if (weakSelf.player.playingIndexPath) return;
            /// 加载下一页数据
            weakSelf.player.assetURLs = weakSelf.mp4UrlArray;
            [weakSelf.tableView reloadData];
            [weakSelf playTheVideoAtIndexPath:indexPath];
        };
    }
    return _player;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.pagingEnabled = YES;
        [_tableView registerClass:[EyeCatchingWaiterCell class] forCellReuseIdentifier:@"EyeCatchingWaiterCell"];
        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.frame = self.view.bounds;
        _tableView.rowHeight = _tableView.frame.size.height;
        _tableView.scrollsToTop = NO;
    }
    return _tableView;
}
- (NSArray *)mp4UrlArray{
    if (_mp4UrlArray == nil) {
        _mp4UrlArray = @[[NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-video/15_dc76d5a63817ebc2f08e5f323d67b753.mp4"],
                         [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/3830561_5acdf9a52e60062c2ccf1244d302a47f_0.mp4"],
                         [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/2410119_c0266426979b4ffaaa57f8413b40f905_0.mp4"],
                         [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/2254819_a91cbcd3e0b2d3f7e91f841af7521533_0.mp4"],
                         [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/2404662_d8f9bc04d43a1760a893174cc1896b08_0.mp4"],
                         [NSURL URLWithString:@"http://tb-video.bdstatic.com/videocp/823173_091d3d8433a802fa74eaad26fc4fe909.mp4"]];
    }
    return _mp4UrlArray;
}

@end
