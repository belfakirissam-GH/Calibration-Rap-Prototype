@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calibration Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_MP2_CALIBRATION
  provider contract transactional_query
  as projection on ZI_MP2_CALIBRATION
{
  key CalibrationUuid,
      EquipmentUuid,
      CalibrationId,
      CalibrationDate,

      @Semantics.quantity.unitOfMeasure: 'TemperatureUnit'
      Temperature,
      TemperatureUnit,
      OverallResult,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Equipment : redirected to ZC_MP2_EQUIPMENT,
      _Points    : redirected to composition child ZC_MP2_CALIBRATIONPOINT
}
