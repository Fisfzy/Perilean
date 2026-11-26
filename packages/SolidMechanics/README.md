# SolidMechanics

这是 Lean 4.36.0 固体力学验证包。包的入口是 `SolidMechanics.lean`。

包内的 `ContinuumMechanics` 目录提供张量、运动学、应力、材料本构、弹性静力学、梁、板、接触、断裂和热弹性模块。入口文件只导入已纳入固体力学验证范围的模块。

Mathlib 通过 `lakefile.toml` 固定到 `v4.36.0`，工具链通过 `lean-toolchain` 固定到 `leanprover/lean4:v4.36.0`。`lake-manifest.json` 固定依赖提交，便于复现构建。

在包目录执行以下命令进行验证：

```powershell
lake build
```

新验证项目可以把本包作为 Lake 路径依赖，然后导入：

```toml
[[require]]
name = "SolidMechanics"
path = "../../packages/SolidMechanics"
```

```lean
import SolidMechanics
```
