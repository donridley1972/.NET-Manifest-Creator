

   MEMBER('DotNETManifestCreator.clw')                     ! This is a MEMBER module


   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('DOTNETMANIFESTCREATOR004.INC'),ONCE        !Local module procedure declarations
                     END


  
!!! <summary>
!!! Generated from procedure template - Window
!!! Form Settings
!!! </summary>
UpdateSettings PROCEDURE 

CurrentTab           STRING(80)                            ! 
ActionMessage        CSTRING(40)                           ! 
History::Set:Record  LIKE(Set:RECORD),THREAD
loc:AnyFontVal string(255)
QuickWindow          WINDOW('Form Settings'),AT(,,366,119),FONT('Segoe UI',10,,FONT:regular,CHARSET:ANSI),RESIZE, |
  AUTO,CENTER,ICON('AppIconNoShadow.ico'),GRAY,IMM,HLP('UpdateSettings'),SYSTEM,WALLPAPER('ArcticBlue' & |
  'GradientBackground1600x1084.jpg')
                       BUTTON('&OK'),AT(263,100,49,14),USE(?OK),LEFT,ICON('Ok1.ico'),DEFAULT,FLAT,MSG('Accept dat' & |
  'a and close the window'),TIP('Accept data and close the window')
                       BUTTON('&Cancel'),AT(316,100,49,14),USE(?Cancel),LEFT,ICON('Cancel1.ico'),FLAT,MSG('Cancel operation'), |
  TIP('Cancel operation')
                       SHEET,AT(2,1,363,96),USE(?SettingsSheet)
                         TAB('Paths'),USE(?PathsTab)
                           PROMPT('Default Input Path:'),AT(8,18),USE(?Set:DefaultInputPath:Prompt),TRN
                           PROMPT('Default Output Path:'),AT(8,34),USE(?Set:DefaultOutputPath:Prompt),TRN
                           ENTRY(@s255),AT(79,17,260,10),USE(Set:DefaultInputPath),LEFT(2)
                           ENTRY(@s255),AT(79,33,260,10),USE(Set:DefaultOutputPath),LEFT(2)
                           BUTTON,AT(343,17,12,11),USE(?LookupFile),ICON('Look.ico'),FLAT,TRN
                           BUTTON,AT(343,33,12,11),USE(?LookupFile:2),ICON('Look.ico'),FLAT,TRN
                         END
                         TAB('Appearance'),USE(?AppearanceTab)
                           BUTTON,AT(9,18,35,24),USE(?FontBtn),ICON('Font.ico'),FLAT,TIP('Update application font')
                         END
                       END
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
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateSettings')
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
  SELF.AddHistoryFile(Set:Record,History::Set:Record)
  SELF.AddHistoryField(?Set:DefaultInputPath,2)
  SELF.AddHistoryField(?Set:DefaultOutputPath,3)
  SELF.AddUpdateFile(Access:Settings)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Settings.Open()                                   ! File Settings used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Settings
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
    ?Set:DefaultInputPath{PROP:ReadOnly} = True
    ?Set:DefaultOutputPath{PROP:ReadOnly} = True
    DISABLE(?LookupFile)
    DISABLE(?LookupFile:2)
    DISABLE(?FontBtn)
  END
  csResize.Init('UpdateSettings',QuickWindow,1)
  INIMgr.Fetch('UpdateSettings',QuickWindow)               ! Restore window settings from non-volatile store
  FileLookup8.Init
  FileLookup8.ClearOnCancel = True
  FileLookup8.Flags=BOR(FileLookup8.Flags,FILE:LongName)   ! Allow long filenames
  FileLookup8.Flags=BOR(FileLookup8.Flags,FILE:Directory)  ! Allow Directory Dialog
  FileLookup8.SetMask('All Files','*.*')                   ! Set the file mask
  FileLookup9.Init
  FileLookup9.ClearOnCancel = True
  FileLookup9.Flags=BOR(FileLookup9.Flags,FILE:LongName)   ! Allow long filenames
  FileLookup9.Flags=BOR(FileLookup9.Flags,FILE:Directory)  ! Allow Directory Dialog
  FileLookup9.SetMask('All Files','*.*')                   ! Set the file mask
  csResize.Open()
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  If self.opened Then WinAlert().
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Settings.Close()
  END
  IF SELF.Opened
    INIMgr.Update('UpdateSettings',QuickWindow)            ! Save window data to non-volatile store
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
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?OK
      ThisWindow.Update()
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    OF ?LookupFile
      ThisWindow.Update()
      Set:DefaultInputPath = FileLookup8.Ask(1)
      DISPLAY
    OF ?LookupFile:2
      ThisWindow.Update()
      Set:DefaultOutputPath = FileLookup9.Ask(1)
      DISPLAY
    OF ?FontBtn
      ThisWindow.Update()
      !-------------------------------------------------------------------------------
      !-- Inserted by AnyFont.
      if AnyFont:Disable = false
        if AnyFont:FontName = '' then AnyFont:FontName = target{prop:fontname}.
        if AnyFont:FontSize = -1 then AnyFont:FontSize = target{prop:fontsize}.
        if AnyFont:FontColor = -1 then AnyFont:FontColor = target{prop:fontcolor}.
        if AnyFont:FontStyle = -1 then AnyFont:FontStyle = target{prop:fontStyle}.
        if AnyFont:FontCharset = -1 then AnyFont:Fontcharset = target{prop:fontCharset}.
        if FONTDIALOGA('Select Font',AnyFont:FontName,AnyFont:FontSize,AnyFont:FontColor,AnyFont:FontStyle,AnyFont:FontCharSet,0)
          ThisAnyFont.AutoWallpaper = prop:stretch
          ThisAnyFont.SetWindow(AnyFont:FontName,AnyFont:FontSize,AnyFont:FontColor,AnyFont:FontStyle,AnyFont:FontCharset,0)
          if band(Anyfont:Save,AnyFont:SaveSettings + AnyFont:SaveInProgramsIni) = AnyFont:SaveSettings + AnyFont:SaveInProgramsIni
            INIMGR.Update(AnyFont:SaveSection,'FontName',AnyFont:FontName)
            INIMGR.Update(AnyFont:SaveSection,'FontSize',AnyFont:FontSize)
            INIMGR.Update(AnyFont:SaveSection,'FontColor',AnyFont:FontColor)
            INIMGR.Update(AnyFont:SaveSection,'FontStyle',AnyFont:FontStyle)
            INIMGR.Update(AnyFont:SaveSection,'FontCharset',AnyFont:FontCharset)
          elsif band(Anyfont:Save,AnyFont:SaveSettings)=AnyFont:SaveSettings
            PUTINI(AnyFont:SaveSection,'FontName',AnyFont:FontName,AnyFont:SaveName)
            PUTINI(AnyFont:SaveSection,'FontSize',AnyFont:FontSize,AnyFont:SaveName)
            PUTINI(AnyFont:SaveSection,'FontColor',AnyFont:FontColor,AnyFont:SaveName)
            PUTINI(AnyFont:SaveSection,'FontStyle',AnyFont:FontStyle,AnyFont:SaveName)
            PUTINI(AnyFont:SaveSection,'FontCharset',AnyFont:FontCharset,AnyFont:SaveName)
          end
          csResize.ResetSetting()
          csResize.Resize()
        end
      end
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
  SELF.SetStrategy(?SettingsSheet,0,0,100,100)
  SELF.SetStrategy(?LookupFile,100,100,0,0)
  SELF.SetStrategy(?LookupFile:2,100,100,0,0)
  SELF.SetStrategy(?FontBtn,100,100,0,0)
