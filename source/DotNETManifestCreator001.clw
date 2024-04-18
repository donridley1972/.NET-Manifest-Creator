

   MEMBER('DotNETManifestCreator.clw')                     ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('DOTNETMANIFESTCREATOR001.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('DOTNETMANIFESTCREATOR002.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DOTNETMANIFESTCREATOR004.INC'),ONCE        !Req'd for module callout resolution
                     END


  
!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
Main PROCEDURE 

st              StringTheory
ManifestST      StringTheory
AppManifestSt   StringTheory
StartPos        Long
EndPos          Long
AssemblyName    String(50)
SourcePath           STRING(255)                           ! 
EtlFileName          STRING(20)                            ! 
KeyInput             CSTRING(1024)                         ! 
DestinationPath      STRING(255)                           ! 
FileName             STRING(50)                            ! 
BRW5::View:Browse    VIEW(Manifests)
                       PROJECT(Man:Description)
                       PROJECT(Man:GUID)
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
Man:Description        LIKE(Man:Description)          !List box control field - type derived from field
Man:GUID               LIKE(Man:GUID)                 !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
loc:AnyFontVal string(255)
Window               WINDOW('.NET Manifest Creator'),AT(,,468,235),FONT('Segoe UI',10),RESIZE,AUTO,ICON('AppIconNoShadow.ico'), |
  GRAY,SYSTEM,WALLPAPER('ArcticBlueGradientBackground1600x1084.jpg'),IMM
                       BUTTON('Close'),AT(414,210,50,14),USE(?Close),LEFT,ICON('Cancel1.ico'),FLAT
                       BUTTON,AT(3,210,26,14),USE(?UpdateSettingsBtn),ICON('gear.ico'),FLAT,TIP('Settings'),TRN
                       SHEET,AT(2,1,464,206),USE(?SHEET1)
                         TAB('General'),USE(?TAB1)
                           BUTTON,AT(9,167,42,14),USE(?Insert),ICON('AddNew.ico'),FLAT,TIP('New manifest')
                           BUTTON,AT(54,167,42,14),USE(?Change),ICON('Edit.ico'),FLAT,TIP('Update Manifest')
                           BUTTON,AT(98,167,42,14),USE(?Delete),ICON('Trash.ico'),FLAT,TIP('Delete manifest')
                           BUTTON('Edit File'),AT(9,184,63,14),USE(?EditFileBtn),LEFT,ICON('Edit.ico'),FLAT,TRN
                           LIST,AT(8,16,133,148),USE(?List),LEFT(2),HVSCROLL,FORMAT('400L(2)|M~Description~@s100@'),FROM(Queue:Browse), |
  IMM
                           SHEET,AT(145,16,317,149),USE(?SHEET2)
                             TAB('DLL Manifest'),USE(?TAB3)
                               TEXT,AT(150,32,307,127),USE(?TEXT1),FONT('Courier New',10),HVSCROLL
                             END
                             TAB('Application Manifest'),USE(?TAB4)
                               TEXT,AT(150,32,307,127),USE(?TextAppManifest),FONT('Courier New',,,,CHARSET:DEFAULT),HVSCROLL
                             END
                           END
                         END
                         TAB('SxSTrace'),USE(?TAB2)
                           BUTTON('Run'),AT(9,18),USE(?RunBtn)
                           TEXT,AT(10,35,448,160),USE(?TEXT2),HVSCROLL
                         END
                       END
                     END

    omit('***',WE::CantCloseNowSetHereDone=1)  !Getting Nested omit compile error, then uncheck the "Check for duplicate CantCloseNowSetHere variable declaration" in the WinEvent local template
WE::CantCloseNowSetHereDone equate(1)
WE::CantCloseNowSetHere     long
    !***
ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
TakeNewSelection       PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
! ----- ThisAnyFont --------------------------------------------------------------------------
ThisAnyFont          Class(AnyFont)
                     End  ! ThisAnyFont
! ----- end ThisAnyFont -----------------------------------------------------------------------
! ----- job --------------------------------------------------------------------------
job                  Class(JobObject)
                     End  ! job
! ----- end job -----------------------------------------------------------------------
! ----- csResize --------------------------------------------------------------------------
csResize             Class(csResizeClass)
    ! derived method declarations
Fetch                  PROCEDURE (STRING Sect,STRING Ent,*? Val),VIRTUAL
Update                 PROCEDURE (STRING Sect,STRING Ent,STRING Val),VIRTUAL
Init                   PROCEDURE (),VIRTUAL
                     End  ! csResize
! ----- end csResize -----------------------------------------------------------------------
BRW5                 CLASS(BrowseClass)                    ! Browse using ?List
Q                      &Queue:Browse                  !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

CrateAppManifest        ROUTINE
    AppManifestSt.SetValue(|
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?> <13,10>' & |
    '<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0"> <13,10>' & |
    '  <assemblyIdentity version="1.0.0.0" processorArchitecture="x86" name="SoftVelocity.Clarion10.Application" type="win32"/> <13,10>' & |
    '  <description>Clarion application.</description> <13,10>' & |
    '  <trustInfo xmlns="urn:schemas-microsoft-com:asm.v3"> <13,10>' & |
    '    <security> <13,10>' & |
    '      <requestedPrivileges> <13,10>' & |
    '        <requestedExecutionLevel level="asInvoker" uiAccess="false"/> <13,10>' & |
    '      </requestedPrivileges> <13,10>' & |
    '    </security> <13,10>' & |
    '  </trustInfo> <13,10>' & |
    '  <dependency> <13,10>' & |
    '    <dependentAssembly> <13,10>' & |
    '      <assemblyIdentity type="win32" name="Microsoft.Windows.Common-Controls" version="6.0.0.0" processorArchitecture="x86" publicKeyToken="6595b64144ccf1df" language="*"/> <13,10>' & |
    '    </dependentAssembly> <13,10>' & |
    '  </dependency> <13,10>' & |
    '  <dependency> <13,10>' & |
    '    <dependentAssembly> <13,10>' & |
    '       <assemblyIdentity name="' & Clip(AssemblyName) & '" version="1.0.0.0" processorArchitecture="x86"/> <13,10>' & |
    '    </dependentAssembly> <13,10>' & |
    '  </dependency> <13,10>' & |
    '  <compatibility xmlns="urn:schemas-microsoft-com:compatibility.v1"> <13,10>' & |
    '    <application> <13,10>' & |
    '      <!--The ID below indicates application support for Windows Vista --> <13,10>' & |
    '      <supportedOS Id="{{e2011457-1546-43c5-a5fe-008deee3d3f0}"/> <13,10>' & |
    '      <!--The ID below indicates application support for Windows 7 --> <13,10>' & |
    '      <supportedOS Id="{{35138b9a-5d96-4fbd-8e2d-a2440225f93a}"/> <13,10>' & |
    '      <!--The ID below indicates application support for Windows 8 --> <13,10>' & |
    '      <supportedOS Id="{{4a2f28e3-53b9-4441-ba9c-d69d4a4a6e38}"/> <13,10>' & |
    '      <!--The ID below indicates application support for Windows 8-1 --> <13,10>' & |
    '      <supportedOS Id="{{1f676c76-80e1-4239-95bb-83d0f6d0da78}"/> <13,10>' & |
    '      <!--The ID below indicates application support for Windows 10 --> <13,10>' & |
    '      <supportedOS Id="{{8e0f7a12-bfb3-4fe8-b9a5-48fd50a15a9a}"/> <13,10>' & |
    '    </application> <13,10>' & |
    '  </compatibility> <13,10>' & |
    '  <asmv3:application> <13,10>' & |
    '    <asmv3:windowsSettings xmlns="http://schemas.microsoft.com/SMI/2005/WindowsSettings"> <13,10>' & |
    '      <dpiAware>true</dpiAware> <13,10>' & |
    '    </asmv3:windowsSettings> <13,10>' & |
    '  </asmv3:application> <13,10>' & |
    '</assembly>')  
    ?TextAppManifest{PROP:Text} = AppManifestSt.GetValue()
!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Main')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Close
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  ! Restore preserved local variables from non-volatile store
  SourcePath = INIMgr.TryFetch('Main_PreservedVars','SourcePath')
  DestinationPath = INIMgr.TryFetch('Main_PreservedVars','DestinationPath')
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:Manifests.Open()                                  ! File Manifests used by this procedure, so make sure it's RelationManager is open
  Relate:Settings.Open()                                   ! File Settings used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW5.Init(?List,Queue:Browse.ViewPosition,BRW5::View:Browse,Queue:Browse,Relate:Manifests,SELF) ! Initialize the browse manager
  SELF.Open(Window)                                        ! Open window
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
  BRW5.Q &= Queue:Browse
  BRW5.AddSortOrder(,)                                     ! Add the sort order for  for sort order 1
  BRW5.AddField(Man:Description,BRW5.Q.Man:Description)    ! Field Man:Description is a hot field or requires assignment from browse
  BRW5.AddField(Man:GUID,BRW5.Q.Man:GUID)                  ! Field Man:GUID is a hot field or requires assignment from browse
  csResize.Init('Main',Window,1)
  INIMgr.Fetch('Main',Window)                              ! Restore window settings from non-volatile store
  BRW5.AskProcedure = 1                                    ! Will call: UpdateManifest
  BRW5.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  csResize.Open()
  SELF.SetAlerts()
    If Not Records(Settings)
        Set:GUID = Glo:st.MakeGuid()
        Access:Settings.Insert()
    End
    !Access:Settings.Open()
    Glo:OriginalPath = Path()
    Set(Settings)
    Access:Settings.Next()
    Glo:DefaultInputPath = Set:DefaultInputPath
    !Access:Settings.Close()    
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  If self.opened Then WinAlert().
  Notify(EVENT:CloseWindow,EditThread)
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Manifests.Close()
    Relate:Settings.Close()
  END
  IF SELF.Opened
    INIMgr.Update('Main',Window)                           ! Save window data to non-volatile store
  END
  ! Save preserved local variables in non-volatile store
  INIMgr.Update('Main_PreservedVars','SourcePath',SourcePath)
  INIMgr.Update('Main_PreservedVars','DestinationPath',DestinationPath)
    ThisAnyFont.kill()
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    UpdateManifest
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

st      StringTheory
Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE ACCEPTED()
    OF ?RunBtn
        !CreateProcess Procedure (string pAppName, ushort pMode, byte pUseCMD=0, <string pPath>, <string pMessage>, <string pTitle>,<*long pExitCommand>, <*StringTheory strData>, long noRead = 0, long noStore = 0) 
        !RUN('SxsTrace Trace -logfile:SxsTrace.etl',0,0)
        EtlFileName = 'SxsTrace' & Random(1,9999) & '.etl'
        !Message(Path() & '\' & Clip(EtlFileName))
        if job.CreateProcess('SxsTrace Trace -logfile:' & Path() & '\' & Clip(EtlFileName),jo:SW_SHOW,1,,,,,st,1,1) <> 0
            !ds_Sleep(1000)
            ?TEXT2{PROP:Text} = st.GetValue()
            !if job.CreateProcess('SxsTrace stoptrace',jo:SW_HIDE,1,,,,,st,0,0) <> 0
                !if job.CreateProcess('.\SxsTrace Parse -logfile:SxSTrace.etl -outfile:SxSTrace.txt',jo:SW_HIDE,1,Path(),,,,st,0,0) <> 0
                !    ?TEXT2{PROP:Text} = st.GetValue()      
                !End
            !End
            !KeyInput = '{{CR}'
            !vuSendKeys(KeyInput,1)
      
        End
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?UpdateSettingsBtn
      ThisWindow.Update()
      Set(Settings)
      !Access:Settings.Next()
      Next(Settings)
      GlobalRequest = ChangeRecord
      UpdateSettings()
      !START(UpdateSettings, 25000)
      ThisWindow.Reset      
    OF ?EditFileBtn
      ThisWindow.Update()
      If EXISTS(Clip(Man:OutputPath))
        ThisWindow.Update()
        START(EditManifest, 25000, Man:OutputPath)
        ThisWindow.Reset      
      ELSE
        Message('File: "' & clip(Man:OutputPath) & '" does not Exist!','Error!',ICON:Exclamation)
      End
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


ThisWindow.TakeNewSelection PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all NewSelection events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE FIELD()
    OF ?List
      get(queue:browse,choice(?List))
      Man:GUID = queue:browse.Man:GUID
      If Access:Manifests.Fetch(Man:GuidKey) = Level:Benign
        ManifestST.FromBlob(Man:Manifest)
        !ManifestST.ConvertOemToAnsi()
        StartPos = ManifestST.FindChar('<')
        EndPos = ManifestST.FindLast('>')
        ?TEXT1{PROP:Text} = ManifestST.Between('','',StartPos,EndPos,True,False) !ManifestST.GetValue()
        AssemblyName = Man:Description
        Do CrateAppManifest
      ELSE
        Glo:st.Trace('Main - Error Fetching Manifests Record!!')
      End
    END
  ReturnValue = PARENT.TakeNewSelection()
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
  SELF.SetStrategy(?Close,100,100,0,0)
  SELF.SetStrategy(?UpdateSettingsBtn,,100,,0)
  SELF.SetStrategy(?SHEET1,0,0,100,100)
  SELF.SetStrategy(?Insert,,100,,0)
  SELF.SetStrategy(?Change,,100,,0)
  SELF.SetStrategy(?Delete,,100,,0)
  SELF.SetStrategy(?EditFileBtn,,100,,0)
  SELF.SetStrategy(?List,,0,,100)
  SELF.SetStrategy(?SHEET2,0,0,100,100)
  SELF.SetStrategy(?TEXT1,0,0,100,100)
  SELF.SetStrategy(?TextAppManifest,0,0,100,100)
  SELF.SetStrategy(?TEXT2,0,0,100,100)

BRW5.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END

  
!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
EditManifest PROCEDURE (string pFilePath)

st              StringTheory
TheManifest          STRING(10000)                         ! 
loc:AnyFontVal string(255)
Window               WINDOW('Edit Manifest'),AT(,,365,220),FONT('Segoe UI',10),RESIZE,AUTO,ICON('AppIconNoShadow.ico'), |
  GRAY,SYSTEM,TOOLBOX,WALLPAPER('ArcticBlueGradientBackground1600x1084.jpg'),IMM
                       TEXT,AT(2,2,360,193),USE(?Text1),FONT('Courier New'),HVSCROLL,FLAT
                       BUTTON('Save Changes'),AT(2,198,74,20),USE(?SaveChangesBtn),LEFT,ICON('Ok1.ico'),FLAT
                       BUTTON('Save and Close'),AT(275,198,87,20),USE(?Close),LEFT,ICON('Cancel1.ico'),FLAT
                     END

    omit('***',WE::CantCloseNowSetHereDone=1)  !Getting Nested omit compile error, then uncheck the "Check for duplicate CantCloseNowSetHere variable declaration" in the WinEvent local template
WE::CantCloseNowSetHereDone equate(1)
WE::CantCloseNowSetHere     long
    !***
ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
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

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('EditManifest')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Text1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  SELF.Open(Window)                                        ! Open window
    0{PROP:Text} = 'Editing ' & clip(pFilePath)  
    st.LoadFile(pFilePath,0,0,1)
    ?Text1{PROP:Text} = st.GetValue()  
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
  csResize.Init('EditManifest',Window,1)
  INIMgr.Fetch('EditManifest',Window)                      ! Restore window settings from non-volatile store
  csResize.Open()
  SELF.SetAlerts()
    !st.LoadFile(pFilePath,0,0,1)
    !?Text1{PROP:Text} = st.GetValue()
    !TheManifest = st.GetValue()  
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  If self.opened Then WinAlert().
    EditThread = 0
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('EditManifest',Window)                   ! Save window data to non-volatile store
  END
    ThisAnyFont.kill()
  GlobalErrors.SetProcedureName
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
    OF ?SaveChangesBtn
        st.SetValue(?Text1{PROP:Text},1)
        st.SaveFile(clip(pFilePath))      
    OF ?Close
        st.SetValue(?Text1{PROP:Text},1)
        st.SaveFile(clip(pFilePath))       
    END
  ReturnValue = PARENT.TakeAccepted()
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

nCode       UNSIGNED
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
    OF EVENT:Notify
      NOTIFICATION(nCode)
        Case nCode
            of EVENT:CloseWindow
                EditThread = 0
                Post(EVENT:CloseWindow)
      End        
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
  SELF.SetStrategy(?Text1,0,0,100,100)
  SELF.SetStrategy(?SaveChangesBtn,,100,,0)
  SELF.SetStrategy(?Close,100,100,0,0)
