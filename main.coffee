app = require 'app'
BrowserWindow = require 'browser-window'
processes = require 'process'
path = require 'path'


# Report crashes to server
require('crash-reporter').start()
processes.env.PATH = path.join(__dirname, 'assets/emigrate') + ':' + processes.env.PATH

# Keep a global reference of the window object. if you don't,
# the window will be closed automatically when the javascript object is GCed.
mainWindow = null

# Quit when all windows are closed.
app.on('window-all-closed', ()->app.quit())

# Import menu template
Menu = require('menu')
template = require('./menu-template').template



# This method will be called when Electron has done everything
# initialization and ready for creating browser windows.
app.on('ready', ()->
  #  Create the browser window.
  # mainWindow = new BrowserWindow({width: 1000, height: 800})
  mainWindow = new BrowserWindow({fullscreen: true})

  mainWindow.loadUrl('file://' + __dirname + '/index.html')

  # Add the menu
  menu = Menu.buildFromTemplate(template)
  Menu.setApplicationMenu(menu)

  # and load the index.html of the app.


  # Emitted when the window is closed.
  # Dereference the window object, usually you would store windows
  # in an array if your app supports multi windows, this is the time
  # when you should delete the corresponding element.
  mainWindow.on('closed',
                ()->mainWindow = null))
