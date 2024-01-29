   PROGRAM


StringTheory:TemplateVersion equate('3.66')
OddJob:TemplateVersion equate('1.45')
ResizeAndSplit:TemplateVersion equate('5.10')
WinEvent:TemplateVersion      equate('5.38')

   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE
  include('StringTheory.Inc'),ONCE
  include('OddJob.Inc'),ONCE
  include('ResizeAndSplit.Inc'),ONCE
    Include('WinEvent.Inc'),Once

   MAP
     MODULE('DOTNETMANIFESTCREATOR_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('DOTNETMANIFESTCREATOR001.CLW')
Main                   PROCEDURE   !
     END
         MODULE('vuSendKeys.dll')
      vuSendKeys(*CSTRING,LONG),Signed,PROC,Pascal,Raw,Name('vuSendKeys')
      vuSendKeys2Title(*CSTRING,*CSTRING),Signed,PROC,Pascal,Raw,Name('vuSendKeys2Title')
      vuName2Handle(*CSTRING),Long,PROC,Pascal,Raw,Name('vuName2Handle')
      vuActivateMyWindow(),Long,PROC,Pascal,Raw,Name('vuActivateMyWindow')
      vuMinimizeWindow(LONG),Long,PROC,Pascal,Raw,Name('vuMinimizeWindow')
      vuMaximizeWindow(LONG),Long,PROC,Pascal,Raw,Name('vuMaximizeWindow')
      vuRestoreWindow(LONG),Long,PROC,Pascal,Raw,Name('vuRestoreWindow')
      vuWindowTitle(LONG),CSTRING,PROC,Pascal,Raw,Name('vuWindowTitle')
      vuCallingWindow(LONG),Signed,PROC,Pascal,Raw,Name('vuCallingWindow')
      vuGetControlText(LONG,LONG),CSTRING,PROC,Pascal,Raw,Name('vuGetControlText')
      vuChild2Handle(LONG,*CSTRING),Long,PROC,Pascal,Raw,Name('vuChild2Handle')
      vuSetControlText(LONG,LONG,*CSTRING),Signed,PROC,Pascal,Raw,Name('vuSetControlText')
      vuSetComboText(LONG,LONG,*CSTRING),Signed,PROC,Pascal,Raw,Name('vuSetComboText')
      vuSetDateText(LONG,LONG,*CSTRING),Signed,PROC,Pascal,Raw,Name('vuSetDateText')
      vuClickButton(LONG,LONG),Signed,PROC,Pascal,Raw,Name('vuClickButton')
      vuIgnoreSpecialCharacters(LONG),Signed,PROC,Pascal,Raw,Name('vuIgnoreSpecialCharacters')
      vuGetAllWindows(*CSTRING,LONG),CSTRING,PROC,Pascal,Raw,Name('vuGetAllWindows')
         END
       MyOKToEndSessionHandler(long pLogoff),long,pascal
       MyEndSessionHandler(long pLogoff),pascal
   END

  include('StringTheory.Inc'),ONCE
Glo:st               StringTheory
Glo:OriginalPath     STRING(255)
Glo:DefaultInputPath STRING(255)
EditThread           LONG
SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
Manifests            FILE,DRIVER('TOPSPEED'),NAME('Manifests.tps'),PRE(Man),CREATE,BINDABLE,THREAD !                     
GuidKey                  KEY(Man:GUID),NOCASE,PRIMARY      !                     
DescriptionKey           KEY(Man:Description),DUP,NOCASE   !                     
DateCreatedKey           KEY(Man:DateCreated),DUP,NOCASE   !                     
Manifest                    BLOB                           !                     
Record                   RECORD,PRE()
GUID                        STRING(16)                     !                     
Description                 STRING(100)                    !                     
DateCreated                 LONG                           !                     
InputPath                   STRING(255)                    !                     
OutputPath                  STRING(255)                    !                     
                         END
                     END                       

Settings             FILE,DRIVER('TOPSPEED'),NAME('Settings.tps'),PRE(Set),CREATE,BINDABLE,THREAD !                     
GuidKey                  KEY(Set:GUID),NOCASE,PRIMARY      !                     
Record                   RECORD,PRE()
GUID                        STRING(16)                     !                     
DefaultInputPath            STRING(255)                    !                     
DefaultOutputPath           STRING(255)                    !                     
                         END
                     END                       

!endregion

WE::MustClose       long
WE::CantCloseNow    long
Access:Manifests     &FileManager,THREAD                   ! FileManager for Manifests
Relate:Manifests     &RelationManager,THREAD               ! RelationManager for Manifests
Access:Settings      &FileManager,THREAD                   ! FileManager for Settings
Relate:Settings      &RelationManager,THREAD               ! RelationManager for Settings

FuzzyMatcher         FuzzyClass                            ! Global fuzzy matcher
GlobalErrorStatus    ErrorStatusClass,THREAD
GlobalErrors         ErrorClass                            ! Global error manager
INIMgr               INIClass                              ! Global non-volatile storage manager
GlobalRequest        BYTE(0),THREAD                        ! Set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE(0),THREAD                        ! Set to the response from the form
VCRRequest           LONG(0),THREAD                        ! Set to the request from the VCR buttons

Dictionary           CLASS,THREAD
Construct              PROCEDURE
Destruct               PROCEDURE
                     END


  CODE
  GlobalErrors.Init(GlobalErrorStatus)
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  INIMgr.Init('.\DotNETManifestCreator.INI', NVD_INI)      ! Configure INIManager to use INI file
  DctInit()
  SYSTEM{PROP:Icon} = 'AppIcon.ico'
    ds_SetOKToEndSessionHandler(address(MyOKToEndSessionHandler))
    ds_SetEndSessionHandler(address(MyEndSessionHandler))
  Main
  INIMgr.Update
  INIMgr.Kill                                              ! Destroy INI manager
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher
    
! ------ winevent -------------------------------------------------------------------
MyOKToEndSessionHandler procedure(long pLogoff)
OKToEndSession    long(TRUE)
! Setting the return value OKToEndSession = FALSE
! will tell windows not to shutdown / logoff now.
! If parameter pLogoff = TRUE if the user is logging off.

  code
  return(OKToEndSession)

! ------ winevent -------------------------------------------------------------------
MyEndSessionHandler procedure(long pLogoff)
! If parameter pLogoff = TRUE if the user is logging off.

  code


Dictionary.Construct PROCEDURE

  CODE
  IF THREAD()<>1
     DctInit()
  END


Dictionary.Destruct PROCEDURE

  CODE
  DctKill()

