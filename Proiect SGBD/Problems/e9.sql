create or replace procedure e9
    (nume client.nume_client%type)
as
    cod_client client.nume_client%type;
    type t_id_livrare is table of livrare.id_livrare%type;
    t_liv t_id_livrare := t_id_livrare();
    type t_id_colet is table of colet.id_colet%type;
    t_col t_id_colet := t_id_colet();
    aux t_id_colet := t_id_colet();
    type t_id_produs is table of colet_produs.id_produs%type;
    t_prod t_id_produs := t_id_produs();
    i number(3);
    j number(3);
    k number(3);
    suma number(10) := 0;
    pret number(10);
begin
    select id_client into cod_client
    from client
    where nume_client = nume;
    
    select id_livrare bulk collect into t_liv
    from livrare
    where id_client = cod_client;
    
    k := 1;
    for i in 1..t_liv.count loop
        select id_colet bulk collect into aux
        from colet
        where id_livrare = t_liv(i);

        for j in 1..aux.count loop
            t_col.extend;
            t_col(k) := aux(j);
            k := k + 1;
        end loop;
    end loop;
    
    for i in 1..t_col.count loop
        select id_produs bulk collect into t_prod
        from colet_produs
        where id_colet = t_col(i);
        
        for j in 1..t_prod.count loop
            select pret_produs into pret
            from produs 
            where id_produs = t_prod(j);
            suma := suma + pret;
--            DBMS_OUTPUT.PUT_LINE(t_prod(j));
        end loop;
    end loop;
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
    e9('Raul');
end;
/