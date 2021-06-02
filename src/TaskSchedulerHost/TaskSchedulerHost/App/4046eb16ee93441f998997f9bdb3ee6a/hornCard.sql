use[honor_card]

GO

----------------------------------------------------------
-- Procedure Name: cc p_act_phonecharge_order_update,0,1
-- Author: Lkl
-- Date Generated: 2021��04��28��
-- Description: ���ɶ���
----------------------------------------------------------

ALTER procedure [dbo].[p_act_phonecharge_order_update]
@rid int = 0,
@status int = 0,
@no varchar(256) = '',
@pws varchar(256) = '',
@outmsg varchar(128) = '' output
as
set nocount on
set transaction isolation level read uncommitted
set xact_abort on

declare @date date = getdate()
declare @userid int = 0, @money decimal(6,2) = 0, @phone char(11) = ''
declare @type int = 0
--��ѯ������Ϣ
select @userid = userid, @money = money, @type = type, @phone = phone from t_act_phonecharge_order where rid = @rid and status = 0
if @@ROWCOUNT <= 0 return

--���¶���״̬
update t_act_phonecharge_order set status = @status where rid = @rid
if @@ROWCOUNT <= 0 return

if @status = 1 and @type = 2
begin
    insert into  t_act_phonecharge_order_jdcard(orderid, userid, no, pws) values(@rid, @userid, @no, @pws)
	if @@ROWCOUNT <= 0 return
	--���Ϳ��ܶ��Žo�û�
	declare @content varchar(1024) = '���һ���50Ԫ�����������ͨ�����뾡���ھ�����Ʒ���жһ�ʹ�á����ţ�' + @no + '�����ܣ�' + @pws + '�����𽫴˶��Ž�ͼ���Ƹ����ˡ�'
	exec [AsynProcQueue].dbo.p_if_sendsms 16, 'E503B26687254BD790BDC5567C6779C5', @phone, @content, 'honor_card', 'p_act_phonecharge_order_update'
end

if @status = 1 and @type in (3,4)
begin
declare @ciid int = case @type when 3 then 215 else 214 end

declare @params varchar(1024) = '{"userid":'+ltrim(@userid)+', "ciid":' + ltrim(@ciid) + '}'
exec AsynProcQueue.dbo.p_if_asynproc_add @dbname = 'wawajivirtual', @procname = 'p_if_gift_add',
@params = @params, @remark = '�����ȯ�һ�', @dbsource = '192.168.1.50', @invokedatabase = 'honor_card', @invokeproc = 'p_act_phonecharge_order_update'

end

--��ֵʧ���˻�����
if @status = -1
begin
    --��Ӽ�¼
    insert into t_act_phonecharge_user_log(userid, rand, probability, stonein, type, money, remark)
    values(@userid, 0, 0, 0, 2000, @money, '��ֵ����ʧ���˻�')
    if @@ROWCOUNT <= 0 return
	--�����û����
	update t_act_phonecharge_user set money += @money, updatetime = getdate() where userid = @userid
end

