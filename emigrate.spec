# -*- mode: python -*-
a = Analysis(['emigrate/cli.py'],
             pathex=['/Users/lewis/Documents/github/emigrate_app'],
             hiddenimports=[],
             hookspath=['.'],
             runtime_hooks=None)
pyz = PYZ(a.pure)
exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          name='emigrate',
          debug=False,
          strip=None,
          upx=True,
          console=True )
