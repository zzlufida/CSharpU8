# CSharpU8
一个快速生成U8相关COM Interop的工程,用于给C#语言进行调用,包括控件
## 文件基本信息
 - Bin\ZTlbImp2.exe 这是一个经过特殊绿化处理的Interop生成工具,他可以在Win7和Win2008系统中正常的生成Interop文件,不会遇到ADODB引用错误.
- Bin\ZTlibImp.exe 这个是微软原装的TlbImp文件包装的,经过特殊绿化,但是不建议使用,他在遇到变体类型参数的时候,会有一些错误,不适合和AxImp配合使用,所以我都使用ZTlbImp2,这个就是临时放在这里,如果遇到问题,可以切换进行对比.
 - Bin\ZAxImp.exe 这也经过特殊绿化,可以配合Interop文件生成AxHost包装类,我使用的是/source参数,直接生成源码文件.
 - Start.bat是批处理脚本,执行后,会在目标文件夹下生成一套相应的Interop文件,具体包含哪些COM组件和OCX控件可以自己修改.
 - License.reg是OCX控件的设计许可证,直接双击导入注册表就可以正常在VS中拖拽控件了.
 ## 工作原理
 Start.bat 执行时会确定3个信息:
 
 1 U8的安装目录
 
 2 Bin目录位置
 
 3 生成结果保存目录
 
 以上三个信息需要在Start.bat脚本中,手工修改,就在前三行.
 
 然后工具会把需要的每一个COM组件产生的Interop文件, 生成到一个文件夹下面,文件夹的名称正好和COM组件名称一致,但是为了看到顺序,我在名字前面故意加上了顺序编号,例如00COMMON,01UAPVouchControl85等等.
 
 过程中工具主要调用ZTlbImp2来生成Interop的DLL,然后调用ZAxImp来生成控件的AxHost包装类源码文件.并在最后将所有生成好的文件统一放在一个叫做Target的文件夹下面,换言之这里面存储了整个生成过程的结果,其余文件夹都是过程中的部分结果.例如00文件夹和01文件夹加起来所有的文件正好等于Target,这样做的目的是为了调试方便(每一步都去看编码文件夹),最后拿到结果也方便(直接去Target).
 
 默认情况下,工具生成的COM组件包括:
 
| 文件名 | 描述 |
| -------- |-------- |
|ADODBV28.dll|ADODB 2.8版本 对应msado28.tlb|
|UAPvouchercontrol85| U8单据控件|
|u8vouchlist| U8单据列表控件|
|U8RefEdit| U8参照控件 带文本框编辑功能|
|UFGeneralFilterOCX|  U8过滤控件|
|voucherco_sa|销售模块CO类,API调用的关键类|
| PrintControl|U8打印控件|
|US_Pz|凭证组件 这个用处不是很大|
|ReferMakeVouch|这个我也不清楚,仅仅是测试用|
 
 
