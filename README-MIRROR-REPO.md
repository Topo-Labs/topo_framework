# Topo Framework 镜像仓库

本仓库提供精简的 Move 包依赖，避免合约项目拉取整套节点代码。本分支是手动同步的源码快照，不承诺按小时自动更新。

## 本次同步记录

- 镜像分支：`topo-mainnet-poc-v2`，从本仓库 `topo-mainnet`（`cb231032`）创建。
- 来源：[Topo-Labs/topo-chain](https://github.com/Topo-Labs/topo-chain) 的 `topo_poc_v2` 分支。
- 固定源提交：`8584f27cb7adace11825fdb65ad7f18fef1721fc`。
- 同步日期：2026-10-15。

| 源目录（相对源仓库根目录） | 镜像目录 | 跟踪文件数 |
| --- | --- | --- |
| `aptos-move/framework/move-stdlib/` | `move-stdlib/` | 46 |
| `aptos-move/framework/topo-stdlib/` | `topo-stdlib/` | 89 |
| `aptos-move/framework/topo-framework/` | `topo-framework/` | 232 |
| `aptos-move/framework/topo-token/` | `topo-token/` | 13 |
| `aptos-move/framework/topo-token-objects/` | `topo-token-objects/` | 8 |
| `aptos-move/framework/topo-trading/` | `topo-trading/` | 7 |

六个目录合计 395 个文件，按固定源提交逐字节同步，包括源码、规格、测试、包清单、模板和源仓库跟踪的其他文件。同步删除了源分支已移除的文件，包括旧 PoC 模块、旧编译缓存及生成文档。不要把源工作区中未跟踪或忽略的本地文件复制进镜像。

源仓库的 Rust workspace、CLI、完整 VM/native 环境、发布工具和实验包不在本分支的镜像范围内。根目录三份说明文档针对镜像维护，未直接照搬源仓库文档。

## 使用镜像包

在 `Move.toml` 中使用实际包名：

```toml
[dependencies]
TopoFramework = { git = "https://github.com/Topo-Labs/topo_framework.git", subdir = "topo-framework", rev = "topo-mainnet-poc-v2" }
TopoToken = { git = "https://github.com/Topo-Labs/topo_framework.git", subdir = "topo-token", rev = "topo-mainnet-poc-v2" }
TopoTokenObjects = { git = "https://github.com/Topo-Labs/topo_framework.git", subdir = "topo-token-objects", rev = "topo-mainnet-poc-v2" }
TopoTrading = { git = "https://github.com/Topo-Labs/topo_framework.git", subdir = "topo-trading", rev = "topo-mainnet-poc-v2" }
```

按需选择依赖；框架会通过相对路径引入 `TopoStdlib` 和 `MoveStdlib`。这些 Git 示例在分支推送到所列远端后才可使用。若使用个人 fork，请替换 URL；本地使用方式见 [README.md](README.md)。

为复现构建，将各依赖的 `rev` 固定为同一个**镜像仓库提交 SHA**。上面的源提交 SHA 属于 `topo-chain`，不能直接用作本镜像的依赖版本。

## 后续同步流程

1. 确认源与镜像工作区状态，记录源分支的完整提交 SHA。
2. 基于指定提交导出六个包的 Git 跟踪文件，例如在源仓库执行以下命令（先替换输出路径）：

   ```sh
   git archive --format=tar --output=/path/to/framework-snapshot.tar \
     8584f27cb7adace11825fdb65ad7f18fef1721fc \
     aptos-move/framework/move-stdlib \
     aptos-move/framework/topo-stdlib \
     aptos-move/framework/topo-framework \
     aptos-move/framework/topo-token \
     aptos-move/framework/topo-token-objects \
     aptos-move/framework/topo-trading
   ```

3. 在临时目录展开归档，将上述源目录映射到镜像根目录。逐包同步新增、修改和删除；检查旧文件删除清单，保持最终文件集合及内容与源提交一致。
4. 更新本文件、[README.md](README.md) 和 [FRAMEWORK-PROVER-GUIDE.md](FRAMEWORK-PROVER-GUIDE.md) 中的来源、命令及兼容性说明。
5. 校验六个包的文件集合、内容及本地依赖路径，并使用对应源提交构建的 CLI 验证。`git diff --check` 可检查本次补丁的空白问题。

Prover 工具构建与源仓库集成测试需要完整源 workspace；请区分静态镜像一致性、编译、单元测试和形式化验证的结果。

## 贡献

框架功能与问题请优先提交到 [Topo 链源仓库](https://github.com/Topo-Labs/topo-chain)。镜像侧维护目录映射、依赖入口和同步说明。
