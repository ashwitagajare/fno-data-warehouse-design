select
t.trade_date,
    stddev(t.close_price)
        over (order by t.trade_date
              rows between 6 preceding and current row) as rolling_7d_volatility
from trades t
join contracts c
on t.contract_id = c.contract_id
join instruments i
on c.instrument_id = i.instrument_id
where i.symbol = 'nifty'
and i.instrument_type like 'opt%' 
