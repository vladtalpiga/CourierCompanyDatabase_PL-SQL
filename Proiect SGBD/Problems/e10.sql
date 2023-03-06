--In urma unui studiu, am aflat ca
--este profitabil ca firma noastra 
--de curierat sa aiba depozite
--in cat mai putine tari diferite.
--Creati un trigger care sa nu 
--permita sa se insereze (infiinteze) 
--depozite in mai mult de 8 tari diferite.
    
create or replace trigger limitare_depozite
    before insert or update on depozit
declare
    cnt number(3);
begin
    select count(distinct tara_depozit) into cnt
    from depozit;
    if cnt > 8 then 
        RAISE_APPLICATION_ERROR(-20100, 'S-a atins limita de tari diferite inca care sa avem depozite.');
    end if;
end;
/

begin
    insert into depozit (id_depozit, tara_depozit)
    values (605, 'Anglia');
    insert into depozit (id_depozit, tara_depozit)
    values (606, 'Grecia');
    insert into depozit (id_depozit, tara_depozit)
    values (607, 'Egypt');
    insert into depozit (id_depozit, tara_depozit)
    values (608, 'Peru');
    insert into depozit (id_depozit, tara_depozit)
    values (609, 'India');
--    delete from depozit where id_depozit > 604;
end;
/

drop trigger limitare_depozite;




