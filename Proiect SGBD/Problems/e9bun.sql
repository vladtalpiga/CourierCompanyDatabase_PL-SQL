--Sa se afiseze cati lei a cheltuit in total
--pe produse clientul cu numele dat ca parametru.

create or replace procedure ex9
    (nume client.nume_client%type)
as
    suma number(11);
    vf client.id_client%type;
begin
-- folosesc acest query pentru a vedea
-- daca numele clientului este unul valid
-- astfel, daca numele nu exista in baza
-- de date, va interveni eroarea
    select id_client into vf
    from client
    where nume_client = nume;
    
    select sum(p.pret_produs) into suma
    from client c
    join livrare l on c.id_client = l.id_client
    join colet co on l.id_livrare = co.id_livrare
    join colet_produs cp on co.id_colet = cp.id_colet
    join produs p on cp.id_produs = p.id_produs
    where c.nume_client = nume;
    DBMS_OUTPUT.PUT_LINE(nume || ' a cumparat produse in valoare de ' || suma || ' lei.');
    exception
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Clientul ' || nume || ' nu exista.');
            --DBMS_OUTPUT.PUT_LINE('Clientul ' || nume || ' nu exista.');
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Too many rows.');
end;
/

begin
    ex9('X');
end;
/