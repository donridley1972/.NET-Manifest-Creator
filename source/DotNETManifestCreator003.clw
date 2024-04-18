

   MEMBER('DotNETManifestCreator.clw')                     ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('DOTNETMANIFESTCREATOR003.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('DOTNETMANIFESTCREATOR004.INC'),ONCE        !Req'd for module callout resolution
                     END


  
!!! <summary>
!!! Generated from procedure template - Window
!!! Browse the Settings file
!!! </summary>
BrowseSettings PROCEDURE 

CurrentTab           STRING(80)                            ! 
BRW1::View:Browse    VIEW(Settings)
                       PROJECT(Set:DefaultInputPath)
                       PROJECT(Set:DefaultOutputPath)
                       PROJECT(Set:GUID)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
Set:DefaultInputPath   LIKE(Set:DefaultInputPath)     !List box control field - type derived from field
Set:DefaultOutputPath  LIKE(Set:DefaultOutputPath)    !List box control field - type derived from field
Set:GUID               LIKE(Set:GUID)                 !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
loc:AnyFontVal string(255)
QuickWindow          WINDOW('Browse the Settings file'),AT(,,350,166),FONT('Segoe UI',10,,FONT:regular,CHARSET:ANSI), |
  RESIZE,AUTO,CENTER,ICON('AppIcon.ico'),GRAY,IMM,HLP('BrowseSettings'),SYSTEM,WALLPAPER('ArcticBlue' & |
  'GradientBackground1600x1084.jpg')
                       LIST,AT(2,2,344,124),USE(?Browse:1),HVSCROLL,FORMAT('265L(2)M~Default Input Path~@s255@' & |
  '265L(2)M~Default Output Path~@s255@'),FROM(Queue:Browse:1),IMM,MSG('Browsing the Set' & |
  'tings file')
                       BUTTON('&View'),AT(106,129,58,14),USE(?View:2),LEFT,ICON('WAVIEW.ICO'),FLAT,MSG('View Record'), |
  TIP('View Record'),TRN
                       BUTTON('&Insert'),AT(167,129,58,14),USE(?Insert:3),LEFT,ICON('WAINSERT.ICO'),FLAT,MSG('Insert a Record'), |
  TIP('Insert a Record'),TRN
                       BUTTON('&Change'),AT(228,129,58,14),USE(?Change:3),LEFT,ICON('WACHANGE.ICO'),DEFAULT,FLAT, |
  MSG('Change the Record'),TIP('Change the Record'),TRN
                       BUTTON('&Delete'),AT(289,129,58,14),USE(?Delete:3),LEFT,ICON('WADELETE.ICO'),FLAT,MSG('Delete the Record'), |
  TIP('Delete the Record'),TRN
                       BUTTON('&Close'),AT(289,146,58,14),USE(?Close),LEFT,ICON('WACLOSE.ICO'),FLAT,MSG('Close Window'), |
  TIP('Close Window'),TRN
                     END

    omit('***',WE::CantCloseNowSetHereDone=1)  !Getting Nested omit compile error, then uncheck the "Check for duplicate CantCloseNowSetHere variable declaration" in the WinEvent local template
WE::CantCloseNowSetHereDone equate(1)
WE::CantCloseNowSetHere     long
    !***
ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
! ----- ThisAnyFont --------------------------------------------------------------------------
ThisAnyFont          Class(AnyFont)
                     End  ! ThisAnyFont
! ----- end ThisAnyFont -----------------------------------------------------------------------
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW1::Sort0:StepClass StepStringClass                      ! Default Step Manager
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
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

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('BrowseSettings')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Browse:1
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
  Relate:Settings.Open()                                   ! File Settings used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:Settings,SELF) ! Initialize the browse manager
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
  BRW1.Q &= Queue:Browse:1
  BRW1::Sort0:StepClass.Init(+ScrollSort:AllowAlpha,ScrollBy:Runtime) ! Moveable thumb based upon Set:GUID for sort order 1
  BRW1.AddSortOrder(BRW1::Sort0:StepClass,Set:GuidKey)     ! Add the sort order for Set:GuidKey for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(,Set:GUID,1,BRW1)               ! Initialize the browse locator using  using key: Set:GuidKey , Set:GUID
  BRW1.AddField(Set:DefaultInputPath,BRW1.Q.Set:DefaultInputPath) ! Field Set:DefaultInputPath is a hot field or requires assignment from browse
  BRW1.AddField(Set:DefaultOutputPath,BRW1.Q.Set:DefaultOutputPath) ! Field Set:DefaultOutputPath is a hot field or requires assignment from browse
  BRW1.AddField(Set:GUID,BRW1.Q.Set:GUID)                  ! Field Set:GUID is a hot field or requires assignment from browse
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('BrowseSettings',QuickWindow)               ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  BRW1.AskProcedure = 1                                    ! Will call: UpdateSettings
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
    INIMgr.Update('BrowseSettings',QuickWindow)            ! Save window data to non-volatile store
  END
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
    UpdateSettings
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
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


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert:3
    SELF.ChangeControl=?Change:3
    SELF.DeleteControl=?Delete:3
  END
  SELF.ViewControl = ?View:2                               ! Setup the control used to initiate view only mode


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

