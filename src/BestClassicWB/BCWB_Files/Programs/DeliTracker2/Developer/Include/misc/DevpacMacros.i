**********************************************************************
*								     *
*	KICKSTART V3.0 / 39.108 Macros for Devpac3		     *
*	$Release 3.01$						     *
*	arranged by Delirium Softdesign				     *
*								     *
**********************************************************************

	IFND	DEVPACMACROS_I
DEVPACMACROS_I	SET	1


;---------------------------------------------------------------------
;
;	Libraries
;

**********************************************************************
*                        amigaguide.library                          *
**********************************************************************

CALLAMIGAGUIDE	MACRO
	move.l	_AmigaGuideBase,a6
	jsr	_LVO\1(a6)
	ENDM

AMIGAGUIDENAME	MACRO
	dc.b	'amigaguide.library',0
	even
	ENDM

_LVOAGARexxHost			EQU -30
_LVOLockAmigaGuideBase		EQU -36
_LVOUnlockAmigaGuideBase	EQU -42
_LVOOpenAmigaGuideA		EQU -54
_LVOOpenAmigaGuideAsyncA	EQU -60
_LVOCloseAmigaGuide		EQU -66
_LVOAmigaGuideSignal		EQU -72
_LVOGetAmigaGuideMsg		EQU -78
_LVOReplyAmigaGuideMsg		EQU -84
_LVOSetAmigaGuideContextA	EQU -90
_LVOSendAmigaGuideContextA	EQU -96
_LVOSendAmigaGuideCmdA		EQU -102
_LVOSetAmigaGuideAttrsA		EQU -108
_LVOGetAmigaGuideAttr		EQU -114
_LVOAddAmigaGuideHostA		EQU -138
_LVORemoveAmigaGuideHostA	EQU -144
_LVOGetAmigaGuideString		EQU -210


**********************************************************************
*                            asl.library                             *
**********************************************************************

CALLASL	MACRO
	move.l	_AslBase,a6
	jsr	_LVO\1(a6)
	ENDM

_LVOAllocFileRequest		EQU -30
_LVOFreeFileRequest		EQU -36
_LVORequestFile			EQU -42
_LVOAllocAslRequest		EQU -48
_LVOFreeAslRequest		EQU -54
_LVOAslRequest			EQU -60


**********************************************************************
*                           bullet.library                           *
**********************************************************************

CALLBULLET	MACRO
	move.l	_BulletBase,a6
	jsr	_LVO\1(a6)
	ENDM

BULLETNAME	MACRO
	dc.b	'bullet.library',0
	even
	ENDM

_LVOOpenEngine			EQU -30
_LVOCloseEngine			EQU -36
_LVOSetInfoA			EQU -42
_LVOObtainInfoA			EQU -48
_LVOReleaseInfoA		EQU -54


**********************************************************************
*                        commodities.library                         *
**********************************************************************

CALLCX	MACRO
	move.l	_CxBase,a6
	jsr	_LVO\1(a6)
	ENDM

CXNAME	MACRO
	dc.b	'commodities.library',0
	even
	ENDM

_LVOCreateCxObj			EQU -30
_LVOCxBroker			EQU -36
_LVOActivateCxObj		EQU -42
_LVODeleteCxObj			EQU -48
_LVODeleteCxObjAll		EQU -54
_LVOCxObjType			EQU -60
_LVOCxObjError			EQU -66
_LVOClearCxObjError		EQU -72
_LVOSetCxObjPri			EQU -78
_LVOAttachCxObj			EQU -84
_LVOEnqueueCxObj		EQU -90
_LVOInsertCxObj			EQU -96
_LVORemoveCxObj			EQU -102
_LVOSetTranslate		EQU -114
_LVOSetFilter			EQU -120
_LVOSetFilterIX			EQU -126
_LVOParseIX			EQU -132
_LVOCxMsgType			EQU -138
_LVOCxMsgData			EQU -144
_LVOCxMsgID			EQU -150
_LVODivertCxMsg			EQU -156
_LVORouteCxMsg			EQU -162
_LVODisposeCxMsg		EQU -168
_LVOInvertKeyMap		EQU -174
_LVOAddIEvents			EQU -180
_LVOMatchIX			EQU -204


**********************************************************************
*                         datatypes.library                          *
**********************************************************************

CALLDATATYPES	MACRO
	move.l	_DataTypesBase,a6
	jsr	_LVO\1(a6)
	ENDM

DATATYPESNAME	MACRO
	dc.b	'datatypes.library',0
	even
	ENDM

_LVORLDispatch			EQU -30
_LVOObtainDataTypeA		EQU -36
_LVOReleaseDataType		EQU -42
_LVONewDTObjectA		EQU -48
_LVODisposeDTObject		EQU -54
_LVOSetDTAttrsA			EQU -60
_LVOGetDTAttrsA			EQU -66
_LVOAddDTObject			EQU -72
_LVORefreshDTObjectA		EQU -78
_LVODoAsyncLayout		EQU -84
_LVODoDTMethodA			EQU -90
_LVORemoveDTObject		EQU -96
_LVOGetDTMethods		EQU -102
_LVOGetDTTriggerMethods		EQU -108
_LVOPrintDTObjectA		EQU -114
_LVOGetDTString			EQU -138


**********************************************************************
*                          diskfont.library                          *
**********************************************************************

CALLDISKFONT	MACRO
	move.l	_DiskfontBase,a6
	jsr	_LVO\1(a6)
	ENDM

DISKFONTNAME	MACRO
	dc.b	'diskfont.library',0
	even
	ENDM

_LVOOpenDiskFont		EQU -30
_LVOAvailFonts			EQU -36
_LVONewFontContents		EQU -42
_LVODisposeFontContents		EQU -48
_LVONewScaledDiskFont		EQU -54


**********************************************************************
*                            dos.library                             *
**********************************************************************

CALLDOS	MACRO
	move.l	_DOSBase,a6
	jsr	_LVO\1(a6)
	ENDM

_LVOOpen			EQU -30
_LVOClose			EQU -36
_LVORead			EQU -42
_LVOWrite			EQU -48
_LVOInput			EQU -54
_LVOOutput			EQU -60
_LVOSeek			EQU -66
_LVODeleteFile			EQU -72
_LVORename			EQU -78
_LVOLock			EQU -84
_LVOUnLock			EQU -90
_LVODupLock			EQU -96
_LVOExamine			EQU -102
_LVOExNext			EQU -108
_LVOInfo			EQU -114
_LVOCreateDir			EQU -120
_LVOCurrentDir			EQU -126
_LVOIoErr			EQU -132
_LVOCreateProc			EQU -138
_LVOExit			EQU -144
_LVOLoadSeg			EQU -150
_LVOUnLoadSeg			EQU -156
_LVODeviceProc			EQU -174
_LVOSetComment			EQU -180
_LVOSetProtection		EQU -186
_LVODateStamp			EQU -192
_LVODelay			EQU -198
_LVOWaitForChar			EQU -204
_LVOParentDir			EQU -210
_LVOIsInteractive		EQU -216
_LVOExecute			EQU -222
_LVOAllocDosObject		EQU -228
_LVOFreeDosObject		EQU -234
_LVODoPkt			EQU -240
_LVOSendPkt			EQU -246
_LVOWaitPkt			EQU -252
_LVOReplyPkt			EQU -258
_LVOAbortPkt			EQU -264
_LVOLockRecord			EQU -270
_LVOLockRecords			EQU -276
_LVOUnLockRecord		EQU -282
_LVOUnLockRecords		EQU -288
_LVOSelectInput			EQU -294
_LVOSelectOutput		EQU -300
_LVOFGetC			EQU -306
_LVOFPutC			EQU -312
_LVOUnGetC			EQU -318
_LVOFRead			EQU -324
_LVOFWrite			EQU -330
_LVOFGets			EQU -336
_LVOFPuts			EQU -342
_LVOVFWritef			EQU -348
_LVOVFPrintf			EQU -354
_LVOFlush			EQU -360
_LVOSetVBuf			EQU -366
_LVODupLockFromFH		EQU -372
_LVOOpenFromLock		EQU -378
_LVOParentOfFH			EQU -384
_LVOExamineFH			EQU -390
_LVOSetFileDate			EQU -396
_LVONameFromLock		EQU -402
_LVONameFromFH			EQU -408
_LVOSplitName			EQU -414
_LVOSameLock			EQU -420
_LVOSetMode			EQU -426
_LVOExAll			EQU -432
_LVOReadLink			EQU -438
_LVOMakeLink			EQU -444
_LVOChangeMode			EQU -450
_LVOSetFileSize			EQU -456
_LVOSetIoErr			EQU -462
_LVOFault			EQU -468
_LVOPrintFault			EQU -474
_LVOErrorReport			EQU -480
_LVOCli				EQU -492
_LVOCreateNewProc		EQU -498
_LVORunCommand			EQU -504
_LVOGetConsoleTask		EQU -510
_LVOSetConsoleTask		EQU -516
_LVOGetFileSysTask		EQU -522
_LVOSetFileSysTask		EQU -528
_LVOGetArgStr			EQU -534
_LVOSetArgStr			EQU -540
_LVOFindCliProc			EQU -546
_LVOMaxCli			EQU -552
_LVOSetCurrentDirName		EQU -558
_LVOGetCurrentDirName		EQU -564
_LVOSetProgramName		EQU -570
_LVOGetProgramName		EQU -576
_LVOSetPrompt			EQU -582
_LVOGetPrompt			EQU -588
_LVOSetProgramDir		EQU -594
_LVOGetProgramDir		EQU -600
_LVOSystemTagList		EQU -606
_LVOAssignLock			EQU -612
_LVOAssignLate			EQU -618
_LVOAssignPath			EQU -624
_LVOAssignAdd			EQU -630
_LVORemAssignList		EQU -636
_LVOGetDeviceProc		EQU -642
_LVOFreeDeviceProc		EQU -648
_LVOLockDosList			EQU -654
_LVOUnLockDosList		EQU -660
_LVOAttemptLockDosList		EQU -666
_LVORemDosEntry			EQU -672
_LVOAddDosEntry			EQU -678
_LVOFindDosEntry		EQU -684
_LVONextDosEntry		EQU -690
_LVOMakeDosEntry		EQU -696
_LVOFreeDosEntry		EQU -702
_LVOIsFileSystem		EQU -708
_LVOFormat			EQU -714
_LVORelabel			EQU -720
_LVOInhibit			EQU -726
_LVOAddBuffers			EQU -732
_LVOCompareDates		EQU -738
_LVODateToStr			EQU -744
_LVOStrToDate			EQU -750
_LVOInternalLoadSeg		EQU -756
_LVOInternalUnLoadSeg		EQU -762
_LVONewLoadSeg			EQU -768
_LVOAddSegment			EQU -774
_LVOFindSegment			EQU -780
_LVORemSegment			EQU -786
_LVOCheckSignal			EQU -792
_LVOReadArgs			EQU -798
_LVOFindArg			EQU -804
_LVOReadItem			EQU -810
_LVOStrToLong			EQU -816
_LVOMatchFirst			EQU -822
_LVOMatchNext			EQU -828
_LVOMatchEnd			EQU -834
_LVOParsePattern		EQU -840
_LVOMatchPattern		EQU -846
_LVOFreeArgs			EQU -858
_LVOFilePart			EQU -870
_LVOPathPart			EQU -876
_LVOAddPart			EQU -882
_LVOStartNotify			EQU -888
_LVOEndNotify			EQU -894
_LVOSetVar			EQU -900
_LVOGetVar			EQU -906
_LVODeleteVar			EQU -912
_LVOFindVar			EQU -918
_LVOCliInitNewcli		EQU -930
_LVOCliInitRun			EQU -936
_LVOWriteChars			EQU -942
_LVOPutStr			EQU -948
_LVOVPrintf			EQU -954
_LVOParsePatternNoCase		EQU -966
_LVOMatchPatternNoCase		EQU -972
_LVOSameDevice			EQU -984
_LVOExAllEnd			EQU -990
_LVOSetOwner			EQU -996


**********************************************************************
*                            exec.library                            *
**********************************************************************

CALLEXEC	MACRO
	move.l	4.w,a6
	jsr	_LVO\1(a6)
	ENDM

EXECNAME	MACRO
	dc.b	'exec.library',0
	even
	ENDM

_LVOSupervisor			EQU -30
_LVOInitCode			EQU -72
_LVOInitStruct			EQU -78
_LVOMakeLibrary			EQU -84
_LVOMakeFunctions		EQU -90
_LVOFindResident		EQU -96
_LVOInitResident		EQU -102
_LVOAlert			EQU -108
_LVODebug			EQU -114
_LVODisable			EQU -120
_LVOEnable			EQU -126
_LVOForbid			EQU -132
_LVOPermit			EQU -138
_LVOSetSR			EQU -144
_LVOSuperState			EQU -150
_LVOUserState			EQU -156
_LVOSetIntVector		EQU -162
_LVOAddIntServer		EQU -168
_LVORemIntServer		EQU -174
_LVOCause			EQU -180
_LVOAllocate			EQU -186
_LVODeallocate			EQU -192
_LVOAllocMem			EQU -198
_LVOAllocAbs			EQU -204
_LVOFreeMem			EQU -210
_LVOAvailMem			EQU -216
_LVOAllocEntry			EQU -222
_LVOFreeEntry			EQU -228
_LVOInsert			EQU -234
_LVOAddHead			EQU -240
_LVOAddTail			EQU -246
_LVORemove			EQU -252
_LVORemHead			EQU -258
_LVORemTail			EQU -264
_LVOEnqueue			EQU -270
_LVOFindName			EQU -276
_LVOAddTask			EQU -282
_LVORemTask			EQU -288
_LVOFindTask			EQU -294
_LVOSetTaskPri			EQU -300
_LVOSetSignal			EQU -306
_LVOSetExcept			EQU -312
_LVOWait			EQU -318
_LVOSignal			EQU -324
_LVOAllocSignal			EQU -330
_LVOFreeSignal			EQU -336
_LVOAllocTrap			EQU -342
_LVOFreeTrap			EQU -348
_LVOAddPort			EQU -354
_LVORemPort			EQU -360
_LVOPutMsg			EQU -366
_LVOGetMsg			EQU -372
_LVOReplyMsg			EQU -378
_LVOWaitPort			EQU -384
_LVOFindPort			EQU -390
_LVOAddLibrary			EQU -396
_LVORemLibrary			EQU -402
_LVOOldOpenLibrary		EQU -408
_LVOCloseLibrary		EQU -414
_LVOSetFunction			EQU -420
_LVOSumLibrary			EQU -426
_LVOAddDevice			EQU -432
_LVORemDevice			EQU -438
_LVOOpenDevice			EQU -444
_LVOCloseDevice			EQU -450
_LVODoIO			EQU -456
_LVOSendIO			EQU -462
_LVOCheckIO			EQU -468
_LVOWaitIO			EQU -474
_LVOAbortIO			EQU -480
_LVOAddResource			EQU -486
_LVORemResource			EQU -492
_LVOOpenResource		EQU -498
_LVORawDoFmt			EQU -522
_LVOGetCC			EQU -528
_LVOTypeOfMem			EQU -534
_LVOProcure			EQU -540
_LVOVacate			EQU -546
_LVOOpenLibrary			EQU -552
_LVOInitSemaphore		EQU -558
_LVOObtainSemaphore		EQU -564
_LVOReleaseSemaphore		EQU -570
_LVOAttemptSemaphore		EQU -576
_LVOObtainSemaphoreList		EQU -582
_LVOReleaseSemaphoreList	EQU -588
_LVOFindSemaphore		EQU -594
_LVOAddSemaphore		EQU -600
_LVORemSemaphore		EQU -606
_LVOSumKickData			EQU -612
_LVOAddMemList			EQU -618
_LVOCopyMem			EQU -624
_LVOCopyMemQuick		EQU -630
_LVOCacheClearU			EQU -636
_LVOCacheClearE			EQU -642
_LVOCacheControl		EQU -648
_LVOCreateIORequest		EQU -654
_LVODeleteIORequest		EQU -660
_LVOCreateMsgPort		EQU -666
_LVODeleteMsgPort		EQU -672
_LVOObtainSemaphoreShared	EQU -678
_LVOAllocVec			EQU -684
_LVOFreeVec			EQU -690
_LVOCreatePool			EQU -696
_LVODeletePool			EQU -702
_LVOAllocPooled			EQU -708
_LVOFreePooled			EQU -714
_LVOAttemptSemaphoreShared	EQU -720
_LVOColdReboot			EQU -726
_LVOStackSwap			EQU -732
_LVOChildFree			EQU -738
_LVOChildOrphan			EQU -744
_LVOChildStatus			EQU -750
_LVOChildWait			EQU -756
_LVOCachePreDMA			EQU -762
_LVOCachePostDMA		EQU -768
_LVOAddMemHandler		EQU -774
_LVORemMemHandler		EQU -780


**********************************************************************
*                         expansion.library                          *
**********************************************************************

CALLEXPANSION	MACRO
	move.l	_ExpansionBase,a6
	jsr	_LVO\1(a6)
	ENDM

_LVOAddConfigDev		EQU -30
_LVOAddBootNode			EQU -36
_LVOAllocBoardMem		EQU -42
_LVOAllocConfigDev		EQU -48
_LVOAllocExpansionMem		EQU -54
_LVOConfigBoard			EQU -60
_LVOConfigChain			EQU -66
_LVOFindConfigDev		EQU -72
_LVOFreeBoardMem		EQU -78
_LVOFreeConfigDev		EQU -84
_LVOFreeExpansionMem		EQU -90
_LVOReadExpansionByte		EQU -96
_LVOReadExpansionRom		EQU -102
_LVORemConfigDev		EQU -108
_LVOWriteExpansionByte		EQU -114
_LVOObtainConfigBinding		EQU -120
_LVOReleaseConfigBinding	EQU -126
_LVOSetCurrentBinding		EQU -132
_LVOGetCurrentBinding		EQU -138
_LVOMakeDosNode			EQU -144
_LVOAddDosNode			EQU -150


**********************************************************************
*                          gadtools.library                          *
**********************************************************************

CALLGADTOOLS	MACRO
	move.l	_GadToolsBase,a6
	jsr	_LVO\1(a6)
	ENDM

GADTOOLSNAME	MACRO
	dc.b	'gadtools.library',0
	even
	ENDM

_LVOCreateGadgetA		EQU -30
_LVOFreeGadgets			EQU -36
_LVOGT_SetGadgetAttrsA		EQU -42
_LVOCreateMenusA		EQU -48
_LVOFreeMenus			EQU -54
_LVOLayoutMenuItemsA		EQU -60
_LVOLayoutMenusA		EQU -66
_LVOGT_GetIMsg			EQU -72
_LVOGT_ReplyIMsg		EQU -78
_LVOGT_RefreshWindow		EQU -84
_LVOGT_BeginRefresh		EQU -90
_LVOGT_EndRefresh		EQU -96
_LVOGT_FilterIMsg		EQU -102
_LVOGT_PostFilterIMsg		EQU -108
_LVOCreateContext		EQU -114
_LVODrawBevelBoxA		EQU -120
_LVOGetVisualInfoA		EQU -126
_LVOFreeVisualInfo		EQU -132
_LVOGT_GetGadgetAttrsA		EQU -174


**********************************************************************
*                          graphics.library                          *
**********************************************************************

CALLGFX	MACRO
	move.l	_GfxBase,a6
	jsr	_LVO\1(a6)
	ENDM

GFXNAME	MACRO
	dc.b	'graphics.library',0
	even
	ENDM

_LVOBltBitMap			EQU -30
_LVOBltTemplate			EQU -36
_LVOClearEOL			EQU -42
_LVOClearScreen			EQU -48
_LVOTextLength			EQU -54
_LVOText			EQU -60
_LVOSetFont			EQU -66
_LVOOpenFont			EQU -72
_LVOCloseFont			EQU -78
_LVOAskSoftStyle		EQU -84
_LVOSetSoftStyle		EQU -90
_LVOAddBob			EQU -96
_LVOAddVSprite			EQU -102
_LVODoCollision			EQU -108
_LVODrawGList			EQU -114
_LVOInitGels			EQU -120
_LVOInitMasks			EQU -126
_LVORemIBob			EQU -132
_LVORemVSprite			EQU -138
_LVOSetCollision		EQU -144
_LVOSortGList			EQU -150
_LVOAddAnimOb			EQU -156
_LVOAnimate			EQU -162
_LVOGetGBuffers			EQU -168
_LVOInitGMasks			EQU -174
_LVODrawEllipse			EQU -180
_LVOAreaEllipse			EQU -186
_LVOLoadRGB4			EQU -192
_LVOInitRastPort		EQU -198
_LVOInitVPort			EQU -204
_LVOMrgCop			EQU -210
_LVOMakeVPort			EQU -216
_LVOLoadView			EQU -222
_LVOWaitBlit			EQU -228
_LVOSetRast			EQU -234
_LVOMove			EQU -240
_LVODraw			EQU -246
_LVOAreaMove			EQU -252
_LVOAreaDraw			EQU -258
_LVOAreaEnd			EQU -264
_LVOWaitTOF			EQU -270
_LVOQBlit			EQU -276
_LVOInitArea			EQU -282
_LVOSetRGB4			EQU -288
_LVOQBSBlit			EQU -294
_LVOBltClear			EQU -300
_LVORectFill			EQU -306
_LVOBltPattern			EQU -312
_LVOReadPixel			EQU -318
_LVOWritePixel			EQU -324
_LVOFlood			EQU -330
_LVOPolyDraw			EQU -336
_LVOSetAPen			EQU -342
_LVOSetBPen			EQU -348
_LVOSetDrMd			EQU -354
_LVOInitView			EQU -360
_LVOCBump			EQU -366
_LVOCMove			EQU -372
_LVOCWait			EQU -378
_LVOVBeamPos			EQU -384
_LVOInitBitMap			EQU -390
_LVOScrollRaster		EQU -396
_LVOWaitBOVP			EQU -402
_LVOGetSprite			EQU -408
_LVOFreeSprite			EQU -414
_LVOChangeSprite		EQU -420
_LVOMoveSprite			EQU -426
_LVOLockLayerRom		EQU -432
_LVOUnlockLayerRom		EQU -438
_LVOSyncSBitMap			EQU -444
_LVOCopySBitMap			EQU -450
_LVOOwnBlitter			EQU -456
_LVODisownBlitter		EQU -462
_LVOInitTmpRas			EQU -468
_LVOAskFont			EQU -474
_LVOAddFont			EQU -480
_LVORemFont			EQU -486
_LVOAllocRaster			EQU -492
_LVOFreeRaster			EQU -498
_LVOAndRectRegion		EQU -504
_LVOOrRectRegion		EQU -510
_LVONewRegion			EQU -516
_LVOClearRectRegion		EQU -522
_LVOClearRegion			EQU -528
_LVODisposeRegion		EQU -534
_LVOFreeVPortCopLists		EQU -540
_LVOFreeCopList			EQU -546
_LVOClipBlit			EQU -552
_LVOXorRectRegion		EQU -558
_LVOFreeCprList			EQU -564
_LVOGetColorMap			EQU -570
_LVOFreeColorMap		EQU -576
_LVOGetRGB4			EQU -582
_LVOScrollVPort			EQU -588
_LVOUCopperListInit		EQU -594
_LVOFreeGBuffers		EQU -600
_LVOBltBitMapRastPort		EQU -606
_LVOOrRegionRegion		EQU -612
_LVOXorRegionRegion		EQU -618
_LVOAndRegionRegion		EQU -624
_LVOSetRGB4CM			EQU -630
_LVOBltMaskBitMapRastPort	EQU -636
_LVOGfxInternal1		EQU -642
_LVOGfxInternal2		EQU -648
_LVOAttemptLockLayerRom		EQU -654
_LVOGfxNew			EQU -660
_LVOGfxFree			EQU -666
_LVOGfxAssociate		EQU -672
_LVOBitMapScale			EQU -678
_LVOScalerDiv			EQU -684
_LVOTextExtent			EQU -690
_LVOTextFit			EQU -696
_LVOGfxLookUp			EQU -702
_LVOVideoControl		EQU -708
_LVOOpenMonitor			EQU -714
_LVOCloseMonitor		EQU -720
_LVOFindDisplayInfo		EQU -726
_LVONextDisplayInfo		EQU -732
_LVOGetDisplayInfoData		EQU -756
_LVOFontExtent			EQU -762
_LVOReadPixelLine8		EQU -768
_LVOWritePixelLine8		EQU -774
_LVOReadPixelArray8		EQU -780
_LVOWritePixelArray8		EQU -786
_LVOGetVPModeID			EQU -792
_LVOModeNotAvailable		EQU -798
_LVOWeighTAMatch		EQU -804
_LVOEraseRect			EQU -810
_LVOExtendFont			EQU -816
_LVOStripFont			EQU -822
_LVOCalcIVG			EQU -828
_LVOAttachPalExtra		EQU -834
_LVOObtainBestPenA		EQU -840
_LVOGfxInternal3		EQU -846
_LVOSetRGB32			EQU -852
_LVOGetAPen			EQU -858
_LVOGetBPen			EQU -864
_LVOGetDrMd			EQU -870
_LVOGetOutlinePen		EQU -876
_LVOLoadRGB32			EQU -882
_LVOSetChipRev			EQU -888
_LVOSetABPenDrMd		EQU -894
_LVOGetRGB32			EQU -900
_LVOGfxSpare1			EQU -906
_LVOAllocBitMap			EQU -918
_LVOFreeBitMap			EQU -924
_LVOGetExtSpriteA		EQU -930
_LVOCoerceMode			EQU -936
_LVOChangeVPBitMap		EQU -942
_LVOReleasePen			EQU -948
_LVOObtainPen			EQU -954
_LVOGetBitMapAttr		EQU -960
_LVOAllocDBufInfo		EQU -966
_LVOFreeDBufInfo		EQU -972
_LVOSetOutlinePen		EQU -978
_LVOSetWriteMask		EQU -984
_LVOSetMaxPen			EQU -990
_LVOSetRGB32CM			EQU -996
_LVOScrollRasterBF		EQU -1002
_LVOFindColor			EQU -1008
_LVOGfxSpare2			EQU -1014
_LVOAllocSpriteDataA		EQU -1020
_LVOChangeExtSpriteA		EQU -1026
_LVOFreeSpriteData		EQU -1032
_LVOSetRPAttrsA			EQU -1038
_LVOGetRPAttrsA			EQU -1044
_LVOBestModeIDA			EQU -1050


**********************************************************************
*                            icon.library                            *
**********************************************************************

CALLICON	MACRO
	move.l	_IconBase,a6
	jsr	_LVO\1(a6)
	ENDM

_LVOGetIcon			EQU -42
_LVOPutIcon			EQU -48
_LVOFreeFreeList		EQU -54
_LVOAddFreeList			EQU -72
_LVOGetDiskObject		EQU -78
_LVOPutDiskObject		EQU -84
_LVOFreeDiskObject		EQU -90
_LVOFindToolType		EQU -96
_LVOMatchToolValue		EQU -102
_LVOBumpRevision		EQU -108
_LVOGetDefDiskObject		EQU -120
_LVOPutDefDiskObject		EQU -126
_LVOGetDiskObjectNew		EQU -132
_LVODeleteDiskObject		EQU -138


**********************************************************************
*                          iffparse.library                          *
**********************************************************************

CALLIFFPARSE	MACRO
	move.l	_IFFParseBase,a6
	jsr	_LVO\1(a6)
	ENDM

IFFPARSENAME	MACRO
	dc.b	'iffparse.library',0
	even
	ENDM

_LVOAllocIFF			EQU -30
_LVOOpenIFF			EQU -36
_LVOParseIFF			EQU -42
_LVOCloseIFF			EQU -48
_LVOFreeIFF			EQU -54
_LVOReadChunkBytes		EQU -60
_LVOWriteChunkBytes		EQU -66
_LVOReadChunkRecords		EQU -72
_LVOWriteChunkRecords		EQU -78
_LVOPushChunk			EQU -84
_LVOPopChunk			EQU -90
_LVOEntryHandler		EQU -102
_LVOExitHandler			EQU -108
_LVOPropChunk			EQU -114
_LVOPropChunks			EQU -120
_LVOStopChunk			EQU -126
_LVOStopChunks			EQU -132
_LVOCollectionChunk		EQU -138
_LVOCollectionChunks		EQU -144
_LVOStopOnExit			EQU -150
_LVOFindProp			EQU -156
_LVOFindCollection		EQU -162
_LVOFindPropContext		EQU -168
_LVOCurrentChunk		EQU -174
_LVOParentChunk			EQU -180
_LVOAllocLocalItem		EQU -186
_LVOLocalItemData		EQU -192
_LVOSetLocalItemPurge		EQU -198
_LVOFreeLocalItem		EQU -204
_LVOFindLocalItem		EQU -210
_LVOStoreLocalItem		EQU -216
_LVOStoreItemInContext		EQU -222
_LVOInitIFF			EQU -228
_LVOInitIFFasDOS		EQU -234
_LVOInitIFFasClip		EQU -240
_LVOOpenClipboard		EQU -246
_LVOCloseClipboard		EQU -252
_LVOGoodID			EQU -258
_LVOGoodType			EQU -264
_LVOIDtoStr			EQU -270


**********************************************************************
*                         intuition.library                          *
**********************************************************************

CALLINT	MACRO
	move.l	_IntuitionBase,a6
	jsr	_LVO\1(a6)
	ENDM

INTNAME	MACRO
	dc.b	'intuition.library',0
	even
	ENDM

_LVOOpenIntuition		EQU -30
_LVOIntuition			EQU -36
_LVOAddGadget			EQU -42
_LVOClearDMRequest		EQU -48
_LVOClearMenuStrip		EQU -54
_LVOClearPointer		EQU -60
_LVOCloseScreen			EQU -66
_LVOCloseWindow			EQU -72
_LVOCloseWorkBench		EQU -78
_LVOCurrentTime			EQU -84
_LVODisplayAlert		EQU -90
_LVODisplayBeep			EQU -96
_LVODoubleClick			EQU -102
_LVODrawBorder			EQU -108
_LVODrawImage			EQU -114
_LVOEndRequest			EQU -120
_LVOGetDefPrefs			EQU -126
_LVOGetPrefs			EQU -132
_LVOInitRequester		EQU -138
_LVOItemAddress			EQU -144
_LVOModifyIDCMP			EQU -150
_LVOModifyProp			EQU -156
_LVOMoveScreen			EQU -162
_LVOMoveWindow			EQU -168
_LVOOffGadget			EQU -174
_LVOOffMenu			EQU -180
_LVOOnGadget			EQU -186
_LVOOnMenu			EQU -192
_LVOOpenScreen			EQU -198
_LVOOpenWindow			EQU -204
_LVOOpenWorkBench		EQU -210
_LVOPrintIText			EQU -216
_LVORefreshGadgets		EQU -222
_LVORemoveGadget		EQU -228
_LVOReportMouse			EQU -234
_LVORequest			EQU -240
_LVOScreenToBack		EQU -246
_LVOScreenToFront		EQU -252
_LVOSetDMRequest		EQU -258
_LVOSetMenuStrip		EQU -264
_LVOSetPointer			EQU -270
_LVOSetWindowTitles		EQU -276
_LVOShowTitle			EQU -282
_LVOSizeWindow			EQU -288
_LVOViewAddress			EQU -294
_LVOViewPortAddress		EQU -300
_LVOWindowToBack		EQU -306
_LVOWindowToFront		EQU -312
_LVOWindowLimits		EQU -318
_LVOSetPrefs			EQU -324
_LVOIntuiTextLength		EQU -330
_LVOWBenchToBack		EQU -336
_LVOWBenchToFront		EQU -342
_LVOAutoRequest			EQU -348
_LVOBeginRefresh		EQU -354
_LVOBuildSysRequest		EQU -360
_LVOEndRefresh			EQU -366
_LVOFreeSysRequest		EQU -372
_LVOMakeScreen			EQU -378
_LVORemakeDisplay		EQU -384
_LVORethinkDisplay		EQU -390
_LVOAllocRemember		EQU -396
_LVOAlohaWorkbench		EQU -402
_LVOFreeRemember		EQU -408
_LVOLockIBase			EQU -414
_LVOUnlockIBase			EQU -420
_LVOGetScreenData		EQU -426
_LVORefreshGList		EQU -432
_LVOAddGList			EQU -438
_LVORemoveGList			EQU -444
_LVOActivateWindow		EQU -450
_LVORefreshWindowFrame		EQU -456
_LVOActivateGadget		EQU -462
_LVONewModifyProp		EQU -468
_LVOQueryOverscan		EQU -474
_LVOMoveWindowInFrontOf		EQU -480
_LVOChangeWindowBox		EQU -486
_LVOSetEditHook			EQU -492
_LVOSetMouseQueue		EQU -498
_LVOZipWindow			EQU -504
_LVOLockPubScreen		EQU -510
_LVOUnlockPubScreen		EQU -516
_LVOLockPubScreenList		EQU -522
_LVOUnlockPubScreenList		EQU -528
_LVONextPubScreen		EQU -534
_LVOSetDefaultPubScreen		EQU -540
_LVOSetPubScreenModes		EQU -546
_LVOPubScreenStatus		EQU -552
_LVOObtainGIRPort		EQU -558
_LVOReleaseGIRPort		EQU -564
_LVOGadgetMouse			EQU -570
_LVOGetDefaultPubScreen		EQU -582
_LVOEasyRequestArgs		EQU -588
_LVOBuildEasyRequestArgs	EQU -594
_LVOSysReqHandler		EQU -600
_LVOOpenWindowTagList		EQU -606
_LVOOpenScreenTagList		EQU -612
_LVODrawImageState		EQU -618
_LVOPointInImage		EQU -624
_LVOEraseImage			EQU -630
_LVONewObjectA			EQU -636
_LVODisposeObject		EQU -642
_LVOSetAttrsA			EQU -648
_LVOGetAttr			EQU -654
_LVOSetGadgetAttrsA		EQU -660
_LVONextObject			EQU -666
_LVOMakeClass			EQU -678
_LVOAddClass			EQU -684
_LVOGetScreenDrawInfo		EQU -690
_LVOFreeScreenDrawInfo		EQU -696
_LVOResetMenuStrip		EQU -702
_LVORemoveClass			EQU -708
_LVOFreeClass			EQU -714
_LVOAllocScreenBuffer		EQU -768
_LVOFreeScreenBuffer		EQU -774
_LVOChangeScreenBuffer		EQU -780
_LVOScreenDepth			EQU -786
_LVOScreenPosition		EQU -792
_LVOScrollWindowRaster		EQU -798
_LVOLendMenus			EQU -804
_LVODoGadgetMethodA		EQU -810
_LVOSetWindowPointerA		EQU -816
_LVOTimedDisplayAlert		EQU -822
_LVOHelpControl			EQU -828


**********************************************************************
*                           keymap.library                           *
**********************************************************************

CALLKEY	MACRO
	move.l	_KeymapBase,a6
	jsr	_LVO\1(a6)
	ENDM

KEYNAME	MACRO
	dc.b	'keymap.library',0
	even
	ENDM

_LVOSetKeyMapDefault		EQU -30
_LVOAskKeyMapDefault		EQU -36
_LVOMapRawKey			EQU -42
_LVOMapANSI			EQU -48


**********************************************************************
*                           locale.library                           *
**********************************************************************

CALLLOCALE	MACRO
	move.l	_LocaleBase,a6
	jsr	_LVO\1(a6)
	ENDM

LOCALENAME	MACRO
	dc.b	'locale.library',0
	even
	ENDM

_LVOCloseCatalog		EQU -36
_LVOCloseLocale			EQU -42
_LVOConvToLower			EQU -48
_LVOConvToUpper			EQU -54
_LVOFormatDate			EQU -60
_LVOFormatString		EQU -66
_LVOGetCatalogStr		EQU -72
_LVOGetLocaleStr		EQU -78
_LVOIsAlNum			EQU -84
_LVOIsAlpha			EQU -90
_LVOIsCntrl			EQU -96
_LVOIsDigit			EQU -102
_LVOIsGraph			EQU -108
_LVOIsLower			EQU -114
_LVOIsPrint			EQU -120
_LVOIsPunct			EQU -126
_LVOIsSpace			EQU -132
_LVOIsUpper			EQU -138
_LVOIsXDigit			EQU -144
_LVOOpenCatalogA		EQU -150
_LVOOpenLocale			EQU -156
_LVOParseDate			EQU -162
_LVOStrConvert			EQU -174
_LVOStrnCmp			EQU -180


**********************************************************************
*                           layers.library                           *
**********************************************************************

CALLLAYERS	MACRO
	move.l	_LayersBase,a6
	jsr	_LVO\1(a6)
	ENDM

LAYERSNAME	MACRO
	dc.b	'layers.library',0
	even
	ENDM

_LVOInitLayers			EQU -30
_LVOCreateUpfrontLayer		EQU -36
_LVOCreateBehindLayer		EQU -42
_LVOUpfrontLayer		EQU -48
_LVOBehindLayer			EQU -54
_LVOMoveLayer			EQU -60
_LVOSizeLayer			EQU -66
_LVOScrollLayer			EQU -72
_LVOBeginUpdate			EQU -78
_LVOEndUpdate			EQU -84
_LVODeleteLayer			EQU -90
_LVOLockLayer			EQU -96
_LVOUnlockLayer			EQU -102
_LVOLockLayers			EQU -108
_LVOUnlockLayers		EQU -114
_LVOLockLayerInfo		EQU -120
_LVOSwapBitsRastPortClipRect	EQU -126
_LVOWhichLayer			EQU -132
_LVOUnlockLayerInfo		EQU -138
_LVONewLayerInfo		EQU -144
_LVODisposeLayerInfo		EQU -150
_LVOFattenLayerInfo		EQU -156
_LVOThinLayerInfo		EQU -162
_LVOMoveLayerInFrontOf		EQU -168
_LVOInstallClipRegion		EQU -174
_LVOMoveSizeLayer		EQU -180
_LVOCreateUpfrontHookLayer	EQU -186
_LVOCreateBehindHookLayer	EQU -192
_LVOInstallLayerHook		EQU -198
_LVOInstallLayerInfoHook	EQU -204
_LVOSortLayerCR			EQU -210
_LVODoHookClipRects		EQU -216


**********************************************************************
*                          mathffp.library                           *
**********************************************************************

CALLFFP	MACRO
	move.l	_MathBase,a6
	jsr	_LVO\1(a6)
	ENDM

FFPNAME	MACRO
	dc.b	'mathffp.library',0
	even
	ENDM

_LVOSPFix			EQU -30
_LVOSPFlt			EQU -36
_LVOSPCmp			EQU -42
_LVOSPTst			EQU -48
_LVOSPAbs			EQU -54
_LVOSPNeg			EQU -60
_LVOSPAdd			EQU -66
_LVOSPSub			EQU -72
_LVOSPMul			EQU -78
_LVOSPDiv			EQU -84
_LVOSPFloor			EQU -90
_LVOSPCeil			EQU -96


**********************************************************************
*                      mathieeedoubbas.library                       *
**********************************************************************

CALLIEEEDB	MACRO
	move.l	_MathIeeeDoubBasBase,a6
	jsr	_LVO\1(a6)
	ENDM

IEEEDBNAME	MACRO
	dc.b	'mathieeedoubbas.library',0
	even
	ENDM

_LVOIEEEDPFix			EQU -30
_LVOIEEEDPFlt			EQU -36
_LVOIEEEDPCmp			EQU -42
_LVOIEEEDPTst			EQU -48
_LVOIEEEDPAbs			EQU -54
_LVOIEEEDPNeg			EQU -60
_LVOIEEEDPAdd			EQU -66
_LVOIEEEDPSub			EQU -72
_LVOIEEEDPMul			EQU -78
_LVOIEEEDPDiv			EQU -84
_LVOIEEEDPFloor			EQU -90
_LVOIEEEDPCeil			EQU -96


**********************************************************************
*                     mathieeedoubtrans.library                      *
**********************************************************************

CALLIEEEDT	MACRO
	move.l	_MathIeeeDoubTransBase,a6
	jsr	_LVO\1(a6)
	ENDM

IEEEDTNAME	MACRO
	dc.b	'mathieeedoubtrans.library',0
	even
	ENDM

_LVOIEEEDPAtan			EQU -30
_LVOIEEEDPSin			EQU -36
_LVOIEEEDPCos			EQU -42
_LVOIEEEDPTan			EQU -48
_LVOIEEEDPSincos		EQU -54
_LVOIEEEDPSinh			EQU -60
_LVOIEEEDPCosh			EQU -66
_LVOIEEEDPTanh			EQU -72
_LVOIEEEDPExp			EQU -78
_LVOIEEEDPLog			EQU -84
_LVOIEEEDPPow			EQU -90
_LVOIEEEDPSqrt			EQU -96
_LVOIEEEDPTieee			EQU -102
_LVOIEEEDPFieee			EQU -108
_LVOIEEEDPAsin			EQU -114
_LVOIEEEDPAcos			EQU -120
_LVOIEEEDPLog10			EQU -126


**********************************************************************
*                      mathieeesingbas.library                       *
**********************************************************************

CALLIEEESB	MACRO
	move.l	_MathIeeeSingBasBase,a6
	jsr	_LVO\1(a6)
	ENDM

IEEESBNAME	MACRO
	dc.b	'mathieeesingbas.library',0
	even
	ENDM

_LVOIEEESPFix			EQU -30
_LVOIEEESPFlt			EQU -36
_LVOIEEESPCmp			EQU -42
_LVOIEEESPTst			EQU -48
_LVOIEEESPAbs			EQU -54
_LVOIEEESPNeg			EQU -60
_LVOIEEESPAdd			EQU -66
_LVOIEEESPSub			EQU -72
_LVOIEEESPMul			EQU -78
_LVOIEEESPDiv			EQU -84
_LVOIEEESPFloor			EQU -90
_LVOIEEESPCeil			EQU -96


**********************************************************************
*                     mathieeesingtrans.library                      *
**********************************************************************

CALLIEEEST	MACRO
	move.l	_MathIeeeSingTransBase,a6
	jsr	_LVO\1(a6)
	ENDM

IEEESTNAME	MACRO
	dc.b	'mathieeesingtrans.library',0
	even
	ENDM

_LVOIEEESPAtan			EQU -30
_LVOIEEESPSin			EQU -36
_LVOIEEESPCos			EQU -42
_LVOIEEESPTan			EQU -48
_LVOIEEESPSincos		EQU -54
_LVOIEEESPSinh			EQU -60
_LVOIEEESPCosh			EQU -66
_LVOIEEESPTanh			EQU -72
_LVOIEEESPExp			EQU -78
_LVOIEEESPLog			EQU -84
_LVOIEEESPPow			EQU -90
_LVOIEEESPSqrt			EQU -96
_LVOIEEESPTieee			EQU -102
_LVOIEEESPFieee			EQU -108
_LVOIEEESPAsin			EQU -114
_LVOIEEESPAcos			EQU -120
_LVOIEEESPLog10			EQU -126


**********************************************************************
*                         mathtrans.library                          *
**********************************************************************

CALLMTRANS	MACRO
	move.l	_MathTransBase,a6
	jsr	_LVO\1(a6)
	ENDM

MTRANSNAME	MACRO
	dc.b	'mathtrans.library',0
	even
	ENDM

_LVOSPAtan			EQU -30
_LVOSPSin			EQU -36
_LVOSPCos			EQU -42
_LVOSPTan			EQU -48
_LVOSPSincos			EQU -54
_LVOSPSinh			EQU -60
_LVOSPCosh			EQU -66
_LVOSPTanh			EQU -72
_LVOSPExp			EQU -78
_LVOSPLog			EQU -84
_LVOSPPow			EQU -90
_LVOSPSqrt			EQU -96
_LVOSPTieee			EQU -102
_LVOSPFieee			EQU -108
_LVOSPAsin			EQU -114
_LVOSPAcos			EQU -120
_LVOSPLog10			EQU -126


**********************************************************************
*                        powerpacker.library                         *
**********************************************************************

CALLPP	MACRO
	move.l	_PPBase,a6
	jsr	_LVO\1(a6)
	ENDM


**********************************************************************
*                            req.library                             *
**********************************************************************

CALLREQ MACRO
	move.l	_ReqBase,a6
	jsr	_LVO\1(a6)
	ENDM


**********************************************************************
*                         rexxsyslib.library                         *
**********************************************************************

CALLRXS	MACRO
	move.l	_RexxSysBase,a6
	jsr	_LVO\1(a6)
	ENDM


**********************************************************************
*                         translator.library                         *
**********************************************************************

CALLTRANSLATOR	MACRO
	move.l	_TranslatorBase,a6
	jsr	_LVO\1(a6)
	ENDM

TRANSLATORNAME	MACRO
	dc.b	'translator.library',0
	even
	ENDM

_LVOTranslate			EQU -30


**********************************************************************
*                          utility.library                           *
**********************************************************************

CALLUTIL	MACRO
	move.l	_UtilityBase,a6
	jsr	_LVO\1(a6)
	ENDM

_LVOFindTagItem			EQU -30
_LVOGetTagData			EQU -36
_LVOPackBoolTags		EQU -42
_LVONextTagItem			EQU -48
_LVOFilterTagChanges		EQU -54
_LVOMapTags			EQU -60
_LVOAllocateTagItems		EQU -66
_LVOCloneTagItems		EQU -72
_LVOFreeTagItems		EQU -78
_LVORefreshTagItemClones	EQU -84
_LVOTagInArray			EQU -90
_LVOFilterTagItems		EQU -96
_LVOCallHookPkt			EQU -102
_LVOAmiga2Date			EQU -120
_LVODate2Amiga			EQU -126
_LVOCheckDate			EQU -132
_LVOSMult32			EQU -138
_LVOUMult32			EQU -144
_LVOSDivMod32			EQU -150
_LVOUDivMod32			EQU -156
_LVOStricmp			EQU -162
_LVOStrnicmp			EQU -168
_LVOToUpper			EQU -174
_LVOToLower			EQU -180
_LVOApplyTagChanges		EQU -186
_LVOSMult64			EQU -198
_LVOUMult64			EQU -204
_LVOPackStructureTags		EQU -210
_LVOUnpackStructureTags		EQU -216
_LVOAddNamedObject		EQU -222
_LVOAllocNamedObjectA		EQU -228
_LVOAttemptRemNamedObject	EQU -234
_LVOFindNamedObject		EQU -240
_LVOFreeNamedObject		EQU -246
_LVONamedObjectName		EQU -252
_LVOReleaseNamedObject		EQU -258
_LVORemNamedObject		EQU -264
_LVOGetUniqueID			EQU -270


**********************************************************************
*                         workbench.library                          *
**********************************************************************

CALLWB	MACRO
	move.l	_WorkbenchBase,a6
	jsr	_LVO\1(a6)
	ENDM

_LVOAddAppWindowA		EQU -48
_LVORemoveAppWindow		EQU -54
_LVOAddAppIconA			EQU -60
_LVORemoveAppIcon		EQU -66
_LVOAddAppMenuItemA		EQU -72
_LVORemoveAppMenuItem		EQU -78
_LVOWBInfo			EQU -90


**********************************************************************
*                         xplmaster.library                          *
**********************************************************************

CALLXPL	MACRO
	move.l	_XplBase,a6
	jsr	_LVO\1(a6)
	ENDM


**********************************************************************
*                         xpkmaster.library                          *
**********************************************************************

CALLXPK	MACRO
	move.l	_XpkBase,a6
	jsr	_LVO\1(a6)
	ENDM


;---------------------------------------------------------------------
;
;	Devices
;

**********************************************************************
*                           console.device                           *
**********************************************************************

CONNAME	MACRO
	dc.b	'console.device',0
	even
	ENDM

_LVOCDInputHandler		EQU -42
_LVORawKeyConvert		EQU -48


**********************************************************************
*                            input.device                            *
**********************************************************************

INPUTNAME	MACRO
	dc.b	'input.device',0
	even
	ENDM

_LVOPeekQualifier		EQU -42


**********************************************************************
*                          ramdrive.device                           *
**********************************************************************

RAMDRIVENAME	MACRO
	dc.b	'ramdrive.device',0
	even
	ENDM

_LVOKillRAD0			EQU -42
_LVOKillRAD			EQU -48


**********************************************************************
*                            timer.device                            *
**********************************************************************

CALLTIMER	MACRO
	move.l	\1+IO_DEVICE,a6
	jsr	_LVO\2(a6)
	ENDM

_LVOAddTime			EQU -42
_LVOSubTime			EQU -48
_LVOCmpTime			EQU -54
_LVOReadEClock			EQU -60
_LVOGetSysTime			EQU -66


;---------------------------------------------------------------------
;
;	Resources
;

**********************************************************************
*                         battclock.resource                         *
**********************************************************************

CALLBATTCLOCK	MACRO
	move.l	_BattClockBase,a6
	jsr	_LVO\1(a6)
	ENDM

_LVOResetBattClock		EQU -6
_LVOReadBattClock		EQU -12
_LVOWriteBattClock		EQU -18


**********************************************************************
*                          battmem.resource                          *
**********************************************************************

CALLBATTMEM	MACRO
	move.l	_BattMemBase,a6
	jsr	_LVO\1(a6)
	ENDM

_LVOObtainBattSemaphore		EQU -6
_LVOReleaseBattSemaphore	EQU -12
_LVOReadBattMem			EQU -18
_LVOWriteBattMem		EQU -24


**********************************************************************
*                          cardres.resource                          *
**********************************************************************

CALLCARD	MACRO
	move.l	_CardResource,a6
	jsr	_LVO\1(a6)
	ENDM

_LVOOwnCard			EQU -6
_LVOReleaseCard			EQU -12
_LVOGetCardMap			EQU -18
_LVOBeginCardAccess		EQU -24
_LVOEndCardAccess		EQU -30
_LVOReadCardStatus		EQU -36
_LVOCardResetRemove		EQU -42
_LVOCardMiscControl		EQU -48
_LVOCardAccessSpeed		EQU -54
_LVOCardProgramVoltage		EQU -60
_LVOCardResetCard		EQU -66
_LVOCopyTuple			EQU -72
_LVODeviceTuple			EQU -78
_LVOIfAmigaXIP			EQU -84
_LVOCardForceChange		EQU -90
_LVOCardChangeCount		EQU -96
_LVOCardInterface		EQU -102


**********************************************************************
*                  ciaa.resource and ciab.resource                   *
**********************************************************************

CALLCIAA	MACRO
	move.l	_CIAABase,a6
	jsr	_LVO\1(a6)
	ENDM

CALLCIAB	MACRO
	move.l	_CIABBase,a6
	jsr	_LVO\1(a6)
	ENDM

_LVOAddICRVector		EQU -6
_LVORemICRVector		EQU -12
_LVOAbleICR			EQU -18
_LVOSetICR			EQU -24


**********************************************************************
*                           disk.resource                            *
**********************************************************************

CALLDISK	MACRO
	move.l	_DiskBase,a6
	jsr	_LVO\1(a6)
	ENDM

_LVOAllocUnit			EQU -6
_LVOFreeUnit			EQU -12
_LVOGetUnit			EQU -18
_LVOGiveUnit			EQU -24
_LVOGetUnitID			EQU -30
_LVOReadUnitID			EQU -36


**********************************************************************
*                           misc.resource                            *
**********************************************************************

CALLMISC	MACRO
	move.l	_MiscBase,a6
	jsr	_LVO\1(a6)
	ENDM

_LVOAllocMiscResource		EQU -6
_LVOFreeMiscResource		EQU -12


**********************************************************************
*                           potgo.resource                           *
**********************************************************************

CALLPOTGO	MACRO
	move.l	_PotgoBase,a6
	jsr	_LVO\1(a6)
	ENDM

_LVOAllocPotBits		EQU -6
_LVOFreePotBits			EQU -12
_LVOWritePotgo			EQU -18


	ENDC	; DEVPACMACROS_I

