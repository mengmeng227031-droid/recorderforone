# Codex 项目上下文

这份文档是给后续 Codex 修改项目时先读的快速上下文。实现细节仍以代码为准；修改前先看这里，再查看对应文件和最近提交。

## 项目定位

Windows Electron 屏幕录制软件，支持屏幕、摄像头、屏幕+摄像头、麦克风、系统声音、预览、MP4/GIF/WebM 导出，以及录制时的透明悬浮工具栏和涂鸦。

## 关键文件

| 文件 | 作用 |
|---|---|
| `index.html` | 主界面、录制状态机、MediaRecorder、画面合成、预览和导出按钮 |
| `main.js` | Electron 主进程、屏幕源选择、磁盘恢复、FFmpeg、悬浮 HUD 窗口和 IPC |
| `preload.js` | 主窗口安全 IPC API |
| `hud.html` | 透明全屏悬浮工具栏、鼠标穿透、屏幕实时笔迹和暂停/继续按钮 |
| `hud-preload.js` | HUD 安全 IPC API |
| `lib/ffmpeg-args.js` | MP4/GIF/WebM 导出参数 |
| `test/` | Node 测试和 FFmpeg 集成测试 |

## 最近一次改动

最近的改动集中在 `hud.html`、`hud-preload.js`、`preload.js`、`main.js` 和 `index.html`：

- HUD 工具栏增加 `🖱` 鼠标模式按钮；鼠标模式下工具栏外穿透到 PDF，涂鸦模式下工具栏外接收笔迹。
- HUD 增加独立透明笔迹层，笔迹会显示在用户当前屏幕，同时录制合成画布仍会记录笔迹。
- HUD 的暂停按钮会在暂停后变成 `▶`，文字变为“继续录制”。暂停状态通过 `hud:state` IPC 在主窗口、快捷键、托盘和 HUD 之间同步。
- 悬浮模式首次运行默认开启，并兼容旧版保存设置。
- HUD 等待 `did-finish-load` 后再显示，避免录制开始时悬浮层未出现。

查看最近提交：

```powershell
git log -8 --oneline
```

## 暂停/继续流程

`index.html` 中的 `pause()` / `resume()` 调用 `MediaRecorder.pause()` / `resume()`，并更新 `recState`、计时器和主窗口按钮。桌面模式同时调用 `api.setHudState(true|false)`；`preload.js` → `main.js` 的 `hud:state` IPC 再把状态发给 `hud.html`，由 HUD 切换“暂停/继续”按钮。

HUD 按钮发出 `{ type: 'pause' }`，主窗口通过 `handleHudAction()` 根据当前 `recState` 决定暂停还是继续。

## 修改后验证

```powershell
npm test
node --check main.js
node --check preload.js
node --check hud-preload.js
git diff --check
```

桌面验证流程：完全退出旧实例 → 双击桌面快捷方式 → 开始录制 → 点击 HUD 暂停 → 确认按钮变为 `▶`“继续录制” → 点击继续 → 停止并预览。

## GitHub 发布注意事项

本地完整仓库位于 `E:\aowsome\screen-recorder-pro`。`vendor/ffmpeg.exe` 超过 GitHub 单文件限制，因此 GitHub 仓库使用 source-only 发布副本；不要直接把含大文件的本地历史推到 GitHub。当前用户仓库为：

`https://github.com/mengmeng227031-droid/recorderforone`


