# Tips / Notes for 2026 Secure 2.0 Presentation

## Retirement Administrator Dashboard
In June 2025 Banner released a new way to assign Banner Self-Service Roles.
This used to be done via GUAUSRL, but is now done using GUAWROL.

There is an Ellucian Article [KB000510502 - Steps to configure the new GUAWMNU and GUAWROL SSB9x menu](https://elluciansupport.service-now.com/customer_center?sys_kb_id=0d27c2c69397fe940ff9ff947aba10d0&id=kb_article_view) (with additional KBs listed near the bottom) for migrating to the new setup.

I recommend moving to this new setup and assigning the role via GUAWROL. If you want to assign the RETIREADMIN role via GUAURSL before you can migrate, you'll need to add the role to the old validation table. (We need this as we have not completed migration.)

```sql
-- Code to copy role validation record from GURVROL
INSERT INTO WTAILOR.TWTVROLE (
  TWTVROLE_CODE
, TWTVROLE_DESC
, TWTVROLE_ACTIVITY_DATE
, TWTVROLE_USER_DEFINED_IND
, TWTVROLE_USER_ID
, TWTVROLE_DATA_ORIGIN
)
-- Alternatively you could use values
-- VALUES ('RETIREADMIN', 'Benefits Retirement Administrator', SYSDATE, 'Y', USER, 'INSERTED VALUES')
select GURVROL_CODE, GURVROL_DESC, GURVROL_ACTIVITY_DATE, GURVROL_USER_DEFINED_IND, GURVROL_USER_ID, 'COPY FROM GURVROL' GURVROL_DATA_ORIGIN
from GURVROL
WHERE GURVROL_CODE = 'RETIREADMIN';
```

## Bulk Delete/Load of Deduction Group Assignments
In this section, I provide code that can be used (in conjunction with the [Retirement Grouping spreadsheet](secure2Template_Retirement_Grouping.xlsx)) to bulk (remove and) setup grouping for retirement deductions.

Optional Backup
```sql
-- -- Optional Backup Existing Deduction Grouping Associations/Setup
-- CREATE TABLE BKPTRBDGM20260330_RT AS 
SELECT * 
FROM PTRBDGM 
WHERE PTRBDGM_BDPG_CODE = 'RT';

-- -- Optional Backup Secondary Groups
-- CREATE TABLE BKPTRBDSG20260330_RT AS 
SELECT * 
FROM PTRBDSG 
WHERE PTRBDSG_BDPG_CODE = 'RT';
```

View
```sql
/* List Retirement Deduction Codes. Current grouping included if it exists */

-- Identify current grouping for retirement deductions
SELECT 
PTRBDGM_BDPG_CODE, PTRBDGM_BDSG_CODE, PTRBDCA_CODE, PTRBDCA_LONG_DESC
-- ,PTRBDCA_SHORT_DESC--, PTRBDGM.* -- , 
FROM PTRBDCA 
LEFT JOIN PTRBDGM ON PTRBDGM_BDCA_CODE = PTRBDCA_CODE
-- -- USU has all retirement deductions starting with 5 or 6
-- -- You may need to tailor this another way, or just removed non-retirement deductions in Excel.
-- WHERE SUBSTR(PTRBDCA_CODE,1,1) IN ('5','6')
;
```

### Prepare an excel spreadsheet to map deductions to primary/sub groups.
Instructions for the [Retirement Grouping spreadsheet](secure2Template_Retirement_Grouping.xlsx)
1) Update your desired secondary group options on the **Secondary Group Validation List** tab
2) Paste the results from the query  in the **Group Assignments** tab and copy down the formula in column E:
    ```excel
    ="SELECT '"&A2&"' BDPG, '"&B2&"' BDSG, '"&C2&"' BDCA FROM DUAL UNION ALL"
    ```
3) Copy the SQL Column into the insert statement below




**Delete Existing Grouping**  
For a clean slate (remove old secondary groups) it's quick to delete the secondary group records (middle section). Deleting a secondary group will remove all deduction associations with that secondary group.

```sql
-- 
INSERT INTO PTRBDGM
( PTRBDGM_BDCA_CODE
, PTRBDGM_BDPG_CODE
, PTRBDGM_BDSG_CODE
, PTRBDGM_WEB_SEL_IND
, PTRBDGM_WEB_INS_IND
, PTRBDGM_WEB_UPD_IND
, PTRBDGM_WEB_DEL_IND
, PTRBDGM_WEB_EMPR_IND
, PTRBDGM_WEB_CVG_SEL_IND
, PTRBDGM_WEB_CVG_INS_IND
, PTRBDGM_WEB_CVG_UPD_IND
, PTRBDGM_WEB_CVG_DEL_IND
, PTRBDGM_WEB_OPEN_IND
, PTRBDGM_ACTIVITY_DATE
, PTRBDGM_WEB_BALC_SEL_IND
, PTRBDGM_WEB_BALC_INS_IND
, PTRBDGM_WEB_BALC_UPD_IND
, PTRBDGM_WEB_BALC_DEL_IND
, PTRBDGM_USER_ID
, PTRBDGM_DATA_ORIGIN
)
SELECT 
  BDCA PTRBDGM_BDCA_CODE
, BDPG PTRBDGM_BDPG_CODE
, BDSG PTRBDGM_BDSG_CODE
-- Set Checkboxes as Appropriate for your institution
, 'Y' PTRBDGM_WEB_SEL_IND
, 'N' PTRBDGM_WEB_INS_IND
, 'N' PTRBDGM_WEB_UPD_IND
, 'N' PTRBDGM_WEB_DEL_IND
, 'Y' PTRBDGM_WEB_EMPR_IND
, 'Y' PTRBDGM_WEB_CVG_SEL_IND
, 'N' PTRBDGM_WEB_CVG_INS_IND
, 'N' PTRBDGM_WEB_CVG_UPD_IND
, 'N' PTRBDGM_WEB_CVG_DEL_IND
, 'N' PTRBDGM_WEB_OPEN_IND
, SYSDATE PTRBDGM_ACTIVITY_DATE
, 'N' PTRBDGM_WEB_BALC_SEL_IND
, 'N' PTRBDGM_WEB_BALC_INS_IND
, 'N' PTRBDGM_WEB_BALC_UPD_IND
, 'N' PTRBDGM_WEB_BALC_DEL_IND
, USER PTRBDGM_USER_ID
, 'DIRECT DB INSERT' PTRBDGM_DATA_ORIGIN
FROM (
-- EXCEL DATA GOES HERE AND SHOULD LOOK SOMETHING LIKE BELOW...
SELECT 'RT' BDPG, 'DB' BDSG, '501' BDCA FROM DUAL UNION ALL
SELECT 'RT' BDPG, 'DB' BDSG, '502' BDCA FROM DUAL UNION ALL
SELECT 'RT' BDPG, 'DB' BDSG, '503' BDCA FROM DUAL UNION ALL
SELECT 'RT' BDPG, 'DB' BDSG, '504' BDCA FROM DUAL UNION ALL
SELECT 'RT' BDPG, 'CAT' BDSG, '505' BDCA FROM DUAL UNION ALL
SELECT 'RT' BDPG, 'C5T' BDSG, '506' BDCA FROM DUAL UNION ALL
SELECT 'RT' BDPG, 'C0T' BDSG, '507' BDCA FROM DUAL UNION ALL
SELECT 'RT' BDPG, 'C0R' BDSG, '508' BDCA FROM DUAL UNION ALL
SELECT 'RT' BDPG, 'C5R' BDSG, '509' BDCA FROM DUAL UNION ALL
SELECT 'RT' BDPG, 'RLP' BDSG, '590' BDCA FROM DUAL UNION ALL
SELECT 'RT' BDPG, 'C5T' BDSG, '606' BDCA FROM DUAL UNION ALL
SELECT 'RT' BDPG, 'C0T' BDSG, '607' BDCA FROM DUAL UNION ALL
SELECT 'RT' BDPG, 'C0R' BDSG, '608' BDCA FROM DUAL UNION ALL
SELECT 'RT' BDPG, 'C5R' BDSG, '609' BDCA FROM DUAL 
-- REMOVE "UNION ALL" FROM THE LAST RECORD
)
where BDCA in (select ptrbdca_code from ptrbdca)
;
```

## Query Current Payroll Data - Add to
Query uses the Retire Admin Dashboard Download layout. This allows you to paste data right into the [Retirement Analysis spreadsheet](secure2Template_Retirement_Dashboard_Analysis.xlsx) (Data tab). This should be pasted under the data from the Retirement Admin Dashboard data as it's missing important data such as prior year FICA which is included in the dashboard. VLOOKUPS will view the first record, which is why the dashboard data should be listed first.

```sql
    SELECT 
          SPRIDEN_ID
        , SPRIDEN_FIRST_NAME || ' ' || SPRIDEN_LAST_NAME EE_NAME
        , TO_NUMBER(COALESCE(TO_CHAR(PHRHIST_POSTING_OVERRIDE_DATE, 'YYYY'), PHRDEDN_YEAR)) - EXTRACT (YEAR FROM SPBPERS_BIRTH_DATE) age
        , PHRDEDN_BDCA_CODE
        , ptrbdca_long_desc
        , NULL BDCL_DESC
        , SUM(PHRDEDN_EMPLOYEE_AMT) TOTAL_EE_CONTRIBUTIONS
        , SUM(PHRDEDN_EMPLOYER_AMT) TOTAL_ER_CONTRIBUTIONS
        , SUM(PHRDEDN_APPLICABLE_GROSS) TOTAL_APPLICABLE_GROSS
        , NULL CY_FICA
        , NULL PR_FICA
    FROM PHRDEDN
      JOIN PHRHIST 
        ON PHRHIST_PIDM = PHRDEDN_PIDM 
          AND PHRHIST_YEAR = PHRDEDN_YEAR 
          AND PHRHIST_PICT_CODE = PHRDEDN_PICT_CODE 
          AND PHRHIST_PAYNO = PHRDEDN_PAYNO 
          AND PHRHIST_SEQ_NO = PHRDEDN_SEQ_NO
      JOIN SPRIDEN ON SPRIDEN_PIDM = PHRDEDN_PIDM AND SPRIDEN_CHANGE_IND IS NULL
      JOIN SPBPERS ON SPBPERS_PIDM = PHRDEDN_PIDM
      JOIN PTRBDCA ON PTRBDCA_CODE = PHRDEDN_BDCA_CODE
    WHERE PHRDEDN_BDCA_CODE IN 
      ( SELECT PTRBDGM_BDCA_CODE PTRBDCA_CODE FROM PTRBDGM 
        WHERE PTRBDGM_BDPG_CODE = 'RT'
          -- -- Optionally limit to secondary groups you care about
          -- AND PTRBDGM_BDSG_CODE IN ('C0R','C0T','C5R','C5T') 
      )
      -- -- ***** PARAMETER: THIS IS WHERE THE YEAR GETS FILTERED ***** -- --
      -- Might not need this, but leaving just in case since data isn't grouped by year
      AND COALESCE(TO_CHAR(PHRHIST_POSTING_OVERRIDE_DATE, 'YYYY'), PHRDEDN_YEAR) = TO_CHAR(:MAIN_EB_CONTRIBUTION_YEAR)
      -- Limit to payrolls at the PHPCALCJ step
      AND PHRHIST_DISP = 40
    GROUP BY 
          spriden_id
        , SPRIDEN_FIRST_NAME || ' ' || SPRIDEN_LAST_NAME
        , TO_NUMBER(COALESCE(TO_CHAR(PHRHIST_POSTING_OVERRIDE_DATE, 'YYYY'), PHRDEDN_YEAR)) - EXTRACT (YEAR FROM SPBPERS_BIRTH_DATE)
        , PHRDEDN_BDCA_CODE
        , ptrbdca_long_desc
;
```