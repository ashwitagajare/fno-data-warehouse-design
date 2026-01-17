-- Snowflake DDL scripts
create or replace database assignment;
create or replace schema assignment.future_options;

create or replace table future_options.fno_raw (
    id                bigint,
    instrument        string,
    symbol            string,
    expiry_dt         date,
    strike_pr         number(10,2),
    option_typ        string,
    open_price        number(10,2),
    high_price        number(10,2),
    low_price         number(10,2),
    close_price       number(10,2),
    settle_pr         number(10,2),
    contracts         number(10,2),
    val_inlakh        number,
    open_int          number,
    chg_in_oi         number,
    trade_timestamp   timestamp
);

select * from  future_options.fno_raw limit 100 ;

create or replace table future_options.exchange (
exchange_id integer autoincrement ,
exchange_name string
) ;
insert into future_options.exchange (exchange_name) values ('nse'),('bse'),('mcx') ;

select * from exchange ;

create or replace table future_options.instruments (
    instrument_id integer autoincrement,
    symbol string,
    instrument_type string,
    exchange_name string
);

insert into instruments (symbol, instrument_type,exchange_name)
select distinct symbol, instrument,'nse' from fno_raw;

select * from instruments ;

create or replace table contracts (
    contract_id integer autoincrement,
    instrument_id integer,
    expiry_date date,
    strike_price number(10,2),
    option_type string
) ;

insert into contracts (
    instrument_id,
    expiry_date,
    strike_price,
    option_type
)
select distinct
    i.instrument_id,
    r.expiry_dt,
    r.strike_pr,
    r.option_typ
from fno_raw r
join instruments i
    on r.symbol = i.symbol
   and r.instrument = i.instrument_type;

select * from contracts order by contract_id asc limit 100  ;


create or replace table trades (
    trade_id bigint autoincrement,
    contract_id integer,
    trade_date date,
    open_price number(10,2),
    high_price number(10,2),
    low_price number(10,2),
    close_price number(10,2),
    settle_price number(10,2),
    val_inlakh  number,
    open_interest number,
    change_in_oi number
);

insert into trades (
    contract_id,
    trade_date,
    open_price,
    high_price,
    low_price,
    close_price,
    settle_price,
    val_inlakh,
    open_interest,
    change_in_oi
)
select
    c.contract_id,
    cast(r.trade_timestamp as date) as trade_date,
    r.open_price,
    r.high_price,
    r.low_price,
    r.close_price,
    r.settle_pr,
    r.val_inlakh,
    r.open_int,
    r.chg_in_oi
from fno_raw r
join instruments i
    on r.symbol = i.symbol
   and r.instrument = i.instrument_type
join contracts c
    on c.instrument_id = i.instrument_id
   and c.expiry_date = r.expiry_dt
   and nvl(c.strike_price, 0) = nvl(r.strike_pr, 0)
   and nvl(c.option_type, 'xx') = nvl(r.option_typ, 'xx');
