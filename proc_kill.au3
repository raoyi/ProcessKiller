#Region ;**** 参数创建于 ACNWrapper_GUI ****
#PRE_icon=C:\Windows\system32\SHELL32.dll|-240
#PRE_Outfile=C:\Users\Administrator\Desktop\CPUCt.exe
#PRE_Res_requestedExecutionLevel=None
#PRE_Add_Constants=y
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
#include <GUIConstantsEx.au3>
 #include <WindowsConstants.au3>
 #include <ProgressConstants.au3>

 Global $IDLETIME, $KERNELTIME, $USERTIME
 Global $StartIdle, $StartKernel, $StartUser
 Global $EndIdle, $EndKernel, $EndUser
 Global $Timer

 $IDLETIME   = DllStructCreate("dword;dword")
 $KERNELTIME = DllStructCreate("dword;dword")
 $USERTIME   = DllStructCreate("dword;dword")
 
 Global $i1
 Global $i2
 
If $cmdline[0] = 0 Then
	MsgBox(64,"Error","使用方法如下："& @LF & _
						"格式：CPUCt.exe 参数1 参数2" & @LF & _
						"参数1：CPU限制值" & @LF & _
						"参数2：禁用进行名"  & @LF & _
						"例如：CPUCt.exe 50 notepad.exe"  & @LF & _
						"如果需要退出请，使用组合键Shift+Alt+Q")
	Exit 1
Else
	$i1 = $cmdline[1]
	$i2 = $cmdline[2]
EndIf

 HotKeySet("+!q", "Quit")

 Opt("GUIOnEventMode",1)
 $hGUI = GUICreate("CPUmon", 200, 100, @DesktopWidth-210, @DesktopHeight-140, 0x80800000);, $WS_EX_TOPMOST)
 GUISetBkColor(0x000000)
 GUISetOnEvent(-3,"Quit")


 GUICtrlCreateGraphic(0,0,200,100)
 GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x008040)
 For $y=25 To 75 Step 25
         GUICtrlSetGraphic(-1, $GUI_GR_MOVE,0,$y)
         GUICtrlSetGraphic(-1, $GUI_GR_LINE, 200, $y)
 Next
 For $x=25 To 175 Step 25
         GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $x, 0)
         GUICtrlSetGraphic(-1, $GUI_GR_LINE, $x, 100)
 Next

 $gr = GUICtrlCreateGraphic(0,0,210,100)

 $lb=GUICtrlCreateLabel("",0,0,25,25)
 GUICtrlSetColor(-1,0x00FF00)

 GUISetState()

 GUICtrlSetGraphic($gr, $GUI_GR_COLOR, 0x00FF00)


 $x=0
 $y=0
 $dx=200
 $dy=100
GUICtrlSetGraphic($gr, $GUI_GR_MOVE,$dx,$dy)
 
         
 While 1
         $rCPU = _TimerProc()
         GUICtrlSetData($lb,$rCPU&"%")
         $dx += 2
         $dy = 100-$rCPU
         GUICtrlSetGraphic($gr, $GUI_GR_LINE, $dx, $dy)
         GUICtrlSetGraphic($gr, $GUI_GR_REFRESH)
         $x -= 2
         GUICtrlSetPos($gr, $x, $y)
		 If $rCPU > $i1 Then
			 ProcessClose($i2)
		 EndIf
         Sleep(1000)
 WEnd

 While 1
     $msg = GUIGetMsg()
     Switch $msg
         Case $GUI_EVENT_CLOSE
             ExitLoop
     EndSwitch
 WEnd

 Func _TimerProc()
     _GetSysTime($EndIdle, $EndKernel, $EndUser)
     $res = _CPUCalc()
     _GetSysTime($StartIdle, $StartKernel, $StartUser)
         Return $res
 EndFunc

 Func _GetSysTime(ByRef $sIdle, ByRef $sKernel, ByRef $sUser)
     DllCall("kernel32.dll", "int", "GetSystemTimes", "ptr", DllStructGetPtr($IDLETIME), _
             "ptr", DllStructGetPtr($KERNELTIME), _
             "ptr", DllStructGetPtr($USERTIME))

     $sIdle = DllStructGetData($IDLETIME, 1)
     $sKernel = DllStructGetData($KERNELTIME, 1)
     $sUser = DllStructGetData($USERTIME, 1)
 EndFunc   ;==>_GetSysTime

 Func _CPUCalc()
     Local $iSystemTime, $iTotal, $iCalcIdle, $iCalcKernel, $iCalcUser
     
     $iCalcIdle   = ($EndIdle - $StartIdle)
     $iCalcKernel = ($EndKernel - $StartKernel)
     $iCalcUser   = ($EndUser - $StartUser)
     
     $iSystemTime = ($iCalcKernel + $iCalcUser)
     $iTotal = Int(($iSystemTime - $iCalcIdle) * (100 / $iSystemTime))
     Return $iTotal
 EndFunc

 func Quit()
         Exit
 EndFunc
