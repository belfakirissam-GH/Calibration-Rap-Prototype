@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calibration Interface View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_MP2_CALIBRATION
  as select from zmp2_calib_h
  composition [0..*] of ZI_MP2_CALIBRATIONPOINT as _Points
  association [1..1] to ZI_MP2_EQUIPMENT as _Equipment
    on $projection.EquipmentUuid = _Equipment.EquipmentUuid
{
  key calibration_uuid      as CalibrationUuid,
      equipment_uuid        as EquipmentUuid,
      calibration_id        as CalibrationId,
      calibration_date      as CalibrationDate,

      @Semantics.quantity.unitOfMeasure: 'TemperatureUnit'
      temperature           as Temperature,
      temperature_unit      as TemperatureUnit,

      overall_result        as OverallResult,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Equipment,
      _Points
}
