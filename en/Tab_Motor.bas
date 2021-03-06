

Const MOTOR_CONVEYOR = 4
Const MOTOR_SHUTTLE = 2
Const MOTOR_WIDTH_ADJ = 3

Const MOTOR_WA_LIM_L = 300
Const MOTOR_WA_LIM_H = 700
Const MOTOR_S_LIM_L = 500
Const MOTOR_S_LIM_H = 1200
Const MOTOR_C_LIM_L = 100
Const MOTOR_C_LIM_H = 300

'-------------------------------------------------------
' Init Windows
'-------------------------------------------------------

Sub Init_WindowMotor( )
DebugMessage "Init Motor Window"
Visual.Select("text_belt_currforward").ReadOnly = True
Visual.Select("text_belt_currbackward").ReadOnly = True
Visual.Select("text_shuttle_currmax").ReadOnly = True
Visual.Select("text_shuttle_currforward").ReadOnly = True
Visual.Select("text_shuttle_currbackward").ReadOnly = True
Visual.Select("text_WA_currmax").ReadOnly = True
Visual.Select("text_WA_currforward").ReadOnly = True
Visual.Select("text_WA_currbackward").ReadOnly = True

Visual.Select("input_shuttle_position").value = "100000"
Visual.Select("input_WA_position").value = "100000"

Visual.Select("row_WA_currmax").style.display = "none"
Visual.Select("row_shuttle_currmax").style.display = "none"
Visual.Select("frame_beltmotor").style.display = "none"
'Visual.Select("btn_belt_checkcurr").style.display = "none"
'Visual.Select("btn_WA_checkcurr").style.display = "none"
'Visual.Select("btn_shuttle_checkcurr").style.display = "none"
Visual.Select("btn_checkcurr").style.display = "none"
Visual.Select("frame_currentcheck").style.display = "none"

End Sub


'-------------------------------------------------------
' On Click Events
'-------------------------------------------------------


Function OnClick_btn_shuttle_calibrate( Reason )
LogAdd "Shuttle Motor calibrate"
Command_Prepare_MotorCalibrate( MOTOR_SHUTTLE )
End Function

'-------------------------------------------------------

Function OnClick_btn_shuttle_refrun( Reason )
LogAdd "Shuttle Motor reference run"
Command_Prepare_MotorReference( MOTOR_SHUTTLE )
End Function

'-------------------------------------------------------

Function OnClick_btn_shuttle_mvtopos( Reason )
  Dim Rail
  
  Rail = Visual.Select("opt_Sfixedrail").SelectedItemAttribute("value")
  If CheckSValue(Visual.Select("input_shuttle_position").Value) Then
    LogAdd "Shuttle Motor Move to position"
    
    Command_Prepare_ShuttlePosition Visual.Select("input_shuttle_position").Value,1,Rail
  Else
    LogAdd "Shuttle Motor Move to position failed!"
  End If
End Function


'-------------------------------------------------------
' Check Current Functions

Function OnClick_btn_belt_checkcurr( Reason )
  Dim CanReadArg, looping
  Dim Curr_Forw, Curr_Back, Count
  Dim CanManager, MyCanSendArg, MyCanReadArg
  looping = 1  
  Set CanReadArg =  CreateObject("ICAN.CanReadArg")
  LogAdd "Belt Motor check current started"
  If Command_Prepare_MotorCurrent( MOTOR_CONVEYOR ) = 1 Then
    Command_Get_Param CanReadArg , $(PAR_CONV_CURRENT_FORW)
    Curr_Forw = Lang.MakeLong4(CanReadArg.Data(4),CanReadArg.Data(5),CanReadArg.Data(6),CanReadArg.Data(7))
    ValidateCurrent MOTOR_CONVEYOR,Curr_Forw,"text_belt_currforward"
    
    Command_Get_Param CanReadArg , $(PAR_CONV_CURRENT_BACKW)
    Curr_Back = Lang.MakeLong4(CanReadArg.Data(4),CanReadArg.Data(5),CanReadArg.Data(6),CanReadArg.Data(7))
    ValidateCurrent MOTOR_CONVEYOR,Curr_Back,"text_belt_currbackward"    
  Else
    Visual.Select("text_belt_currforward").value = "-"
    Visual.Select("text_belt_currbackward").value = "-"
  End If
  
End Function

'-------------------------------------------------------

Function OnClick_btn_shuttle_checkcurr( Reason )
  Dim CanReadArg
  Dim Curr_Forw, Curr_Back
  Set CanReadArg =  CreateObject("ICAN.CanReadArg")
  LogAdd "Shuttle Motor check current started"  
  If Command_Prepare_MotorCurrent( MOTOR_SHUTTLE ) = 1 Then
  Command_Get_Param CanReadArg , $(PAR_SHUTTLE_CURRENT_FORW)
  Curr_Forw = Lang.MakeLong4(CanReadArg.Data(4),CanReadArg.Data(5),CanReadArg.Data(6),CanReadArg.Data(7))
  ValidateCurrent MOTOR_SHUTTLE,Curr_Forw,"text_shuttle_currforward"    
  
  Command_Get_Param CanReadArg , $(PAR_SHUTTLE_CURRENT_BACKW)
  Curr_Back = Lang.MakeLong4(CanReadArg.Data(4),CanReadArg.Data(5),CanReadArg.Data(6),CanReadArg.Data(7))
  ValidateCurrent MOTOR_SHUTTLE,Curr_Back,"text_shuttle_currbackward"    
  
  Else
    Visual.Select("text_shuttle_currforward").value = "-"
    Visual.Select("text_shuttle_currbackward").value = "-"
  End If
End Function

'-------------------------------------------------------

Function OnClick_btn_WA_checkcurr( Reason )

  Dim CanReadArg
  Dim Curr_Forw, Curr_Back
  Set CanReadArg =  CreateObject("ICAN.CanReadArg")
  LogAdd "Width Adjustment check current started"
  If Command_Prepare_MotorCurrent( MOTOR_WIDTH_ADJ ) = 1 Then
    Command_Get_Param CanReadArg , $(PAR_WA_CURRENT_FORW)
    Curr_Forw = Lang.MakeLong4(CanReadArg.Data(4),CanReadArg.Data(5),CanReadArg.Data(6),CanReadArg.Data(7))
    ValidateCurrent MOTOR_WIDTH_ADJ,Curr_Forw,"text_WA_currforward"    
    
    Command_Get_Param CanReadArg , $(PAR_WA_CURRENT_BACKW)
    Curr_Back = Lang.MakeLong4(CanReadArg.Data(4),CanReadArg.Data(5),CanReadArg.Data(6),CanReadArg.Data(7))
    ValidateCurrent MOTOR_WIDTH_ADJ,Curr_Back,"text_WA_currbackward"    
  Else
    Visual.Select("text_WA_currforward").value = "-"
    Visual.Select("text_WA_currbackward").value = "-"
  End If
End Function

'-------------------------------------------------------

Function OnClick_btn_checkcurr( Reason )

  Dim CanReadArg
  Dim Curr_Forw, Curr_Back
  Set CanReadArg =  CreateObject("ICAN.CanReadArg")
  LogAdd "Shuttle check current"
  Command_Prepare_MotorCurrent( MOTOR_SHUTTLE ) 
  
  'Width Adjust
  Command_Get_Param CanReadArg , $(PAR_WA_CURRENT_FORW)
  Curr_Forw = Lang.MakeLong4(CanReadArg.Data(4),CanReadArg.Data(5),CanReadArg.Data(6),CanReadArg.Data(7))
  ValidateCurrent MOTOR_WIDTH_ADJ,Curr_Forw,"text_WA_currforward"    
  Command_Get_Param CanReadArg , $(PAR_WA_CURRENT_BACKW)
  Curr_Back = Lang.MakeLong4(CanReadArg.Data(4),CanReadArg.Data(5),CanReadArg.Data(6),CanReadArg.Data(7))
  ValidateCurrent MOTOR_WIDTH_ADJ,Curr_Back,"text_WA_currbackward"    
  
  'shuttle
  Command_Get_Param CanReadArg , $(PAR_SHUTTLE_CURRENT_FORW)
  Curr_Forw = Lang.MakeLong4(CanReadArg.Data(4),CanReadArg.Data(5),CanReadArg.Data(6),CanReadArg.Data(7))
  ValidateCurrent MOTOR_SHUTTLE,Curr_Forw,"text_shuttle_currforward"    
  Command_Get_Param CanReadArg , $(PAR_SHUTTLE_CURRENT_BACKW)
  Curr_Back = Lang.MakeLong4(CanReadArg.Data(4),CanReadArg.Data(5),CanReadArg.Data(6),CanReadArg.Data(7))
  ValidateCurrent MOTOR_SHUTTLE,Curr_Back,"text_shuttle_currbackward"    

  'belt
  Command_Get_Param CanReadArg , $(PAR_CONV_CURRENT_FORW)
  Curr_Forw = Lang.MakeLong4(CanReadArg.Data(4),CanReadArg.Data(5),CanReadArg.Data(6),CanReadArg.Data(7))
  ValidateCurrent MOTOR_CONVEYOR,Curr_Forw,"text_belt_currforward"
  Command_Get_Param CanReadArg , $(PAR_CONV_CURRENT_BACKW)
  Curr_Back = Lang.MakeLong4(CanReadArg.Data(4),CanReadArg.Data(5),CanReadArg.Data(6),CanReadArg.Data(7))
  ValidateCurrent MOTOR_CONVEYOR,Curr_Back,"text_belt_currbackward"    
End Function

'-------------------------------------------------------
Function ValidateCurrent ( Axis , Curr , Element)
  Dim Min,Max
  'Show value
  Visual.Select(Element).value = String.Format("%d",Curr)

  Select Case Axis  
  Case MOTOR_WIDTH_ADJ:    
    Min = MOTOR_WA_LIM_L
    Max = MOTOR_WA_LIM_H
  Case MOTOR_SHUTTLE:
    Min = MOTOR_S_LIM_L
    Max = MOTOR_S_LIM_H
  Case MOTOR_CONVEYOR:
    Min = MOTOR_C_LIM_L
    Max = MOTOR_C_LIM_H  
  End Select
  
  If Curr > Min AND Curr < Max Then
     Visual.Select(Element).Style.Background = "Green"
  Else
     Visual.Select(Element).Style.Background = "Red"  
  End If
  
End Function

'-------------------------------------------------------
' Width Adjustment Motors

Function OnClick_btn_WA_calibrate( Reason )
  LogAdd "Width Adjustment Motor calibrate"
  Command_Prepare_MotorCalibrate( MOTOR_WIDTH_ADJ )
End Function

'-------------------------------------------------------

Function OnClick_btn_WA_refrun( Reason )
  LogAdd "Width Adjustment Motor reference run"
  Command_Prepare_MotorReference( MOTOR_WIDTH_ADJ )
End Function

'-------------------------------------------------------

Function OnClick_btn_WA_mvtopos( Reason )
  Dim Rail
  
  Rail = Visual.Select("opt_WAfixedrail").SelectedItemAttribute("value")
  If CheckUValue(Visual.Select("input_WA_position").Value) Then
    LogAdd "Width Adjustment Motor Move to Position"
    Command_Prepare_WidthAdjustment Visual.Select("input_WA_position").value,1,Rail
  Else
    LogAdd "Width Adjustment Motor Move to Position failed!"
  End If
End Function

'-------------------------------------------------------



'PAR_SHUTTLE_CURRENT_FORW
'PAR_SHUTTLE_CURRENT_BACKW
'PAR_WA_CURRENT_FORW
'PAR_WA_CURRENT_BACKW
'PAR_CONV_CURRENT_FORW
'PAR_CONV_CURRENT_BACKW


