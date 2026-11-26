# PeriLean

PeriLean 是基于 Lean 4 和 Mathlib 的近场动力学形式化验证项目。

当前仓库包含：

- `packages/SolidMechanics`：固体力学基础验证包。
- `verifications/BBPD`：独立的键型近场动力学 BB-PD 基础验证包，直接依赖固定版本的 Mathlib。

## BBPD 构建

```powershell
cd verifications/BBPD
lake build
```

工具链和 Mathlib 版本固定为 Lean 4.36.0 与 Mathlib v4.36.0。BBPD 当前覆盖有限粒子几何与运动学、PMB 成对力、成对力反对称性、离散线动量平衡、单键势能、断裂能标定恒等式和局部损伤边界。

连续 Bochner 积分、球坐标标定积分、局部极限、时间积分稳定性和浮点求解器验证属于后续模块。
