echo off
::--请指明用友软件的安装目录
set U8PATH=C:\U8Soft\
::--请指定需要将结果保存到哪个目录
set TARPATH=C:\AX_U8V1300\
::--请指定工具命令所在的目录
set BINPATH=C:\ax_new\Bin\

set U8INTEROP=%U8PATH%Interop\
set U8COMSQL=%U8PATH%ufcomsql\
set TLBPARAM=/sysarray /unsafe /machine:X86 /silent
set AXPARAM=/source
set TLBIMP=%BINPATH%ztlbimp2.exe
set AXIMP=%BINPATH%zaximp.exe
set R_=/reference:
set FR=%BINPATH%fr.exe

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
call:AddRefByDir %cd%
call:GORet

echo.%TLBPARAM%
::第三步 顺序生成ocx和dll对应的interop文件
call:CreateDLLAndAxHost 01UAPvouchercontrol85 %U8COMSQL%UAPvouchercontrol85.ocx

call:CreateDLLAndAxHost 02u8vouchlist %U8COMSQL%U8VouchList.ocx

call:CreateDLLAndAxHost 03U8RefEdit %U8COMSQL%U8RefEdit.ocx

call:CreateDLLAndAxHost 04UFGeneralFilterOCX %U8COMSQL%UFGeneralFilterOCX.ocx

call:CreateDLL 05voucherco_sa %U8COMSQL%voucherco_sa.dll

call:CreateDLLAndAxHost 06PrintControl %U8COMSQL%PrintControl.ocx

call:CreateDLL 07US_Pz %U8COMSQL%US_Pz.dll

call:CreateDLLAndAxHost 08ReferMakeVouch %U8COMSQL%ReferMakeVouch.ocx

call:GODIR 09UFToolBarCtrl
call:AXIMP %U8COMSQL%UFToolBarCtrl.ocx
call:GORet

call:GODIR 10MSCOMCTL
call:AXIMP c:\windows\syswow64\MSCOMCTL.OCX
call:GORet


%FR% %TARPATH%Target\*.cs /r:"public\sclass\s(.*)\s[:]\sSystem.Windows.Forms.AxHost" -t:"[System.ComponentModel.ToolboxItem(true)]\n    public class \1 : System.Windows.Forms.AxHost"
%FR% %TARPATH%Target\*.cs /r:"[[]assembly: System.Reflection.AssemblyVersion.*\n" /t:""
%FR% %TARPATH%Target\*.cs /r:"[[]assembly: System.Windows.Forms.AxHost.TypeLibraryTimeStamp.*\n" /t:""
goto:eof

::--------------------------------------------------------
::-- TLB生成函数，调用tlbimp执行COM组件的interop工作
::--------------------------------------------------------
:TLBIMP    - here starts my function identified by it`s label
::echo. 生成 %~1
%TLBIMP% "%~1"  %TLBPARAM% >tlbimp.log
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
mkdir %~1 >nul
cd %~1 >nul
del *.dll >nul
goto:eof

::--------------------------------------------------------
::-- GORet函数，和GODIR配对使用，
::-- 用于从GODIR中快速返回到工作主目录
::--------------------------------------------------------
:GORet
del Ax*.dll >nul
del Ax*.pdb >nul
copy *.cs %TARPATH%Target >nul
copy *.dll %TARPATH%Target >nul
cd %TARPATH%
goto:eof

::--------------------------------------------------------
::-- AddRefByDir罗列某目录下的所有dll文件，并自动调用AddRef
::--------------------------------------------------------
:AddRefByDir %~1
:: 参数 /R 表示需要遍历子文件夹,去掉表示不遍历子文件夹
:: %%f 是一个变量,类似于迭代器,但是这个变量只能由一个字母组成,前面带上%%
:: 括号中是通配符,可以指定后缀名,*.*表示所有文件
for /R %~1 %%f in (*.dll) do ( 
call:AddRef %%f
)
goto:eof

::--------------------------------------------------------
::-- CreateDLLAndAxHost 调用tlbimp和axImp生成
::--------------------------------------------------------
:CreateDLLAndAxHost %~1 %~2
call:GODIR %~1
call:TLBIMP %~2
call:AddRefByDir %cd%
call:AXIMP  %~2
call:GORet
goto:eof

::--------------------------------------------------------
::-- CreateDLL 调用tlbimp生成
::--------------------------------------------------------
:CreateDLL %~1 %~2
call:GODIR %~1
call:TLBIMP %~2
call:AddRefByDir %cd%
call:GORet
goto:eof
