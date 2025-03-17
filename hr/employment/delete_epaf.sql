/* Delete EPAF - With Backup
 * 2023-09-20 Run requested by [HR Rep] to [IT Rep] via [Communication Method]
*/
CREATE TABLE bknoreaer20230920_2delete AS SELECT * -- DELETE
FROM noreaer WHERE noreaer_trans_no in (182573,203537,1132623,1146689,1146833,1311778,1329836); -- Errors and Warnings
CREATE TABLE bknorcmnt20230920_2delete AS SELECT * -- DELETE
FROM norcmnt WHERE norcmnt_transaction_no in (182573,203537,1132623,1146689,1146833,1311778,1329836); -- Comments
CREATE TABLE bknorrout20230920_2delete AS SELECT * -- DELETE
FROM norrout WHERE norrout_transaction_no in (182573,203537,1132623,1146689,1146833,1311778,1329836); -- Approval Routing
CREATE TABLE bknortern20230920_2delete AS SELECT * -- DELETE
FROM nortern WHERE nortern_transaction_no in (182573,203537,1132623,1146689,1146833,1311778,1329836); -- Earnings
CREATE TABLE bknortlbd20230920_2delete AS SELECT * -- DELETE
FROM nortlbd WHERE nortlbd_transaction_no in (182573,203537,1132623,1146689,1146833,1311778,1329836); -- Labor Distribution
CREATE TABLE bknortran20230920_2delete AS SELECT * -- DELETE
FROM nortran WHERE nortran_transaction_no in (182573,203537,1132623,1146689,1146833,1311778,1329836); -- Transaction Details (Job)
CREATE TABLE bknobtran20230920_2delete AS SELECT * -- DELETE
FROM nobtran WHERE nobtran_transaction_no in (182573,203537,1132623,1146689,1146833,1311778,1329836); -- Base

/* Code to restore data from backup if needed */
INSERT INTO nobtran SELECT * FROM bknobtran20230920_2delete;
INSERT INTO nortran SELECT * FROM bknortran20230920_2delete;
INSERT INTO nortlbd SELECT * FROM bknortlbd20230920_2delete;
INSERT INTO nortern SELECT * FROM bknortern20230920_2delete;
INSERT INTO norrout SELECT * FROM bknorrout20230920_2delete;
INSERT INTO norcmnt SELECT * FROM bknorcmnt20230920_2delete;
INSERT INTO noreaer SELECT * FROM bknoreaer20230920_2delete;

-- ROLLBACK;
-- COMMIT;