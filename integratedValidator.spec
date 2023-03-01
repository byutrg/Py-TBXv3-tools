# -*- mode: python ; coding: utf-8 -*-


block_cipher = None


a = Analysis(['integratedValidator.py'],
             pathex=[r'C:\Users\chadh\AppData\Local\Programs\Python\Python39\Lib\site-packages\saxonpy\saxonc_home', '.\Lib\site-packages'],
             binaries=[(r'C:\Users\chadh\AppData\Local\Programs\Python\Python39\Lib\site-packages\saxonpy\saxonc_home\libsaxonhec.dll' , '.\saxonpy\saxonc_home')],
             datas=[("schxslt-1.8.5", "./schxslt-1.8.5"),
             ("2023-01-12-TBX-Basic_DCA_modifiedToEnforceTypes.sch","."),
             ("2023-01-12-TBXcoreStructV03.rng","."),
             (r'C:\Users\chadh\AppData\Local\Programs\Python\Python39\Lib\site-packages\saxonpy\saxonc_home' , '.\saxonpy\saxonc_home'),
             ('Min.sch','.'),('Min.rng','.'),
             ('TBXcoreStructV03_TBX-Basic_integrated.rng','.'),
             ('TBX-Basic_DCA.sch','.')],
             hiddenimports=["nodekind", "lxml", "requests"],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)

exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,  
          name='integratedValidator',
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          upx_exclude=[],
          runtime_tmpdir=None,
          console=True,
          disable_windowed_traceback=False,
          target_arch=None,
          codesign_identity=None,
          entitlements_file=None )
