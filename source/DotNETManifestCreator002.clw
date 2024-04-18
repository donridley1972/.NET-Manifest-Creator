

   MEMBER('DotNETManifestCreator.clw')                     ! This is a MEMBER module


   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('DOTNETMANIFESTCREATOR002.INC'),ONCE        !Local module procedure declarations
                     END


  
!!! <summary>
!!! Generated from procedure template - Window
!!! Form Manifests
!!! </summary>
UpdateManifest PROCEDURE 

StartPos            Long
EndPos              Long
ManifestSt          StringTheory
CurrentTab           STRING(80)                            ! 
NewOutputPath        STRING(255)                           ! 
ActionMessage        CSTRING(40)                           ! 
History::Man:Record  LIKE(Man:RECORD),THREAD
loc:AnyFontVal string(255)
QuickWindow          WINDOW('Form Manifests'),AT(,,373,194),FONT('Segoe UI',10,,FONT:regular,CHARSET:ANSI),RESIZE, |
  AUTO,CENTER,ICON('AppIconNoShadow.ico'),GRAY,IMM,HLP('UpdateManifest'),SYSTEM,WALLPAPER('ArcticBlue' & |
  'GradientBackground1600x1084.jpg')
                       BUTTON('&OK'),AT(270,176,49,14),USE(?OK),LEFT,ICON('Ok1.ico'),DEFAULT,FLAT,MSG('Accept dat' & |
  'a and close the window'),TIP('Accept data and close the window')
                       BUTTON('&Cancel'),AT(322,176,49,14),USE(?Cancel),LEFT,ICON('Cancel1.ico'),FLAT,MSG('Cancel operation'), |
  TIP('Cancel operation')
                       ENTRY(@s255),AT(62,35,286,10),USE(Man:InputPath),LEFT(2)
                       PROMPT('Description:'),AT(6,6),USE(?Man:Description:Prompt),TRN
                       ENTRY(@s100),AT(62,6,286,10),USE(Man:Description),LEFT(2)
                       PROMPT('Date Created:'),AT(6,20),USE(?Man:DateCreated:Prompt),TRN
                       ENTRY(@D12),AT(62,20,47,10),USE(Man:DateCreated),RIGHT(1)
                       PROMPT('Input Path:'),AT(6,35),USE(?Man:InputPath:Prompt),TRN
                       PROMPT('Output Path:'),AT(6,50),USE(?Man:OutputPath:Prompt),TRN
                       ENTRY(@s255),AT(62,50,286,10),USE(Man:OutputPath),LEFT(2)
                       BUTTON,AT(351,33,12,12),USE(?LookupFile),ICON('Look.ico'),FLAT,TRN
                       BUTTON,AT(351,48,12,12),USE(?LookupFile:2),ICON('Look.ico'),FLAT,TRN
                       TEXT,AT(6,68,365,105),USE(?TEXT1),FONT('Courier New',10),HVSCROLL
                       BUTTON('Generate'),AT(6,176,46,14),USE(?GenerateBtn),FLAT,TRN
                     END

    omit('***',WE::CantCloseNowSetHereDone=1)  !Getting Nested omit compile error, then uncheck the "Check for duplicate CantCloseNowSetHere variable declaration" in the WinEvent local template
WE::CantCloseNowSetHereDone equate(1)
WE::CantCloseNowSetHere     long
    !***
ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
! ----- ThisAnyFont --------------------------------------------------------------------------
ThisAnyFont          Class(AnyFont)
                     End  ! ThisAnyFont
! ----- end ThisAnyFont -----------------------------------------------------------------------
! ----- csResize --------------------------------------------------------------------------
csResize             Class(csResizeClass)
    ! derived method declarations
Fetch                  PROCEDURE (STRING Sect,STRING Ent,*? Val),VIRTUAL
Update                 PROCEDURE (STRING Sect,STRING Ent,STRING Val),VIRTUAL
Init                   PROCEDURE (),VIRTUAL
                     End  ! csResize
! ----- end csResize -----------------------------------------------------------------------
! ----- job --------------------------------------------------------------------------
job                  Class(JobObject)
                     End  ! job
! ----- end job -----------------------------------------------------------------------
FileLookup8          SelectFileClass
FileLookup9          SelectFileClass
CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Record Will Be Added'
  OF ChangeRecord
    ActionMessage = 'Record Will Be Changed'
  END
  QuickWindow{PROP:Text} = ActionMessage                   ! Display status message in title bar
  CASE SELF.Request
  OF ChangeRecord OROF DeleteRecord
    QuickWindow{PROP:Text} = QuickWindow{PROP:Text} & '  (' & Man:Description & ')' ! Append status message to window title text
  OF InsertRecord
    QuickWindow{PROP:Text} = QuickWindow{PROP:Text} & '  (New)'
  END
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateManifest')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?OK
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(Man:Record,History::Man:Record)
  SELF.AddHistoryField(?Man:InputPath,4)
  SELF.AddHistoryField(?Man:Description,2)
  SELF.AddHistoryField(?Man:DateCreated,3)
  SELF.AddHistoryField(?Man:OutputPath,5)
  SELF.AddUpdateFile(Access:Manifests)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Manifests.Open()                                  ! File Manifests used by this procedure, so make sure it's RelationManager is open
  Relate:Settings.Open()                                   ! File Settings used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Manifests
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.CancelAction = Cancel:Cancel+Cancel:Query         ! Confirm cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  Alert(AltKeyPressed)  ! WinEvent : These keys cause a program to crash on Windows 7 and Windows 10.
  Alert(F10Key)         !
  Alert(CtrlF10)        !
  Alert(ShiftF10)       !
  Alert(CtrlShiftF10)   !
  Alert(AltSpace)       !
  WinAlertMouseZoom()
  WinAlert(WE::WM_QueryEndSession,,Return1+PostUser)
  ThisAnyFont.PreserveMenubar = 1
  ThisAnyFont.PreserveToolbar = 1
  If Band(Anyfont:save,AnyFont:SavedSettingsLoaded) = 0
    INIMGR.Fetch(AnyFont:SaveSection,'FontName',AnyFont:FontName)
    INIMGR.Fetch(AnyFont:SaveSection,'FontSize',AnyFont:FontSize)
    INIMGR.Fetch(AnyFont:SaveSection,'FontColor',AnyFont:FontColor)
    INIMGR.Fetch(AnyFont:SaveSection,'FontStyle',AnyFont:FontStyle)
    INIMGR.Fetch(AnyFont:SaveSection,'FontCharset',AnyFont:FontCharset)
    INIMGR.Fetch(AnyFont:SaveSection,'Disable',AnyFont:Disable)
    Anyfont:Save = bor(Anyfont:Save,AnyFont:SavedSettingsLoaded)
  end
  if AnyFont:Disable = false
    ThisAnyFont.AutoWallpaper = prop:stretch
    ThisAnyFont.SetWindow(AnyFont:FontName,AnyFont:FontSize,AnyFont:FontColor,AnyFont:FontStyle,AnyFont:FontCharset,0)
  else
  end
  ThisAnyFont.SetListStyles()
  IF SELF.Request = ViewRecord                             ! Configure controls for View Only mode
    ?Man:InputPath{PROP:ReadOnly} = True
    ?Man:Description{PROP:ReadOnly} = True
    ?Man:DateCreated{PROP:ReadOnly} = True
    ?Man:OutputPath{PROP:ReadOnly} = True
    DISABLE(?LookupFile)
    DISABLE(?LookupFile:2)
    DISABLE(?GenerateBtn)
  END
  csResize.Init('UpdateManifest',QuickWindow,1)
  INIMgr.Fetch('UpdateManifest',QuickWindow)               ! Restore window settings from non-volatile store
  FileLookup8.Init
  FileLookup8.ClearOnCancel = True
  FileLookup8.Flags=BOR(FileLookup8.Flags,FILE:LongName)   ! Allow long filenames
  FileLookup8.SetMask('All Files','*.*')                   ! Set the file mask
  FileLookup8.DefaultDirectory=Set:DefaultInputPath
  FileLookup9.Init
  FileLookup9.ClearOnCancel = True
  FileLookup9.Flags=BOR(FileLookup9.Flags,FILE:LongName)   ! Allow long filenames
  FileLookup9.Flags=BOR(FileLookup9.Flags,FILE:Directory)  ! Allow Directory Dialog
  FileLookup9.SetMask('All Files','*.*')                   ! Set the file mask
  csResize.Open()
  SELF.SetAlerts()
    Set(Settings)
    Access:Settings.Next()
  
    If SELF.ChangeAction = Change:Caller
        If Access:Manifests.Fetch(Man:GuidKey) = Level:Benign
            ManifestSt.FromBlob(Man:Manifest)
            StartPos = ManifestSt.FindChar('<')
            EndPos = ManifestSt.FindLast('>')
            ?TEXT1{PROP:Text} = ManifestSt.Between('','',StartPos,EndPos,True,False)  !ManifestSt.GetValue()
        End
    End      
    If SELF.InsertAction = Insert:Caller
        SETPATH(Clip(Glo:DefaultInputPath))
    End
    If Not Man:DateCreated
        Man:DateCreated = Today()
    End    
    If Not Man:GUID
        Man:GUID = Glo:st.MakeGuid()
    End
  
    
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  If self.opened Then WinAlert().
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Manifests.Close()
    Relate:Settings.Close()
  END
  IF SELF.Opened
    INIMgr.Update('UpdateManifest',QuickWindow)            ! Save window data to non-volatile store
  END
    ThisAnyFont.kill()
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE ACCEPTED()
    OF ?GenerateBtn
      !    RUN('mt -managedassemblyname:"'&clip(Man:InputPath)&'" -out:"'&clip(Man:OutputPath)&'"',0)
      !job.CreateProcess('mt','-managedassemblyname:"'&clip(Man:InputPath)&'" -out:"'&clip(Man:OutputPath)&'"',
      SETPATH(clip(Glo:OriginalPath))
      If job.CreateProcess('mt -nologo -managedassemblyname:"'&clip(Man:InputPath)&'" -out:"'&clip(Man:OutputPath)&'"',jo:SW_HIDE,true,,,,,Glo:st,0,0) <> 0
        Glo:st.Trace(Glo:st.GetValue())
      End
        !ds_Sleep(100)
        If Exists(clip(Man:OutputPath))
            ManifestSt.LoadFile(Man:OutputPath)
            ManifestSt.Remove('</file>','</assembly>',0,1,0)
            ManifestSt.Replace('><assemblyIdentity','><13><10><assemblyIdentity')
            ManifestSt.Replace('</assemblyIdentity><clrClass','</assemblyIdentity><13><10><clrClass')
            ManifestSt.Replace('</clrClass><clrClass','</clrClass><13><10><clrClass')
            ManifestSt.Replace('</clrClass><file','</clrClass><13><10><file')
            ManifestSt.Replace('</file></assembly>','</file><13><10></assembly>')
            ManifestSt.Replace('</clrSurrogate><clrSurrogate','</clrSurrogate><13><10><clrSurrogate')
            StartPos = ManifestSt.FindChar('<')
            EndPos = ManifestSt.FindLast('>')
            ManifestSt.SetValue(ManifestSt.Between('','',StartPos,EndPos,True,False))
            ?TEXT1{PROP:Text} = ManifestSt.GetValue() !ManifestSt.Between('','',StartPos,EndPos,True,False) !ManifestSt.GetValue()
            ManifestSt.ToBlob(Man:Manifest)
            ManifestSt.SaveFile(Man:OutputPath)
            !If Exists(clip(Man:OutputPath))
            !    ?EditBtn{PROP:Disable} = False
            !    Display(?EditBtn)
            !End    
        End            
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?OK
      ThisWindow.Update()
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    OF ?LookupFile
      ThisWindow.Update()
          
      Man:InputPath = FileLookup8.Ask(1)
      DISPLAY
      SETPATH(clip(Glo:OriginalPath))      
      
      !NewOutputPath = ManifestSt.PathOnly(Man:InputPath) & '\'
      FileLookup9.DefaultDirectory = Glo:st.PathOnly(Man:InputPath) !NewOutputPath
      
      !Message(NewOutputPath)
    OF ?LookupFile:2
      ThisWindow.Update()
      Man:OutputPath = FileLookup9.Ask(1)
      DISPLAY
      Man:OutputPath = Clip(Man:OutputPath) & '\' & Glo:st.FileNameOnly(Man:InputPath,0) & '.manifest'
      SETPATH(clip(Glo:OriginalPath))
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  csResize.TakeEvent()
  LOOP                                                     ! This method receives all events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeEvent()
  If event() = event:VisibleOnDesktop !or event() = event:moved
    ds_VisibleOnDesktop()
  end
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeWindowEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all window specific events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE EVENT()
    OF EVENT:CloseDown
      if WE::CantCloseNow
        WE::MustClose = 1
        cycle
      else
        self.CancelAction = cancel:cancel
        self.response = requestcancelled
      end
    END
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:OpenWindow
        post(event:visibleondesktop)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

!----------------------------------------------------
csResize.Fetch   PROCEDURE (STRING Sect,STRING Ent,*? Val)
  CODE
  INIMgr.Fetch(Sect,Ent,Val)
  PARENT.Fetch (Sect,Ent,Val)
!----------------------------------------------------
csResize.Update   PROCEDURE (STRING Sect,STRING Ent,STRING Val)
  CODE
  INIMgr.Update(Sect,Ent,Val)
  PARENT.Update (Sect,Ent,Val)
!----------------------------------------------------
csResize.Init   PROCEDURE ()
  CODE
  PARENT.Init ()
  Self.CornerStyle = Ras:CornerDots
  SELF.GrabCornerLines() !
  SELF.SetStrategy(?OK,100,100,0,0)
  SELF.SetStrategy(?Cancel,100,100,0,0)
  SELF.SetStrategy(?TEXT1,0,0,100,100)
  SELF.SetStrategy(?GenerateBtn,,100,,0)
