use[lxyuan_activity]

GO
----------------------------------------------------------
-- Procedure Name: cc p_gift_sort,2,0
-- Author: liubin
-- Date Generated: 2020��07��21��
-- Description: �������
----------------------------------------------------------

ALTER procedure [dbo].[p_gift_sort]
@rid int = 0,	--��Ҫ�ƶ���id
@move int = 1,	--�ƶ����� -2:�õ�, -1:����, 1:����, 2�ö�,
@outmsg varchar(128) = '' output
as
set nocount on
set transaction isolation level read uncommitted
set xact_abort on

declare @sort int = 0, @distsort int = 0, @distrid int = 0
select @sort = sort from t_gift where rid = @rid and status = 0
if @@ROWCOUNT <= 0
begin
    set @outmsg = 'û���ҵ������'
	return 0
end
if @move = -2
    select top 1 @distrid = rid, @distsort = sort from t_gift where status = 0 order by sort asc
else if @move = 1
    select top 1 @distrid = rid, @distsort = sort from t_gift where sort > @sort and status = 0 order by sort asc
else if @move = -1
    select top 1 @distrid = rid, @distsort = sort from t_gift where sort < @sort and status = 0 order by sort desc
else if @move = 2
    select top 1 @distrid = rid, @distsort = sort from t_gift where status = 0 order by sort desc
if @@ROWCOUNT <= 0
begin
    set @outmsg ='��ǰ��Ʒ�Ѿ����ܽ����ƶ���'
	return 0
end

select * from t_gift

if @move = -2
begin
    update t_gift set sort = @distsort - 1 where rid = @rid
	if @@ROWCOUNT <= 0
    begin
        set @outmsg = '�õ�ʧ��'
	    return 0
    end 
end
else if @move = 2
begin
    begin tran
	update t_gift set sort -= 1 where sort > @sort
	if @@ROWCOUNT <= 0
	begin
	    set @outmsg = '�ö�ʧ��'
		rollback tran
		return 0
	end
	update t_gift set sort = @distsort where rid = @rid
	if @@ROWCOUNT <= 0
	begin
	    set @outmsg = '�ö�ʧ��'
		rollback tran
		return 0
	end

	commit tran
end
else
begin
    begin tran
    update t_gift set sort = @distsort where rid = @rid
    if @@ROWCOUNT <= 0
    begin
        set @outmsg = '�ƶ�ʧ��'
	    return 0
    end
    update t_gift set sort = @sort where rid = @distrid
    if @@ROWCOUNT <= 0
    begin
        set @outmsg = '�ƶ�ʧ��'
	    rollback tran
	    return 0
    end
    commit tran
end

set @outmsg = '�ƶ��ɹ�'
return 1