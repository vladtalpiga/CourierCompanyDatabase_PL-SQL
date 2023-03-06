create or replace package e13 as

    procedure e6 (cod_colet colet_produs.id_colet%type);
    
    procedure e7 (nume curier.nume_curier%type,
                  gr colet.greutate%type);
                  
    function e8 (nume curier.nume_curier%type, 
                 an vehicul.an_vehicul%type)
        return number;
        
    procedure ex9 (nume client.nume_client%type);

end e13;
/


create or replace package body e13 as

    procedure e6 (cod_colet colet_produs.id_colet%type)
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
    end e6;
    
    procedure e7 (nume curier.nume_curier%type,
                  gr colet.greutate%type)
    as
        cursor cp (x colet.greutate%type) is
            select id_colet
            from colet
            where greutate <= x;
            
        cursor cn is
            select pret_livrare pl
            from livrare
            where id_curier = (select id_curier 
                                from curier
                                where nume_curier = nume);
            
        cod_colet colet.id_colet%type;
        suma number(10) := 0;
        nr_colete number(3) := 0;
        nr_produse number(4) := 0;
        aux number(4);
    begin
        for i in cn loop
            suma := suma + i.pl;
        end loop;
        
        DBMS_OUTPUT.PUT_LINE('Pretul total al livrarilor efectuate de curierul '|| nume || ' este ' || suma || '.');
        
        open cp(gr);
        loop
            fetch cp into cod_colet;
            exit when cp%notfound;
            
            select count(*) into aux
            from colet_produs
            where cod_colet = id_colet;
            
            nr_colete := nr_colete + 1;
            nr_produse := nr_produse + aux;   
        end loop;
        close cp;
        DBMS_OUTPUT.PUT_LINE('Sunt ' || nr_colete || ' colete care au maxim ' || gr || ' kg si contin in total ' || nr_produse || ' produse.');
    end e7;
    
    function e8 (nume curier.nume_curier%type, 
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
    end e8;
    
    procedure ex9 (nume client.nume_client%type)
    as
        suma number(11);
        vf client.id_client%type;
    begin
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
    end ex9;

end e13;
/