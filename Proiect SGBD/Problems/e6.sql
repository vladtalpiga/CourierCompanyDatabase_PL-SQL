--Sa se afiseze toate tarile cu depozite care stocheaza 
--produse aflate in coletul cu codul dat ca parametru.

create or replace procedure e6
    (cod_colet colet_produs.id_colet%type)
as
    type t_id_produs is table of colet_produs.id_produs%type;
    t t_id_produs;
    type t_id_depozit is table of produs.id_depozit%type index by PLS_INTEGER;
    z t_id_depozit;
    type dif is varray(6) of number(1);
    d dif := dif(0, 0, 0, 0, 0);
    cnt number(3);
    a number(3);
    i number(3);
    verif number(3) := 0;
    cod_depozit produs.id_depozit%type;
    aux depozit.tara_depozit%type;
begin
    select unique id_colet into verif
    from colet_produs
    where id_colet = cod_colet;
    
    if verif = 0 then
        DBMS_OUTPUT.PUT_LINE('Coletul ' || cod_colet || ' nu exista.');
    else
        select id_produs bulk collect into t
        from colet_produs
        where id_colet = cod_colet;
        
        select count(*) into cnt
        from colet_produs
        where id_colet = cod_colet;
        
        if cnt = 0 then
            DBMS_OUTPUT.PUT_LINE('Coletul ' || cod_colet || ' nu contine niciun produs.');
        else
            DBMS_OUTPUT.PUT_LINE('Coletul ' || cod_colet || ' contine produse din urmatoarele tari:');
            for i in 1..cnt loop
                select id_depozit into z(i)
                from produs
                where t(i) = id_produs;
                
                select tara_depozit into aux
                from depozit
                where id_depozit = z(i);
                
                a := z(i) - 599;
                
                if d(a) = 0 then
                    d(a) := 1; 
                    DBMS_OUTPUT.PUT_LINE(aux);
                end if;
            end loop;
        end if;
    end if;
end;
/

begin
    e6(406);
end;
/