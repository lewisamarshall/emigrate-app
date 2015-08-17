#!/bin/bash

# Compile the python scripts


# Pack the files into the asar archives.
asar pack emigrate/ dist/Emigrate.app/Contents/Resources/app.asar
asar pack emigrate/ dist/Emigrate-win32/resources/app.asar

# zip -ru dist/Emigrate.app.zip dist/Emigrate.app
# zip -ru dist/dist/Emigrate-win32.zip dist/Emigrate-win32

open dist/Emigrate.app
