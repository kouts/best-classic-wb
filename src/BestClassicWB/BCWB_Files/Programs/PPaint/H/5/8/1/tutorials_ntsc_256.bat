.k ""
.bra {
.ket }

If EXISTS PPaintCD:PPaint
  Assign >NIL: PPAINT: EXISTS
  If WARN
    Assign PPAINT: PPaintCD:
  Else
    Assign >NIL: PCDPPAINT: EXISTS
    If WARN
      Assign PCDPPAINT: PPAINT:
    EndIf
    If NOT EXISTS PPAINT:AnimBrushes
      Assign PPAINT: PPaintCD:
    EndIf
  EndIf
EndIf

Type > T:pprx_slideshow.list PPaintCD:H/5/8/3/tutorials_ntsc_256.list

PPaintCD:H/2/RunIcon PPaintCD:Rexx/Slideshow.pprx
