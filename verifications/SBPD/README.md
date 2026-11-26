# SBPD

这是独立的通用态型近场动力学核心验证包。它直接依赖 Lean 4.36.0 和 Mathlib v4.36.0，不依赖 `BBPD`、`PDComposite` 或 `SolidMechanics`。

## 构建

```powershell
cd verifications/SBPD
lake build
lake env lean PeriLean/SBPD/AxiomAudit.lean
```

入口模块是 `SBPD`。核心模块包括：

- `PeriLean.SBPD.Basic`：有限物质点系统、参考键、变形键、形状张量、非局部变形梯度、论文应力测度和力态。
- `PeriLean.SBPD.Dynamics`：离散态型运动方程、内部力、惯性力、外力和线动量平衡。

正交各向异性本构、铺层、`A/B/D`、复材断裂和损伤模块已移入独立的 `PDComposite` 包。

当前 SBPD 形式化范围是通用有限物质点态型模型。连续 horizon 积分、形状张量可逆性存在性、连续求积一致性、时间积分收敛和数值算例属于后续扩展。
