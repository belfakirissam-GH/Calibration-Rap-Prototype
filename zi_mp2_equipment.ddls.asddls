@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Equipment Interface View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_MP2_EQUIPMENT
  as select from zmp2_equip
{
  key equipment_uuid        as EquipmentUuid,
      equipment_id          as EquipmentId,
      description           as Description,
      manufacturer          as Manufacturer,
      model_name            as ModelName,
      serial_number         as SerialNumber,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
