# Local BCWB package builds

The catalogue includes Directory Opus 4.16, FBlit 3.79, SnoopDos 3.11, iGame 2.4.6, DeliTracker 2.34, EaglePlayer 2.06, SongPlayer 1.62, INOVAMusic 3.1, mpega.library 2.4, playsid.library 1.1, ACDPlay 1.6, DTView2 1.5b, MUI 3.8, guigfx.library 20.0, render.library 31.0, WHDLoad 18.9, WHDLoadCD32 18.9, WBDock 2.907, PeterK IconLib 46.4.582, NewIconEmu 45.0, FText 1.7, FullPalette 40.22, and TitleShadow 1.0B from BestClassicWB 2.1.12. Each entry maps an archive member or a BCWB source file to a path on `SYS:`, with the expected SHA-256, Amiga protection mask, and comment.

Directory Opus takes `DirectoryOpus.CFG` and the replacement icons directly from the tracked BCWB payload. The Aminet archives supply the application, library, and class-file add-on. The catalogue records the installed spelling of accented paths as observed in 2.1.12. FBlit takes `FBlit.cfg` from the BCWB payload and records the executable protection setting on `C/FBlit` separately from the other files. The BCWB system supplies the shared startup scripts. The WBDock manifest maps the dock settings.

SongPlayer uses the pinned Aminet 1.62 archive for 105 files and the BCWB payload for its configuration and 11 replacement icons. Its 32 drawers retain stock metadata and observed accented spellings. The `mpega` entry owns the standalone archive's 68020 integer library, which also matches EaglePlayer's bundled 68020 copy. The stock payload and installed inventory contain no `C/mpega` command. INOVAMusic 3.1 remains a checked BCWB release input while its exact upstream archive is unresolved. Shared MUI and asyncio dependencies remain separate migration work.

The independent `playsid` entry takes `Libs/playsid.library` from the checked `playsid3` archive nested inside DeliTracker 2.32. DeliTracker retains its PlaySID documentation and icon. No PlaySID application or `L` handler is installed. ACDPlay uses the pinned 1.6 executable and the BCWB replacement icon, including its `scsi.device` unit 1 settings. DTView2 retains the verified BCWB 1.5b executable, icon and English help file: the current Aminet archive contains 1.7, and the exact 1.5b upstream archive remains unresolved. Shared help and system drawers are not owned by these packages.

MUI maps the installed `Expansion/MUI` tree, including its shared custom classes, and the BCWB default MUI icon in `ENVARC:Sys`. The MUI 3.8 archive supplies the stock 19.35 master library. Matching class archives supply Guigfx.mcc 19.2, HTMLtext and SpeedBar files. The checked BCWB payload supplies replacement icons, extra graphics, and classes with no verified matching archive. The system startup script supplies the MUI assignments. Per-application MUI preferences and shared system drawers remain outside these packages.

The `guigfx` entry pins the NoFPU 20.0 library and its readme. The 68020 library also matches EaglePlayer's bundled copy. The `render` entry keeps the stock 68020 version 31.0 from the checked BCWB payload while the exact archive is unresolved. iGame requires MUI, TextEditor.mcc and NListview.mcc. For scaled screenshots it also uses Guigfx.mcc, guigfx.library and render.library.

WHDLoad 18.9 build 6601 and WHDLoadCD32 18.9 build 6602 match the publisher's pinned user archive. The `whdload` manifest owns the complete `Expansion/WHDLoad` drawer, the standard loader and DIC, RawDIC and Patcher in `C:`, and the `S:` inputs. The `whdloadcd32` manifest owns the CD32 command in `C:`. The checked BCWB payload supplies the four drawer icons, three files in `S:` and `Devs/Kickstarts.info`. The reference templates under `Expansion/WHDLoad/S` match upstream.

WBDock 2.907 maps 65 files and 19 drawers in `Expansion/WBDock2` and `WBStartup`. Both executables match the pinned publisher archive. The BCWB payload supplies the active dock list, its pattern, and the differing icons. The startup icon points to the stock dock list, whose second item targets `SYS:Programs/DOpus/DirectoryOpus`, which loads its BCWB `s/DirectoryOpus.CFG`. The French and Turkish archive member names use Latin-1. The builder accounts for 7-Zip's Windows OEM filename conversion and retains the literal installed spelling in the manifest.

On AmigaOS 3.2.2.1, the stock Directory Opus executable has protection mask 2, which blocks its WBDock launch. The full rebuild preserves that mask. Enabling execute permission on a disposable rebuilt copy let the same dock item open Directory Opus with its BCWB configuration.

The `iconlib` entry maps the shipped `Libs/icon.library` and `Locale/Help/english/IconLib.guide`. Peter Keunecke's release is 46.4.582. Its AmigaOS 3.2-compatible TrueColor variant identifies as `icon.library 51.4.582 (TC020)`. Both stock files match the archived release listing by size and LhA CRC-16. The original build-582 download remains unresolved, so the catalogue pins the BCWB files by SHA-256. The distribution installer backs up the target OS library as `Libs/icon.library.bak` before copying the payload. [Archived Aminet listing](https://web.archive.org/web/20240323222904/http://aminet.net/package/util/libs/IconLib_46.4)

The `newicon` entry owns `Libs/newicon.library`, Stephan Rupprecht's NewIconEmu 45.0. The checked BCWB file matches the NewIconEmu on local AmigaOS 3.9 media by SHA-256. NewIconEmu exposes the NewIcons API using `icon.library`. The BCWB install adds no NewIcons startup hook or handler in `L:`. System default icons, application icons, and the shared startup scripts retain their existing ownership.

FText 1.7 matches Aminet for both the command and its readme. It requires FBlit 3 or later, Fast RAM, and a 68020 or later. The shared BCWB startup sequence runs FText just after FBlit, and the stock installer enables execute permission on both commands. [FText archive](https://aminet.net/util/boot/FText.lha)

The FullPalette editor and FPPrefs helper each identify as 40.22 and match the Aminet archive. The installer enables execution on `C/FPPrefs` and startup runs it after IPrefs. The preset edit and activation marker match BetterWB. The checked BCWB payload supplies the active palette, its icon, both editor icons, and the adapted activation script. The installed system already loads FPPrefs through its startup sequence, while the legacy activation preset expects BetterWB paths. [FullPalette archive](https://aminet.net/util/wb/FullPalette22.lha) [BetterWB disk 5 archive](https://raw.githubusercontent.com/henrikstengaard/betterwb-package/9a2d320d9cc4bb19c5895dc71988148010e1de0f/package/BetterWB5.zip)

The TitleShadow 1.0B archive supplies the 1.0 command, preferences editor and English guide. The checked BCWB payload supplies the preferences icon and Workbench settings. The shared startup sequence requests TitleShadow before IPrefs. Stock and rebuilt startup both leave the patch inactive because `C/TitleShadow` lacks execute permission. Enabling execution on a disposable rebuilt copy started the patch and rendered the configured title shadow. The preferences editor opens through Workbench with its stock protection. [TitleShadow archive](https://aminet.net/util/boot/titleshadow.lha)

## Build on Windows

Run from the repository root in PowerShell. Use Python 3.12 or newer and Windows `tar.exe` with LhA support. SnoopDos, EaglePlayer, MUI, and WBDock also need 7-Zip on PATH or installed in the standard Windows program directory. WHDLoad and WHDLoadCD32 need the Amiga LZX CLI (tested with v0.1.5) as `lzx.exe` on PATH. [Amiga LZX CLI releases](https://github.com/bitplane/amiga-lzx/releases/tag/v0.1.5)

Install the pinned Python dependency in a local virtual environment.

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
