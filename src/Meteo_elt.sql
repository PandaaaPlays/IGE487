SET SCHEMA 'Herbivorie' ;

alter domain Date_eco drop constraint Date_eco_check ;
alter domain Date_eco add constraint Date_eco_check
  check ((extract(year from value) between 2016 and 2030));

create or replace function Date_eco_verif (argument text)
returns boolean language sql as
$$
with
  syntaxe as (
    select argument,
      argument similar to '[0-9]{4}-[0-9]{2}-[0-9]{2}' as syntaxe_ok,
      split_part(argument,'-',1) annee_p,
      split_part(argument,'-',2) mois_p,
      split_part(argument,'-',3) jour_p),
  eval as (
    select *,
      case when syntaxe_ok then annee_p::int else 1900 end annee,
      case when syntaxe_ok then mois_p::int  else 1 end mois,
      case when syntaxe_ok then jour_p::int  else 1 end jour
    from syntaxe),
  verif as (
    select *,
      case
        when mois in (1,3,5,7,8,10,12) then jour between 1 and 31
        when mois in (4,6,9,11) then jour between 1 and 30
        when mois = 2 then
          case
            when annee/4*4 = annee and (annee/100*100 <> annee or annee/400*400 = annee)
              then jour between 1 and 29
              else jour between 1 and 28 end
        else false end valide
    from eval)
select syntaxe_ok AND valide AND (annee between 2016 and 2030)
from verif;
$$;

create or replace function Date_eco_conv (argument text)
returns date_eco language sql as
$$ select to_date(argument,'yyyy-mm-dd') $$;

create or replace function Entier_verif(argument text, min integer, max integer)
returns boolean language sql as
$$
select case
  when argument similar to '(-)?[0-9]{1,6}'
    then cast(argument as integer) between min and max
  else false end;
$$;

create or replace function Temperature_verif(arg text)
returns boolean language sql as $$ select Entier_verif(arg,-50,50) $$;
create or replace function Temperature_conv(arg text)
returns Temperature language sql as $$ select arg::Temperature $$;

create or replace function Humidite_verif(arg text)
returns boolean language sql as $$ select Entier_verif(arg,0,100) $$;
create or replace function Humidite_conv(arg text)
returns Humidite language sql as $$ select arg::Humidite $$;

create or replace function Vitesse_verif(arg text)
returns boolean language sql as $$ select Entier_verif(arg,0,300) $$;
create or replace function Vitesse_conv(arg text)
returns Vitesse language sql as $$ select arg::Vitesse $$;

create or replace function Pression_verif(arg text)
returns boolean language sql as $$ select Entier_verif(arg,900,1100) $$;
create or replace function Pression_conv(arg text)
returns Pression language sql as $$ select arg::Pression $$;

create or replace function HNP_verif(arg text)
returns boolean language sql as $$ select Entier_verif(arg,0,500) $$;
create or replace function HNP_conv(arg text)
returns HNP language sql as $$ select arg::HNP $$;

create or replace function Code_P_verif(arg text)
returns boolean language sql as
$$ select arg in (select code from TypePrecipitations) $$;

create or replace function Code_P_conv(arg text)
returns Code_P language sql as $$ select arg::Code_P $$;

create or replace function Zone_verif(argument text)
returns boolean
language sql as
$$
select
  argument is not null
  and length(trim(argument)) > 0
  and argument similar to '[A-Za-z0-9_-]+'
$$;

create or replace function Conv_zone(argument text)
returns text
language sql as
$$
select trim(argument)
$$;


create or replace procedure Meteo_ELT ()
language plpgsql as
$$
begin
  insert into ObsTemperature(date,temp_min,temp_max,note,zone)
    select
      date_eco_conv(date),
      Temperature_conv(temp_min),
      Temperature_conv(temp_max),
      coalesce(note,''),
      Conv_zone(zone)
    from CarnetMeteo
    where date_eco_verif(date)
      and Temperature_verif(temp_min)
      and Temperature_verif(temp_max)
      and Zone_verif(zone);

  insert into ObsHumidite(date,hum_min,hum_max,zone)
    select
      date_eco_conv(date),
      Humidite_conv(hum_min),
      Humidite_conv(hum_max),
      Conv_zone(zone)
    from CarnetMeteo
    where date_eco_verif(date)
      and Humidite_verif(hum_min)
      and Humidite_verif(hum_max)
      and Zone_verif(zone);

  insert into ObsPrecipitations(date,prec_tot,prec_nat,zone)
    select
      date_eco_conv(date),
      HNP_conv(prec_tot),
      Code_P_conv(prec_nat),
      Conv_zone(zone)
    from CarnetMeteo
    where date_eco_verif(date)
      and HNP_verif(prec_tot)
      and Code_P_verif(prec_nat)
      and Zone_verif(zone);

  insert into ObsVents(date,vent_min,vent_max,zone)
    select
      date_eco_conv(date),
      Vitesse_conv(vent_min),
      Vitesse_conv(vent_max),
      Conv_zone(zone)
    from CarnetMeteo
    where date_eco_verif(date)
      and Vitesse_verif(vent_min)
      and Vitesse_verif(vent_max)
      and Zone_verif(zone);

  ------------------------------------------------------------
  -- Pression (ajout zone)
  ------------------------------------------------------------
  insert into ObsPression(date,pres_min,pres_max,zone)
    with T as (
      select
        date_eco_conv(date),
        Pression_conv(pres_min),
        Pression_conv(pres_max),
        Conv_zone(zone)
      from CarnetMeteo
      where date_eco_verif(date)
        and Pression_verif(pres_min)
        and Pression_verif(pres_max)
        and Zone_verif(zone)
    )
    select * from T where pres_min <= pres_max;

end;
$$;

