@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calibration Point Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_MP2_CALIBRATIONPOINT
  as projection on ZI_MP2_CALIBRATIONPOINT
{
  key PointUuid,
      CalibrationUuid,
      PointNumber,

      @Semantics.quantity.unitOfMeasure: 'MeasurementUnit'
      TargetValue,
      @Semantics.quantity.unitOfMeasure: 'MeasurementUnit'
      ReferenceValue,
      @Semantics.quantity.unitOfMeasure: 'MeasurementUnit'
      MeasuredValue,
      @Semantics.quantity.unitOfMeasure: 'MeasurementUnit'
      ToleranceValue,
      @Semantics.quantity.unitOfMeasure: 'MeasurementUnit'
      DeviationValue,

      MeasurementUnit,
      PointResult,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Calibration : redirected to parent ZC_MP2_CALIBRATION
}
