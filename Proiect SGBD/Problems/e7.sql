--Sa se afiseze pretul total al livrarilor efectuate de
--curierul cu numele dat ca prim parametru, respectiv
--numarul de colete care au maxim greutatea data ca 
--al doilea parametru si cate produse contin in total 
--aceste colete.

create or replace procedure e7
    (nume curier.nume_curier%type,
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
end;
/

begin
    e7('David', 10);
end;
/