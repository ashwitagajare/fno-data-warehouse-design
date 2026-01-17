select 
i.exchange_name,
    avg(t.settle_price) as avg_settle_price
from  trades t
inner join contracts c
    on t.contract_id = c.contract_id
inner join instruments i
    on c.instrument_id = i.instrument_id
where i.symbol in ('mindtree', 'pidilitind')
group by i.exchange_name;
