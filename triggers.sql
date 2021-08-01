-- Check that dates of the order are leagle
delimiter $$
create trigger CHK_date before insert on orders
for each row
begin
	IF NEW.check_in >= NEW.check_out
	THEN
	    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Illegal Dates: check in cannot be after check out!';
	END IF;
	end; $$
delimiter ;

