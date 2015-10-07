app = require 'app'
BrowserWindow = require 'browser-window'
processes = require 'process'
path = require 'path'
Menu = require('menu')


# Report crashes to server
require('crash-reporter').start()

# Update the path with the local copy of emigrate
asset_path = path.join(__dirname, 'assets/emigrate')
processes.env.PATH = asset_path + ':' + processes.env.PATH

# Keep a global reference of the window object. if you don't,
# the window will be closed automatically when the javascript object is GCed.
mainWindow = null

# Quit when all windows are closed.
app.on('window-all-closed', ()->app.quit())

# Import menu template
template = require('./menu-template').template


# This method will be called when Electron has done everything
# initialization and ready for creating browser windows.
app.on('ready', ()->
  #  Create the browser window.
  # mainWindow = new BrowserWindow({width: 1000, height: 800})
  mainWindow = new BrowserWindow({fullscreen: true})

  # Add the menu
  menu = Menu.buildFromTemplate(template(app, mainWindow))
  Menu.setApplicationMenu(menu)

  # and load the index.html of the app.
  mainWindow.loadUrl('file://' + __dirname + '/index.html')


  # Emitted when the window is closed.
  # Dereference the window object, usually you would store windows
  # in an array if your app supports multi windows, this is the time
  # when you should delete the corresponding element.
  mainWindow.on('closed',
                ()->mainWindow = null))
