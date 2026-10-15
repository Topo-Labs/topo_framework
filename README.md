# Topo Framework — PoC v2

本仓库是 Topo 链框架的 Move 包镜像，可用于合约依赖和框架源码查阅。

## 分支与来源

| 项目 | 值 |
| --- | --- |
| 镜像分支 | `topo-mainnet-poc-v2` |
| 创建基线 | 本仓库 `topo-mainnet`，提交 `cb231032` |
| 源仓库 | [Topo-Labs/topo-chain](https://github.com/Topo-Labs/topo-chain)；本地目录 `/Users/tuminfei/Documents/Code/Rust/aptos-core` |
| 源分支 | `topo_poc_v2` |
| 源提交 | `8584f27cb7adace11825fdb65ad7f18fef1721fc` |
| 同步日期 | 2026-10-15 |
| 同步范围 | 源仓库 `aptos-move/framework/` 下的六个对应包，共 395 个 Git 跟踪文件 |

这是指定提交的源码快照，分支名不表示已部署到主网。同步流程和固定版本依赖方式见 [README-MIRROR-REPO.md](README-MIRROR-REPO.md)。

## 包与目录

| 目录 | Move 包名 | 主要地址 | 内容 |
| --- | --- | --- | --- |
| `move-stdlib/` | `MoveStdlib` | `std = 0x1` | Move 标准库、规格和测试，以及源仓库配套 Rust native 代码 |
| `topo-stdlib/` | `TopoStdlib` | `topo_std = 0x1` | 密码学、数学、表与其他数据结构 |
| `topo-framework/` | `TopoFramework` | `topo_framework = 0x1` | 账户、资产、质押、治理、重配置与 PoC |
| `topo-token/` | `TopoToken` | `topo_token = 0x3` | Token 和属性管理 |
| `topo-token-objects/` | `TopoTokenObjects` | `topo_token_objects = 0x4` | Object 模型 Token、集合与版税 |
| `topo-trading/` | `TopoTrading` | `topo_trading = 0x5` | 订单与撮合数据类型 |

包之间通过 `Move.toml` 中的相对路径依赖连接。各包的 `sources/`、`tests/`、`doc_template/`、`Prover.toml` 和少量已跟踪的 `doc/` 文件以源提交为准，并非每个包都有上述所有目录。

本仓库没有根级 Cargo workspace，也不包含源仓库根级框架的 `src/`、`tests/`、`cached-packages/`、完整 VM/native 环境或发布工具。`move-stdlib/Cargo.toml` 继承源 workspace 配置，不能在镜像中独立执行 Cargo 测试。

### PoC v2 主要变化

- `poc_accounting`：统一保存部署参数、算力分配、持仓和奖励账本。
- `poc_allocation`：提供治理准备、池准入、用户分配和奖励领取入口。
- `poc_power_store`：按算力周期维护双版本窗口、衰减指数和标准化 units。
- `poc_reward_split`：管理原生质押与 PoC 的奖励拆分配置。
- `poc_registry`、`poc_contribution`：更新应用身份授权与可信贡献事件逻辑。
- 同步 `stake`、`staking_proxy`、重配置及相关规格、PoC 回归测试，同时引入源分支中的 confidential asset、委托池和模块初始化等代码。

旧 `poc/staking_registry` 和旧 PoC 测试已按源分支移除；Token Objects 的模块文件由 `topo_token.move` 对齐为 `aptos_token.move`，使用方应检查相应模块引用。旧 `build/`、`Move.lock` 和源分支不再跟踪的生成文档也已移除。

## 在 Move 项目中使用

在使用方的 `Move.toml` 中添加：

```toml
[dependencies]
TopoFramework = { git = "https://github.com/Topo-Labs/topo_framework.git", subdir = "topo-framework", rev = "topo-mainnet-poc-v2" }
```

该 Git 示例需要先将本分支推送到对应远端；本地开发可使用：

```toml
[dependencies]
TopoFramework = { local = "../topo_framework/topo-framework" }
```

稳定构建应将 `rev` 固定为**镜像仓库提交**，不要填源仓库提交。其他包的依赖键及 `subdir` 见上表。

## 编译与测试

使用源提交对应的编译器与 native 实现。本次本机安装的 `aptos 7.14.1` 无法解析该快照的 `proof` 等语法，不适用于此分支。

可以在 `aptos-core` 的 `topo_poc_v2` 分支构建独立 Move CLI（按源仓库要求安装 Rust 与本地构建依赖）：

```sh
cd /path/to/aptos-core
git rev-parse HEAD  # 本快照对应 8584f27cb7adace11825fdb65ad7f18fef1721fc
cargo build --locked -p aptos-move-cli --features binary --bin move
export MOVE_CLI="$(pwd)/target/debug/move"

cd /path/to/topo_framework
"$MOVE_CLI" compile --package-dir topo-framework
"$MOVE_CLI" test --package-dir topo-framework --filter poc_
```

将 `--package-dir` 改为其他包目录即可编译或测试该包；移除 `--filter` 可运行整包测试。该 CLI 可直接读取本镜像中的文件。

源仓库另有集成测试入口，以下命令须在 `aptos-core` 根目录执行，验证的是**源仓库**的包：

```sh
cargo test --locked -p topo-framework --test move_unit_test
TEST_FILTER="poc_" cargo test --locked -p topo-framework --test move_unit_test move_framework_unit_tests
REPORT_STATS=1 TEST_FILTER="poc_" cargo test --locked -p topo-framework --test move_unit_test move_framework_unit_tests
```

Prover 配置、过滤验证和超时排查见 [FRAMEWORK-PROVER-GUIDE.md](FRAMEWORK-PROVER-GUIDE.md)。

### 本次同步校验与已知问题

- 六个包共 395 个文件的路径集合和内容均与固定源提交一致。
- 六个包的 `Move.toml` 及本地依赖路径检查通过，镜像补丁 `git diff --check` 通过。
- 在源提交上执行六个对应包的单元测试，共 1,598 项 Move 测试，1,597 项通过、1 项失败，详细结果如下。
- 源仓库 `topo-stdlib` 的 `type_info::test_chain_id` 断言链 ID 为 `4`，但源仓库 `types/src/chain_id.rs` 将 `NamedChain::TESTING` 配置为 `164`，该测试失败。本镜像保留源提交内容，问题应在源仓库修复后重新同步。
- 本次未执行 Move Prover 形式化验证。

| 包 | 通过 | 失败 |
| --- | ---: | ---: |
| MoveStdlib | 207 | 0 |
| TopoStdlib | 296 | 1 |
| TopoFramework | 965 | 0 |
| TopoToken | 43 | 0 |
| TopoTokenObjects | 86 | 0 |
| TopoTrading | 0（包内无测试用例，编译通过） | 0 |

本次测试命令（在源仓库根目录执行，排除未镜像的实验包）：

```sh
cargo test --offline --locked -p topo-framework --test move_unit_test -- --skip move_experimental_unit_tests
```

## 生成文档

使用同一源提交构建的工具：

```sh
"$MOVE_CLI" document --help
"$MOVE_CLI" document --package-dir topo-framework
```

自动生成的 API 文档可能未包含在快照中。优先阅读当前包的源码、规格和模板，避免依赖其他分支的文档。

## 贡献

框架逻辑、VM/native 和规格修改请在 [Topo 链源仓库](https://github.com/Topo-Labs/topo-chain) 开发并验证，再同步到镜像。参见 [CONTRIBUTING.md](CONTRIBUTING.md)。
