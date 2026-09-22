@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calibration Point Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_MP2_CALIBRATIONPOINT
  as select from zmp2_calib_p
  association to parent ZI_MP2_CALIBRATION as _Calibration
    on $projection.CalibrationUuid = _Calibration.CalibrationUuid
{
  key point_uuid            as PointUuid,
      calibration_uuid      as CalibrationUuid,
      point_number          as PointNumber,

      @Semantics.quantity.unitOfMeasure: 'MeasurementUnit'
      target_value          as TargetValue,
      @Semantics.quantity.unitOfMeasure: 'MeasurementUnit'
      reference_value       as ReferenceValue,
      @Semantics.quantity.unitOfMeasure: 'MeasurementUnit'
      measured_value        as MeasuredValue,
      @Semantics.quantity.unitOfMeasure: 'MeasurementUnit'
      tolerance_value       as ToleranceValue,
      @Semantics.quantity.unitOfMeasure: 'MeasurementUnit'
      deviation_value       as DeviationValue,

      measurement_unit      as MeasurementUnit,
      point_result          as PointResult,

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

      _Calibration
}
