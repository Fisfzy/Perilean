# SBPD 逐公式映射

本文档区分“定义存在”“局部定理已证明”和“论文等价性已证明”。只有最后一种状态才可以称为完成对应论文公式的形式化验证。

| 论文公式或结论 | 当前代码 | 当前状态 | 缺口 |
| --- | --- | --- | --- |
| 运动方程中的连续 horizon 积分 | `Dynamics.lean` 的有限求和谓词 | 仅有离散定义 | 没有测度、积分和离散求积等价 |
| 形状张量 `K = ∫ ω ξ⊗ξ dV` | `shapeTensor` | 仅有有限和定义 | 没有连续积分版本和可逆性证明 |
| 非局部变形梯度 `F̄ = (...)K⁻¹` | `deformationNumerator`、`deformationGradient` | 有条件代数恒等式 | 逆矩阵是外部证书 |
| `Y = ξ + η` | `deformedBond` | 有限点定义 | 没有论文状态记号和离散化误差证明 |
| 力态 `T = ω σ̂(F̄) K X` | `forceState`、`paperForceState` | 论文应力测度和离散力态表达式已定义并展开证明 | 没有积分和论文求积约定的等价证明 |
| `M = B ε⁰ + D κ` | `bendingMomentResultant`、`bendingMomentResultant_eq_sum_layerContributions` | 有限矩阵公式和层片贡献求和已证明 | 尚无连续厚度积分等价证明 |
| `A = Σ Q_k(z_k-z_{k-1})` | `extensionalStiffness`、`membraneResultant_eq_sum_layerContributions` | 有限厚度片段求和和膜力层片贡献已证明 | 尚无连续层合板积分等价证明 |
| `B = 1/2 Σ Q_k(z_k²-z_{k-1}²)` | `couplingStiffness`、`membraneResultant_eq_sum_layerContributions` | 有限厚度片段求和和膜力层片贡献已证明 | 尚无一般铺层输入映射证明 |
| `D = 1/3 Σ Q_k(z_k³-z_{k-1}³)` | `bendingStiffness`、`bendingMomentResultant_eq_sum_layerContributions` | 有限厚度片段求和和弯矩层片贡献已证明 | 尚无一般铺层输入映射证明 |
| 运动方程中的 `T' - T` | `statePairForce` | 通过差定义得到 | 没有从双端状态和本构推导 |
| 正交各向异性 `S` 与 `Q` | `Constitutive.lean` | 部分代数定理 | 没有一般角度矩阵变换全式证明 |
| 铺层角变换矩阵 | `rotateStress` | 只证明零角度 | 没有一般角度、逆变换和应变变换定理 |
| Hoffman 判据 | `hoffmanIndex` | 定义和对称性 | 没有失效模式分解和状态更新连接 |
| 层内/层间键 | `bondKind` | 分类定义和交换对称性 | 没有层间牵引-分离本构 |
| 层间断裂能和混合模式准则 | 暂无 | 未形式化 | 需要 CZM、能量和不可逆演化 |
| `G_c = π c s_0² δ⁵/10`、`G_c = 9 K s_0² δ/5` | `pmbFractureEnergy`、`pmbFractureEnergy_of_bulkModulus` | 代数公式、微模量代入和临界伸长率反解已证明 | 连续裂面能量积分尚未证明 |
| `s_f = X_T/E_1`、`s_m = Y_T/E_2` | `fiberCriticalStretch`、`matrixCriticalStretch` | 乘法恢复恒等式已证明 | 尚未证明与复材失效演化完全等价 |
| `K_int = E_3/δ_int` | `interfaceStiffness` | 乘法恢复恒等式已证明 | 尚未连接层间牵引-分离本构 |
| BK 混合模式临界能量 | `bkCriticalEnergy`、`bkCriticalEnergy_pure_mode_I`、`bkCriticalEnergy_pure_mode_II` | 公式和纯模式端点已证明 | 尚无能量分解和损伤演化证明 |
| 局部损伤率 | `localDamage` | `[0,1]` 局部边界 | 没有与论文裂纹可视化和损伤演化等价证明 |
| 零能模式控制 | 暂无 | 未形式化 | 需要稳定性或能量控制定理 |
| 人工阻尼和动态松弛 | 暂无 | 未形式化 | 需要时间离散和收敛性 |
| FEM/实验误差 | 暂无 | 未形式化 | 需要固定数据、误差定义和可复现实验记录 |
