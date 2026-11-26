# PDComposite 局部定理注册表

本表只登记 Lean 已检查的局部定理，不表示论文级验证已经完成。论文等价性缺口见 `VerificationStatus.md` 和 `EquationMap.md`。

| 定理 | 内容 | 类型 |
| --- | --- | --- |
| `referenceBond_swap` | 参考键交换后取负 | Lean 已证明 |
| `deformedBond_swap` | 变形键交换后取负 | Lean 已证明 |
| `inHorizon_swap` | horizon 邻域交换对称 | Lean 已证明 |
| `deformationGradient_mul_shapeTensor` | 形状张量逆证书下的梯度重构 | Lean 已证明 |
| `paperStressMeasure_formula`, `paperForceState_formula` | `hat σ = det(F) τ F⁻ᵀ` 和 `T = ω hat σ K X` 的离散展开 | Lean 已证明 |
| `statePairForce_antisymmetric` | 态型成对内力反对称 | Lean 已证明 |
| `totalStateInternalForce_zero` | 离散内部合力为零 | Lean 已证明 |
| `discrete_linear_momentum_balance` | 离散线动量平衡 | Lean 已证明 |
| `poisson_reciprocity` | `ν12 E2 = ν21 E1` | Lean 已证明 |
| `q11_pos`, `q22_pos`, `q66_pos` | 约化刚度正性 | Lean 已证明 |
| `rotateStress_zero` | 零铺层角应力变换恒等 | Lean 已证明 |
| `hoffmanFailed_of_eq_one` | Hoffman 等式阈值蕴含失效 | Lean 已证明 |
| `pairHoffmanIndex_swap` | 平均应力 Hoffman 指标的端点交换对称 | Lean 已证明 |
| `pairHoffmanFailed_swap` | 成对 Hoffman 失效判据的端点交换对称 | Lean 已证明 |
| `bondKind_swap` | 层内/层间键分类交换对称 | Lean 已证明 |
| `extensionalStiffness_formula` | `A = Σ Q_k(z_k-z_{k-1})` | Lean 已证明 |
| `couplingStiffness_formula` | `B = 1/2 Σ Q_k(z_k²-z_{k-1}²)` | Lean 已证明 |
| `bendingStiffness_formula` | `D = 1/3 Σ Q_k(z_k³-z_{k-1}³)` | Lean 已证明 |
| `bendingMomentResultant_formula` | `M = B ε⁰ + D κ` | Lean 已证明 |
| `membraneResultant_eq_sum_layerContributions` | 膜力由各层厚度贡献求和得到 | Lean 已证明 |
| `bendingMomentResultant_eq_sum_layerContributions` | 弯矩由各层厚度贡献求和得到 | Lean 已证明 |
| `pmbFractureEnergy_of_criticalStretch` | PMB 断裂能临界伸长率反解 | Lean 已证明 |
| `pmbFractureEnergy_of_bulkModulus`, `pmbCriticalStretch_of_bulkModulus` | 三维微模量代入后的 `K` 形式断裂参数 | Lean 已证明 |
| `fiberCriticalStretch_recovery` | `E₁ s_f = X_T` | Lean 已证明 |
| `matrixCriticalStretch_recovery` | `E₂ s_m = Y_T` | Lean 已证明 |
| `interfaceStiffness_recovery` | `δ_int K_int = E₃` | Lean 已证明 |
| `bkCriticalEnergy_pure_mode_I`, `bkCriticalEnergy_pure_mode_II` | BK 准则纯 I/纯 II 端点恢复 `G_Ic`、`G_IIc` | Lean 已证明 |
| `localDamage_nonneg`, `localDamage_le_one` | 局部损伤边界 | Lean 已证明 |
| `updateAlive_irreversible` | 断键状态不可恢复 | Lean 已证明 |
