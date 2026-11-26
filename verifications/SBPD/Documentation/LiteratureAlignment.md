# SBPD 文献对应关系

## 采用的来源

- Silling, Epton, Weckner, Xu and Askari, *Peridynamic states and constitutive modeling*, Journal of Elasticity, 2007。
- Madenci and Oterkus, *Peridynamic Theory and Its Applications*, Springer, 2014。
- Oterkus and Madenci, *Peridynamic analysis of fiber-reinforced composite materials*, Journal of Mechanics of Materials and Structures, 7(1), 45-84, 2012。
- Zhou and Qian, *Crack propagation simulation of fiber-reinforced composite laminates based on non-ordinary state-based peridynamics*, Materials Research Express, 2025。该文献的本地提取文本位于 `D:\AIWORK\AI_SBPD\参考非常规态型论文`，其中的公式编号用于本表。

## 方程对应

下表中的“已定义”只表示代码中存在相应符号，不表示已经证明与论文的连续方程或离散算法完全等价。

| 文献内容 | SBPD 形式化位置 | 状态 |
| --- | --- | --- |
| 离散物质点、参考键和变形键 | `PeriLean.SBPD.Basic` | 已定义并证明交换反对称性 |
| 形状张量 `K` | `shapeTensor` | 已定义 |
| 非局部变形梯度 `F̄ = (...) K⁻¹` | `deformationNumerator`、`deformationGradient` | 已定义；在逆证书下证明重构恒等式 |
| 力态 `T = ω σ̂ K X` 的离散形式 | `forceState`、`paperForceState`、`paperForceState_formula` | 论文应力测度和有限点表达式已证明展开 |
| 态型运动方程中的 `T_i - T_j` | `statePairForce`、`stateInternalForce` | 已定义并证明总内力为零 |
| 正交各向异性约化刚度 `Q11,Q12,Q22,Q66` | `Constitutive.lean` | 已定义并证明正性 |
| 铺层角应力变换 | `rotateStress` | 已定义并证明零角度恒等式 |
| Hoffman 失效指标 | `hoffmanIndex`、`hoffmanFailed` | 已定义；等式阈值蕴含失效 |
| 物质点损伤率 `φ = 1 - V_alive/V_neighbor` | `Damage.lean` | 已定义并证明 `[0,1]` 边界 |
| 层合板 `A/B/D` 厚度求和 | `Laminate.lean` | 有限层片代数公式已证明 |
| 弯矩结果 `M = B ε⁰ + D κ` | `bendingMomentResultant`、`bendingMomentResultant_eq_sum_layerContributions` | 有限矩阵公式和层片贡献求和已证明 |
| PMB `G_c`、`s_0` 反解和 `K` 形式 | `Fracture.lean` | 代数反解和微模量代入已证明 |
| 纤维/基体临界伸长率 | `fiberCriticalStretch`、`matrixCriticalStretch` | 乘法恢复恒等式已证明 |
| 层间刚度 `K_int = E_3/δ_int` | `interfaceStiffness` | 乘法恢复恒等式已证明 |
| BK 临界能量函数 | `bkCriticalEnergy`、`bkCriticalEnergy_pure_mode_I`、`bkCriticalEnergy_pure_mode_II` | 公式和两个纯模式端点已证明，演化尚未证明 |

## 与 BBPD 的关系

BBPD 的有限粒子几何、PMB 键力、键势能和离散平衡与上述文献的基础离散框架一致。PMB 作用现在显式要求 `isBond`，因此非邻域粒子不会产生键力或键势能。SBPD 独立定义自己的状态系统和力态接口，不通过导入 BBPD 或 SolidMechanics 复用类型。

## 尚未宣称的结论

文献中的连续积分公式、球坐标积分、材料参数标定、矩阵可逆性、零能模式控制、人工阻尼的收敛性和 FEM/试验误差结果没有被当前 Lean 定理自动覆盖。它们必须作为独立假设或后续分析定理加入，不能由当前离散定义直接推出。
