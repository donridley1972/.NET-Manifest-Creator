  MEMBER('DotNETManifestCreator.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('DotNETManifestCreator_BC0.CLW')
DotNETManifestCreator_BC0:DctInit             PROCEDURE()
DotNETManifestCreator_BC0:DctKill             PROCEDURE()
DotNETManifestCreator_BC0:FilesInit           PROCEDURE()
    END
  END

DctInit PROCEDURE()
  CODE
  DotNETManifestCreator_BC0:DctInit
  DotNETManifestCreator_BC0:FilesInit


DctKill PROCEDURE()
  CODE
  DotNETManifestCreator_BC0:DctKill

