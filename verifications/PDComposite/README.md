# PDComposite

这是独立的复合材料近场动力学形式化验证包。它依赖 `SBPD` 的通用态型 PD 几何、力态和离散动力学接口，不依赖 `BBPD` 或 `SolidMechanics`。

## 构建

```powershell
cd verifications/PDComposite
lake build
lake env lean PDComposite/AxiomAudit.lean
```

入口模块是 `PDComposite`。主要模块包括：

- `PDComposite.Constitutive`：正交各向异性平面应力本构、约化刚度、铺层角应力变换和 Hoffman 指标。
- `PDComposite.Composite`：单层、铺层、物质点所属铺层和层内/层间键分类。
- `PDComposite.Damage`：存活键体积、局部损伤和不可逆状态更新。
- `PDComposite.Laminate`：`A/B/D` 刚度、膜力结果和弯矩结果。
- `PDComposite.Fracture`：PMB 断裂参数、纤维/基体临界伸长率、界面刚度和 BK 准则。

三个包的职责边界如下：`BBPD` 是键型 PD，`SBPD` 是通用态型 PD，`PDComposite` 是基于 SBPD 接口的复合材料扩展。

当前已经形式化的是有限物质点、有限层片和显式参数公式。连续积分、一般铺层变换的完整等价性、层间 CZM 损伤演化、时间积分收敛和论文数值结论仍属于后续范围。
