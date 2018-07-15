set U8PATH=C:\U8Soft\
set TARPATH=C:\ax\
set U8INTEROP=%U8PATH%Interop\
set U8COMSQL=%U8PATH%ufcomsql\
set TLBPARAM=/sysarray /unsafe /machine:X86
set AXPARAM=/source
set TLBIMP=%TARPATH%ztlbimp2.exe
set AXIMP=%TARPATH%zaximp.exe
set R_=/reference:
echo off
cd %TARPATH%
del *.dll
::-- 生成ADODB v2.8版本的Interop文件
 %TLBIMP% "C:\Program Files (x86)\Common Files\System\ado\msado28.tlb" /namespace:ADODBV28 /out:"ADODBV28.dll" %TLBPARAM%

call:AddRef %U8INTEROP%Interop.U8Login.dll
call:AddRef %TARPATH%adodbv28.dll
call:AddRef C:\Windows\assembly\GAC\ADODB\7.0.3300.0__b03f5f7f11d50a3a\adodb.dll
echo.%TLBPARAM%
call:TLBIMP %U8COMSQL%UAPvouchercontrol85.ocx
call:AddRef %TARPATH%VBA.dll
call:AddRef %TARPATH%MSXML2.dll
call:AddRef %TARPATH%EDITLib.dll
call:AddRef %TARPATH%VBRUN.dll
call:AddRef %TARPATH%VSFlex8N.dll
call:AddRef %TARPATH%MSHierarchicalFlexGridLib.dll
call:AddRef %TARPATH%UFToolBarCtrl.dll
call:AddRef %TARPATH%UAPUfToolKit85.dll
call:AddRef %TARPATH%UAPVoucherControl85.dll

call:AXIMP  %U8COMSQL%UAPvouchercontrol85.ocx



mkdir u8vouchlist
cd u8vouchlist
del *.dll
echo.注册u8vouchlist.ocx
call:TLBIMP %U8COMSQL%U8VouchList.ocx
call:AddRef %cd%\Scripting.dll
call:AddRef %cd%\MsSuperGrid.dll
call:AddRef %cd%\VSFlex8U.dll
call:AddRef %cd%\U8VouchList.dll
call:AXIMP  %U8COMSQL%U8VouchList.ocx
call:AXIMP  %U8COMSQL%vsflex8u.ocx

del Ax*.dll
del Ax*.pdb


cd ..
mkdir U8RefEdit
cd U8RefEdit
del *.dll
call:TLBIMP %U8COMSQL%U8RefEdit.ocx
call:AddRef %cd%\U8Ref.dll
call:AXIMP %U8COMSQL%U8RefEdit.ocx
del Ax*.dll
del Ax*.pdb
cd ..
mkdir UFGeneralFilterOCX
cd UFGeneralFilterOCX
del *.dll
call:TLBIMP %U8COMSQL%UFGeneralFilterOCX.ocx
call:AddRef %cd%\UFGeneralFilterPub.dll
call:AddRef %cd%\UFGeneralFilterOCX.dll
call:AXIMP  %U8COMSQL%UFGeneralFilterOCX.ocx
del Ax*.dll
del Ax*.pdb
cd ..
mkdir voucherco_sa
cd voucherco_sa
del *.dll
call:TLBIMP %U8COMSQL%voucherco_sa.dll
cd ..
mkdir PrintControl
cd PrintControl
del *.dll
call:TLBIMP %U8COMSQL%PrintControl.ocx
call:AddRef %cd%\PRINTCONTROLLib.dll
call:AXIMP  %U8COMSQL%PrintControl.ocx
del Ax*.dll
del Ax*.pdb
cd ..
mkdir US_Pz
cd US_Pz
del *.dll
call:TLBIMP %U8COMSQL%US_Pz.dll
call:AddRef %cd%\ADOX.dll
call:AddRef %cd%\DAO.dll
call:AddRef %cd%\U8DefPro.dll
call:AddRef %cd%\U8RowAuthsvr.dll
call:AddRef %cd%\UfDbKit.dll
call:AddRef %cd%\UFPortalProxyInterface.dll
call:AddRef %cd%\ZzPub.dll
call:AddRef %cd%\ZzPz.dll
cd ..

mkdir ReferMakeVouch
cd ReferMakeVouch
del *.dll
call:TLBIMP %U8COMSQL%ReferMakeVouch.ocx
call:AddRef %cd%\ReferMakeVouch.dll
call:AXIMP  %U8COMSQL%ReferMakeVouch.ocx
call:AXIMP C:\Windows\SysWOW64\MSCOMCTL.OCX
del Ax*.dll
del Ax*.pdb
cd ..


call:AXIMP %U8COMSQL%UFToolBarCtrl.ocx

goto:eof

::--------------------------------------------------------
::-- 函数部分开始
::--------------------------------------------------------
:TLBIMP    - here starts my function identified by it`s label
::echo. 生成 %~1
%TLBIMP% "%~1"  %TLBPARAM%
goto:eof

::--------------------------------------------------------
::-- 函数部分开始
::--------------------------------------------------------
:AXIMP    - here starts my function identified by it`s label
::echo. 生成 %~1
%AXIMP% "%~1"  %AXPARAM%
goto:eof

::--------------------------------------------------------
::-- Ref增加函数
::--------------------------------------------------------
:AddRef    - here starts my function identified by it`s label
echo. AddRef %~1
set TLBPARAM=%R_%"%~1" %TLBPARAM%
set AXPARAM=/rcw:"%~1" %AXPARAM%
goto:eof