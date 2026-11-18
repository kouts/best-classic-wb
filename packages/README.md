# Local BCWB package builds

The catalogue includes Directory Opus 4.16, FBlit 3.79, SnoopDos 3.11, iGame 2.4.6, DeliTracker 2.34, and EaglePlayer 2.06 from BestClassicWB 2.1.12. Each entry maps an archive member or a BCWB source file to a path on `SYS:`, with the expected SHA-256, Amiga protection mask, and comment.

Directory Opus takes `DirectoryOpus.CFG` and the replacement icons directly from the tracked BCWB payload. The Aminet archives supply the application, library, and class-file add-on. The catalogue records the installed spelling of accented paths as observed in 2.1.12. FBlit takes `FBlit.cfg` from the BCWB payload and records the executable protection setting on `C/FBlit` separately from the other files. Shared startup scripts and WBDock settings remain part of the BCWB system.

## Build on Windows

Run from the repository root in PowerShell. Use Python 3.12 or newer and Windows `tar.exe` with LhA support. SnoopDos and EaglePlayer also need 7-Zip on PATH or installed in the standard Windows program directory. Install the pinned Python dependency in a local virtual environment.

```powershell
python -m venv tmp/package-venv
$python = 'tmp/package-venv/Scripts/python.exe'
& $python -m pip install -r tools/package-requirements.txt
```

Place the archive files named in the package JSON in a local input directory. Each manifest contains the download URLs and SHA-256 values. The example uses the existing reference archives under `tmp/baseline`.

DeliTracker uses the 2.34 executable update and the full 2.32 archive. The manifest pins the inner LhA files under `nestedArchives`. Each record names its outer archive, member path, and SHA-256. The builder extracts them from the outer archive automatically.

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

## Rebuild the full 2.1.12 distribution

Keep a copy of the published 2.1.12 ZIP, the vanilla AmigaOS 3.2.2.1 hardfile, and a stock-installed reference hardfile locally. The published ZIP supplies the exact path layout and ZIP metadata. The builder checks catalogue files from their pinned archives or BCWB customizations and uses the pinned checkout for remaining legacy payload files. It verifies every assembled file against the published release.

```powershell
& $python tools/update_report.py fetch-pinned --archives tmp/archives
& $python tools/distribution.py build --stock-zip tmp/baseline/BestClassicWB-v2.1.12.zip --archives tmp/archives --output tmp/rebuilt/BestClassicWB.zip
```

The builder writes the ZIP and a `.sources.json` ledger containing each file's source and SHA-256. It preserves the stock installer so relabeling, backups, moves, removals, and protection operations follow the original sequence.

In WinUAE, boot a fresh copy of the vanilla hardfile. Mount the rebuilt ZIP and an Amiga UnZip tool using a read-only host directory, extract it in the guest, and run the stock `BCWB` script from its extracted drawer. Reboot into Workbench and close WinUAE before comparing. Pass your own clean, stock-installed, and rebuilt hardfile paths.

```powershell
& $python tools/distribution.py verify-install --clean 'F:/path/to/vanilla.hdf' --stock tmp/baseline/BCWB-v2.1.12-installed.hdf --installed 'F:/path/to/rebuilt-installed.hdf' --ledger tmp/rebuilt/BestClassicWB.sources.json --report tmp/rebuilt/installed-parity.json
```

The comparison covers volume label, paths, contents, protection masks, and comments. It also traces added and changed paths back to archive inputs, BCWB checkout files, or operations on the clean system. Modification timestamps are excluded from parity because repeated stock installations produced different times.

## Check upstream inputs

```powershell
& $python tools/update_report.py report --output tmp/update-report.json
```

This checks the live bytes at each pinned archive URL. For iGame it also reads the latest GitHub release and identifies the Amiga package asset. Supply `--candidates tmp/update-candidates` to save that candidate locally, with a comparison against its publisher SHA-256 when one is available. Fixed Aminet URLs report whether the pinned archive changed. Automated version discovery for those sources is still open. Review candidates explicitly before adopting any update.
