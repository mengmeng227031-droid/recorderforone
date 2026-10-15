const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('hudAPI', {
  setMouseMode: (interactive) => ipcRenderer.send('hud:mouse-mode', !!interactive),
  action: (action) => ipcRenderer.send('hud:action', action),
  pointer: (event) => ipcRenderer.send('hud:pointer', event),
  onState: (cb) => {
    const handler = (_event, state) => cb(state);
    ipcRenderer.on('hud:state', handler);
    return () => ipcRenderer.removeListener('hud:state', handler);
  },
});

