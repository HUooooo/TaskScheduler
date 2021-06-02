use[lxyuan_giftcenter]

GO
----------------------------------------------------------    
-- function Name: cc f_stone_tovarchar
-- Author: zhongzhenyu    
-- Date Generated: 2017��11��7��    
-- Description: ��ʽ���ֱ�    
----------------------------------------------------------    
create function [dbo].[f_stone_tovarchar](@instone bigint)returns varchar(128)
as  
begin
    declare @charstone varchar(128),@temp1 decimal(16,2),@temp2 decimal(16,2)  
    if @instone>=100000000  
    begin  
        if @instone%100000000=0  
            set @charstone=CONVERT(varchar,@instone/100000000)+'��'  
        else if @instone%10000000=0  
        begin  
            set @temp1=@instone/100000000.0  
            set @charstone=CONVERT(varchar,@temp1)+'��'  
        end  
        else  
        begin  
            set @temp2=@instone/100000000.00  
            set @charstone=CONVERT(varchar,@temp2)+'��'  
        end  
    end  
    else if @instone>=10000  
    begin  
        if @instone%10000=0  
            set @charstone=CONVERT(varchar,@instone/10000)+'��'  
        else if @instone%1000=0  
        begin  
            set @temp1=@instone/10000.0  
            set @charstone=CONVERT(varchar,@temp1)+'��'  
        end  
        else  
        begin  
            set @temp2=@instone/10000.00  
            set @charstone=CONVERT(varchar,@temp2)+'��'  
        end  
    end  
    else  
        set @charstone=CONVERT(varchar,@instone)  
            
    return @charstone
end

GO
----------------------------------------------------------  
-- Procedure Name: cc p_job_assign_bynewuser,0,1  
-- Author: liubin  
-- Date Generated: 2020��10��20��  
-- Description: �ѷ������������û����뵽ָ������б���  
----------------------------------------------------------  
  
ALTER procedure [dbo].[p_job_assign_bynewuser]  
as  
set nocount on  
set transaction isolation level read uncommitted  
set xact_abort ON  
  
declare @date date = getdate(), @gid int = 106, @count int = 0, @i int = 0, @userid int = 0, @point int = 0  
declare @content varchar(1024) = '��ϲ������׳丣�������Ȩ��(url=http://cz.lexun.com/WelfarePackage/index.php?)ԭ��17Ԫ�������ֻҪ10Ԫ���ɹ��򣡽��޽��գ���������̻������޶�����x30�졢10���ֱҡ���(/url)�Ķ����������ж��ɣ�'  
create table #tb (rid int identity primary key,  userid int)  
  
--�ж�106����Ƿ��¼�  
if exists (select 1 from t_gift where rid = @gid and starttime <= getdate() and endtime > getdate() and status = 0)  
begin
    --��ѯ�����������û�  
    insert into #tb(userid)  
    select userid from LinkSRV214.lxmyzone.dbo.t_user_lastlogin where lastlogindate >= @date  
    and userid not in (select userid from t_user_gift_log group by userid)  
    and userid not in (select userid from t_user_gift_assign where gid = @gid) and userid >= 10000
	set @count = @@ROWCOUNT  
    --��ӵ�Ŀ�����  
    insert into t_user_gift_assign(gid, userid) select @gid, userid from #tb 
    --������  
    while @i < @count  
    begin  
        set @i += 1  
        select @userid = userid from #tb where rid = @i
		if not exists(select 1 from t_rejectmsg_user where userid = @userid)
           exec AsynProcQueue.dbo.p_if_sendmsg 10018,@userid,'','','',1,@content,1,0,'��������������û���ʾ','lxyuan_giftcenter','p_job_assign_bynewuser'  
    end  
end

--ÿ�·�δ������û�����
set @gid = 285
declare @month date = convert(char(8),getdate(),120) + '01'
declare @money decimal(9,2) = 0, @virmoney decimal(9,2) = 0, @stone bigint = 0
select @money = price, @virmoney = virprice, @stone = stone from t_gift g join t_gift_extra e on g.rid = e.gid where rid = @gid

set @i = 0
set @content = '��ϲ�����'+ltrim(datepart(mm,@month))+'���׳������Ȩ��ԭ��'+ltrim(convert(int, @virmoney))+'Ԫ��(u)��ֻҪ'+ltrim(convert(int, @money))+'Ԫ���ɹ���'+ltrim(datepart(mm,@month))+'������-ϲ��֮�������Ҷ��������'+dbo.f_stone_tovarchar(@stone)+'�ֱҡ�(/u)���������ۣ��ȵ��ȵã�(url=http://cz.lexun.com/WelfarePackage/index.php?)�������ǰ������(/url)'
truncate table #tb
--�ж�285����Ƿ��¼� 
if exists (select 1 from t_gift where rid = @gid and starttime <= getdate() and endtime > getdate() and status = 0)  
begin
    --��ѯ�����������û�
	insert into #tb(userid) select userid from LinkSRV214.lxmyzone.dbo.t_user_lastlogin where lastlogindate >= @date
	and userid not in (select userid from t_user_gift_log where dateflag >= @month and dateflag < dateadd(MM, 1, @month) group by userid)
	and userid not in (select userid from t_user_gift_assign where gid = @gid) and userid >= 10000
	set @count = @@ROWCOUNT  
    --��ӵ�Ŀ�����  
    insert into t_user_gift_assign(gid, userid) select @gid, userid from #tb 
    --������  
    while @i < @count  
    begin  
        set @i += 1  
        select @userid = userid from #tb where rid = @i
		exec LinkSRV9.gamehotelpage.dbo.p_active_user_getpoint @userid, 0, @point out
		if @point >= 10 and not exists(select 1 from t_rejectmsg_user where userid = @userid)
            exec AsynProcQueue.dbo.p_if_sendmsg 10018,@userid,'','','',1,@content,1,0,'��������������û���ʾ','lxyuan_giftcenter','p_job_assign_bynewuser' 
    end  
end

go