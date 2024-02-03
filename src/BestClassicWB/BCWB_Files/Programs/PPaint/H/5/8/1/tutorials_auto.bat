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

PPaintCD:H/2/CheckVideo -anim -pal
If WARN
  PPaintCD:H/2/CheckVideo -anim -256
  If WARN
    Type > T:pprx_slideshow.list PPaintCD:H/5/8/3/tutorials_ntsc_16-32.list
  Else
    Type > T:pprx_slideshow.list PPaintCD:H/5/8/3/tutorials_ntsc_256.list
  EndIf
Else
  PPaintCD:H/2/CheckVideo -anim -256
  If WARN
    Type > T:pprx_slideshow.list PPaintCD:H/5/8/3/tutorials_pal_16-32.list
  Else
    Type > T:pprx_slideshow.list PPaintCD:H/5/8/3/tutorials_pal_256.list
  EndIf
EndIf

PPaintCD:H/2/RunIcon PPaintCD:Rexx/Slideshow.pprx
