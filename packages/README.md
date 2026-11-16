# Local BCWB package builds

The first catalogue entries reproduce Directory Opus 4.16 and FBlit 3.79 from BestClassicWB 2.1.12. Each entry maps an archive member or a BCWB source file to a path on `SYS:`, with the expected SHA-256, Amiga protection mask, and comment.

Directory Opus takes `DirectoryOpus.CFG` and the replacement icons directly from the tracked BCWB payload. The Aminet archives supply the application, library, and class-file add-on. The catalogue records the installed spelling of accented paths as observed in 2.1.12. FBlit takes `FBlit.cfg` from the BCWB payload and records the executable protection setting on `C/FBlit` separately from the other files. Shared startup scripts and WBDock settings remain part of the BCWB system.

## Build on Windows

Run from the repository root in PowerShell. Use Python 3.12 or newer and the Windows `tar.exe` with LhA support. Install the pinned Python dependency in a local virtual environment.

```powershell
python -m venv tmp/package-venv
$python = 'tmp/package-venv/Scripts/python.exe'
& $python -m pip install -r tools/package-requirements.txt
```

Place the archive files named in the package JSON in a local input directory. Each manifest contains the download URLs and SHA-256 values. The example uses the existing reference archives under `tmp/baseline`.

```powershell
& $python tools/package.py build directory-opus --archives tmp/baseline/directory-opus --output tmp/packages/directory-opus.hdf
& $python tools/package.py build fblit --archives tmp/baseline/fblit --output tmp/packages/fblit.hdf
```

Builds check the archive and file hashes and produce a WinUAE transport hardfile. Use a new output filename for each build or remove the old build output before rebuilding.

## Install and verify in WinUAE

Boot a disposable AmigaOS 3.2.2.1 hardfile. Mount one package hardfile at a time as a read-only, non-bootable WinUAE hardfile with 32 sectors, one surface, two reserved blocks, and 512-byte blocks. Run this in the Amiga Shell:

```text
Execute BCWB-Package:Install
```

The installer uses `COPY CLONE` for files and `COPY ALL CLONE` for package-owned drawers. Close WinUAE to flush the destination hardfile before verifying from PowerShell.

```powershell
& $python tools/package.py verify directory-opus --hardfile 'F:/path/to/disposable-installed.hdf'
& $python tools/package.py verify fblit --hardfile 'F:/path/to/disposable-installed.hdf'
```

Verification checks installed paths, file contents, protection bits, and comments. Timestamps and full system startup behavior need separate tests. Use these builds locally while the release packaging format is being evaluated.
