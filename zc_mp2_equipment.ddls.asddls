@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Equipment Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_MP2_EQUIPMENT
  provider contract transactional_query
  as projection on ZI_MP2_EQUIPMENT
{
  key EquipmentUuid,
      EquipmentId,
      Description,
      Manufacturer,
      ModelName,
      SerialNumber,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
