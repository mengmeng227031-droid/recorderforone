const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('hudAPI', {
  setMouseMode: (interactive) => ipcRenderer.send('hud:mouse-mode', !!interactive),
  action: (action) => ipcRenderer.send('hud:action', action),
  pointer: (event) => ipcRenderer.send('hud:pointer', event),
});
