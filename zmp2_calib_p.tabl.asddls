@EndUserText.label : 'Calibration Measurement Points'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zmp2_calib_p {
  key client       : abap.clnt not null;
  key point_uuid   : abap.raw(16) not null;
  calibration_uuid : abap.raw(16);
  point_number     : abap.int2;
  target_value     : zmp2_target_val;
  reference_value  : zmp2_ref_val;
  measured_value   : zmp2_meas_val;
  tolerance_value  : zmp2_tol_val;
  deviation_value  : zmp2_dev_val;
  measurement_unit : abap.unit(3);
  point_result     : zmp2_result;
  include zmp2_admin;
}
