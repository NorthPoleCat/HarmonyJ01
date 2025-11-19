// 全局事件管理器
export class RouterEventManager {
  private static instance: RouterEventManager;
  private refreshCallbacks: Map<string, () => void> = new Map();

  public static getInstance(): RouterEventManager {
    if (!RouterEventManager.instance) {
      RouterEventManager.instance = new RouterEventManager();
    }
    return RouterEventManager.instance;
  }

  // 注册刷新回调
  registerRefreshCallback(pageId: string, callback: () => void): void {
    this.refreshCallbacks.set(pageId, callback);
  }

  // 移除回调
  unregisterRefreshCallback(pageId: string): void {
    this.refreshCallbacks.delete(pageId);
  }

  // 触发刷新
  triggerRefresh(pageId: string): void {
    const callback = this.refreshCallbacks.get(pageId);
    if (callback) {
      callback();
    } else {
      console.warn(`未找到页面 ${pageId} 的刷新回调`);
    }
  }
}