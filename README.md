# PeriLean

PeriLean 是基于 Lean 4 和 Mathlib 的近场动力学形式化验证项目。

当前仓库包含：

- `packages/SolidMechanics`：固体力学基础验证包。
- `verifications/BBPD`：独立的键型近场动力学 BB-PD 基础验证包，直接依赖固定版本的 Mathlib。
- `verifications/SBPD`：独立的态型近场动力学 SBPD 基础验证包，直接依赖固定版本的 Mathlib。

## BBPD 构建

```powershell
cd verifications/BBPD
lake build
```

工具链和 Mathlib 版本固定为 Lean 4.36.0 与 Mathlib v4.36.0。BBPD 当前覆盖有限粒子几何与运动学、PMB 成对力及其当前键方向展开、成对弯矩、离散线动量平衡、单键势能、断裂能标定恒等式和局部损伤边界。

## SBPD 构建

```powershell
cd verifications/SBPD
lake build
```

SBPD 当前提供有限粒子态型方程、论文应力测度与力态展开、形状张量与非局部变形梯度、正交各向异性单层本构、`A/B/D` 与弯矩结果函数、Hoffman 指标、PMB/复材断裂参数公式、层内/层间键分类和离散损伤边界的基础形式化片段。它尚未完成与论文连续积分和数值算法逐公式等价的完整证明。

连续 Bochner 积分、球坐标标定积分、局部极限、时间积分稳定性和浮点求解器验证属于后续模块。
