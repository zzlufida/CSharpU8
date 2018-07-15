# CSharpU8
一个快速生成U8相关COM Interop的工程,用于给C#语言进行调用,包括控件
## 文件基本信息
 - Bin\ZTlbImp2.exe 这是一个经过特殊绿化处理的Interop生成工具,他可以在Win7和Win2008系统中正常的生成Interop文件,不会遇到ADODB引用错误.
 - Bin\ZAxImp.exe 这也经过特殊绿化,可以配合Interop文件生成AxHost包装类,我使用的是/source参数,直接生成源码文件.
 - Start.bat是批处理脚本,执行后,会在目标文件夹下生成一套相应的Interop文件,具体包含哪些COM组件和OCX控件可以自己修改.
 - License.reg是OCX控件的设计许可证,直接双击导入注册表就可以正常在VS中拖拽控件了.
 ## 工作原理
 Start.bat 执行时会确定3个信息:
 
 1 U8的安装目录
 
 2 Bin目录位置
 
 3 生成结果保存目录
 
 以上三个信息需要在Start.bat脚本中,手工修改,就在前三行.
 
 然后工具会把需要的每一个COM组件对应的Interop文件, 生成到一个对应名称的文件夹下面,为了看到顺序,我使用编码开头来命名文件夹,例如00COMMON,01UAPVouchControl85等等.
 
 
