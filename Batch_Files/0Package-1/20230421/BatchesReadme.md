## Package-1 机器上使用的 bat 脚本

使用 `TeamCity_` 开头的一系列脚本以及 `Diffcopy.bat`, `ModifyVerProp.bat`, 以及其它 bat 脚本

### Init
20230421
- 在 Package-1 机器上不使用的脚本：
    - AutoPacking.bat
    - AutoPacking_shipping.bat
    - copyto_Y.bat
    - DiffcopyAndCompress.bat
    - SendDingMsg.bat
    - SendFailMsg.bat


- 每个脚本的说明
    - AutoBuilding.bat
        - 自动构建，里面调用了 GenerateProjectFiles.bat, Build_t6.bat 和 puerts.gen.bat
    - AutoBuildingAndStartProject.bat
        - 自动构建并开启项目
    - AutoPacking_shipping_to_publish.bat
        - 自动在 Y:/new 打 shipping 包，会删除所有，谨慎使用！
    - AutoPacking_shipping.bat
        - 自动在 %~dp0Projects\t6\ArchivedBuilds 目录打 shipping 包，会删除所有，谨慎使用！
    - AutoPacking.bat
        - 自动在 %~dp0Projects\t6\ArchivedBuilds 目录打 development 包，会删除所有，谨慎使用！
    - Build_t6.bat
        - 构建 t6 项目
    - copyto_Y.bat
        - 复制文件到 Y 盘的测试，可删
    - Diffcopy_test.bat
        - 测试 DiffcopyCompressTransfer.bat 的文件，给 prevvernum 和 currvernum 可打出增量包并压缩，然后复制到 Y:\CICI_Packages\prevvernum_currvernum
    - Diffcopy.bat
        - 打增量包，TeamCity_Packing.bat 中有调用
    - DiffcopyAndCompress.bat 
        - 打增量包并压缩的测试，可删
    - DiffcopyCompressTransfer.bat
        - 接收两个参数，打增量包并压缩，复制到 Y:\CICI_Packages\prevvernum_currvernum
    - GenerateProjectFiles.bat
        - UE 引擎自带的生成 Proejct 文件的脚本
    - ModifyVerProp.bat
        - 打包成功且 Diffcopy 成功之后修改 versioncontrol.properties 文件，修改当前 ver，上一个 ver，使用过的 ver
    - p4ignore.bat
        - 只有第一次需要运行，忽略 p4 不必要的部分
    - Packing.bat
        - 打包的具体执行脚本，包含目录设置， 预编译？ 调用 uat 打包 client 和 server
    - SendDingMsg.bat 
        - 发送钉钉消息，接收参数 0 为成功，1 为失败
    - SendFailMsg.bat
        - SendDingMsg 的之前版本，可删
    - Setup.bat
        - UE 引擎源码 Setup
    

    - TeamCity_AutoPacking_shipping_to_publish_ANSI.bat
        - 弃用
    - TeamCity_AutoPacking_shipping.bat
        - TeamCity 目前正在使用的打包入口，会调用 TeamCity_AutoPacking.bat
    - TeamCity_AutoPacking.bat
        - TeamCity 目前正在使用的打包操作，根据 p4 changelist 创建版本号命名的文件夹，调用 TeamCity_Packing.bat
    - TeamCity_CopyToNetDisk.bat
        - copy 新的完整包、增量包、releases、versioncontrol.properties 到 Y:\CICD_Packages
    - TeamCity_Packing.bat 
        - TeamCity 目前正在使用的打包实际命令
    - TeamCity_SendDingMsg.bat
        - TeamCity 目前正在使用的发送钉钉消息命令，接收一个参数 0 成功，1 失败
    - TestCopyToNetDisk.bat
        - 可删
    - TestDiffCopy.bat
        - 可删
    - TestDiffPkg.bat
        - ！！！这个不要删，这是 根据 versioncontrol.properties 中进行每个文件夹比对，一个一个合并文件夹得到最终差分包的脚本
    

### Modified
