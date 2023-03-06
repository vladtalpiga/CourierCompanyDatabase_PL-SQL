--Fiind sezonul reducerilor, majoritatea
--produselor vor fi reduse si nu se poate 
--mari pretul acestora.
--Creati un trigger prin care sa nu se permita 
--cresterea pretului produselor.

create or replace trigger crestere_pret
    before update of pret_produs on produs
    for each row
    when (new.pret_produs > old.pret_produs)
begin
    RAISE_APPLICATION_ERROR(-20101, 'Pretul produselor nu poate fi majorat.');
end;
/

update produs
set pret_produs = pret_produs + 1
where id_produs = 500;

drop trigger crestere_pret;


    