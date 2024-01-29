  MEMBER('DotNETManifestCreator.clw')

  INCLUDE('ABFILE.INC'),ONCE

  MAP
DotNETManifestCreator_BC0:DctInit    PROCEDURE()
DotNETManifestCreator_BC0:DctKill    PROCEDURE()
DotNETManifestCreator_BC0:FilesInit  PROCEDURE()
  END

Hide:Access:Manifests CLASS(FileManager),TYPE              ! FileManager for Manifests
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
PrimeFields            PROCEDURE(),PROC,DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:Manifests CLASS(RelationManager),TYPE          ! RelationManager for Manifests
Init                   PROCEDURE
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:Settings CLASS(FileManager),TYPE               ! FileManager for Settings
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
PrimeFields            PROCEDURE(),PROC,DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:Settings CLASS(RelationManager),TYPE           ! RelationManager for Settings
Init                   PROCEDURE
Kill                   PROCEDURE(),DERIVED
                     END


_Hide:Access:Manifests &Hide:Access:Manifests,AUTO,THREAD
_Hide:Relate:Manifests &Hide:Relate:Manifests,AUTO,THREAD
_Hide:Access:Settings &Hide:Access:Settings,AUTO,THREAD
_Hide:Relate:Settings &Hide:Relate:Settings,AUTO,THREAD


DotNETManifestCreator_BC0:DctInit PROCEDURE()
  CODE
  _Hide:Access:Manifests &= NEW(Hide:Access:Manifests)
  _Hide:Relate:Manifests &= NEW(Hide:Relate:Manifests)
  _Hide:Access:Settings &= NEW(Hide:Access:Settings)
  _Hide:Relate:Settings &= NEW(Hide:Relate:Settings)
  Relate:Manifests &= _Hide:Relate:Manifests
  Relate:Settings &= _Hide:Relate:Settings


DotNETManifestCreator_BC0:FilesInit PROCEDURE()
  CODE
  _Hide:Relate:Manifests.Init
  _Hide:Relate:Settings.Init


DotNETManifestCreator_BC0:DctKill PROCEDURE()
  CODE
  _Hide:Relate:Manifests.Kill
  DISPOSE(_Hide:Relate:Manifests)
  _Hide:Relate:Settings.Kill
  DISPOSE(_Hide:Relate:Settings)


Hide:Relate:Manifests.Init PROCEDURE()
  CODE
  _Hide:Access:Manifests.Init
  SELF.Init(Access:Manifests,1)


Hide:Access:Manifests.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= Man:Record
  SELF.FileNameValue = 'Manifests'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Manifests
  PARENT.Init
  Access:Manifests &= SELF


Hide:Access:Manifests.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Manifests &= NULL                                 ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Manifests.PrimeFields PROCEDURE

  CODE
  Man:GUID = Glo:st.MakeGuid()                             ! Assign initial field value
  PARENT.PrimeFields


Hide:Access:Manifests.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Manifests,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(Man:GuidKey,'Man:GuidKey',0)
    SELF.AddKey(Man:DescriptionKey,'Man:DescriptionKey',0)
    SELF.AddKey(Man:DateCreatedKey,'Man:DateCreatedKey',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:Manifests.Kill PROCEDURE

  CODE
  _Hide:Access:Manifests.Kill                              ! Kill the file manager
  PARENT.Kill
  Relate:Manifests &= NULL                                 ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Manifests)                          ! destroy the file manager


Hide:Relate:Settings.Init PROCEDURE()
  CODE
  _Hide:Access:Settings.Init
  SELF.Init(Access:Settings,1)


Hide:Access:Settings.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= Set:Record
  SELF.FileNameValue = 'Settings'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Settings
  PARENT.Init
  Access:Settings &= SELF


Hide:Access:Settings.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Settings &= NULL                                  ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Settings.PrimeFields PROCEDURE

  CODE
  Set:GUID = Glo:st.MakeGuid()                             ! Assign initial field value
  PARENT.PrimeFields


Hide:Access:Settings.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Settings,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(Set:GuidKey,'Set:GuidKey',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:Settings.Kill PROCEDURE

  CODE
  _Hide:Access:Settings.Kill                               ! Kill the file manager
  PARENT.Kill
  Relate:Settings &= NULL                                  ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Settings)                           ! destroy the file manager

