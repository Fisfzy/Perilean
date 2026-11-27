# 定理注册表

状态含义：`已证明` 表示已经有 Lean 声明和证明并通过当前工具链构建，`已定义` 表示有形式化对象但定理尚未加入，`后续` 表示需要连续分析或数值分析基础。

| 编号 | 内容 | Lean 名称或目标 | 依赖 | 状态 |
| --- | --- | --- | --- | --- |
| G01 | 交换端点后参考键反向 | `referenceBond_swap` | A06 | 已证明 |
| G02 | 交换端点后参考键长不变 | `isBond_swap_iff` 中的范数步骤 | A06 | 已证明 |
| G03 | 近场关系对称 | `isBond_swap_iff` | A07 | 已证明 |
| G04 | 有效键参考长度为正 | `referenceBond_norm_pos` | A06 | 已证明 |
| K01 | 当前键等于当前位置差 | `deformedBond_eq_current_sub_current` | 定义 | 已证明 |
| K02 | 相对位移反对称 | `relativeDisplacement_swap` | 定义 | 已证明 |
| K03 | 变形键反对称 | `deformedBond_swap` | K01, K02 | 已证明 |
| K04 | 零位移产生零伸长 | `stretch_zero_displacement` | G04 | 已证明 |
| K05 | 伸长率交换对称 | `stretch_swap` | K03 | 已证明 |
| K06 | 伸长率下界 `s >= -1` | `stretch_lower_bound` | G04 | 已证明 |
| K07 | 零向量的总单位方向 | `unitOrZero` | 奇异约定 | 已定义 |
| P01 | 成对力接口反对称 | `PairForceLaw.antisymmetric` | A08 | 已定义 |
| P02 | 中心力接口 | `IsCentral` | A09 | 已定义 |
| P03 | 加权实际成对力反对称 | `weightedPairForce_antisymmetric` | P01 | 已证明 |
| P04 | 总内力展开为双重和 | `totalInternalForce_eq_sum_pair` | P03 | 已证明 |
| P05 | 离散内部合力为零 | `totalInternalForce_zero` | P03, 有限和交换 | 已证明 |
| C01 | PMB 断键后力为零 | `pmbForce_zero_if_failed` | A10 | 已证明 |
| C02 | PMB 成对力为中心力 | `pmbForce_central` | K01, K05 | 已证明 |
| C03 | PMB 成对力反对称 | `pmbForce_antisymmetric` | K03, K05, A10 | 已证明 |
| C04 | PMB 可封装为通用成对力 | `pmbPairForceLaw` | C03 | 已定义 |
| C05 | PMB 单键势能非负 | `pmbBondPotential_nonneg` | `c >= 0` | 已证明 |
| C06 | PMB 单键势能交换对称 | `pmbBondPotential_symmetric` | 端点状态对称 | 已证明 |
| C07 | PMB 键力模长等于 `|c*s|` | `pmbForce_norm` | 当前键非零 | 已证明 |
| C08 | PMB 存活键逐项力函数 | `pmbForce_formula_on_bond` | 有效键、存活状态 | 已证明 |
| C09 | PMB 力函数展开到当前键方向 | `pmbForce_formula_current_direction` | C08、当前键非零 | 已证明 |
| C10 | 中心成对力的内部力矩为零 | `pairTorque_zero_of_central_and_antisymmetric` | 三维叉积、反对称和中心力 | 已证明 |
| C11 | PMB 三维成对力矩为零 | `pmbPairTorque_zero` | C02、C03、三维表示转换 | 已证明 |
| C12 | PMB 体积加权总成对力矩为零 | `pmbWeightedTotalPairTorque_zero` | C10、体积加权有限和 | 已证明 |
| C13 | 断键更新保持端点对称 | `pmbUpdateAlive_symmetric` | horizon 对称、伸长率对称、初始状态对称 | 已证明 |
| C14 | 断键后的 PMB 离散内力仍平衡 | `pmbUpdateAlive_totalInternalForce_zero` | C13、P05 | 已证明 |
| O01 | 键伸长率的等距不变性 | `bondStretch_isometry` | 线性等距同构 | 已证明 |
| O02 | 键力的等距协变性 | `bondForce_objective` | O01、单位方向协变性 | 已证明 |
| O03 | 键势能的等距不变性 | `bondPotential_objective` | O01 | 已证明 |
| D01 | PMB 更新保留存活键的旧状态 | `pmbUpdateAlive_implies_old_alive` | A11 | 已证明 |
| D02 | PMB 更新不可逆 | `pmbUpdateAlive_is_irreversible` | D01 | 已证明 |
| D03 | 存活键体积不超过邻域体积 | `activeVolume_le_neighborVolume` | A04, 有限权重 | 已证明 |
| D04 | 局部损伤非负 | `localDamage_nonneg` | D03, 邻域体积正 | 已证明 |
| D05 | 局部损伤不超过一 | `localDamage_le_one` | A04 | 已证明 |
| D06 | 损伤变量随存活键集合减少而单调增加 | `localDamage_mono` | `aliveSub`、邻域体积为正 | 已证明 |
| Q04 | 离散运动方程 | `satisfiesDiscreteEquation` | 离散动力学 | 已定义 |
| Q05 | 离散线动量平衡 | `discrete_linear_momentum_balance` | Q04, P05 | 已证明 |
| E01 | 微势能对相对位移的梯度等于键力 | `microPotential_fderiv` | A13, A14 | 后续 |
| E02 | 离散弹性能量恒等式 | `discrete_energy_balance` | E01, 时间正则性 | 后续 |
| M01 | 三维 PMB 微模量公式定义 | `pmb3DMicromodulus` | A19, 文献标定结果 | 已定义 |
| M02 | PMB 断裂能公式定义 | `pmbFractureEnergy` | 文献裂面积分结果 | 已定义 |
| M03 | 临界伸长率反解 | `pmbFractureEnergy_of_criticalStretch` | M02, 正性 | 已证明 |
| M04 | 三维微模量正性 | `pmb3DMicromodulus_pos` | M01, 参数正性 | 已证明 |
| M05 | 微模量代入断裂能公式 | `pmbFractureEnergy_of_bulkModulus` | M01, M02, 参数正性 | 已证明 |
| M06 | 体积模量形式的临界伸长率 | `pmbCriticalStretch_of_bulkModulus` | M01, M03, 参数正性 | 已证明 |
| M07 | 球坐标标定和裂面积分 | `pmb_micromodulus_3d`, `criticalStretch_from_fractureEnergy` | A19, 连续积分 | 后续 |
| N01 | 中心差分更新方程 | `central_difference_step` | 离散运动方程 | 后续 |
| N02 | 稳定时间步上界 | `central_difference_stable` | 线性化谱分析 | 后续 |
| N03 | 离散一致性和收敛 | `discrete_convergence` | 正则性、网格族 | 后续 |
| Q01 | 连续内力积分定义 | `continuumInternalForce` | A15 | 后续 |
| Q02 | 连续线动量守恒 | `continuum_linear_momentum` | A08, A15, A16 | 后续 |
| Q03 | 连续能量守恒 | `continuum_energy_balance` | E01, A15-A17 | 后续 |
