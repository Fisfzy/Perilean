# SBPD

这是独立的态型近场动力学形式化验证包。包直接依赖 Lean 4.36.0 和 Mathlib v4.36.0，不依赖 `SolidMechanics` 或 `BBPD`。

## 构建

```powershell
cd verifications/SBPD
lake build
lake env lean PeriLean/SBPD/AxiomAudit.lean
```

入口模块是 `SBPD`。核心模块包括：

- `PeriLean.SBPD.Basic`：有限物质点系统、参考键、变形键、形状张量、非局部变形梯度、力态和成对内力。
- `PeriLean.SBPD.Constitutive`：正交各向异性平面应力、工程常数到约化刚度、铺层角应力变换和 Hoffman 指标。
- `PeriLean.SBPD.Composite`：单层、层合板、物质点所属铺层、层内键和层间键分类。
- `PeriLean.SBPD.Damage`：存活键体积、局部损伤、有界性和不可逆状态更新。
- `PeriLean.SBPD.Dynamics`：离散态型运动方程、总惯性力、外力和线动量平衡。

## 当前验证范围

当前版本形式化了文献中的有限粒子离散骨架。已证明形状张量逆的梯度重构恒等式、态型成对内力的反对称性、离散内部合力为零、离散线动量平衡、正交各向异性刚度的正性、应力旋转零角度恒等式、Hoffman 等式阈值蕴含失效和局部损伤边界。

连续体积分、形状张量存在性、矩阵可逆性判定、ABD 层合板等效刚度、零能模式稳定性、时间积分收敛和数值结果与 FEM 的误差界仍属于后续模块。
