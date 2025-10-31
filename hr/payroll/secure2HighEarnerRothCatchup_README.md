# Secure 2.0 High-Wage Earner Catch-Up Contributions
Ellucian is working on a long-term solution, but here’s our current approach:

## **Goal**
Identify high earners whose pre-tax contributions exceed IRS limits. Move excess pre-tax contributions to a Roth deduction.

## **Initial Setup**
Update the report with correct deduction codes in the appropriate CTE (Pre/Post-Tax Main/457b).

## **Ongoing Setup Recommendation**
- Annually add records to **Limits and Wages** as announced by the IRS.
- Set up both **pre-tax** and **post-tax** deductions for high-wage earners eligible for, and electing, age catch-up contributions at the start of the year (or when elections change).
    - If using contribution limits, apply the **full IRS limit** (including catch-up) combined limit for employees intending to use the age catch-up.
        - Use the same limit for pre-tax and post-tax deductions in a given bucket (Main or 457b).
        - Banner will **not** automatically stop pre-tax when using full limits.
        - Payroll must monitor and run the report regularly.
    - Having the Roth account set up allows quick adjustments without pulling employees out of payroll.
    - Post-tax can be set up at \$0 if the employee does not elect to contribute to Roth.
- (Optional) Add record(s) to the **Special Catch-Up CTE** if you have employees eligible for, and electing to use, special catch-up contributions.

## **Payroll Checklist**
- [ ] Confirm high-wage earner status (IRS threshold: \$145,000 prior-year compensation).
- [ ] Verify both pre-tax and post-tax deductions are set up.
- [ ] Run **PHPCALCJ** after each payroll cycle.
- [ ] Execute the [Secure 2.0 High Earners Exceeding Pretax Allowed SQL report](secure2HighEarnerExceedingPretaxAllowable.sql)\* and review flagged employees.
- [ ] Move excess contributions from the **pre-tax** to the **post-tax** deduction in Banner using **Add/Replace**.
- [ ] Rerun **PHPCALCJ** and the Report
- [ ] Validate year-to-date totals do not exceed appropriate IRS limits.
- [ ] (Optional) Alter deduction setup for future payrolls.
- [ ] (Optional) Note how to revert at the start of the next year, or setup next year with a future effective date.

---

## **Important Notes**
If you have employees deemed High Earners based on wages earned outside of Banner, you may need to alter the **High Earner CTE** to include them.

*\* The current query is an early draft; adjustments may follow.*