# Local BCWB package builds

The catalogue includes Directory Opus 4.16, FBlit 3.79, SnoopDos 3.11, iGame 2.4.6, DeliTracker 2.34, EaglePlayer 2.06, SongPlayer 1.62, INOVAMusic 3.1, mpega.library 2.4, playsid.library 1.1, ACDPlay 1.6, DTView2 1.5b, MUI 3.8, guigfx.library 20.0, render.library 31.0, WHDLoad 18.9, WHDLoadCD32 18.9, WBDock 2.907, PeterK IconLib 46.4.582, NewIconEmu 45.0, FText 1.7, FullPalette 40.22, TitleShadow 1.0B, ViNCEd 3.107, OpenDrawer 0.1, WBRun 2.2, OpenURL 7.18, MagicMenu 2.35, ToolsMenu 1.10.2, PopupMenu.library 10.8.6, ClickNot 37.3, ToolAlias 1.02, WBStartEmu 45.1a, CharMap 2.0b, NewMode 3.9, PowerSnap 2.2a, Personal Paint 7.1c, GrabIFF 1.00, ILBM 47.6, JFIF 44.16, PCX 39.7, Targa 43.1, TIFF 43.2, fixiff 1.0, topaz6, XCourier, XEN, XHelvetica, ttengine.library 7.2, FileX 2.7a, JanoEditor 1.01d, SimpleFind 2.5, ABackup 5.22, SuperDuper 3.13, and ReOrg 3.11 from BestClassicWB 2.1.12. Each entry maps an archive member or a BCWB source file to a path on `SYS:`, with the expected SHA-256, Amiga protection mask, and comment.

Directory Opus takes `DirectoryOpus.CFG` and the replacement icons directly from the tracked BCWB payload. The Aminet archives supply the application, library, and class-file add-on. The catalogue records the installed spelling of accented paths as observed in 2.1.12. FBlit takes `FBlit.cfg` from the BCWB payload and records the executable protection setting on `C/FBlit` separately from the other files. The BCWB system supplies the shared startup scripts. The WBDock manifest maps the dock settings.

SongPlayer uses the pinned Aminet 1.62 archive for 105 files and the BCWB payload for its configuration and 11 replacement icons. Its 32 drawers retain stock metadata and observed accented spellings. The `mpega` entry owns the standalone archive's 68020 integer library, which also matches EaglePlayer's bundled 68020 copy. The stock payload and installed inventory contain no `C/mpega` command. INOVAMusic 3.1 remains a checked BCWB release input while its exact upstream archive is unresolved. The MUI and asyncio packages own their shared files.

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

ViNCEd 3.107 and its SetVNC 41.50 preferences editor share one catalogue entry. The archived 3.107 release supplies the library, English guide and three mount files. The 3.95.1 archive supplies the encoded SetVNC 41.50 overlay executable. The builder applies the same decoding as the publisher and verifies the installed executable by SHA-256. The checked BCWB payload supplies the installed preferences, guide path and icons. Workbench opens the ViNCEd console through `System/Shell_VNC.info`. The `Prefs/SetVNC.info` project points to the preferences editor in `C:`. The shared startup sequence mounts the DOSDrivers and exposes the preferences through `ENV:`. The standard Shell continues to use `CON:`. Both stock and rebuilt AmigaOS 3.2.2.1 reproduced the SetVNC launch failure with stock protection. Enabling execution on a disposable copy opened the Workbench preferences editor and the English guide. [ViNCEd 3.107 archive](https://web.archive.org/web/20240509064829id_/http://sg.aminet.net/util/shell/ViNCEd.lha) [ViNCEd 3.95.1 archive](https://web.archive.org/web/20200916174900id_/https://aminet.net/util/shell/ViNCEd.lha)

OpenDrawer 0.1 and WBRun 2.2 match the pinned Aminet executables. Directory Opus calls OpenDrawer on its source drawer. WBRun launches Workbench programs from a Shell and ships with its English documentation. The same archive also matches the installed `parm.library` 13.6, which is tracked separately as a shared dependency. For Workbench launches, iGame uses WBRun when the AmigaOS `WBLoad` command is absent. [OpenDrawer archive](https://aminet.net/util/cli/OpenDrawer.lha) [WBRun archive](https://aminet.net/util/cli/WBRun_fix.lha)

OpenURL 7.18 matches the OS3/m68k command, library and MUI preferences editor in the pinned archive, along with its English guide. The checked BCWB payload supplies the preferences icon and saved `ENVARC:OpenURL.prefs`. The stock startup exposes it through `ENV:`. The installed Processfile script and SimpleFind guide invoke the command. WHDLoad and Voodoo-X use the shared library. [OpenURL archive](https://aminet.net/comm/www/OpenURL-7.18.lha)

Stock and rebuilt AmigaOS 3.2.2.1 both reject the three Shell launchers with `file is not executable`. On a disposable copy with execution enabled, OpenDrawer opened a RAM drawer and WBRun passed a local guide to MultiView. OpenURL dispatched a local HTML file to an ARexx receiver after enabling the IBrowse entry in the RAM-only profile.

MagicMenu 2.35 uses the 020+/PPC fat binary and matching MagicMenuPrefs from Aminet. The installed English guide comes from the older 2.30 archive. The checked BCWB payload supplies the two icons and saved preferences, including the enabled menu patch and the Right Amiga+Space shortcut. [MagicMenu 2.35 archive](https://aminet.net/util/wb/MagicMenu_2.35.lha) [MagicMenu 2.30 archive](https://aminet.net/util/wb/MagicMenu_II.lha)

ToolsMenu 1.10.2 matches the archived Aminet command and readme. The BCWB startup icon stores five Tools menu entries, including File Manager and Help. The stock installer separately moves the AmigaOS MenuTools commodity to `SYS:Tools/Commodities` and overlays its BCWB icon. [Archived ToolsMenu 1.10.2 release](https://web.archive.org/web/20210211040614id_/http://aminet.net/util/cdity/ToolsMenu.lha)

The standalone PopupMenu.library 10.8.6 archive supplies the 68020 library and its readme. EaglePlayer bundles the same library bytes. SimpleFind, Directory Opus, BWin.mcc and the EagleAMPGui engines reference the shared library. MagicMenu uses its own Intuition menu patch. [PopupMenu 68020 archive](https://aminet.net/util/libs/pmlib020.lha)

ClickNot 37.3 matches the Aminet executable and English documentation. The checked BCWB icon controls its placement in `WBStartup`. ClickNot runs at Workbench startup, sets the no-click flag for each available floppy drive, and exits. [ClickNot archive](https://aminet.net/disk/misc/clicknot373.lha)

ToolAlias 1.02 matches Fred Fish disk 962 for its executable and English documentation. The checked BCWB icon in `Tools/Commodities` retains `CX_POPUP=FALSE`, so launch starts the commodity without opening its settings. ToolAlias defaults to Control+Alt+T, the same shortcut advertised by ToolsMenu. Stock BCWB installs ToolAlias for manual launch and ships no `S:ToolAlias.config`. [Fred Fish disk 962](https://aminet.net/misc/fish/fish-0962.lha)

WBStartEmu 45.1a matches the installed `Libs/wbstart.library`, `L/wbstart-handler` and English documentation. The embedded library ID reads 45.1, the live API reports 2.2, and the compatibility handler identifies as 2.0. The library forwards legacy Workbench launches through `workbench.library`. The handler accepts requests from older clients and forwards them to the library. WBDock, SimpleFind, DoMIME and TinyMeter contain references to the shared library. [WBStartEmu archive](https://aminet.net/util/libs/WBStartEmu.lha)

CharMap 2.0b, NewMode 3.9, and PowerSnap 2.2a match the pinned Aminet executables and English help. The PowerSnap archive also supplies the installed handler in `L:`. The checked BCWB tool icons preserve their artwork, positions, and tooltypes. CharMap opens from `Tools`, and NewMode and PowerSnap are installed for manual launch in `Tools/Commodities`. [CharMap archive](https://aminet.net/text/font/CharMap.lha) [NewMode archive](https://aminet.net/util/cdity/NewMode_V39.lha) [PowerSnap archive](https://aminet.net/util/cdity/PowerSnap22a.lha)

Personal Paint 7.1c owns the complete `Programs/PPaint` tree and its drawer icon. Cloanto supplies the application, four copies of PPView 1.2, the CPU and Agnus blitters, most I/O modules, fonts, documents, scripts and sample artwork. The separate Aminet Icon I/O archive supplies the module with the 5.17 version string. The checked BCWB payload supplies all 95 stock icons, the customized `Startup_1.set` and eight other files. The saved startup settings select the Agnus and 68000 blitters. Shared icon libraries, picture datatypes and ARexx keep their existing ownership. [Cloanto download](https://www.amigaforever.com/classic/download/) [Personal Icon I/O archive](https://aminet.net/gfx/ppaint/pio_icon.lha)

GrabIFF 1.00 uses the Aminet executable, `L/GrabIFFHandler` and English `GrabIFF.Doc`. The checked BCWB icon preserves its artwork and position. The commodity starts from `Tools/Commodities` and uses Control+Left Amiga by default. Hold that qualifier and press S to capture the current screen to RAM. [GrabIFF archive](https://aminet.net/util/cdity/grabiff.lha)

ILBM 47.6 uses Richter’s all-in-one 68k class, descriptor, and English readme from the archived Aminet release. Tron’s PCX 39.7 uses the class, descriptor, and English guide from its Aminet archive. The JFIF 44.16 68020+ class and English guide use checked BCWB inputs while the exact release is unresolved. The JFIF descriptor matches the archived 44.18 and 44.15 releases. All three descriptor icons come from the checked BCWB payload. The shared startup sequence refreshes the datatype registry. Before the payload copy, the distribution installer moves the original AmigaOS ILBM and JPEG classes to Storage and removes the original JPEG descriptor and icon. [ILBM 47.6 archive](https://web.archive.org/web/20240509074210id_/http://de6.aminet.net/util/dtype/ILBMdt.lha) [JFIF 44.18 archive](https://web.archive.org/web/20240507140030id_/http://de.aminet.net/aminet/util/dtype/JFIFdt44.lha) [PCX 39.7 archive](https://aminet.net/util/dtype/TPD.lha)

Arthur Pijpers's Targa 43.1 archive supplies the 68000 class, filename-matching descriptor and English guide. Bert Wynants's TIFF 43.2 archive supplies the class, the descriptor for both TIFF byte orders and the English guide. The akTIFF archive supplies the two additional byte-order descriptors that name the akTIFF class. The checked BCWB payload supplies the four descriptor icons. The Workbench TIFF default icon belongs to the shared BCWB defaults. The stock installer copies these additions and startup registers the descriptors through AddDataTypes. [Targa 43.1 archive](https://aminet.net/util/dtype/targadtype.lha) [TIFF 43.2 archive](https://se.aminet.net/util/dtype/TIFFDT.lha) [akTIFF archive](https://se.aminet.net/util/dtype/akTIFF-dt.lha)

The fixiff 1.0 command comes from the ILBM 47.6 archive. The ILBM entry owns its English readme, which documents the command. Stock protection mask 2 blocks direct Shell execution.

The pinned ViNCEd 3.107 archive supplies the topaz6 descriptor and its 8-pixel extended bitmap. The installed ViNCEd guide describes it as an optional console font. [ViNCEd 3.107 archive](https://web.archive.org/web/20240509064829id_/http://sg.aminet.net/util/shell/ViNCEd.lha)

MagicWB 2.1p supplies the exact XCourier bitmaps at 11, 13, and 15 pixels and XEN bitmaps at 8, 9, and 11 pixels. The checked BCWB descriptors preserve the installed order of the same archive records. The shipped Font preferences select XEN at 11 pixels as System Default Text. Directory Opus, DeliTracker, and MUI also reference XEN. MUI owns its XEN images and preset. [MagicWB 2.1p archive](https://se.aminet.net/util/wb/MagicWB21p.lha)

MagicWB 2.1p supplies the exact XHelvetica bitmaps at 9 and 13 pixels. Checked BCWB inputs preserve the 11-pixel bitmap and the descriptor's 9, 13, 11 record order. Directory Opus, EaglePlayer, MUI and the optional TinyMeter profile reference the family. [MagicWB 2.1p archive](https://se.aminet.net/util/wb/MagicWB21p.lha)

Grzegorz Kraszewski's TTEngine 7.2 m68k archive supplies the AmigaOS 3.0 68020 library and its English readme. TTEngine opens TrueType files directly. Its package owns `Libs/ttengine.library` and `Locale/Help/english/ttengine.readme`. The two bundled LCARS TrueType files belong to the WBDock entry. [TTEngine 7.2 m68k archive](https://se.aminet.net/util/libs/ttengine-68k.lha)

FileX 2.7a uses the four 68k builds from Aminet. The default executable matches the 68020 build. The archive also supplies its manuals, English guides, ARexx examples and language catalogs. The checked BCWB inputs preserve all twelve icons. ReqTools is an optional shared dependency tracked separately. [FileX 2.7a archive](https://se.aminet.net/disk/moni/FileX-68K.lha)

JanoEditor 1.01d uses the Aminet 68020 editor, JanoPrefs, guides, catalogs and source tree. The checked BCWB inputs preserve eleven icons and the saved preferences at `ENVARC:JanoEditor.prefs`. [JanoEditor 1.01d archive](https://se.aminet.net/text/edit/JanoEditor.lha)

The original SimpleFind 2.5 distribution on Aminet CD 30 supplies both 14 January 1999 binaries and the English guide. Checked BCWB inputs preserve the four icons and the saved profile beside the preferences editor in `SYS:Prefs`. SimpleFind defaults to a profile in its own drawer, and its installed icon leaves the profile override unset. PopupMenu, WBStartEmu and OpenURL keep their existing catalogue entries. [Aminet CD 30 archive](https://discmaster.textfiles.com/file/3300/Aminet%2030%20%281999%29%28Schatztruhe%29%5B%21%5D%5BApr%201999%5D.iso/Aminet/util/dir/simplefind.lha)

ABackup 5.22 uses the pinned archive for the application, ABackupPrefs 38.4 and both English guides. BCWB installs the editor as `SYS:Prefs/ABackup` and puts both guides beside the application. Checked BCWB inputs preserve five icons and `ENVARC:ABackup.prefs`. The shared startup sequence exposes the saved settings through `ENV:`. [ABackup archive](https://se.aminet.net/disk/bakup/abackup.lha)

SuperDuper 3.13 uses the pinned archive for the main executable, all three helpers and six documents. The `SD` member identifies as 37.13 and installs as `SuperDuper`. The helpers stay in its Programs drawer. The checked BCWB inputs preserve four icons. [SuperDuper archive](https://se.aminet.net/disk/misc/SD3V13.lha)

ReOrg 3.11 uses the preserved 3.1 release for the English documents, preferences, and two companion files. The publisher’s 3.11 patch applied to the original executable reproduces the stock binary by SHA-256. The manifest uses the checked BCWB executable for host-only builds and retains four checked BCWB icons. The English guide is beside the application. The stock installer copies all three packages with its standard payload operation. [ReOrg 3.1 archive](https://ftp.funet.fi/pub/amiga/utilities/disk/ReOrg-3.1.lha) [ReOrg 3.11 publisher patch](https://ftp.funet.fi/pub/amiga/utilities/disk/ReOrg-3.11-patch.lha)

TSgui 2.6 beta 22 owns the Programs drawer and its adjacent icon. The publisher's 2.6b25 archive supplies the exact bilingual 2.5 guide. The checked BCWB payload supplies the unresolved beta 22 executable and all three stock icons. Stock ships no S:tsgui.prefs or TSgui catalogs. Standard floppy transfers use trackdisk.device. Optional compression uses the shared GZIP and DMS commands. Directory Opus and the Workbench DMS default icon point to the installed executable. The ADF default icon points to DAControl. [Thomas Rapp's TSgui download](https://thomas-rapp.hier-im-netz.de/download.html)

TransADF 4.0.46 and UnADF 1.2 match the pinned Aminet command and documentation members. TransADF is the full build with statically linked zlib. UnADF uses xfdmaster.library for optional compressed input. Both Shell commands live in C: with documentation under Locale/Help/english. Directory Opus calls TransADF for image writes and UnADF for listing and extraction. The Directory Opus config, Workbench default icons, and shared dependencies retain their existing ownership. [TransADF archive](https://se.aminet.net/disk/misc/TransADF.lha) [UnADF archive](https://se.aminet.net/disk/misc/UnADF.lha)

The `rawread` entry pins Toni Wilen's 2 December 2001 m68k build, which matches the sole installed path, `C/rawread`, by SHA-256. The Aminet readme is a separate download. The shipped Directory Opus configuration calls the command for its ADF and Raw Read actions. TSgui includes its own Rawread-derived code. [rawread archive](https://se.aminet.net/disk/bakup/rawread.lha) [Aminet readme](https://se.aminet.net/disk/bakup/rawread.readme)

FMSsys maps `Programs/FMSsys` and its drawer icon. Aminet supplies Legionary's ADF2FMS 1.3 and both FMS guides. Checked BCWB inputs supply the Workbench icons, Bloodwych's `MountFMS` launcher, and the `Unit0` virtual floppy. ADF2FMS opens `fmsdisk.device` directly and uses the shared `reqtools.library` for its requesters. The Directory Opus configuration retains its shipped reference to `SYS:Programs/FMSys/MountFMS`. [ADF2FMS archive](https://se.aminet.net/disk/misc/adf2fms.lha)

The `fmsdisk` entry owns `Devs/fmsdisk.device` 5.01 and the complete `Devs/Mountlist`. Both match the pinned FMS archive, including the four double-density definitions for `FF0:` through `FF3:`. The FMSsys launcher assigns `FMS:` and uses `Mount` and `Format` to set up `FF0:`. [FMS archive](https://se.aminet.net/disk/misc/fmsdisk.lha)

PFS3AIO 3.1 supplies both 68000-compatible handlers in `Expansion/PFS3AIO`. Each reports filesystem version 19.2 dated 2 October 2018. The custom build supports RDB loaders that cannot handle hunk relocations. The checked BCWB payload supplies the drawer icon. Both handlers are shipped for manual filesystem setup. [PFS3AIO archive](https://se.aminet.net/disk/misc/pfs3aio.lha)

SCSIMounter 2.03 uses the Aminet 68k tool and English guide. The checked BCWB icon retains its artwork, position and tooltypes, including `DEVICE=scsi.device`, `CX_POPUP=Yes` and `CX_POPKEY=alt shift f10`. The Workbench tool is available for manual launch. [SCSIMounter 2.03 archive](https://se.aminet.net/disk/misc/SCSIMounter203.lha)

The `pccard` manifest pins Neil Cafferkey’s 5,420-byte 68k `pccard.library` 1.1 from the 3c589 1.5 archive. The pccardserial 1.1 bundle carries the same binary, while the standalone pccard 2.2 release contains a different build. The installed 3c589 driver uses this library to parse PCMCIA card information. Stock cnet uses `card.resource` directly. [3c589 1.5 archive](https://se.aminet.net/driver/net/3c589.lha)

CardPatch 1.2 uses the Aminet command and the readme inside the archive. Stock puts the readme under `Locale/Help/english` and leaves the CardPatch and CardReset lines disabled in the shared startup sequence. [CardPatch 1.2 archive](https://se.aminet.net/util/boot/CardPatch.lha)

CardReset 3.0 uses the pinned Aminet m68k command and in-archive readme. It uses card.resource ownership and the Gayle PCMCIA registers on the A600 or A1200. The shared startup sequence leaves its TICKS 50 invocation commented out. [CardReset archive](https://se.aminet.net/util/boot/CardReset.lha)

EjectADF 1.0 uses the pinned Aminet Workbench startup script, ejection script and in-archive readme. The checked BCWB project icon retains the stock artwork, position and ARexx tooltypes. Workbench adds Eject ADF image to the Tools menu. The handler uses AmigaOS 3.2 DAControl and trackfile.device for selected guest-mounted ADF images. Workbench reserves Right Amiga+period for Clean Up by Column, which takes precedence over the requested shortcut on 3.2.2.1. [EjectADF archive](https://se.aminet.net/util/wb/EjectADF.lha) [Workbench shortcuts](https://wiki.amigaos.net/wiki/Using_the_keyboard_to_control_Workbench)

MiamiDx 1.0c uses Holger Kruse’s two Aminet archives for the program, tools, English guide, private libraries, PPPoE, PPTP and L2TP devices, six MNI drivers, modem INF and the two MUI modules. Checked BCWB inputs preserve the default settings, the MUI selector, the installation log and eight icons. The main tool opens from the MiamiDx drawer in Workbench. The shared user startup script assigns `Miami:`. The default settings provide cnet and 3c589 hardware profiles. [MiamiDx main archive](https://se.aminet.net/comm/tcp/MiamiDx10cmain.lha) [MiamiDx MUI archive](https://se.aminet.net/comm/tcp/MiamiDx10c-MUI.lha)

The `cnet` entry owns the standard 68020+ SANA-II driver 1.9 and its English guide. The `3c589` entry owns the 1.5 device and the archive's English manual at the installed `3c589.guide` path. Both use the shared `DEVS:Networks` drawer. The separately catalogued `pccard` entry supplies the library used by 3c589. [cnet archive](https://se.aminet.net/driver/net/cnetdevice.lha) [3c589 archive](https://se.aminet.net/driver/net/3c589.lha)

Amiga Explorer maps the literal `Programs/Amiga Explorer` drawer and six files. Cloanto's 10.0.2.0 Windows setup contains the identical 68k AExplorer 10.0.0.0 and Setup.rexx 1.0 in both its x86 and x64 cabinets. Cloanto's 7.0.1.0 Windows setup supplies the exact stock README.TXT. The checked BCWB drawer, tool and project icons preserve the stock artwork and settings. Workbench opens the AExplorer icon with AUTO transport. Setup.rexx is the separate ARexx bootstrap for SER:. [Current Cloanto setup](https://cdn.cloanto.com/pub/amigaforever/amiga-explorer-10-setup.exe) [Legacy Cloanto setup](https://cdn.cloanto.com/pub/amigaforever/legacy/amiga-explorer-7-setup.exe)

DoMIME 1.0 matches the m68k command in DefIcons44. The shipped command looks up suffixes in Voyager-format `ENV:MIME.prefs` and can dispatch a project to a viewer. Workbench dispatch uses the separately owned WBStartEmu library. The stock installation contains no MIME.prefs or icon configured to use DoMIME. [DefIcons44 archive](https://se.aminet.net/util/wb/DefIcons44.lha)

asyncio.library 40.6 and its English help match the Aminet asyncioppc archive. The installed mixed library provides the 68020+ and WarpOS entry points. SongPlayer enables the library in its config. The installed EaglePlayer MPEG players, MiamiFtp and MUI GIFAnim.mcc also reference it. Each consumer stays with its existing package. [asyncioppc archive](https://se.aminet.net/util/libs/asyncioppc.lha)

VirusZ III 1.04b uses the classic 68k executable, documentation, history and signature from the pinned Aminet archive. An archived Virus Help Team release supplies the stock bootblock checksum database and English help. Checked BCWB inputs preserve the four Workbench icons. The Directory Opus AntiVirus button references the installed executable through its existing configuration. [VirusZ archive](https://se.aminet.net/util/virus/VirusZ.lha) [Archived bootblock release](https://web.archive.org/web/20230811073044id_/https://www.vht-dk.dk/amiga/vz/vhtvzboot.lha)

The shared xvs.library 33.47 and the English 33.42 readme match members from two archived Aminet releases. VirusZ and Voodoo-X use the library. [Archived 33.47 release](https://web.archive.org/web/20250121221113id_/https://aminet.net/util/virus/xvslibrary.lha) [Archived 33.42 release](https://web.archive.org/web/20200808033709id_/https://aminet.net/util/virus/xvslibrary.lha)

Voodoo-X 1.5 uses the pinned 68020 executable, English readme and history, and all 20 toolbar images, including CheckVirus. Checked BCWB inputs supply its Workbench icons, `ENVARC:Voodoo-X` files and `ENVARC:mui/VOODOO_X.prefs`. The saved settings enable external XAD clients and automatic scanning through the separately catalogued xvs library. Workbench, WBDock, ToolsMenu and the archive default icons target the installed Voodoo-X executable. [Voodoo-X archive](https://se.aminet.net/util/arc/Voodoo-X.lha)

The xadmaster 12.1a Aminet archive supplies the exact 12.1 KEY 020 library, eight `xad` commands, external clients and English help. The xfd 1.38 release supplies the exact xfdmaster 39.15 library, seven `xfd` commands, external depackers and English help. The release ZIP and installed hardfile spell two plug-ins `Libs/xad/__uae___R_A_W_` and `Libs/xfd/__uae___Ace_`. Each `X-Systems.TXT` maps to the same-named member of its respective archive. Checked BCWB inputs supply the shipped xad key and help icons. The English help drawers are shared with exe2arc and HackProPack. [xadmaster 68020 archive](https://se.aminet.net/util/arc/xadmaster020.lha) [xfdmaster 1.38 archive](https://se.aminet.net/util/pack/xfdmaster.lha)

LhA 2.15 uses the exact generic 68000+ member from the pinned Aminet archive and the exact March 2006 English guide from the preserved Aminet self-extractor. Applying the published Y2K patch to the registered LZX 1.21r 68000/68010 member reproduces the stock executable. The host build uses the checked BCWB binary and the exact English guide and public keyfile from Aminet. The separately catalogued xadmaster client owns `Libs/xad/LZX`. [LhA 2.15 archive](https://se.aminet.net/util/arc/lha_68k.lha) [Archived March 2006 guide](https://web.archive.org/web/20090215145936id_/http://aminet.net/util/arc/lha.run) [LZX 1.21r archive](https://se.aminet.net/util/arc/lzx121r1.lha) [Matching LZX Y2K patch](https://se.aminet.net/util/arc/LZX121r_pch.lha)

The DISK-Masher 1.11 TURBO GENERIC command matches the executable unpacked by the original SDS Software self-extractor. The host build uses the checked BCWB copy. The shipped Directory Opus configuration calls all three commands, and TSgui can call DMS for disk-image operations. The shared LhA, lharc and LZX Workbench project defaults open Voodoo-X and the DMS default opens TSgui. [DMS 1.11 self-extractor](https://se.aminet.net/util/arc/dms111.run)

Zip 2.2 uses the checked BCWB Amiga command and the exact English manual from Info-ZIP's preserved 2.2 archive. The archive's encryption-enabled executable differs from stock. UnZip 5.42 and UnRAR 3.4.3 use their pinned Aminet executables and documentation. The UnRAR executable reports 3.40 and requires ixemul.library 48 or later, which is absent from the stock installation. Directory Opus's Archive bank invokes Zip for creation and the ZIP and RAR filetype actions call the extractors. The shared Workbench ZIP default opens Voodoo-X. The installer harness runs its own byte-identical UnZip helper from `Reference:` before `C/unzip` is installed. [Zip 2.2 archive](https://sourceforge.net/projects/infozip/files/OldFiles/zcr22xA.zip/) [UnZip 5.42 archive](https://se.aminet.net/util/arc/unz542xA.lha) [UnRAR 3.4.3 archive](https://se.aminet.net/util/arc/unrar-68k-amigaos-bin.lha)

The native Amiga tar command matches the single member of Aminet's tar archive. UnTAR 37.1 uses the matching 68020+ build and can unpack plain and gzip-compressed TAR files. The ADE gzip 1.2.4 archive contains a pinned TAR with the exact command and English guide. The gzip executable needs ixemul.library 47 or later, which stock BCWB lacks. Directory Opus calls tar and gzip for the two filetypes. TSgui can call gzip for floppy images, while the shared Workbench GZIP default opens Voodoo-X. [Amiga tar archive](https://se.aminet.net/util/arc/tar.lha) [UnTAR 37.1 archive](https://se.aminet.net/util/arc/UnTAR_MH.lha) [ADE gzip 1.2.4 archive](https://se.aminet.net/dev/gg/gzip-bin.lha)

The AmigArc 0.23 entry uses the exact 68k command and SEA ARC 4.3 manual. The UnARJ 2.41 port 1.04 entry uses the optimized UnARJ.030 build and the original English 2.41 manual. Zoo 2.10 uses Olaf Seibert's 52,716-byte Amiga port from the pinned LZH. Directory Opus supplies all three sets of filetype actions. The Workbench unarchiver routes through Voodoo-X and XAD. [AmigArc archive](https://se.aminet.net/util/arc/arc.lha) [UnARJ 1.04 archive](https://se.aminet.net/util/arc/UnARJ241_104.lha) [Zoo 2.10 archive](https://se.aminet.net/util/arc/zoo2-10.lzh)

The exe2arc 1.5 and HackProPack 1.00a entries reuse the exact command and English help members from the pinned XAD and XFD releases. The checked BCWB exe2arc project icon opens its help in More. Lh 1.8 uses the authors' runtime library and English manual from Fred Fish disk 436. The shared help drawers remain with XAD and XFD, and the XPK LHLB plug-in uses the installed lh.library. [xadmaster archive](https://se.aminet.net/util/arc/xadmaster020.lha) [xfdmaster archive](https://se.aminet.net/util/pack/xfdmaster.lha) [Fred Fish disk 436](https://se.aminet.net/misc/fish/fish-0436.lha)

## Build on Windows

Run from the repository root in PowerShell. Use Python 3.12 or newer and Windows `tar.exe` with LhA support. SnoopDos, EaglePlayer, MUI, WBDock, ViNCEd, ToolsMenu, Personal Paint, ILBM, JFIF, Targa, TIFF, fixiff, XCourier, XEN, XHelvetica, TTEngine, FileX, JanoEditor, SimpleFind, ABackup, SuperDuper, ReOrg, TSgui, TransADF, UnADF, rawread, FMSsys, fmsdisk, PFS3AIO, SCSIMounter, pccard, CardPatch, CardReset, EjectADF, MiamiDx, cnet, 3c589, Amiga Explorer, DoMIME, asyncio, VirusZ, xvs, Voodoo-X, xadmaster, xfdmaster, LhA, LZX, Zip, UnZip, UnRAR, Zoo, exe2arc and HackProPack also need 7-Zip on PATH or installed in the standard Windows program directory. WHDLoad and WHDLoadCD32 need the Amiga LZX CLI (tested with v0.1.5) as `lzx.exe` on PATH. [Amiga LZX CLI releases](https://github.com/bitplane/amiga-lzx/releases/tag/v0.1.5)

Install the pinned Python dependency in a local virtual environment.

```powershell
python -m venv tmp/package-venv
$python = 'tmp/package-venv/Scripts/python.exe'
& $python -m pip install -r tools/package-requirements.txt
```

Place the archive files named in the package JSON in a local input directory. Each manifest contains the download URLs and SHA-256 values. The example uses the existing reference archives under `tmp/baseline`.

DeliTracker uses the 2.34 executable update and the full 2.32 archive. The manifest pins the inner LhA files under `nestedArchives`. Each record names its parent archive, member path, and SHA-256. Amiga Explorer uses the same mechanism for each Cloanto setup, its x86 MSI, and that MSI's cabinet. The builder verifies and extracts the pinned members in dependency order. A self-extracting release can set `payloadOffset` to the first byte of its embedded archive. The builder verifies the full release hash before extracting that payload and checking the selected members.

```powershell
& $python tools/package.py build directory-opus --archives tmp/baseline/directory-opus --output tmp/packages/directory-opus.hdf
& $python tools/package.py build fblit --archives tmp/baseline/fblit --output tmp/packages/fblit.hdf
```

Builds check the archive and file hashes and produce a WinUAE transport hardfile. Use a new output filename for each build or remove the old build output before rebuilding.

The builder selects long-name FFS (DOS\7) when an installed path component exceeds 30 characters. UnRAR uses this for `unrar-3.4.3-68k-amigaos-bin.readme`. Mount that transport on a system with long-name FFS support and install onto a volume that supports the same filename.

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
