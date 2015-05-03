app = require 'app'
BrowserWindow = require 'browser-window'

# Report crashes to server
require('crash-reporter').start()

# Keep a global reference of the window object. if you don't,
# the window will be closed automatically when the javascript object is GCed.
mainWindow = null

# Quit when all windows are closed.
app.on('window-all-closed', ()->app.quit())

# This method will be called when Electron has done everything
# initialization and ready for creating browser windows.
app.on('ready', ()->
    #  Create the browser window.
    mainWindow = new BrowserWindow({width: 1000, height: 800})

    # and load the index.html of the app.
    mainWindow.loadUrl('file://' + __dirname + '/index.html')


    # Emitted when the window is closed.
    # Dereference the window object, usually you would store windows
    # in an array if your app supports multi windows, this is the time
    # when you should delete the corresponding element.
    mainWindow.on('closed', ()->mainWindow = null)
    )
