 ---
 Shortcuts for "More" viewer:

    <Space>  = Next Page
    <Return> = Next Line
    <q>      = Quit

 This text can also be read under Windows.
 ---


 [1mAmiga Forever Data Sharing Software (Amiga Side)[0m


 [1mOverview[0m

 This document covers the Amiga side (opposed to the PC side) of the
 following software:

 - Amiga Explorer
 - DOS file systems
 - Transdisk and Transrom
 - Amiga Forever boot floppy disk

 Please note that if you are already running Amiga Explorer you probably
 don't need either a DOS file system or the Transdisk and Transrom
 utilities, the functionality of which is included in Amiga Explorer.

 Additional documentation in HTML format is included on the PC side. The
 following internet resources also include tutorials, frequently asked
 questions (FAQ) and troubleshooting sections:

    Amiga Forever Web Site
    www.amigaforever.com

    Amiga Explorer Home Page
    www.amigaforever.com/ae/


 [1mIntroduction to Amiga Explorer[0m

 The main data sharing tool, which is included in the same directory
 containing this text, is the Amiga Explorer network server software (to
 connect one or more PCs to the Amiga). This part of Amiga Explorer was
 designed to run on a "real" Amiga, but, thanks to the TCP/IP
 functionality, Amiga Explorer can also be used to improve communications
 between Windows and an Amiga emulation environment running on the same
 machine.

 The Amiga side of Amiga Explorer ("AExplorer" icon) communicates over a
 serial or TCP/IP link with the Amiga Explorer part which resides on a
 Windows machine, exposing all Amiga drives. In this configuration, the
 Amiga is called the "server", because it is the computer which satisfies
 requests from "clients", which are Windows machines. All Windows clients
 can "see" what is stored on the Amiga server, and read and write to the
 Amiga. The Amiga itself does not see the drives mounted on the client
 machines, i.e. the drives of the Windows computers do not appear on the
 Workbench screen of the Amiga server.

 Amiga Explorer is available as a stand-alone package and as part of Amiga
 Forever. Amiga Explorer and the other utilities described here are fully
 independent from the Amiga emulation software, and can be used to share
 data between Windows and Amiga systems without using the Amiga emulation
 software.


 [1mInstalling Amiga Explorer[0m

 If you intend to use Amiga Explorer over a serial connection (null-modem
 cable or Bluetooth serial link), and you don't have a DOS file system on
 the Amiga, then the easiest way to copy the Amiga files from the PC to
 the Amiga is to install Amiga Explorer on the PC and then proceed with
 the automatic Setup option, which is available with a right-click on the
 Amiga Explorer icon on the Windows desktop.

 If instead your Amiga has a DOS file system you can use the "Copy to
 Floppy" option in the "Cloanto/Amiga Explorer" program folder (Windows
 Start menu) to copy the Amiga data sharing software to the PC's floppy
 disk, from where it can be copied to an Amiga computer. If the DOS file
 system on your Amiga does not support "long" file names, be sure to
 rename the files after copying them to the Amiga, so that their names
 are:

    AExplorer
    AExplorer.info
    ReadMe.txt
    ReadMe.txt.info


 [1mStarting Amiga Explorer[0m

 On the Amiga side, double-click the AExplorer icon to start it. You can
 double-click it again to stop it. Stopping Amiga Explorer may be useful,
 for example, to free the serial port for other tasks, or to change some
 Amiga Explorer settings. To install Amiga Explorer, simply copy the
 "AExplorer" icon to the hard disk.

 On version 2.0 and newer of the Amiga OS, copying the "AExplorer" icon
 into the "WBStartup" drawer will cause Amiga Explorer to start
 automatically when the system boots.

 On all Amiga systems, Amiga Explorer can also be started automatically by
 entering the following line in the "S:Startup-Sequence" or
 "S:User-Startup" file:

    Run >NIL: <NIL: AExplorer >NIL: <NIL: [OPTIONS]

 (Instead of "AExplorer", in the above line, you will probably have to
 enter the path of the software as it is installed on the hard disk, e.g.
 "Work:Software/AExplorer/AExplorer", etc.)

 The optional [OPTIONS] part consists of one or more keywords each
 followed by a setting, e.g. "CONNECTION SERIAL SERBAUD 115200", etc. If
 no options are indicated, then the default settings are used. The option
 names and the default values are explained below. All command line
 options also have matching ToolTypes with the same name.

 This version of Amiga Explorer supports standard "null-modem" 7-wire
 serial cables (the schematics are included in the main documentation), as
 well as TCP/IP (Ethernet, ARCNet, internet, serial, etc.) Settings can be
 changed by clicking on the "AExplorer" icon once, and selecting the
 "Information..." (or "Info", on older systems) item from the Workbench
 menus. All settings are accessible by editing the appropriate "ToolType"
 entries, which are described here.

 CONNECTION: This entry may be set to AUTO, SERIAL or TCP/IP. AUTO, which
 is the default, means that Amiga Explorer uses TCP/IP if a TCP/IP
 environment is found, otherwise it uses the serial (null-modem) cable
 connection.

 SERDEVICE, SERUNIT, SERBAUD: These are the serial port settings. By
 default, the standard Amiga serial device, "serial.device", unit 0, is
 used. This does not require changes, unless non-standard serial ports and
 devices are used, in which case the corresponding documentation needs to
 be referred to. SERBAUD is preset to 19200 bit/sec, which was tested to
 run well even on the slowest Amiga systems. Higher values allow for
 higher transmission speeds, but are not supported by all systems. If this
 setting is changed, it also needs to be changed to the same value on the
 Windows side of Amiga Explorer. Other possible values include (without
 being limited to): 4800, 9600, 38400, 57600 and 115200.

 TCPLIBRARY, TCPPASSWORD, TCPCLIENT, TCPSERVER: These are the TCP/IP
 settings, which on the Amiga side by default do not require any specific
 configuration. The Amiga side of Amiga Explorer processes requests from
 all Windows clients. To limit potential security risks, Amiga Explorer
 gives the possibility to specify a password (TCPPASSWORD), and to
 optionally indicate the IP address of a single Windows client to which
 exclusive access is to be granted. A default password is preset on both
 the Windows and the Amiga side. If the password is changed, the new value
 must be set both on the Windows clients and on the Amiga server. Requests
 from clients with a different password are not processed. By default, the
 Amiga side of Amiga Explorer "listens" to all Windows clients. As an
 additional security measure, it is possible to program the TCPCLIENT
 setting to the IP address (e.g. "TCPCLIENT=10.0.0.5") of a single Windows
 client, which will then become the only client with which the Amiga
 server exchanges data. This provides an additional level of protection
 over the password solution, because the (encrypted) password is
 transmitted over the network, and, in theory, could be read by an
 unauthorized party on the same network path using a TCP/IP packet
 monitor. The TCPSERVER setting, which is also optional, can be programmed
 to the IP address of the Amiga server. This is required on multi-homed
 systems, i.e. where the Amiga has more than one network board and/or IP
 address, and Amiga Explorer may need to be told which one to use.

 PACKETSIZE: This value indicates the maximum size, in bytes, of the data
 packets sent by the Amiga server to the Windows clients. A "packet" is
 the unit of data which is transmitted from one side to the other at one
 time. Each packet has different checksums to ensure the integrity of the
 data, once the packet is received by the other side. If the line is not
 totally error-free, which may for example occur on a serial connection
 which is set to an excessively high speed, corrupt packets are detected
 and re-sent. If this happens, the overhead is in proportion to the size
 of the packet. Longer packets are more likely to be corrupt, because they
 contain more data, and they also take longer to be sent and re-sent.
 Shorter packets are more reliable, but they slightly increase the overall
 overhead on an error-free line, because each packet has some additional
 header and checksum data, which, if there are no errors, is not
 necessary. By default, PACKETSIZE is set to 512 bytes, which is a good
 compromise for different types of connections and operating systems. For
 optimum performance, the Amiga side and the Windows side should be set to
 the same values, because each side allocates input buffers based on the
 local setting. All Amiga Explorer packets are "dynamic", i.e. the packet
 size is only a maximum, not a constant. If the packet size is set to
 4096, but only 100 bytes need to be transmitted, then only 100 bytes
 (plus the header) are transmitted, not 4096.

 RETRIES: This parameter determines how often the Amiga side will request
 a corrupt packet to be retransmitted, before "giving up". By default, it
 retries 50 times. The Amiga and the Windows side do not need to be set to
 the same value.

 ADFVERIFY: Amiga Explorer can transform Amiga disks to ADF ("Amiga Disk
 File") images, and vice versa. When writing an ADF image to an Amiga
 disk, Amiga Explorer by default verifies that the data was written
 correctly, just like the Amiga OS does when formatting a disk, or like
 disk-copying programs can do during a copy. In this way, bad disks and
 other possible problems are immediately detected. If ADFVERIFY is set to
 NO, bad disks and other write errors are not detected, but the write
 process will be faster.

 OVERRIDEPROTECTION: If this setting is enabled (=YES), then Amiga
 Explorer overrides any Amiga protection bits which may indicate, for
 example, that a file cannot be deleted, read or written.

 LOGGING, LOGFILE: Logging can be enabled (LOGGING=YES) in case of
 persistent difficulties, to better track the origin of specific problems.
 By default, logging is disabled (LOGGING=NO). Please refer to the main
 documentation for additional information.

 QUIET: This setting can be set to YES or NO to respectively suppress or
 enable the initial and final status window which appears when Amiga
 Explorer is launched or stopped.

 DONOTWAIT: This ToolType ensures that the "AExplorer" icon can be dropped
 in "WBStartup" without leaving the Amiga OS waiting for Amiga Explorer to
 terminate.

 UNIT: This setting, which has a default value of 0, can be used to launch
 multiple Amiga Explorer servers, for example one running in serial mode
 and one in TCP/IP mode. Each server must be referenced by its unique UNIT
 number in the ToolType or command line (also to stop the server).


 [1mDOS File Systems[0m

 In order to read PC-formatted floppy disks, the Amiga must have a DOS
 file system, such as CrossDOS, MSH or XFS.

 Amiga OS versions 2.1 and higher include a version of CrossDOS, although
 it does not support "long" file names (i.e. longer than 8+3 characters).
 When using CrossDOS, DOS format drives are accessible with device names
 such as PC0: and PC1:.

 The Amiga Forever boot floppy disk, described in more detail below,
 includes MSH, which is implemented as an Amiga file system handler that
 allows the Amiga to read and write DOS-formatted floppy disks. MSH does
 not support long file names, however it has the advantage of running even
 on older Amiga systems (e.g. systems with 1.2 ROMs), which may otherwise
 not be able to access DOS disks. When using MSH, DOS format drives are
 accessible with device names such as MS0: and MS1:.

 XFS (available for free download on Aminet) and the latest commercial
 version of CrossDOS support long Windows file names, meaning that file
 names longer than 8 characters appear properly when read on an Amiga.

 The most popular 3.5" floppy disk variants are DD (double density, 1 MB
 unformatted capacity) and HD (high density, 2 MB unformatted capacity).
 HD disks can be recognized by the high density media identification hole
 (opposite the write-protect hole). Under the DOS file system these disks
 are formatted as 720 KB and 1.44 MB, respectively, which is a bit less
 than the capacity of Amiga format disks.

 High density DOS-formatted data (disks formatted for 1.44 MB) cannot be
 accessed by the Amiga unless the Amiga drive supports this functionality.
 Some drives shipping with the Commodore-Amiga A3000, A3000T, A4000 and
 A1200 models, as well as some newer third-party drives support this. If
 high density is not supported by the drive, then only disks formatted in
 the 720 KB format can be accessed.

 If in doubt, use the Amiga (not the PC) to format disks used for data
 sharing, or cover the high density hole with some opaque tape. Be careful
 not to damage the disk or drive with the tape.


 [1mTransdisk and Transrom[0m

 The "Transdisk" and "Transrom" utilities can be used to create image
 files of Amiga ROMs and floppy disks, for use with the UAE and Fellow
 Amiga emulators. Floppy disk images are usually referred to as "ADF"
 images. The same functionality is also part of Amiga Explorer, which is
 capable of creating "virtual" ADF and ROM image files, so these
 additional tools are mainly interesting when Amiga Explorer is not used.

 Transdisk and Transrom can be found on the Amiga Forever CD-ROM, on the
 Amiga Forever boot disk image, and in the
 "Emulation/shared/amiga_utilities" subdirectory of the Amiga Forever
 installation (usually "C:\Program Files\Cloanto\Amiga Forever" on an
 English language Windows system).

 In order to share data stored on floppy disks between the Amiga and other
 systems which cannot read Amiga-format disks, the disks should be
 formatted using the DOS file system.

 An Amiga ROM image is small enough to fit on a 720 KB DOS-formatted disk.
 However, an ADF floppy disk image file of an 880 KB Amiga disk cannot fit
 on a 720 KB DOS disk unless it is either compressed (with a program such
 as LhA), or split in several parts. The transdisk utility includes an
 option to split a disk image in several files.

 Both utilities are designed to be used from the Shell. Before use, they
 are best copied to the C: directory, or to another location where the
 system looks for programs associated to Shell commands.

 The following are examples of command lines entered in a Shell (or CLI,
 on older systems) window.

 To install the command line utilities (add file path as necessary):

    Copy transdisk C: CLONE
    Copy transrom C: CLONE

 To get instructions on the use of Transdisk:

    transdisk ?

 To write a ROM image file to the PC0: DOS disk:

    transrom > PC0:kick31.rom

 To write a ROM image file to the MS0: DOS disk:

    transrom > MS0:kick31.rom


 [1mThe Amiga Forever Boot Floppy Disk[0m

 The CD-ROM version of Amiga Forever includes a disk image in ADF format
 which can be used (e.g. with Amiga Explorer) to write a bootable Amiga
 floppy disk containing all the tools described in this document. The disk
 image, named "af-boot.adf", is stored in the "Emulation/shared/adf"
 directory of the Amiga Forever installation.

 The Amiga Forever boot floppy disk supports Amiga computers with version
 1.2 or higher ROMs. At the end of the boot process both the Amiga side of
 Amiga Explorer and the MSH file system are running, and the boot disk
 itself is not required any more (it may be removed to access other
 disks). This means that by booting with this disk it is possible to use
 an Amiga computer without monitor as a "floppy drive" for the PC to read
 and write Amiga disks via Amiga Explorer.

 In order to use this default configuration you only need to make sure
 that on the Windows side of Amiga Explorer the proper COM port is
 selected for communications with the Amiga.


 [1mInstalling MSH from the Boot Floppy Disk[0m

 If you prefer to install MSH on your system, execute the following in a
 Shell or CLI window (replace "AF_Boot:" with the path where the MSH files
 are located):

    Copy AF_Boot:devs/messydisk.device DEVS: CLONE
    Copy AF_Boot:devs/MountList.MSH DEVS: CLONE
    Copy AF_Boot:l/MessyFileSystem L: CLONE

 In the "S:Startup-Sequence" or "S:User-Startup" file, add one entry for
 each disk drive for which you wish to enable MSH, where the name of the
 device to be mounted is "MS" plus the unit number. For example, to add
 MS-DOS-support to drives 0 and 1, add:

    Mount MS0: FROM DEVS:MountList.MSH
    Mount MS1: FROM DEVS:MountList.MSH


 [1mNotes[0m

 Amiga Explorer is Copyright © 1998-2004 Cloanto. MSH is Copyright ©
 1989-1997 Olaf "Rhialto" Seibert, distributed under license. Transdisk is
 Copyright © 1995-1997 Bernd Schmidt, Joanne Dow, Marcus Sundberg, Rodney
 Hester and Stefan Ropke, distributed with permission. Transrom is
 Copyright © 1995-1996 Bernd Schmidt, Marcus Sundberg, Rodney Hester and
 Stefan Ropke, distributed with permission. For additional copyright,
 distribution and other legal and technical information please refer to
 the main documentation or visit the Amiga Forever Home Page at
 www.amigaforever.com.

