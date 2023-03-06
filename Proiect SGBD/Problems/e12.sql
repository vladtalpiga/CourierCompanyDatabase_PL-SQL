--Creati un trigger care sa ii dea permisiuni
--de modificare a schemei doar userului 'SYSTEM'.
--Salvati toate modificarile in tabelul audit_user.

create table audit_user(
    utilizator varchar2(30),
    nume_bd varchar2(50),
    eveniment varchar2(20),
    nume_obiect varchar2(30),
    data date
);

create or replace trigger audit_schema
    before create or alter or drop on schema
begin
    if user != 'X' then
        RAISE_APPLICATION_ERROR(-20102, 'Doar admin-ul are dreptul sa modifice schema.');
    end if;
    insert into audit_user
    values (sys.login_user, sys.database_name, sys.sysevent, sys.dictionary_obj_name, sysdate);
end;
/

alter table depozit
add supraf number(4);

alter table depozit
add nr_zone number(4);

rollback;

create table ambalaj (
    id_ambalaj number(3) primary key,
    id_produs number(3) not null,
    foreign key (id_produs) references produs(id_produs),
    pret_ambalaj number(5)
);

drop table ambalaj;

--select * from audit_user;

drop trigger audit_schema;
