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

## 当前验证状态

当前版本是态型复合材料 PD 的基础形式化片段，不是对 Madenci、Oterkus 或相关论文的完整复现。Lean 已证明的是有限求和模型中的局部代数恒等式和明确写出的离散假设，不能直接解释为论文全部方程已经验证。

已证明的局部结果包括形状张量逆证书下的梯度重构恒等式、人工定义的反对称成对态力导致的离散内部合力为零、离散线动量平衡、部分正交各向异性刚度正性、零铺层角应力恒等式、Hoffman 指标的端点交换对称和局部损伤边界。

以下论文结论尚未完成形式化证明：形状张量可逆性和存在性、连续积分到离散求积的一致性、论文力态与 `forceState` 的等价性、一般铺层角变换、ABD 层合板刚度、层间牵引-分离和断裂能、零能模式控制、人工阻尼与自适应动态松弛、时间积分收敛、裂纹扩展路径以及与 FEM 或试验的误差结论。

完整性状态和逐公式证据见 `Documentation/VerificationStatus.md` 与 `Documentation/EquationMap.md`。
