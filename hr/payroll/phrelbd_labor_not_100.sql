/* Identify payroll records (often caused in PHAREDS or ESS Labor Redistributions) */
-- phrelbd WHERE phrelbd_percent <> 100%
SELECT 
f_getspridenid(phrelbd_pidm) id, 
f_format_name(phrelbd_pidm, 'LFMI') name, 
--phrhist_disp,
(select phrhist_disp from phrhist where phrhist_year = phrelbd_year and phrhist_pict_code = phrelbd_pict_code and phrhist_payno = phrelbd_payno and phrhist_pidm = phrelbd_pidm and phrhist_seq_no = phrelbd_seq_no) disposition,
phrelbd.* 
FROM phrelbd 
--JOIN phrhist on phrhist_year = phrelbd_year and phrhist_pict_code = phrelbd_pict_code and phrhist_payno = phrelbd_payno and phrhist_pidm = phrelbd_pidm and phrhist_seq_no = phrelbd_seq_no and phrhist_disp < 70
WHERE (phrelbd_year, 
phrelbd_pict_code, 
phrelbd_payno, 
phrelbd_seq_no, 
phrelbd_earn_code, 
phrelbd_posn,
phrelbd_suff,
phrelbd_effective_date,
phrelbd_shift,
phrelbd_gen_ind,
phrelbd_pidm ) IN 
(
SELECT 
--SUM(phrelbd_percent) sum_percent,
phrelbd_year, 
phrelbd_pict_code, 
phrelbd_payno, 
phrelbd_seq_no, 
phrelbd_earn_code, 
phrelbd_posn,
phrelbd_suff,
phrelbd_effective_date,
phrelbd_shift,
phrelbd_gen_ind,
phrelbd_pidm 
FROM phrelbd
GROUP BY phrelbd_year, phrelbd_pict_code, phrelbd_payno, phrelbd_seq_no, phrelbd_earn_code, phrelbd_posn, phrelbd_suff, phrelbd_effective_date, phrelbd_shift, phrelbd_gen_ind, phrelbd_pidm
HAVING SUM(phrelbd_percent) <> 100
)
ORDER BY phrelbd_pidm, phrelbd_year, phrelbd_pict_code, phrelbd_payno, phrelbd_seq_no, phrelbd_earn_code, phrelbd_posn, phrelbd_suff, phrelbd_effective_date, phrelbd_gen_ind, phrelbd_shift
;
