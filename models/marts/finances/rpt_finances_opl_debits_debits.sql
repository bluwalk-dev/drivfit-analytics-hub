select 
  a.period_start AS start_date,
  a.period_end AS end_date,
  a.description AS description,
  b.lease_contract_id,
  a.opl_conditions_id as conditions_id,
  a.product_id,
  amount AS debit,
  quantity,
  payment_cycle
from {{ ref('fct_billable_items') }} a
left join {{ ref('fct_lease_contracts') }} b on a.contract_id = b.lease_contract_id
where 
  contract_type = 'mid-term' and 
  status = 'invoiced' and
  opl_conditions_id is not null