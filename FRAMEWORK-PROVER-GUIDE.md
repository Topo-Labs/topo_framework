# Topo Framework PoC v2 Prover 指南

本指南适用于镜像分支 `topo-mainnet-poc-v2`，对应源分支 `topo_poc_v2`、源提交 `8584f27cb7adace11825fdb65ad7f18fef1721fc`。同步范围见 [README-MIRROR-REPO.md](README-MIRROR-REPO.md)。

## 工具与执行位置

本镜像只提供框架包。Prover 的 Rust 实现、测试入口和外部工具安装脚本位于完整源仓库。请使用同一源提交的编译器；本机 `aptos 7.14.1` 无法解析该版本的 `proof` 语法，不能用于验证此快照。

按 [README.md](README.md#编译与测试) 构建源分支的独立 Move CLI，并设置 `MOVE_CLI`。然后在源仓库查看并按需要运行工具安装脚本：

```sh
cd /path/to/aptos-core
./scripts/dev_setup.sh -h
./scripts/dev_setup.sh -y
```

本次源提交的脚本配置为 .NET 8.0、Boogie 3.5.6、Z3 4.13.0。确保当前 shell 中 `BOOGIE_EXE` 和 `Z3_EXE` 指向可执行文件；使用 `--cvc5` 时配置 `CVC5_EXE`。安装位置取决于脚本选项，例如用户目录安装可配置为：

```sh
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$PATH"
export BOOGIE_EXE="$DOTNET_ROOT/tools/boogie"
export Z3_EXE="$HOME/bin/z3"
"$BOOGIE_EXE" /version
"$Z3_EXE" --version
```

## 验证镜像中的规格

在本镜像根目录执行；`MOVE_CLI` 应指向对应源提交构建的 `move` 二进制：

```sh
"$MOVE_CLI" prove --package-dir topo-framework
"$MOVE_CLI" prove --package-dir topo-framework --filter poc_accounting
"$MOVE_CLI" prove --package-dir topo-framework --filter poc_power_store
"$MOVE_CLI" prove --package-dir topo-framework --filter poc_allocation
"$MOVE_CLI" prove --package-dir topo-framework --only poc_accounting::pool_power
```

`--filter` 按模块文件名匹配，`--only` 限定函数。也可将包目录改为 `move-stdlib`、`topo-stdlib` 或 `topo-token`。局部验证通过仅说明所选目标通过，不能代替整包验证。

`topo-framework/Prover.toml` 包含以下源分支配置，应随代码一起保留：

```toml
[prover]
borrow_natives = ["storage_slot::borrow_storage_slot_resource_mut"]
```

新增 PoC 规格入口为 `poc_accounting.spec.move`、`poc_allocation.spec.move` 和 `poc_power_store.spec.move`。奖励拆分及 Epoch 安装还涉及 `stake`、`staking_config` 和重配置路径，修改时需结合相关模块及回归测试验证。

## 源仓库测试入口

以下命令在 **aptos-core 根目录**运行，使用源仓库的包和 native 实现：

```sh
cargo test --locked -p topo-framework --test move_prover_tests
cargo test --locked -p topo-framework --test move_prover_tests move_framework_prover_tests
MVP_TEST_VC_TIMEOUT=120 cargo test --locked -p topo-framework --test move_prover_tests move_framework_prover_tests
```

该提交的 `move_prover_tests` 包含框架、Token、Topo 标准库和 Move 标准库四个入口。环境变量 `MVP_TEST_INCONSISTENCY=1` 可开启规格一致性检查，`MVP_TEST_DISALLOW_TIMEOUT_OVERWRITE=1` 可禁止局部覆盖超时。

仅运行 Move 单元测试时使用：

```sh
cargo test --locked -p topo-framework --test move_unit_test
TEST_FILTER="poc_" cargo test --locked -p topo-framework --test move_unit_test move_framework_unit_tests
```

若运行整个框架 crate 并临时跳过 Prover：

```sh
cargo test --locked -p topo-framework -- --skip prover
```

跳过 Prover 的结果不代表规格验证通过。本镜像没有这些 Cargo 测试入口。

## 超时与内部错误

源提交的默认单条验证条件超时为 40 秒。先缩小目标，增加超时或开启跟踪，定位具体函数：

```sh
"$MOVE_CLI" prove --package-dir topo-framework \
  --only poc_accounting::pool_power --vc-timeout 120 --trace
```

遇到 Boogie 内部错误时，保留最小复现、工具版本、源提交和诊断日志，检查是否使用了匹配的编译器及 `Prover.toml`，再到源仓库提交问题。

若必须暂时跳过某个验证目标，在源仓库规格中添加有原因和问题链接的 TODO，并在后续同步时记录该缺口。例如：

```move
spec foo {
    pragma verify = false; // TODO: 超时，见对应问题链接；修复后恢复验证。
}
```

这种跳过会减少验证覆盖范围。单元测试通过、过滤后的 Prover 通过、或诊断基线匹配都不应表述为完整框架已通过形式化验证。
