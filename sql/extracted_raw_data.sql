SELECT
    -- Claims (fact)
    cl.claim_id,
    cl.claim_date,
    cl.incident_date,
    cl.claim_type,
    cl.amount_claimed,
    cl.amount_approved,
    cl.processed_date,
    cl.status                         AS claim_status,
    cl.is_fraudulent,

    -- Policies (dimension)
    p.policy_id,
    p.policy_number,
    p.policy_type,
    p.coverage_amount,
    p.premium_monthly,
    p.deductible,
    p.start_date,
    p.end_date,
    p.risk_grade,
    p.status                          AS policy_status,

    -- Customers (dimension)
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.occupation,
    c.annual_income,
    c.credit_score,
    c.risk_score                      AS customer_risk_score,
    c.customer_since,

    -- Agents (dimension)
    ag.agent_id,
    ag.first_name                     AS agent_first_name,
    ag.last_name                      AS agent_last_name,
    ag.specialization,
    ag.region,
    ag.commission_rate,
    ag.years_exp,
    ag.is_active                      AS agent_is_active,

    -- Risk Assessments (most recent per customer)
    ra.assessment_id,
    ra.assessment_date,
    ra.risk_category,
    ra.risk_score                     AS assessed_risk_score,
    ra.recommended_premium,
    ra.factors

FROM      insurance.claims          cl
JOIN      insurance.policies        p   ON p.policy_id    = cl.policy_id
JOIN      insurance.customers       c   ON c.customer_id  = cl.customer_id
JOIN      insurance.agents          ag  ON ag.agent_id    = p.agent_id
LEFT JOIN (
    SELECT DISTINCT ON (customer_id)
        assessment_id,
        customer_id,
        assessment_date,
        risk_category,
        risk_score,
        recommended_premium,
        factors
    FROM  insurance.risk_assessments
    ORDER BY customer_id, assessment_date DESC
) ra                                    ON ra.customer_id = cl.customer_id

ORDER BY cl.claim_date, cl.incident_date;