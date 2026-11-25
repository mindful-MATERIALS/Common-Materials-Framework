<!-- Generated from the BuildingEase CMF schema. Do not edit by hand; regenerate with `npm -w packages/shared run docs:cmf`. -->

# CMF Structure Reference

**Schema version:** `1`

**Machine-readable definition:** [`cmf-structure.schema.json`](./cmf-structure.schema.json) (JSON Schema, draft 2020-12)

## Overview

The Common Materials Framework (CMF) structure is a JSON document that describes one product's sustainability attributes across five impact areas: Human Health, Climate Health, Circular Economy, Social Health & Equity, and Ecosystem Health. Each value in the document records which data source it came from, such as an Environmental Product Declaration (EPD), a Health Product Declaration (HPD), or the product's own data.

## Document structure

| Property | Type | Description |
|---|---|---|
| `schemaVersion` | integer | The version of this structure the document follows; `1` for this reference. See [Versioning](#versioning). |
| `sources` | array of Source | Every data source referenced by a value in the document. See [Sources](#sources). |
| `updatedTimestamp` | string | When the document was generated, as an ISO 8601 date-time in UTC. |
| `impactAreas` | object | The CMF fields, grouped by impact area, then topic and aspect. See [Field reference](#field-reference). |

A complete, valid example:

```json
{
  "schemaVersion": 1,
  "sources": [
    {
      "name": "hpd",
      "id": 401233,
      "certId": "HPD-2024-0412",
      "typeName": "HPD",
      "typeId": 129,
      "issuedAt": "2024-03-01",
      "expiresAt": "2027-03-01"
    },
    {
      "name": "declare",
      "id": 401540,
      "typeName": "Declare",
      "typeId": 130
    },
    {
      "name": "epd",
      "id": 415582,
      "typeName": "EPD",
      "typeId": 131,
      "issuedAt": "2024-01-24",
      "expiresAt": "2029-01-23"
    }
  ],
  "updatedTimestamp": "2026-11-09T15:04:05.000Z",
  "impactAreas": {
    "humanHealth": {
      "substances": {
        "transparency": {
          "thirdPartyVerified": [
            {
              "value": true,
              "source": "hpd"
            },
            {
              "value": true,
              "source": "declare"
            }
          ],
          "reportingThresholdLevel": [
            {
              "value": "100 ppm",
              "source": "hpd"
            }
          ]
        }
      }
    },
    "climateHealth": {
      "embodiedCarbon": {
        "transparency": {
          "carbonAssessmentType": [
            {
              "value": "product_specific_epd_sku_specific_parameters",
              "source": "epd"
            }
          ]
        },
        "optimization": {
          "carbonReduction": {
            "percentCo2eReduced": [
              {
                "value": 18.5,
                "source": "epd"
              }
            ],
            "carbonReductionMethod": {
              "energyReduction": [
                {
                  "value": 12,
                  "source": "epd"
                }
              ],
              "productDesign": [
                {
                  "value": 6.5,
                  "source": null
                }
              ]
            }
          }
        }
      }
    }
  }
}
```

## Sources

Each entry in `sources` describes one data source that supplied at least one value. Names are unique within a document, and values refer to their source by name. Certification sources are named after the certification type (for example `epd`, `hpd`, `declare`); data taken from the product or manufacturer record uses `Product` or `Manufacturer`.

| Property | Type | Required | Description |
|---|---|---|---|
| `name` | string | yes | Unique name, referenced by field records. |
| `id` | integer | no | BuildingEase identifier of the certification record. |
| `certId` | string | no | Certificate or declaration number assigned by the issuing program. |
| `typeName` | string | no | Certification type, e.g. `EPD`, `HPD`, `Declare`. |
| `typeId` | integer | no | BuildingEase identifier of the certification type. |
| `issuedAt` | string | no | Issue date, `YYYY-MM-DD`. |
| `expiresAt` | string | no | Expiration date, `YYYY-MM-DD`. |
| `description` | string | no | Description of the certified product or declaration. |

Product and manufacturer sources usually carry only `name`. Sources may include additional properties in future versions; ignore any you don't recognize.

## Field values

Every field holds a list of records. Each record pairs a value with the source it came from:

```json
[
  {
    "value": true,
    "source": "hpd"
  },
  {
    "value": true,
    "source": "declare"
  }
]
```

- **Several records.** A field has more than one record when its value was determined from more than one source, or when different sources reported different values. Records are listed in the order the sources were evaluated, with at most one record per source.
- **`source`** is the `name` of an entry in `sources`, or `null` when the value is not attributed to a data source (for example, a value set directly by BuildingEase's assessment rules).
- **`value: null`** means the source was consulted but did not provide that information.
- **Omitted fields.** A field is omitted when no value was determined for it, and a section is omitted when none of its fields have values. An empty list means the same as an omitted field.

### Value types

| Type | JSON value |
|---|---|
| Boolean | `true` or `false` |
| Number | A JSON number. The field's unit is given in the reference below. |
| Text | A string. |
| Single select | A string: the chosen entry's value (below). |
| Rating | A string: the rating level (below). |
| Structured | An object of named sub-fields. Each sub-field is its own list of records; some sub-fields are nested in a group. |

**Single select.** The value is the chosen entry's stable identifier, not its display label. The values and labels for each enumeration are listed in [Appendix A](#appendix-a-single-select-values).

```json
[
  {
    "value": "product_specific_epd_sku_specific_parameters",
    "source": "epd"
  }
]
```

**Rating.** The value identifies a level of the field's rating scale; it is the level's stable identifier, which can differ from its display name. The values, names and scores of each scale's levels, where a higher score is a better outcome, are listed in [Appendix B](#appendix-b-rating-scales).

```json
[
  {
    "value": "100 ppm",
    "source": "hpd"
  }
]
```

**Structured.** Each sub-field holds its own records, so different sub-fields can come from different sources:

```json
{
  "percentCo2eReduced": [
    {
      "value": 18.5,
      "source": "epd"
    }
  ],
  "carbonReductionMethod": {
    "energyReduction": [
      {
        "value": 12,
        "source": "epd"
      }
    ],
    "productDesign": [
      {
        "value": 6.5,
        "source": null
      }
    ]
  }
}
```

## Versioning

This reference describes schema version `1`. Every CMF document states the version it follows in `schemaVersion`. The version increases by one whenever the structure changes: a field added, removed or retyped, or a change to how values are written. Each version is published with its own JSON Schema and reference, so check `schemaVersion` before reading a document.

## Validation

Validate documents with any JSON Schema draft 2020-12 validator, for example Ajv (JavaScript) or `jsonschema` (Python). The schema checks the document's shape, value types, single-select values and rating levels. The allowed values and levels are the ones in effect when this reference was generated; a value added since then is valid but fails validation until the next reference. One rule can't be expressed in JSON Schema, so check it separately: every non-null record `source` must match the `name` of an entry in `sources`.

The schema uses the `date` and `date-time` formats. Ajv 8 does not know them by default and rejects the schema when it compiles it: add the `ajv-formats` package (`addFormats(ajv)`), or turn format validation off with `validateFormats: false`.

## Field reference

The schema defines 56 fields; structured fields add 90 sub-fields. Each table lists the fields of one aspect. **Key** is the property name under the section's path. A sub-field (↳) row shows only the sub-field's own key, which sits inside its parent field's object (the nearest row above without ↳); a dotted sub-field key denotes a nested group. **Type** gives the value type, with the value list, rating scale or unit where one applies.

### 1. HUMAN HEALTH

Path: `impactAreas.humanHealth`

Materials and the chemicals and processes used to make them impact human health at every stage, from manufacturing to use to disposal.

#### 1.1 Substances

Path: `impactAreas.humanHealth.substances` · Applies to: product

Substances are defined by the EPA as any organic or inorganic substance of a particular molecular identity. The CMF includes factors such as percentage of disclosure, disclosure granularity, restricted substance lists, and class-based chemical avoidance.

##### 1.1.1 Transparency

Path: `impactAreas.humanHealth.substances.transparency`

| # | Field | Key | Type |
|---|---|---|---|
| 1.1.1.1 | Reporting Threshold Level | `reportingThresholdLevel` | Rating: *Reporting Threshold* (Appendix B) |
| 1.1.1.2 | Third-Party Verified | `thirdPartyVerified` | Boolean |
| 1.1.1.3 | Extent of Disclosed Inventory | `extentOfDisclosedInventory` | Structured |
| 1.1.1.3.1 | ↳ % Disclosed | `percentDisclosed` | Rating: *% Disclosed* (Appendix B) |
| 1.1.1.3.2 | ↳ Publicly Disclosed | `publiclyDisclosed` | Boolean |
| 1.1.1.4 | Screened | `screened` | Boolean |
| 1.1.1.5 | Characterized | `characterized` | Boolean |
| 1.1.1.6 | Identified | `identified` | Boolean |

##### 1.1.4 Optimization

Path: `impactAreas.humanHealth.substances.optimization`

| # | Field | Key | Type |
|---|---|---|---|
| 1.1.4.1 | Class-Based Substance Avoidance | `classBasedSubstanceAvoidance` | Structured |
| 1.1.4.1.1 | ↳ No Alkylphenols (APEs) | `noAlkylphenols` | Boolean |
| 1.1.4.1.2 | ↳ No Antimicrobials | `noAntimicrobials` | Boolean |
| 1.1.4.1.3 | ↳ No Azo Dyes | `noAzoDyes` | Boolean |
| 1.1.4.1.4 | ↳ No Bisphenols | `noBisphenols` | Boolean |
| 1.1.4.1.5 | ↳ No Chlorophenols (All) | `noChlorophenols` | Boolean |
| 1.1.4.1.6 | ↳ No Crumb Rubber (aka Tire-Derived Rubber) | `noCrumbRubber` | Boolean |
| 1.1.4.1.7 | ↳ No Flame Retardants | `noFlameRetardants` | Boolean |
| 1.1.4.1.8 | ↳ No Fly Ash | `noFlyAsh` | Boolean |
| 1.1.4.1.9 | ↳ No Formaldehydes | `noFormaldehydes` | Boolean |
| 1.1.4.1.10 | ↳ No Isocyanates | `noIsocyanates` | Boolean |
| 1.1.4.1.11 | ↳ No Methyl & Acrylate Groups | `noMethylAndAcrylateGroups` | Boolean |
| 1.1.4.1.12 | ↳ No Ortho-Phthalates | `noOrthoPhthalates` | Boolean |
| 1.1.4.1.13 | ↳ No PFAS | `noPfas` | Boolean |
| 1.1.4.1.14 | ↳ No Polyvinyl Chloride (PVC) / Chlorinated Polyvinyl Chloride (CPVC) | `noPvcCpvc` | Boolean |
| 1.1.4.1.15 | ↳ No Styrene Butadiene Rubber (SBR) | `noSbr` | Boolean |
| 1.1.4.1.16 | ↳ No Toxic Metals & Compounds | `noToxicMetalsAndCompounds` | Boolean |
| 1.1.4.2 | Assessment-Based Optimization | `assessmentBasedOptimization` | Rating: *Assessment-Based Optimization Levels* (Appendix B) |
| 1.1.4.3 | Restricted Substance List (RSL) Screening Compliance | `restrictedSubstanceListScreeningCompliance` | Structured |
| 1.1.4.3.1 | ↳ CA EPA - Prop 65 | `caEpaProp65` | Boolean |
| 1.1.4.3.2 | ↳ Cradle to Cradle Restricted Substances (version 4) | `c2cRestrictedV4` | Boolean |
| 1.1.4.3.3 | ↳ Cradle to Cradle Banned List Substances (version 3) | `c2cBannedListV3` | Boolean |
| 1.1.4.3.4 | ↳ Green Science Policy Institute Six Classes | `gspiSixClasses` | Boolean |
| 1.1.4.3.5 | ↳ GreenScreen BM-1 or LT-1 Chemicals | `greenScreenBm1Lt1` | Boolean |
| 1.1.4.3.6 | ↳ HCWH Healthy Interiors: Furniture & Furnishings, v2.4 | `hcwhHealthyInteriorsV24` | Boolean |
| 1.1.4.3.7 | ↳ Kaiser Permanente EPP Chemicals of Concern | `kaiserPermanenteEpp` | Boolean |
| 1.1.4.3.8 | ↳ Living Building Challenge Red List Substances - v4.0 (April 2024 Update) | `lbcRedListV40Apr2024` | Boolean |
| 1.1.4.3.9 | ↳ Living Building Challenge Red List Substances - v4.0 (April 2023 Update) | `lbcRedListV40Apr2023` | Boolean |
| 1.1.4.3.10 | ↳ Perkins+Will Precautionary List | `perkinsWillPrecautionary` | Boolean |
| 1.1.4.3.11 | ↳ REACH Candidate List of Substances of Very High Concern (SVHC) | `reachSvhc` | Boolean |
| 1.1.4.3.12 | ↳ REACH Authorization List (Annex XIV) | `reachAnnexXiv` | Boolean |
| 1.1.4.3.13 | ↳ REACH Restrictions List (Annex XVII) | `reachAnnexXvii` | Boolean |
| 1.1.4.3.14 | ↳ US EPA - Toxics Release Inventory PBTs | `epaTriPbts` | Boolean |
| 1.1.4.3.15 | ↳ RoHS Restricted Substances, EU (ANNEX II, Version 2.0) | `rohsAnnexIiV2` | Boolean |

#### 1.2 VOCs

Path: `impactAreas.humanHealth.vocs` · Applies to: product

Volatile organic compounds (VOCs) are chemicals frequently used in interior products and finishes which may off-gas at room temperature.

##### 1.2.2 Assessment

Path: `impactAreas.humanHealth.vocs.assessment`

| # | Field | Key | Type |
|---|---|---|---|
| 1.2.2.1 | Applicable VOC Testing | `applicableVocTesting` | Structured |
| 1.2.2.1.1 | ↳ VOC Content | `vocContent` | Boolean |
| 1.2.2.1.2 | ↳ VOC Emissions | `vocEmissions` | Boolean |
| 1.2.2.1.3 | ↳ Formaldehyde Emissions | `formaldehydeEmissions` | Boolean |
| 1.2.2.1.4 | ↳ Inherently Non-Emitting | `inherentlyNonEmitting` | Boolean |
| 1.2.2.2 | VOC Content (Regulatory) | `vocContentRegulatory` | Number (g/L) |

##### 1.2.4 Optimization

Path: `impactAreas.humanHealth.vocs.optimization`

| # | Field | Key | Type |
|---|---|---|---|
| 1.2.4.1 | VOC Content - CARB 2007 Compliance | `vocContentCarb2007Compliance` | Boolean |
| 1.2.4.2 | VOC Content - SCAQMD Compliance Level | `vocContentScaqmdComplianceLevel` | Single select: *VOC Content - SCAQMD Compliance Level* (Appendix A) |
| 1.2.4.3 | VOC Emissions Compliance | `vocEmissionsCompliance` | Structured |
| 1.2.4.3.1 | ↳ CDPH Standard Method v1.2-2017 | `cdphV122017` | Boolean |
| 1.2.4.3.2 | ↳ Green Label Plus (GLP) Emissions Criteria v2.01-2017 | `glpV2012017` | Boolean |
| 1.2.4.3.3 | ↳ Inherently Non-Emitting | `inherentlyNonEmitting` | Boolean |
| 1.2.4.4 | TVOC Emissions Range | `tvocEmissionsRange` | Rating: *TVOC Emissions Range* (Appendix B) |
| 1.2.4.5 | Emissions Modeling Scenario for Compliance | `emissionsModelingScenarioForCompliance` | Structured |
| 1.2.4.5.1 | ↳ Private Office Scenario | `privateOffice` | Boolean |
| 1.2.4.5.2 | ↳ Open Plan Office Scenario | `openPlanOffice` | Boolean |
| 1.2.4.5.3 | ↳ School Classroom Scenario | `schoolClassroom` | Boolean |
| 1.2.4.5.4 | ↳ Single-Family Residence Scenario | `singleFamilyResidence` | Boolean |
| 1.2.4.5.5 | ↳ Seating Scenario | `seating` | Boolean |
| 1.2.4.6 | Composite Wood - Formaldehyde Emissions Compliance (CARB & TSCA Title VI) | `compositeWoodFormaldehydeEmissionsCompliance` | Single select: *Composite Wood - Formaldehyde Emissions Compliance (CARB & TSCA Title VI)* (Appendix A) |
| 1.2.4.7 | Furniture - ANSI/BIFMA M7.1-2011 Compliance | `furnitureAnsiBifmaM71Compliance` | Structured |
| 1.2.4.7.1 | ↳ Section 7.6.1 | `section761` | Boolean |
| 1.2.4.7.2 | ↳ Section 7.6.2 | `section762` | Boolean |
| 1.2.4.7.3 | ↳ Section 7.6.3 | `section763` | Boolean |

### 2. CLIMATE HEALTH

Path: `impactAreas.climateHealth`

Materials and the energy used to extract, manufacture, move, and install them have a major impact on climate.

#### 2.1 Embodied Carbon

Path: `impactAreas.climateHealth.embodiedCarbon` · Applies to: product

##### 2.1.1 Transparency

Path: `impactAreas.climateHealth.embodiedCarbon.transparency`

| # | Field | Key | Type |
|---|---|---|---|
| 2.1.1.1 | Carbon Assessment Type<br>EPD and LCA types range from highly specific third-party verified product assessments to broader industry-average or internal assessments. | `carbonAssessmentType` | Single select: *Carbon Assessment Type* (Appendix A) |
| 2.1.1.2 | Third-Party Verified<br>Third-party verification demonstrates that the data was collected with the applicable PCR and meets relevant ISO requirements. | `thirdPartyVerified` | Single select: *Embodied Carbon - Third-Party Verified* (Appendix A) |
| 2.1.1.3 | EPD Standard(s) Used | `epdStandardsUsed` | Structured |
| 2.1.1.3.1 | ↳ ISO 14025 | `iso14025` | Boolean |
| 2.1.1.3.2 | ↳ ISO 21930 | `iso21930` | Boolean |
| 2.1.1.3.3 | ↳ EN 15804 | `en15804` | Boolean |
| 2.1.1.3.4 | ↳ EN 15804 + A2 | `en15804A2` | Boolean |
| 2.1.1.4 | Service Life / Extended Utility | `serviceLifeExtendedUtility` | Structured (years) |
| 2.1.1.4.1 | ↳ # of years (per PCR) | `yearsPerPcr` | Number (years) |
| 2.1.1.4.2 | ↳ Product Lifetime - Warranty | `productLifetimeWarranty` | Number (years) |
| 2.1.1.4.3 | ↳ Average Lifetime for Product Category | `averageLifetimeForProductCategory` | Number (years) |
| 2.1.1.5 | Declared Unit | `declaredUnit` | Single select: *Declared Unit* (Appendix A) |
| 2.1.1.6 | Reported GWP (A1-A3) per Unit (kgCO2e)<br>Reported Global Warming Potential for Life Cycle Production stage modules A1-A3. | `reportedGwpA1A3PerUnit` | Structured (kgCO2e) |
| 2.1.1.6.1 | ↳ GWP - total | `gwpTotal` | Number (kgCO2e) |
| 2.1.1.6.2 | ↳ GWP - biogenic | `gwpBiogenic` | Number (kgCO2e) |
| 2.1.1.6.3 | ↳ GWP - fossil | `gwpFossil` | Number (kgCO2e) |
| 2.1.1.6.4 | ↳ GWP - luluc | `gwpLuluc` | Number (kgCO2e) |
| 2.1.1.7 | Product Category Rule (PCR) Information<br>A PCR provides instructions for how an LCA should be conducted for a particular product type or category. | `productCategoryRuleInformation` | Text |
| 2.1.1.8 | Declared Modules | `declaredModules` | Structured |
| 2.1.1.8.1 | ↳ Product Stage (Cradle to Gate) A1-A3 | `productStageA1A3` | Boolean |
| 2.1.1.8.2 | ↳ Construction Stage (A4-A5) | `constructionStageA4A5` | Boolean |
| 2.1.1.8.3 | ↳ Use Stage (B1-B5) | `useStageB1B5` | Boolean |
| 2.1.1.8.4 | ↳ End of Life Stage (C1-C4) | `endOfLifeStageC1C4` | Boolean |
| 2.1.1.8.5 | ↳ Reuse / Recovery / Recycling Potential (D) | `reuseRecoveryRecyclingPotentialD` | Boolean |
| 2.1.1.8.6 | ↳ All Stages (Cradle-to-Grave) | `allStagesCradleToGrave` | Boolean |
| 2.1.1.9 | kg per Declared Unit | `kgPerDeclaredUnit` | Number (kg) |

##### 2.1.4 Optimization

Path: `impactAreas.climateHealth.embodiedCarbon.optimization`

| # | Field | Key | Type |
|---|---|---|---|
| 2.1.4.1 | Carbon Reduction | `carbonReduction` | Structured (%) |
| 2.1.4.1.1 | ↳ % co2e Reduced (%) | `percentCo2eReduced` | Number (%) |
| 2.1.4.1.2.1 | ↳ Carbon Reduction Method: Energy Reduction | `carbonReductionMethod.energyReduction` | Number (%) |
| 2.1.4.1.2.2 | ↳ Carbon Reduction Method: Product Design | `carbonReductionMethod.productDesign` | Number (%) |
| 2.1.4.1.2.3 | ↳ Carbon Reduction Method: Scope 3 Reduction | `carbonReductionMethod.scope3Reduction` | Number (%) |
| 2.1.4.1.2.4 | ↳ Carbon Reduction Method: Other | `carbonReductionMethod.other` | Number (%) |
| 2.1.4.2 | Carbon Handprinting | `carbonHandprinting` | Number (%) |
| 2.1.4.3 | Carbon Storage | `carbonStorage` | Structured |
| 2.1.4.3.1 | ↳ Contains Biogenic Carbon | `containsBiogenicCarbon` | Boolean |
| 2.1.4.3.2 | ↳ Actively Carbon Absorbing | `activelyCarbonAbsorbing` | Boolean |
| 2.1.4.4 | Carbon Offset | `carbonOffset` | Structured |
| 2.1.4.4.1 | ↳ % of Product Offset (0-200%) | `percentOfProductOffset` | Number |
| 2.1.4.4.2 | ↳ Third-Party Verified | `thirdPartyVerified` | Boolean |
| 2.1.4.4.3 | ↳ Type of Offset | `typeOfOffset` | Single select: *Type of Offset* (Appendix A) |

#### 2.2 Company Carbon Impact

Path: `impactAreas.climateHealth.companyCarbonImpact` · Applies to: company

##### 2.2.1 Transparency

Path: `impactAreas.climateHealth.companyCarbonImpact.transparency`

| # | Field | Key | Type |
|---|---|---|---|
| 2.2.1.1 | Methodology for Calculating Baseline | `methodologyForCalculatingBaseline` | Single select: *Methodology for Calculating Baseline* (Appendix A) |
| 2.2.1.2 | Organizational Boundary | `organizationalBoundary` | Single select: *Organizational Boundary* (Appendix A) |
| 2.2.1.3 | Public Disclosure of Company Emissions | `publicDisclosureOfCompanyEmissions` | Structured |
| 2.2.1.3.1 | ↳ Climate Registry | `climateRegistry` | Boolean |
| 2.2.1.3.2 | ↳ CDP | `cdp` | Boolean |
| 2.2.1.3.3 | ↳ GRI | `gri` | Boolean |
| 2.2.1.3.4 | ↳ SBTi | `sbti` | Boolean |
| 2.2.1.3.5 | ↳ Company Report / Website | `companyReportWebsite` | Boolean |
| 2.2.1.4 | Est. GHG Emissions Inventory for Scope 1 | `estimatedGhgEmissionsInventoryScope1` | Boolean |
| 2.2.1.5 | Est. GHG Emissions Inventory for Scope 2 | `estimatedGhgEmissionsInventoryScope2` | Single select: *Est. GHG Emissions Inventory for Scope 2* (Appendix A) |
| 2.2.1.6 | Est. GHG Emissions Inventory for Scope 3 | `estimatedGhgEmissionsInventoryScope3` | Single select: *Est. GHG Emissions Inventory for Scope 3* (Appendix A) |

##### 2.2.3 Commitments

Path: `impactAreas.climateHealth.companyCarbonImpact.commitments`

| # | Field | Key | Type |
|---|---|---|---|
| 2.2.3.1 | Participation in Initiatives | `participationInInitiatives` | Boolean |

##### 2.2.4 Optimization

Path: `impactAreas.climateHealth.companyCarbonImpact.optimization`

| # | Field | Key | Type |
|---|---|---|---|
| 2.2.4.1 | Certifications/Disclosures | `certificationsDisclosures` | Boolean |

### 3. CIRCULAR ECONOMY

Path: `impactAreas.circularEconomy`

A circular economy keeps materials in use for as long as possible, reducing waste, preserving value, and minimizing harm.

#### 3.1 Sourcing

Path: `impactAreas.circularEconomy.sourcing` · Applies to: product

##### 3.1.1 Transparency

Path: `impactAreas.circularEconomy.sourcing.transparency`

| # | Field | Key | Type |
|---|---|---|---|
| 3.1.1.1 | Final Manufacturing Location | `finalManufacturingLocation` | Structured |
| 3.1.1.1.1 | ↳ City | `city` | Text |
| 3.1.1.1.2 | ↳ State | `state` | Text |
| 3.1.1.1.3 | ↳ Postal code | `postalCode` | Text |
| 3.1.1.1.4 | ↳ Country | `country` | Text |
| 3.1.1.2 | Regenerative & Renewable Content Percentages (%) | `regenerativeAndRenewableContentPercentages` | Text |
| 3.1.1.3 | Reintegrated Content (%) | `reintegratedContent` | Number |

#### 3.2 End-of-Life

Path: `impactAreas.circularEconomy.endOfLife` · Applies to: product

##### 3.2.1 Transparency

Path: `impactAreas.circularEconomy.endOfLife.transparency`

| # | Field | Key | Type |
|---|---|---|---|
| 3.2.1.1 | End of Life Guidance Provided | `endOfLifeGuidanceProvided` | Text |
| 3.2.1.2 | Guidance Provided on Physical Product | `guidanceProvidedOnPhysicalProduct` | Boolean |

##### 3.2.4 Optimization

Path: `impactAreas.circularEconomy.endOfLife.optimization`

| # | Field | Key | Type |
|---|---|---|---|
| 3.2.4.1 | Extended Producer Responsibility (Take Back) Programs | `extendedProducerResponsibilityTakeBackPrograms` | Text |

#### 3.3 Company Facility Waste

Path: `impactAreas.circularEconomy.companyFacilityWaste` · Applies to: company

##### 3.3.4 Optimization

Path: `impactAreas.circularEconomy.companyFacilityWaste.optimization`

| # | Field | Key | Type |
|---|---|---|---|
| 3.3.4.1 | Facility Waste Diversion | `facilityWasteDiversion` | Boolean |

### 4. SOCIAL HEALTH & EQUITY

Path: `impactAreas.socialHealthAndEquity`

#### 4.1 Company Workplace

Path: `impactAreas.socialHealthAndEquity.companyWorkplace` · Applies to: company

##### 4.1.1 Transparency

Path: `impactAreas.socialHealthAndEquity.companyWorkplace.transparency`

| # | Field | Key | Type |
|---|---|---|---|
| 4.1.1.1 | Corporate Social Responsibility (CSR) and/or Environmental Social Governance (ESG) Reporting Type | `corporateSocialResponsibilityAndEsgReportingType` | Text |

#### 4.2 Company Ownership

Path: `impactAreas.socialHealthAndEquity.companyOwnership` · Applies to: company

##### 4.2.1 Transparency

Path: `impactAreas.socialHealthAndEquity.companyOwnership.transparency`

| # | Field | Key | Type |
|---|---|---|---|
| 4.2.1.2 | Business Enterprise Categorization | `businessEnterpriseCategorization` | Text |

#### 4.3 Supply Chain (Product)

Path: `impactAreas.socialHealthAndEquity.productSupplyChain` · Applies to: product

##### 4.3.1 Transparency

Path: `impactAreas.socialHealthAndEquity.productSupplyChain.transparency`

| # | Field | Key | Type |
|---|---|---|---|
| 4.3.1.1 | Raw Material Supply Chain Standards | `rawMaterialSupplyChainStandards` | Boolean |
| 4.3.1.2 | Design for Freedom (DFF) Supplier Questionnaire | `designForFreedomSupplierQuestionnaire` | Boolean |

#### 4.4 Supply Chain (Company)

Path: `impactAreas.socialHealthAndEquity.companySupplyChain` · Applies to: company

##### 4.4.1 Transparency

Path: `impactAreas.socialHealthAndEquity.companySupplyChain.transparency`

| # | Field | Key | Type |
|---|---|---|---|
| 4.4.1.1 | Company Supply Chain Standards | `companySupplyChainStandards` | Text |

### 5. ECOSYSTEM HEALTH

Path: `impactAreas.ecosystemHealth`

#### 5.1 Environmental Impacts

Path: `impactAreas.ecosystemHealth.environmentalImpacts` · Applies to: product

##### 5.1.1 Transparency

Path: `impactAreas.ecosystemHealth.environmentalImpacts.transparency`

| # | Field | Key | Type |
|---|---|---|---|
| 5.1.1.1 | Certified Wood | `certifiedWood` | Number (%) |
| 5.1.1.2 | Biobased Content | `biobasedContent` | Number (%) |
| 5.1.1.3 | Responsibly Sourced Stone | `responsiblySourcedStone` | Number (%) |

##### 5.1.2 Assessment

Path: `impactAreas.ecosystemHealth.environmentalImpacts.assessment`

| # | Field | Key | Type |
|---|---|---|---|
| 5.1.2.1 | TRACI Additional Impact Areas (#) | `traciAdditionalImpactAreas` | Structured |
| 5.1.2.1.1 | ↳ Ozone depletion potential | `ozoneDepletionPotential` | Number |
| 5.1.2.1.2 | ↳ Acidification potential | `acidificationPotential` | Number |
| 5.1.2.1.3 | ↳ Eutrophication potential | `eutrophicationPotential` | Number |
| 5.1.2.1.4 | ↳ Smog formation potential | `smogFormationPotential` | Number |
| 5.1.2.1.5 | ↳ Abiotic depletion potential | `abioticDepletionPotential` | Number |
| 5.1.2.1.6 | ↳ Eco-toxicity | `ecoToxicity` | Number |

#### 5.2 Biodiversity & Conservation

Path: `impactAreas.ecosystemHealth.biodiversityAndConservation` · Applies to: product

##### 5.2.1 Transparency

Path: `impactAreas.ecosystemHealth.biodiversityAndConservation.transparency`

| # | Field | Key | Type |
|---|---|---|---|
| 5.2.1.2 | Standards for Company Impacts on Biodiversity & Conservation | `standardsForCompanyImpactsOnBiodiversityAndConservation` | Text |

## Appendix A: Single-select values

### Carbon Assessment Type

| Value | Label |
|---|---|
| `product_specific_epd_sku_specific_parameters` | Product Specific EPD - SKU Specific Parameters |
| `product_specific_epd_manufacturer_specific` | Product Specific EPD - Manufacturer Specific |
| `product_lca` | Product LCA |
| `lca_internal` | LCA - Internal |
| `industry_average_epd` | Industry-Average EPD |
| `pcf_iso_14067` | PCF (ISO 14067) |
| `product_specific_epd_plant_specific` | Product Specific EPD - Plant Specific |
| `product_specific_epd_batch_specific` | Product Specific EPD - Batch Specific |
| `product_specific_epd_supply_chain_specific` | Product Specific EPD - Supply Chain Specific |

### Composite Wood - Formaldehyde Emissions Compliance (CARB & TSCA Title VI)

| Value | Label |
|---|---|
| `no_added_formaldehyde` | No Added Formaldehyde (NAF) |
| `ultra_low_emitting_formaldehyde` | Ultra Low Emitting Formaldehyde (ULEF) |
| `carb_exempt` | CARB Exempt |
| `not_applicable` | N/A |

### Declared Unit

| Value | Label |
|---|---|
| `1_ft` | 1 ft |
| `1_ft2` | 1 ft2 |
| `1_ft3` | 1 ft3 |
| `1_item` | 1 item |
| `1_m` | 1 m |
| `1_m2` | 1 m2 |
| `1_m3` | 1 m3 |
| `1_lbs` | 1 lbs |
| `1_yd3` | 1 yd3 |
| `1_kg` | 1 kg |

### Embodied Carbon - Third-Party Verified

| Value | Label |
|---|---|
| `yes_third_party_verified` | Yes, 3rd Party (Externally) Verified |
| `no` | No |
| `yes_internally_verified` | Yes, Internally Verified |

### Est. GHG Emissions Inventory for Scope 2

| Value | Label |
|---|---|
| `location_based` | Location-Based |
| `market_based` | Market-Based |
| `both_location_and_market` | Both Location + Market GHG Inventory has been established |
| `none` | None |

### Est. GHG Emissions Inventory for Scope 3

| Value | Label |
|---|---|
| `yes` | yes |
| `in_progress` | in progress |
| `no` | no |

### Methodology for Calculating Baseline

| Value | Label |
|---|---|
| `ghg_protocol` | GHG Protocol |
| `sbti` | SBTi |

### Organizational Boundary

| Value | Label |
|---|---|
| `equity_share_approach` | Equity Share Approach |
| `control_approach_financial` | Control Approach - Financial |
| `control_approach_operational` | Control Approach - Operational |

### Type of Offset

| Value | Label |
|---|---|
| `nature_based` | Nature Based |
| `carbon_removal_other` | Carbon Removal - Other |

### VOC Content - SCAQMD Compliance Level

| Value | Label |
|---|---|
| `rule_1113_compliant` | SCAQMD Rule 1113 (Architectural Coatings) - Compliant ("Low-VOC") |
| `rule_1113_super_compliant` | SCAQMD Rule 1113 (Architectural Coatings) - Super-Compliant (<10 g/L) |
| `rule_1168_compliant` | SCAQMD Rule 1168 (Adhesive and Sealants) - Compliant |
| `rule_1168_super_compliant` | SCAQMD Rule 1168 (Adhesive and Sealants) - Super Compliant |
| `non_compliant` | Non-Compliant |

## Appendix B: Rating scales

### % Disclosed

| Value | Level | Score |
|---|---|---|
| `≥75% disclosed inventory` | ≥75% disclosed inventory | 1 |
| `≥99% disclosed inventory` | ≥99% disclosed inventory | 2 |
| `100% disclosed inventory` | 100% disclosed inventory | 3 |

### Assessment-Based Optimization Levels

| Value | Level | Score |
|---|---|---|
| `75% Assessed` | 75% Assessed | 1 |
| `95% Assessed` | 95% Assessed | 2 |
| `100% Assessed` | 100% Assessed | 3 |

### Reporting Threshold

| Value | Level | Score |
|---|---|---|
| `100 ppm` | 100 ppm | 4 |
| `1,000 ppm` | 1,000 ppm | 3 |
| `10,000 ppm` | 10,000 ppm | 2 |

### TVOC Emissions Range

| Value | Level | Score |
|---|---|---|
| `very_high` | Very High (> 3000 µg/m³) | 1 |
| `high` | High (1000–3000 µg/m³) | 2 |
| `medium` | Medium (500–1000 µg/m³) | 3 |
| `low` | Low (100–500 µg/m³) | 4 |
| `very_low` | Very Low (< 100 µg/m³) | 5 |
