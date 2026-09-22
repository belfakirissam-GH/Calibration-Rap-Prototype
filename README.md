# Calibration Data Management — ABAP Cloud / RAP Prototype

A prototype that models and manages measurement-equipment **calibration data** in SAP using the
ABAP RESTful Application Programming Model (RAP), Core Data Services (CDS) and an OData V4 service.
Built as **case study B** of a Master's project on transferring an object-oriented abstraction
principle to ERP-side data modelling.

> **Prototype / portfolio project.** Runs in a standalone ABAP Cloud environment (SAP BTP ABAP
> Environment). It is **not** connected to any productive SAP system. All data is fictitious.

## 1. Problem

Today, calibration results travel from the measurement software to SAP through a *media break*:
measurement software → PDF report → Excel macro → prepared file → manual upload. The data starts
structured, is turned into a human-readable document, and is then machine-read again.

## 2. Goal

Replace the manual chain with a structured, Clean-Core-compliant data model that receives
calibration data, evaluates it **rule-based (PASS/FAIL)** and exposes it as a standard OData V4
service — consumable by a UI or, in future, directly by the measurement application.

## 3. Data model

Three objects in a two-level hierarchy, plus a referenced equipment master:

```
Equipment  --(referenced, 1:n)-->  Calibration  --(composition, 1:n)-->  CalibrationPoint
```

- **Equipment** (`ZMP2_EQUIP`) — the test device. Referenced by the calibration and exposed
  **read-only**; in a productive landscape this would be resolved through a released SAP API
  instead of a local table.
- **Calibration** (`ZMP2_CALIB_H`) — one calibration event; references one Equipment.
- **CalibrationPoint** (`ZMP2_CALIB_P`) — one measurement point (composition child).

Own entities use a **UUID** key; the technical identity is separated from the business number.

## 4. Business logic (RAP behavior)

- **Determination `calculatePointResult`**: `deviation = |reference − measured|`;
  `PointResult = PASS` if `deviation ≤ tolerance`, else `FAIL`;
  `OverallResult = FAIL` as soon as any point is `FAIL` (else `PENDING`/`PASS`).
- **Determination `setInitialResult`**: sets `OverallResult = PENDING` on create, only while empty.
- **Validation `ValidatePointData`**: a point is only saved with a tolerance greater than zero
  (message `ZMP2_MSG` 001).

Evaluation happens rule-based **inside the system, before persistence** — not as a downstream
manual step.

## 5. Architecture (layers)

```
Tables → CDS Interface Views → Business Object (RAP, managed)
       → CDS Projection Views → Service Definition (+ Binding) → OData V4 → Fiori Elements
```

A **stable internal core** (tables, interface views, behavior) is separated from a **replaceable
external shell** (projections, service).

## 6. Repository structure

Source objects live under `src/`, named `<object>.<type>.<ext>`:

| Pattern | Content |
|---|---|
| `*.doma.asddls` | domains (`ZMP2_MEAS_D` DEC 15,3 · `ZMP2_RESULT_D` CHAR 10, values PENDING/PASS/FAIL) |
| `*.dtel.asddls` | data elements (measurement values, result) |
| `*.stru.asddls` | admin-field structure (`ZMP2_ADMIN`) |
| `*.tabl.asddls` | database tables |
| `*.ddls.asddls` | CDS interface (`ZI_*`) and projection (`ZC_*`) views |
| `*.bdef.asbdef` | behavior definitions (interface + projection) |
| `zbp_i_mp2_calibration.clas*` | behavior implementation (determinations, validation, authorization) |
| `zcl_mp2_fill.clas.abap` | demo-data loader (fictitious data) |
| `*.srvd.srvdsrv` | service definition (`ZUI_MP2_CALIBRATION`) |
| `zmp2_msg.msag.txt` | message class |

The OData **service binding** (OData V4 – UI) is created in ADT on top of the service definition;
as a binding configuration it has no source representation and is therefore not included here.

The files are a readable source export for review and portfolio use; the canonical objects live in
the ABAP Cloud system. DDIC objects (domains, data elements, structure) are shown in their ABAP
Cloud source form.

## 7. Clean Core

The prototype uses only released ABAP Cloud objects and does **not** modify SAP standard. The
equipment master is referenced and exposed read-only, not treated as an editable, owned object.

## 8. Scope and limitations

- Prototype in a standalone ABAP Cloud environment; no connection to a productive SAP system.
- Equipment is represented by a local table with fictitious data (stand-in for a released API).
- The machine-to-machine handover from the Delphi measurement software is described as *target
  architecture*, not implemented.

## 9. Future work

Direct integration: the measurement application sends calibration data to the OData V4 service via
HTTPS (`POST`), eliminating the PDF / Excel / manual-upload chain.

## 10. Academic context

Developed as case study B of a Master's project. The full write-up is in the thesis; this
repository contains the complete prototype source code.

## License

Choose according to your university / employer rules (e.g. MIT for a public portfolio).
