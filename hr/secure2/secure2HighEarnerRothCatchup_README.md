# Secure 2.0 Highly Paid Individual (HPI) Catch-Up Contributions
Ellucian is working on a long-term solution. Below I outline our interim approach to prevent HPIs from exceeding pre-tax contributions. Your institution will need to adjust it for your setup and needs for it to work. 

## **Goal**
Identify HPIs whose pre-tax contributions exceed the IRS Standard Contribution Limit. Move excess pre-tax contributions to a Roth deduction.

The report is **not** intended to prevent excess contributions in total, such as Roth plus Pre-tax contributions. I highly recommend using Banner's combined limit rule code setup for that (not required for this report to work). You are welcome to alter the report to watch for excess total contributions if you desire.

## **Initial Setup**
- Bring the [Secure 2.0 HPIs Exceeding Pretax Allowed SQL report](secure2HighEarnerExceedingPretaxAllowable.sql)\* into your reporting tool. Ideally you'll have someone review the code to understand what it's doing, and make any necessary adjustments.
- Update the report with correct deduction codes in the appropriate CTE (Pre/Post-Tax Main/457b).
- Ensure Other CTEs have needed records (such as **Special Catchup** records and the correct values and years in **Limits and Wages** if **not** using parameters in that CTE)

## **Ongoing Setup Recommendation**
- Annually add records to **Limits and Wages** as announced by the IRS if **not** using parameters.
- Set up both **pre-tax** and **post-tax** deductions for high-wage earners eligible for, and electing, age catch-up contributions at the start of the year (or when elections change).
    - If using contribution limits, apply the **full IRS limit** (including catch-up) combined limit for employees intending to use the age catch-up.
        - Use the same limit for pre-tax and post-tax deductions in a given bucket (Main or 457b).
        - Banner will **not** automatically stop pre-tax when using full limits.
        - Payroll must monitor and run the report regularly.
    - Having the Roth account set up allows quick adjustments without pulling employees out of payroll.
    - Post-tax can be set up at \$0 if the employee does not elect to contribute to Roth.
- (Optional) Add record(s) to the **Special Catch-Up CTE** if you have employees eligible for, and electing to use, special catch-up contributions.

## **Payroll Checklist**
- [ ] Confirm Highly Paid Individual status (IRS threshold: \$150,000 prior-year compensation).
- [ ] Verify both pre-tax and post-tax deductions are set up.
- [ ] Run **PHPCALCJ** after each payroll cycle.
- [ ] Execute the **Secure 2.0 HPIs Exceeding Pretax Allowed SQL report** and review flagged employees.
- [ ] Move excess contributions from the **pre-tax** to the **post-tax** deduction in Banner using **Add/Replace**.
- [ ] Rerun **PHPCALCJ** and the Report
- [ ] Validate year-to-date totals do not exceed appropriate IRS limits.
- [ ] (Optional) Alter deduction setup for future payrolls.
- [ ] (Optional) Note how to revert at the start of the next year, or setup next year with a future effective date.

## **Important Notes**
If you have employees deemed HPIs based on wages earned outside of Banner, you may need to alter the **Highly Paid Individuals CTE** to include them.

## To Do (Note to Self)
Add information about Deduction setup (calc rules, combined limit rule codes, etc.)

## Footnote
*\* The current query is an early draft; adjustments may follow.*