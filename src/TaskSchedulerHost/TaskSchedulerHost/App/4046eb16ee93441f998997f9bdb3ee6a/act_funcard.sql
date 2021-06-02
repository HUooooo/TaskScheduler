USE [act_funcard]
GO
----------------------------------------------------------
-- Procedure Name: cc p_act_time_validate,0,1
-- Author: liubin
-- Date Generated: 2020��06��17��
-- Description: �ʱ����֤
----------------------------------------------------------
ALTER procedure [dbo].[p_act_time_validate]
@outmsg varchar(128) = '' output
as
set nocount on
set transaction isolation level read uncommitted
set xact_abort on

declare @datetime datetime = getdate()

--�ʱ�� 2020��01��13 - 2020��01��26

if @datetime >= '2021-02-22' and @datetime <= '2021-03-07'
begin
    set @outmsg = '�������'
	return 1
end

set @outmsg = '��Ѿ�����'
return 0
