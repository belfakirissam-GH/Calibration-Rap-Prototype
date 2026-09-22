CLASS zcl_mp2_fill DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_mp2_fill IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " Reset demo data (children first)
    DELETE FROM zmp2_calib_p.
    DELETE FROM zmp2_calib_h.
    DELETE FROM zmp2_equip.

    GET TIME STAMP FIELD DATA(now).

    " --- Equipment (fictitious data) ---
    DATA(equipment_uuid_1) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(equipment_uuid_2) = cl_system_uuid=>create_uuid_x16_static( ).

    INSERT zmp2_equip FROM TABLE @( VALUE #(
      ( client = sy-mandt  equipment_uuid = equipment_uuid_1
        equipment_id = 'EQ-0001'  description = 'Force sensor'
        manufacturer = 'Demo Measurement GmbH'  model_name = 'ForceSensor X100'
        serial_number = 'DEMO-4711'
        created_by = sy-uname  created_at = now
        last_changed_by = sy-uname  last_changed_at = now  local_last_changed_at = now )
      ( client = sy-mandt  equipment_uuid = equipment_uuid_2
        equipment_id = 'EQ-0002'  description = 'Force sensor'
        manufacturer = 'Demo Measurement GmbH'  model_name = 'ForceSensor X200'
        serial_number = 'DEMO-4712'
        created_by = sy-uname  created_at = now
        last_changed_by = sy-uname  last_changed_at = now  local_last_changed_at = now ) ) ).

    " --- Calibrations (reference the equipment above) ---
    DATA(cal_uuid_1) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(cal_uuid_2) = cl_system_uuid=>create_uuid_x16_static( ).

    INSERT zmp2_calib_h FROM TABLE @( VALUE #(
      ( client = sy-mandt  calibration_uuid = cal_uuid_1  equipment_uuid = equipment_uuid_1
        calibration_id = 'CAL-2026-001'  calibration_date = '20260901'
        temperature = '21.50'  temperature_unit = 'CEL'  overall_result = 'PENDING'
        created_by = sy-uname  created_at = now
        last_changed_by = sy-uname  last_changed_at = now  local_last_changed_at = now )
      ( client = sy-mandt  calibration_uuid = cal_uuid_2  equipment_uuid = equipment_uuid_2
        calibration_id = 'CAL-2026-002'  calibration_date = '20260910'
        temperature = '22.10'  temperature_unit = 'CEL'  overall_result = 'PENDING'
        created_by = sy-uname  created_at = now
        last_changed_by = sy-uname  last_changed_at = now  local_last_changed_at = now ) ) ).

    " --- Measurement points (reference the calibrations above) ---
    " Note: direct INSERT bypasses RAP; results stay PENDING here.
    " Creating through the business object runs the determination that
    " computes DeviationValue / PointResult / OverallResult.
    INSERT zmp2_calib_p FROM TABLE @( VALUE #(
      ( client = sy-mandt  point_uuid = cl_system_uuid=>create_uuid_x16_static( )
        calibration_uuid = cal_uuid_1  point_number = 1
        target_value = '100.000'  reference_value = '100.100'  measured_value = '99.900'
        tolerance_value = '1.500'  deviation_value = '0.000'  measurement_unit = 'N'
        point_result = 'PENDING'
        created_by = sy-uname  created_at = now
        last_changed_by = sy-uname  last_changed_at = now  local_last_changed_at = now )
      ( client = sy-mandt  point_uuid = cl_system_uuid=>create_uuid_x16_static( )
        calibration_uuid = cal_uuid_1  point_number = 2
        target_value = '200.000'  reference_value = '200.100'  measured_value = '199.700'
        tolerance_value = '1.500'  deviation_value = '0.000'  measurement_unit = 'N'
        point_result = 'PENDING'
        created_by = sy-uname  created_at = now
        last_changed_by = sy-uname  last_changed_at = now  local_last_changed_at = now )
      ( client = sy-mandt  point_uuid = cl_system_uuid=>create_uuid_x16_static( )
        calibration_uuid = cal_uuid_2  point_number = 1
        target_value = '100.000'  reference_value = '100.000'  measured_value = '97.500'
        tolerance_value = '1.500'  deviation_value = '0.000'  measurement_unit = 'N'
        point_result = 'PENDING'
        created_by = sy-uname  created_at = now
        last_changed_by = sy-uname  last_changed_at = now  local_last_changed_at = now ) ) ).

    out->write( 'Demo data inserted: 2 equipments, 2 calibrations, 3 points.' ).

  ENDMETHOD.

ENDCLASS.
