echo off
::--请指明用友软件的安装目录
set U8PATH=C:\U8Soft\
::--请指定需要将结果保存到哪个目录
set TARPATH=C:\AX_U8V1300\
::--请指定工具命令所在的目录
set BINPATH=C:\ax_new\Bin\


set U8INTEROP=%U8PATH%Interop\
set U8COMSQL=%U8PATH%ufcomsql\
set TLBPARAM=/sysarray /unsafe /machine:X86
set AXPARAM=/source
set TLBIMP=%BINPATH%ztlbimp2.exe
set AXIMP=%BINPATH%zaximp.exe
set R_=/reference:

::第一步 前往目的目录
call:GODIR %TARPATH%
mkdir Target

::第二步 创建基础目录00COMMON,用于存放基础文件,为后面提供引用
call:GODIR 00COMMON
::-- 生成ADODB v2.8版本的Interop文件
 %TLBIMP% "C:\Program Files (x86)\Common Files\System\ado\msado28.tlb" /namespace:ADODBV28 /out:"ADODBV28.dll" %TLBPARAM%
::--拷贝interop.u8login.dll
copy %U8INTEROP%Interop.U8Login.dll %cd%\Interop.U8Login.dll 
::--拷贝v2.6版本的ADODB.dll
copy C:\Windows\assembly\GAC\ADODB\7.0.3300.0__b03f5f7f11d50a3a\adodb.dll %cd%\adodb.dll
call:AddRef %cd%\Interop.U8Login.dll
call:AddRef %cd%\adodbv28.dll
call:AddRef %cd%\adodb.dll
call:GORet

echo.%TLBPARAM%
::第三步 顺序生成ocx和dll对应的interop文件
call:GODIR 01UAPvouchercontrol85
call:TLBIMP %U8COMSQL%UAPvouchercontrol85.ocx
call:AddRef %cd%\VBA.dll
call:AddRef %cd%\MSXML2.dll
call:AddRef %cd%\EDITLib.dll
call:AddRef %cd%\VBRUN.dll
call:AddRef %cd%\VSFlex8N.dll
call:AddRef %cd%\MSHierarchicalFlexGridLib.dll
call:AddRef %cd%\UFToolBarCtrl.dll
call:AddRef %cd%\UAPUfToolKit85.dll
call:AddRef %cd%\UAPVoucherControl85.dll
call:AXIMP  %U8COMSQL%UAPvouchercontrol85.ocx
call:GORet


call:GODIR 02u8vouchlist
echo.注册u8vouchlist.ocx
call:TLBIMP %U8COMSQL%U8VouchList.ocx
call:AddRef %cd%\Scripting.dll
call:AddRef %cd%\MsSuperGrid.dll
call:AddRef %cd%\VSFlex8U.dll
call:AddRef %cd%\U8VouchList.dll
call:AXIMP  %U8COMSQL%U8VouchList.ocx
call:AXIMP  %U8COMSQL%vsflex8u.ocx
call:GORet


call:GODIR 03U8RefEdit
call:TLBIMP %U8COMSQL%U8RefEdit.ocx
call:AddRef %cd%\U8Ref.dll
call:AXIMP %U8COMSQL%U8RefEdit.ocx
call:GORet


call:GODIR 04UFGeneralFilterOCX
call:TLBIMP %U8COMSQL%UFGeneralFilterOCX.ocx
call:AddRef %cd%\UFGeneralFilterPub.dll
call:AddRef %cd%\UFGeneralFilterOCX.dll
call:AXIMP  %U8COMSQL%UFGeneralFilterOCX.ocx
call:GORet

call:GODIR 05voucherco_sa
call:TLBIMP %U8COMSQL%voucherco_sa.dll
call:GORet


call:GODIR  06PrintControl
call:TLBIMP %U8COMSQL%PrintControl.ocx
call:AddRef %cd%\PRINTCONTROLLib.dll
call:AXIMP  %U8COMSQL%PrintControl.ocx
call:GORet


call:GODIR 07US_Pz
call:TLBIMP %U8COMSQL%US_Pz.dll
call:AddRef %cd%\ADOX.dll
call:AddRef %cd%\DAO.dll
call:AddRef %cd%\U8DefPro.dll
call:AddRef %cd%\U8RowAuthsvr.dll
call:AddRef %cd%\UfDbKit.dll
call:AddRef %cd%\UFPortalProxyInterface.dll
call:AddRef %cd%\ZzPub.dll
call:AddRef %cd%\ZzPz.dll
call:GORet

call:GODIR 08ReferMakeVouch
call:TLBIMP %U8COMSQL%ReferMakeVouch.ocx
call:AddRef %cd%\ReferMakeVouch.dll
call:AXIMP  %U8COMSQL%ReferMakeVouch.ocx
call:AXIMP C:\Windows\SysWOW64\MSCOMCTL.OCX
call:GORet

call:GODIR 09UFToolBarCtrl
call:AXIMP %U8COMSQL%UFToolBarCtrl.ocx
call:GORet

goto:eof

::--------------------------------------------------------
::-- TLB生成函数，调用tlbimp执行COM组件的interop工作
::--------------------------------------------------------
:TLBIMP    - here starts my function identified by it`s label
::echo. 生成 %~1
%TLBIMP% "%~1"  %TLBPARAM%
goto:eof

::--------------------------------------------------------
::-- AXIMP函数，调用AxImp生成控件的源代码文件
::--------------------------------------------------------
:AXIMP    - here starts my function identified by it`s label
::echo. 生成 %~1
%AXIMP% "%~1"  %AXPARAM%
goto:eof

::--------------------------------------------------------
::-- AddRef增加函数
::--------------------------------------------------------
:AddRef    - here starts my function identified by it`s label
echo. AddRef %~1
set TLBPARAM=%R_%"%~1" %TLBPARAM%
set AXPARAM=/rcw:"%~1" %AXPARAM%
goto:eof

::--------------------------------------------------------
::-- GODIR函数，创建组件对应的目录，让tlb和ax生成到该目录下，
::-- 方便生成后进行观察和调试
::--------------------------------------------------------
:GODIR
mkdir %~1
cd %~1
del *.dll
goto:eof

::--------------------------------------------------------
::-- GORet函数，和GODIR配对使用，
::-- 用于从GODIR中快速返回到工作主目录
::--------------------------------------------------------
:GORet
del Ax*.dll
del Ax*.pdb
copy *.* %TARPATH%Target
cd %TARPATH%
