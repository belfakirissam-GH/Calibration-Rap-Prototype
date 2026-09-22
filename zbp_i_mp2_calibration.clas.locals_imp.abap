CLASS lhc_calibrationpoint DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculatePointResult FOR DETERMINE ON MODIFY
      keys FOR CalibrationPoint~calculatePointResult.

    METHODS ValidatePointData FOR VALIDATE ON SAVE
      keys FOR CalibrationPoint~ValidatePointData.

ENDCLASS.

CLASS lhc_calibrationpoint IMPLEMENTATION.

  METHOD calculatePointResult.

    " 1) Read the changed measurement points
    READ ENTITIES OF zi_mp2_calibration IN LOCAL MODE
      ENTITY CalibrationPoint
      FIELDS ( ReferenceValue MeasuredValue ToleranceValue )
      WITH CORRESPONDING #( keys )
      RESULT DATA(points).

    " 2) Determine deviation and per-point result
    MODIFY ENTITIES OF zi_mp2_calibration IN LOCAL MODE
      ENTITY CalibrationPoint
      UPDATE FIELDS ( DeviationValue PointResult )
      WITH VALUE #( FOR point IN points
        LET deviation = CONV zmp2_dev_val( abs( point-ReferenceValue - point-MeasuredValue ) ) IN
        ( %tky           = point-%tky
          DeviationValue = deviation
          PointResult    = COND #( WHEN deviation <= point-ToleranceValue
                                     THEN 'PASS'
                                   ELSE 'FAIL' ) ) ).

    " 3) Navigate from the changed points to their parent calibrations
    READ ENTITIES OF zi_mp2_calibration IN LOCAL MODE
      ENTITY CalibrationPoint BY \_Calibration
      FIELDS ( CalibrationUuid OverallResult )
      WITH CORRESPONDING #( keys )
      RESULT DATA(calibrations).

    " 4) Aggregate the overall result per calibration
    LOOP AT calibrations INTO DATA(calibration)
         GROUP BY calibration-CalibrationUuid.

      READ ENTITIES OF zi_mp2_calibration IN LOCAL MODE
        ENTITY Calibration BY \_Points
        FIELDS ( PointResult )
        WITH VALUE #( ( %tky = calibration-%tky ) )
        RESULT DATA(all_points).

      DATA(overall_result) = COND zmp2_result(
          WHEN all_points IS INITIAL                                THEN 'PENDING'
          WHEN line_exists( all_points[ PointResult = 'FAIL' ] )    THEN 'FAIL'
          WHEN line_exists( all_points[ PointResult = 'PENDING' ] ) THEN 'PENDING'
          ELSE                                                           'PASS' ).

      MODIFY ENTITIES OF zi_mp2_calibration IN LOCAL MODE
        ENTITY Calibration
        UPDATE FIELDS ( OverallResult )
        WITH VALUE #( ( %tky = calibration-%tky  OverallResult = overall_result ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD ValidatePointData.

    READ ENTITIES OF zi_mp2_calibration IN LOCAL MODE
      ENTITY CalibrationPoint
      FIELDS ( ToleranceValue )
      WITH CORRESPONDING #( keys )
      RESULT DATA(points).

    LOOP AT points INTO DATA(point).
      IF point-ToleranceValue <= 0.
        APPEND VALUE #( %tky = point-%tky ) TO failed-calibrationpoint.
        APPEND VALUE #( %tky                    = point-%tky
                        %msg                    = new_message(
                                                    id       = 'ZMP2_MSG'
                                                    number   = '001'
                                                    severity = if_abap_behv_message=>severity-error )
                        %element-ToleranceValue = if_abap_behv=>mk-on
                      ) TO reported-calibrationpoint.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.


CLASS lhc_Calibration DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR Calibration RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Calibration RESULT result.

    METHODS setInitialResult FOR DETERMINE ON MODIFY
      keys FOR Calibration~setInitialResult.

ENDCLASS.

CLASS lhc_Calibration IMPLEMENTATION.

  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(key).
      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<authorization>).
      <authorization>-%tky = key-%tky.
      IF requested_authorizations-%update = if_abap_behv=>mk-on.
        <authorization>-%update = if_abap_behv=>auth-allowed.
      ENDIF.
      IF requested_authorizations-%delete = if_abap_behv=>mk-on.
        <authorization>-%delete = if_abap_behv=>auth-allowed.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.
    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.
    IF requested_authorizations-%update = if_abap_behv=>mk-on.
      result-%update = if_abap_behv=>auth-allowed.
    ENDIF.
    IF requested_authorizations-%delete = if_abap_behv=>mk-on.
      result-%delete = if_abap_behv=>auth-allowed.
    ENDIF.
  ENDMETHOD.

  METHOD setInitialResult.
    " Set PENDING only when the result is still empty, so it never
    " overwrites a value already computed by calculatePointResult.
    READ ENTITIES OF zi_mp2_calibration IN LOCAL MODE
      ENTITY Calibration
      FIELDS ( OverallResult )
      WITH CORRESPONDING #( keys )
      RESULT DATA(calibrations).

    MODIFY ENTITIES OF zi_mp2_calibration IN LOCAL MODE
      ENTITY Calibration
      UPDATE FIELDS ( OverallResult )
      WITH VALUE #( FOR cal IN calibrations
                    WHERE ( OverallResult IS INITIAL )
                    ( %tky = cal-%tky  OverallResult = 'PENDING' ) ).
  ENDMETHOD.

ENDCLASS.
