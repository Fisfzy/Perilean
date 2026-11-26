# BBPD

这是基于 Lean 4.36.0 和 Mathlib v4.36.0 的键型近场动力学基础验证包。当前实现范围是有限粒子离散模型，重点验证几何、运动学、成对力接口和 PMB 不可逆断裂状态。

## 构建

在本目录执行：

```powershell
lake build
```

包通过 Lake 直接依赖固定版本的 Mathlib，不依赖仓库中的 `SolidMechanics`。入口模块是 `BBPD`，核心模块包括：

- `PeriLean.BBPD.Basic`：有限粒子、参考键、当前构形、伸长率和奇异方向处理。
- `PeriLean.BBPD.Pairwise`：通用成对力、中心力和离散内力总和。
- `PeriLean.BBPD.PMB`：PMB 力、成对力反对称性和不可逆状态更新。
- `PeriLean.BBPD.Potential`：PMB 单键势能、势能非负性、键能对称性和键力模长。
- `PeriLean.BBPD.Calibration`：三维微模量公式和断裂能临界伸长率的代数标定恒等式。
- `PeriLean.BBPD.Dynamics`：离散运动方程谓词、惯性力和外力平衡。
- `PeriLean.BBPD.Damage`：邻域体积、存活键体积和局部损伤定义及有界性。

文献对应关系见 `Documentation/LiteratureAlignment.md`。PMB 力、势能和断键状态均显式受 `isBond` 的 horizon 邻域约束。

## 当前已形式化的局部内容

- 交换粒子后参考键、相对位移和变形键的反对称性。
- 近场关系的交换对称性。
- 有效键的非零参考长度。
- 刚体零位移下的零伸长率和伸长率下界。
- 成对力反对称性推出离散内部合力为零。
- PMB 断键后不恢复的状态更新性质。
- PMB 单键势能非负性和端点交换对称性。
- PMB 键力模长与 `|c*s|` 的一致性。
- `c = 18 K / (pi * delta^4)` 和 `G_c = pi*c*s0^2*delta^5/10` 的代数定义及反解恒等式。
- 离散运动方程推出总惯性力等于总外力。
- 局部损伤在有邻域时属于 `[0,1]`，无邻域时按零定义。

连续体积分、Bochner 积分、连续能量守恒、局部极限和时间积分稳定性暂未作为已证明结论发布，具体边界见 `Documentation/BBPD-Specification.md`。

三维微模量和断裂能模块目前只验证文献公式的代数定义和反解恒等式，不等于完成球坐标积分、能量等效和裂面几何积分的论文级证明。完整边界见 `Documentation/LiteratureAlignment.md`。
