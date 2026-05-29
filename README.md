
# Actions-OpenWrt

此代码是使用P3TERX源码，基于自己想法修改的，因能力有限，如使用过程有其他bug，请见谅！

## 使用方法

- 右上角点击 Fork
- 在 Repository name 栏目中填写你的自定义仓库名(其他不用改)，然后点 Create repository
- 
- 创建后需要开启权限，在页面的 Settings - Actions - General - Workflow permissions 页面中，然后鼠标拉到
- 最下面，点选 Read and write permissions，勾上 Allow GitHub Actions to create and approve pull requests
- 最后点 Save 即可
-  
- 在仓库页面中（一般修改以下3项即可）
- Part0_Global.env 是全局变量，可按需调整
- Part1_Feeds.sh 是软件源地址，可按需添加
- Part2_Custom.sh 是自定义配置，可按需修改
- 
- 借助源码生成 .config 配置文件（用AI生成也行）
- 在 Actions 页面选择 Build ，然后点击右边的 Run workflow 编译任务
- 可修改 Update.yml 中的 - cron: '0 18 * * 0,3' 设置相应的定时更新计划
- 编译完成后，在 Actions 或 Releases 页面下载固件镜像

## 温馨提示

- 完整编译：每次固件编译时间一般都要1个小时左右
- 矩阵编译：因免费10G大小的缓存限制，建议一次性最多3个固件同时编译（保留最新3条缓存）
- 保留条数、缓存空间大小决定一个仓库编译多少固件，具体可以自行研究 
- 加速编译：全局变量中开启了加速编译，第一遍完整编译生成缓存，第二遍就会自动加速
- ⚠️ 注意
- 加速编译时间会快10%以上，具体视型号插件等情况而定
- 若因缓存导致固件的bug，请进入 Action - Caches 清空缓存，再执行一遍完整编译

## 致谢 / 项目引用

- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [GitHub Actions](https://github.com/features/actions)
- [Actions](https://github.com/actions)
- [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
- [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt)
