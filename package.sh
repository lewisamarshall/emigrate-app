#!/bin/bash

# Compile the python scripts


# Pack the files into the asar archives.
asar pack emigrate/ dist/Emigrate.app/Contents/Resources/app.asar
asar pack emigrate/ dist/Emigrate-win32/resources/app.asar
asar pack emigrate/ dist/Emigrate-x64/resources/app.asar

# zip -ru dist/Emigrate.app.zip dist/Emigrate.app
# zip -ru dist/dist/Emigrate-win32.zip dist/Emigrate-win32
# zip -ru dist/Emigrate-x64.zip dist/Emigrate-x64

open dist/Emigrate.app
