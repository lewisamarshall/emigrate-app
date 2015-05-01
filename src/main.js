// Generated by CoffeeScript 1.9.2
(function() {
  var BrowserWindow, app, mainWindow;

  app = require('app');

  BrowserWindow = require('browser-window');

  require('crash-reporter').start();

  mainWindow = null;

  app.on('window-all-closed', function() {
    return app.quit();
  });

  app.on('ready', function() {
    mainWindow = new BrowserWindow({
      width: 1000,
      height: 800
    });
    mainWindow.loadUrl('file://' + __dirname + '/index.html');
    return mainWindow.on('closed', function() {
      return mainWindow = null;
    });
  });

}).call(this);
