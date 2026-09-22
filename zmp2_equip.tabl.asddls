@EndUserText.label : 'Calibration Equipment'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zmp2_equip {
  key client         : abap.clnt not null;
  key equipment_uuid : abap.raw(16) not null;
  equipment_id       : abap.char(20);
  description        : abap.char(60);
  manufacturer       : abap.char(60);
  model_name         : abap.char(40);
  serial_number      : abap.char(40);
  include zmp2_admin;
}
