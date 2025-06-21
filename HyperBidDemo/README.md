# HyperBid_iOSDemo

Demo说明
1.启动demo时会完整展示SDK初始化-加载开屏广告全部流程，启动时的开屏广告通过HyperBidAdManager.m管理
2.如果遇到pod下载缓慢，可以移除一些适配器（adapter）重试。如果遇到网络错误频繁，请检查终端是否正常能够访问github，如有必要请修改对应的gitconfig给pod install过程添加代理网络。
3.请先指定pod install --repo-update安装相关依赖
4.如需将APP参数、广告位参数替换为您自己的，还需要检查podfile中安装的adapter适配器是否满足您的选择。

Demo Instructions

When launching the demo, it will fully demonstrate the SDK initialization → splash ad loading workflow. The splash ad during startup is managed by HyperBidAdManager.m.

Troubleshooting Tips:

If pod download is slow, try removing some adapters and retrying.

If network errors occur frequently, check whether your terminal can properly access GitHub. If necessary, modify the corresponding gitconfig to add a proxy for the pod install process.

You need exec pod install --repo-update first.

If you need to replace the appid/appkey and ad placement parameters with your own, please also verify whether the adapters installed in the Podfile align with your selected ad networks.
