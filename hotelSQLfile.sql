create database Hotel

use Hotel

create table Rooms
(
r_code int identity(1,1) primary key,
r_floor int,
r_bedNum int not null,
r_doubleBedNum int not null,
r_babyBedNum int not null,
r_c_level int foreign key references  Levels(l_code) not null
)
insert into Rooms values
(1,3,2,1,1),
(2,3,2,1,1),
(3,3,2,1,1),
(3,10,5,4,2),
(1,5,1,2,3),
(2,5,1,2,3),
(2,5,1,2,3),
(1,0,1,1,4),
(3,0,1,0,5),
(2,0,1,0,5)


create table Levels
(
l_code int identity (1,1) primary key,
l_name nvarchar(30) not null,
l_bedPrice int not null
)

insert into Levels values
('suite',600),
('premium',800),
('family',300),
('dual',400),
('business',500)
create table Clients
(
c_id varchar(9)  primary key,
c_fname nvarchar(30) not null,
c_lname nvarchar(30) not null,
c_phone varchar(10) not null
)
insert into Clients values
('327709739','tami','yanai','0527114073'),
('215483660','ayala','mualem','0548574212'),
('326106663','yeudit','hirsh','0533117623'),
('327753141','tamar','eshed','0527638102'),
('215501925','yosef','cohen','0527689543')
create table Orders
(
o_code int identity (1,1) primary key,
o_idClient varchar(9) foreign key references  Clients(c_id) not null,
o_childrenNum int not null,
o_babiesNum int not null,
o_date date not null,
o_nightsNum int not null,
o_price int
)

insert into Orders values
('327709739',4,1,'10/25/2024',2,0),
('215483660',10,2,'6/26/2024',4,0),
('326106663',0,0,'10/5/2024',3,0),
('327753141',5,1,'10/5/2024',6,0),
('215501925',2,0,'5/7/2024',1,0)
select * from Orders

create table Bonuses
(
b_code int identity (1,1) primary key,
b_description nvarchar(100),
b_workTCode int foreign key references  WorksType(wt_code) not null,
b_price float not null
)

insert into Bonuses values
('cleaning rooms',3,100),
('tasks performance',2,50),
('meals prepare',4,100),
('meals serving',4,10),
('children actions',2,50),
('clothes washing',3,30)
select * from Bonuses

create table BonusInOrder
(
bio_code int identity (1,1) primary key,
bio_codeOrder int foreign key references  Orders(o_code) not null,
bio_codeBonus int foreign key references  Bonuses(b_code) not null,
bio_date date not null
)
insert into BonusInOrder values
(1,1,'10/26/2024'),
(1,3,'10/26/2024'),
(1,4,'10/26/2024'),
(2,3,'7/28/2024'),
(2,4,'7/28/2024'),
(2,3,'7/1/2024'),
(2,4,'7/1/2024'),
(3,6,'10/6/2024'),
(4,5,'10/6/2024'),
(4,1,'10/6/2024'),
(5,3,'5/8/2024')

select * from BonusInOrder
create table RoomsInOrder
(
rio_code int identity (1,1) primary key,
rio_codeOrder int foreign key references  Orders(o_code) not null,
rio_codeRoom int foreign key references  Rooms(r_code) not null
)

insert into RoomsInOrder values
(1,5),
(2,4),
(3,8)

select * from RoomsInOrder
create table Privileges
(
p_code int identity (1,1) primary key,
p_privilege nvarchar(50) not null,
p_hourPayment float not null
)
insert into Privileges values
('manager','100'),
('officer','40'),
('cleaner','40'),
('chef','40')

create table Workers
(
w_id varchar(9) primary key,
w_fname nvarchar(30) not null,
w_lname nvarchar(30) not null,
w_phone varchar(10) not null,
w_workDays varchar(7) not null,
w_codeP int foreign key references  Privileges(p_code) not null
)
insert into Workers values
('325672657','ruti','tiko','0548551090', '1100111', 2),
('034812099','moshe','levi','0527114905',    '1111100',2),
('327812855','avigail','stachi','0527114905','0000011',2),
('215500398','ayala','zigler','0548552253','1101100',4),
('325855518','yafi','kolp','0548552253',   '0010011',4),
('215501925','yosef','cohen','0527689543', '0011100',3),
('328865780','shoshi','mish','0527689699', '1100011',3),
('327709739','tami','yanai','0527114073',  '1111111',1)
select * from Workers
drop table Workers
create table Works
(
w_code int identity (1,1) primary key,
w_idWorker varchar(9) foreign key references Workers(w_id) not null,
w_done int not null,
w_bonusIOCode int foreign key references BonusInOrder(bio_code) not null
)
drop table Works

insert into Works values
('325672657',0,9),
('328865780',0,1),
('215501925',0,1),
('215501925',0,10),
('215501925',0,10),
('327709739',0,10),
('215500398',0,2),
('215500398',0,3)
select * from Works

create table WorksType
(
wt_code int identity (1,1) primary key,
wt_description nvarchar(100),
wt_codePrivilege int foreign key references  Privileges(p_code) not null
)
insert into WorksType values
('running',1),
('office and more',2),
('clean',3),
('kitchen',4)

--בדיקת תקינות - קומה בבית המלון יכולה להיות בין 1-3
alter table [dbo].[Rooms] add constraint R_floor check ([r_floor] >=1 and [r_floor]<=3)
--בדיקת תקינות - טלפון לקוח
alter table [dbo].[Clients] add constraint C_phone check ([c_phone] like ('[0][5][0-6,8-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')) 
--בדיקת תקינות - טלפון עובד
alter table [dbo].[Workers] add constraint W_phone check ([w_phone] like ('[0][5][0-6,8-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
--בדיקת תקינות - ימי עבודה של העובד 
alter table [dbo].[Workers] add constraint W_days check ([w_workDays] like ('[0-1][0-1][0-1][0-1][0-1][0-1][0-1]'))
-- בדיקת תקינות - סטטוס עבודה שווה ל0 או ל1
alter table [dbo].[Works] add constraint W_done check ([w_done] =0 or [w_done] =1)


---------------------------------------------------------------qweries----------------------------------------------------------------------------------------------
--הבאת רשימת משימות של יום מסוים
select * from Works inner join BonusInOrder on w_bonusIOCode=bio_code where bio_date = '10/26/2024'

--הבאת רשימת משימות לעובד מסוים
select * from Works inner join Workers on w_idWorker=w_id where w_id='215500398'

--בדיקה אילו חדרים תפוסים בתאריך המבוקש  
select r_code, l_name from Levels inner join (Rooms inner join (RoomsInOrder inner join Orders on rio_codeOrder=o_code)
on r_code=rio_codeRoom)on l_code=r_c_level where o_date='10/5/2024'

--(בדיקה אילו משימות עדיין לא נעשו (סטטוס = 0
select Bonuses.b_description, BonusInOrder.bio_date from Works inner join
(BonusInOrder inner join Bonuses on bio_codeBonus=b_code) on w_bonusIOCode=bio_code where w_done=0


------------------------------------------------------------------------view----------------------------------------------------------------------------------------
--view רשימת משימות לעובד
create view tasksList
as
select w_code , bio_date, bio_codeBonus, w_done  from BonusInOrder inner join
( Works inner join Workers on w_idWorker=w_id) on bio_code= w_bonusIOCode where w_id='328865780'

--רשימת עובדי ניקיון
create view cleaners
as 
select  w_id ,w_fname+ ' '+w_lname as name, w_workDays from Workers 
inner join Privileges on w_codeP=p_code where p_privilege='cleaner'



-------------------------------------------------------------------functions--------------------------------------------------------------------------------------



-----------------בדיקה אם פנוי למס' הלילות שרוצים לפי חדר Vv
go
create function ifitEmpty(@date date, @rcode int, @numofN int)
returns int
as begin
declare @s1 int, @num int
select @s1= count(o_code)  from  Rooms inner join (RoomsInOrder inner join Orders on rio_codeOrder=o_code) on r_code=rio_codeRoom
  where r_code=@rcode
  select @num = count(o_code) from Rooms inner join (RoomsInOrder inner join Orders on rio_codeOrder=o_code) on r_code=rio_codeRoom
  where r_code=@rcode and (@date >dateadd(dd,o_nightsNum,o_date) or dateadd(dd,@numofN,@date) < o_date)
  if (@num = @s1)
return 1
return 0
end

declare @x bit = [dbo].[ifitEmpty]('10/5/2025', 8,2)
print @x


--פונקציה שעוברת על החדרים ומביאה טבלת חדרים שמתאימים למס' המתארחים ולחדרים X
alter function roomsForGuest(@orderC int)
returns @t table
(
r_code int,
r_babyBedNum int,
r_doubleBedNum int
)
as begin
declare @i int=(select max(r_code) from Rooms ), @childnum int= (select o_childrenNum from Orders where o_code=@orderC),
@babynum int= (select o_babiesNum from Orders where o_code=@orderC),
@date date = (select Orders.o_date from Orders where o_code= @orderC), @numofn int= (select Orders.o_nightsNum from Orders where o_code= @orderC)
if (@babynum  > (select MAX(r_babyBedNum) from Rooms) or @childnum > (select MAX(r_doubleBedNum) from Rooms)*2  )
  insert into @t values
  (0,0,0)
else
while (@i>0)
   begin
   --להוסיף בדיקה האם קיים כזה קוד
     if ( ([dbo].[ifitEmpty](@date, @i,@numofn) = 1 and @babynum <= (select r_babyBedNum from Rooms where r_code=@i) and (@childnum <= (select r_doubleBedNum from Rooms)*2 ) )
         insert into @t values (@i, (select r_babyBedNum from Rooms where r_code=@i),  (select r_doubleBedNum from Rooms) )
     set  @i=@i-1
  end
return
end

select * from [dbo].[roomsForGuest](1)



--טבלת חדרים לכל לקוח vv
go
alter function roomsForClient(@c_id varchar(9)) 
returns table
as
return  (select *  from Rooms inner join 
(RoomsInOrder inner join (Orders inner join
Clients on o_idClient=c_id)on rio_codeOrder=o_code)
on r_code=rio_codeRoom  where o_idClient=@c_id )

select * from [dbo].roomsForClient('215483660') 

--מחיר כל המיטות בכל החדרים שהזמין לקוח מסוים  vv!!!!!!!!
go
create function bedPrice(@c_id varchar(9)) 
returns int
as begin
declare @r_code int, @i int=1,@bednum int=0, @price int=0, @plevel int
select @r_code=  max(rio_code) from [dbo].roomsForClient(@c_id) 
declare @code int= @r_code
while (@i<=@r_code)
begin
if (@i in (select rio_code from [dbo].roomsForClient(@c_id)))
   begin
     set @bednum= (select  r_bedNum from [dbo].[roomsForClient](@c_id) where rio_code=@i)
     set @bednum= @bednum+( select r_babyBedNum from [dbo].[roomsForClient](@c_id) where rio_code=@i)
      --מציאת מס' מיטות בכל חדרי הלקוח
     set @bednum= @bednum+ (select   r_doubleBedNum from [dbo].[roomsForClient](@c_id) where rio_code=@i)
     -- מחיר למיטה בכל חדר
     select @plevel= l_bedPrice from Levels where l_code= (select r_c_level from [dbo].[roomsForClient](@c_id) where rio_code=@i)
    set @plevel= (@plevel * @bednum)--סיכום כל מחיר חדר
     set @price = @price + @plevel
   end
  set @i= @i+1
 end
return  @price * (select o_nightsNum from Orders where o_idClient=@c_id)--מחיר סופי לפי מס' הלילות
end
 
declare @a int=[dbo].[bedPrice]('327709739')
print @a

--טבלת בונוסים לכל לקוח vv
go
create function bonusesForClient(@cid varchar(9))
returns table
as
return (select * from Bonuses inner join 
(BonusInOrder inner join (Orders inner join Clients on o_idClient=c_id)on bio_codeOrder=o_code)
on b_code=bio_codeBonus  where o_idClient=@cid)

select * from [dbo].[bonusesForClient]('327709739')

--מחיר כל הבונוסים שהזמין לקוח מסוים (אח"כ מזומן בפונקציה אחרת כדי לפרט את הוצאות הלקוח) Vv
go
create function bonusPrice(@c_id varchar(9)) 
returns int
as
begin
declare  @bprice int=0
set @bprice= (select sum(b_price) from [dbo].bonusesForClient(@c_id) )
return @bprice
end

declare @a int=  [dbo].bonusPrice('215483660')
print @a



--פונקציה המפרטת את המחיר הסופי לחדרים , ובונוסים - כמו חשבונית (לאחר הזנת פרטי בונוסים וחדרים) vv
go
alter function final_payment(@ordercode int)
returns @t table
(
priceofBonuses int,
priceofRooms int,
finalPrice int
)
as begin 
declare @cid varchar(9)= (select o_idClient from Orders where o_code=@ordercode)
declare @all int=0
declare @priceofBonuses int = [dbo].bonusPrice(@cid)
declare @priceofRooms int=  [dbo].bedPrice(@cid)
set @all=  @priceofBonuses+ @priceofRooms
insert into @t values (@priceofBonuses, @priceofRooms, @all)
return
end
 
select * from [dbo].final_payment(1)

--טריגר לאחר הוספת הזמנה, מציג את החדרים המתאימים ללקוח x
create trigger RoomsInsert
on [dbo].[Orders] for insert
as begin
--קריאה לפונקציה שבודקת איזה חדרים מתאימים ללקוח
   if( (select * from [dbo].[roomsForGuest](select o_code from Orders where o_code=  ( select o_code from  inserted))) = IS NULL 
   or  (select top1(r_code) from [dbo].[roomsForGuest](select o_code from Orders where o_code=(select o_code from  inserted))) =0)
      print ('rooms were not found')
   else
    begin
        insert into RoomsInOrder values (select o_code from inserted,   select top1(r_code) from [dbo].[roomsForGuest](select o_code from inserted))--קוד הזמנה וקוד חדר
        print ('your room is ' +select top1(r_code) from [dbo].[roomsForGuest](select o_code from inserted) 
        + 'at floor' + select Rooms.r_floor from Rooms where r_code= (select top1(r_code) from [dbo].[roomsForGuest](select o_code from inserted) )) +
        'the payment per bed:' + select l_bedPrice from Levels where l_code=(select rooms.r_c_level from rooms where r_code= (select top1(r_code) from [dbo].[roomsForGuest](select o_code from inserted)) )
    end
end

--טריגר לאחר הוספת בונוס בהזמנה, שיכניס את זה לרשימת העבודות ויעדכן את מחיר ההזמנה vv
go
create trigger addBonus
on [dbo].[BonusInOrder] for insert
as begin 
declare @bCode int= (select bio_codeBonus from BonusInOrder where bio_code =
(select bio_code from inserted))
declare @bTime date = (select bio_date from BonusInOrder where bio_code =
(select bio_code from inserted))
--מציאת העובד המתאים לבונוס שנוסף ושיבוץ העבודה על שמו
declare @wID varchar(9)= (select [dbo].[MinWorks](@bCode , @bTime))
insert into Works values
(@wID, 0, (select bio_code from BonusInOrder where bio_code = (select bio_code from inserted)) )
update Orders set [o_price] = [o_price] + (select b_price from Bonuses where b_code=@bCode)
where o_code= (select bio_codeOrder from inserted)
end

--פונקציה המביאה את העובד המתאים לבונוס, שעבודותיו הכי מינמליות vv
go
create function MinWorks(@codeBonus int, @date date)
returns varchar(9)
as begin
declare  @day int =(datepart(dw, @date))
declare @codeP int= (select p_code from Privileges inner join (WorksType inner join Bonuses on wt_code=b_workTCode)
on p_code=wt_codePrivilege where b_code= @codeBonus )
--הוצאת העובד שמתקיימים בו 3 תנאים: * בעל הרשאה מתאימה * עובד ביום המבוקש * בעל העבודות המינימליות
declare @min int = (select   top 1 count (w_code) as c from Works right join Workers on w_idWorker= w_id
where (w_codeP=@codeP  and left(substring( w_workDays ,@day,7-@day+1 ),1)=1) group by w_idWorker order by count (w_code)  )
declare @id varchar(9)=(select w_id from Workers left join Works on w_id=w_idWorker 
        where w_codeP= @codeP
        and left(substring( w_workDays ,@day,7-@day+1 ),1)=1     --מביא את היום המבוקש מתוך מחרוזת הימים של העובד ובודק אם הוא אכן עובד באותו יום
        and w_id in (select w_id from Workers left join Works on w_id=w_idWorker group by w_id having count(w_code)=@min)
        )  
        return @id
end

declare @id varchar(9)=(select [dbo].[MinWorks](2,'07-10-2024'))
print @id

--טריגר עדכון לאחר הוספת חדר, שמעדכן את מחיר ההזמנה בעוד מחיר חדר vv
alter trigger addRoom
on [dbo].[RoomsInOrder] for insert
as begin 
declare @bedPrice int = (select l_bedPrice from Levels where l_code=
(select r_c_level from Rooms inner join RoomsInOrder on r_code=rio_codeRoom 
where rio_code= (select rio_code from inserted) ))
declare @sumBed int = (select r_bedNum from Rooms inner join RoomsInOrder on r_code=rio_codeRoom 
where rio_code= (select rio_code from inserted) )
set @sumBed = @sumBed+ (select r_babyBedNum  from Rooms inner join RoomsInOrder on r_code=rio_codeRoom 
where rio_code= (select rio_code from inserted) )
set @sumBed = @sumBed+ (select r_doubleBedNum  from Rooms inner join RoomsInOrder on r_code=rio_codeRoom 
where rio_code= (select rio_code from inserted) )
update Orders set [o_price]   = [o_price] + (@sumBed * @bedPrice) 
where o_code= (select rio_codeOrder from inserted)
end


-------------------------------------------------------------------procedures---------------------------------------------------------------
--עדכון סטטוס עבודה ל-1, נעשתה vv
go
create procedure UpdateDone
@w_code int
as begin
update Works set [w_done] = 1 where w_code= @w_code
end

exec  [dbo].UpdateDone 1


insert into RoomsInOrder values(1,5)

select * from Works

select * from RoomsInOrder

insert into BonusInOrder values(5,2,'2024-1-8')


select * from BonusInOrder

select * from Works

select * from Orders

