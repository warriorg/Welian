百度地图iOS SDK自v2.3.0起，采用可定制的形式为您提供开发包，当前开发包包含如下功能：
--------------------------------------------------------------------------------------
基础地图：包括基本矢量地图、卫星图、实时路况图和各种地图覆盖物，此外还包括各种与地图相关的操作和事件监听；
检索功能：包括POI检索，公交信息查询，路线规划，地理编码/反地理编码，在线建议查询，短串分享等；
LBS云检索：包括LBS云检索（周边、区域、城市内、详情）；
定位功能：获取当前位置信息；
计算工具：包括测距（两点之间距离）、坐标转换、调起百度地图导航等功能；
--------------------------------------------------------------------------------------
当前版本为v2.4.0，较上一个版本（v2.3.0）的更新内容如下：

 新增：
 基础地图
 1. 开放热力图绘制能力，帮助用户绘制自有数据热力图；
 在文件BMKHeatMap.h中新增类BMKHeatMapNode来表示热力图数据的单个数据节点
 在类BMKHeatMapNode中新增属性@property (nonatomic) CLLocationCoordinate2D pt;定义点的位置坐标
 在类BMKHeatMapNode中新增属性@property (nonatomic) double intensity;定义点的强度权值
 在BMKHeatMap中新增类BMKHeatMap来存储热力图的绘制数据和自定义热力图的显示样式
 在类BMKHeatMap中新增属性@property (nonatomic, assign) int mRadius; 设置热力图的柔化半径
 在类BMKHeatMap中新增属性@property (nonatomic, retain) BMKGradient* mGradient; 设置热力图的渐变色
 在类BMKHeatMap中新增属性@property (nonatomic, assign) double mOpacity; 设置热力图的透明度
 在类BMKHeatMap中新增属性@property (nonatomic, retain) NSMutableArray* mData; 设置热力图数据
 在类BMKMapView中新增方法- (void)addHeatMap:;来添加热力图
 在类BMKMapView中新增方法- (void)removeHeatMap;来删除热力图
 
 检索功能
 1. 开放POI的Place详情信息检索能力；
 在BMKPoiSearchOption.h文件中新增poi详情检索信息类BMKPoiDetailSearchOption
 在类 BMKPoiDetailSearchOption中新增属性@property (nonatomic, retain) NSString* poiUid; poi的uid
 在BMKPoiSearchType.h文件中新增poi详情检索结果类BMKPoiDetailResult
 在类BMKPoiSearch中新增方法- (BOOL)poiDetailSearch:;来根据poi uid 发起poi详情检索
 在BMKPoiSearchDelegate中新增回调- (void)onGetPoiDetailResult: result: errorCode:;来返回POI详情搜索结果
 
 定位功能
 1. 新增定位多实例，满足开发者在多个页面分别使用定位的需求；

 优化：
 1. 高级别地图下做平移操作时，标注覆盖物移动流畅性优化；

 修复：
 1. 修复相邻地形图图层拼接时，接缝过大的问题；
 2. 修复检索内存泄露的问题；
 3. 修复定位图层内存泄露的问题；