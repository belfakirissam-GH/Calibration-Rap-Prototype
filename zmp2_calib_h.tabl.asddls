@EndUserText.label : 'Calibration Header'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zmp2_calib_h {
  key client           : abap.clnt not null;
  key calibration_uuid : abap.raw(16) not null;
  equipment_uuid       : abap.raw(16);
  calibration_id       : abap.char(20);
  calibration_date     : abap.dats;
  temperature          : abap.dec(5,2);
  temperature_unit     : abap.unit(3);
  overall_result       : zmp2_result;
  include zmp2_admin;
}
