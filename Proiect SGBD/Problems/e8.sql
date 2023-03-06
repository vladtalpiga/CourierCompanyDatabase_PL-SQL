-- Sa se afiseze cate vehicule poate
-- conduce un curier cu numele dat ca
-- prim parametru. Vehiculele trebuie sa 
-- fie produse dupa anul dat ca al
-- doilea parametru.

create or replace function e8
    (nume curier.nume_curier%type, 
     an vehicul.an_vehicul%type)
    return number
is
    rez number(3);
    v number(3);
    curryear number(4);
begin
    select count(*) into v
    from curier
    where nume_curier = nume;
    
    if v = 0 then
        --DBMS_OUTPUT.PUT_LINE('Nu exista niciun curier cu numele ' || nume || '.');
        RAISE_APPLICATION_ERROR(-20001, 'Nu exista niciun curier cu numele ' || nume || '.');
        return -1;
    end if;
        
    select to_char(sysdate, 'YYYY') into curryear
    from dual;
        
    if an < 0 or an > curryear then
        --DBMS_OUTPUT.PUT_LINE('Anul introdus este invalid.');
        RAISE_APPLICATION_ERROR(-20002, 'Anul introdus este invalid.');
        return -1;
    end if;
    
    select count(*) into rez
    from vehicul v, transport t, curier c
    where an < v.an_vehicul and
          v.id_vehicul = t.id_vehicul and 
          t.id_curier = c.id_curier and 
          c.nume_curier = nume;
          
    DBMS_OUTPUT.PUT_LINE('Numarul de vehicule produse dupa anul ' || an || ' pe care le poate conduce curierul ' || nume || ' este: ');
    return rez; 
end;
/

begin
    DBMS_OUTPUT.PUT_LINE(e8('David', 2059));
end;
/