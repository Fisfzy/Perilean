# BBPD 文献对应关系

## 当前一致部分

- `ParticleSystem`、参考键、变形键和伸长率对应经典键型 PD 的有限物质点离散运动学。
- `PairForceLaw` 的反对称性和 `totalInternalForce_zero` 对应成对内力抵消与离散线动量守恒。
- `pmbForce` 对应 PMB 中由微模量、伸长率和当前键方向组成的中心键力。
- `pmb3DMicromodulus` 和 `pmbFractureEnergy` 对应三维 PMB 的常用微模量与断裂能标定公式。
- `localDamage` 对应以存活键体积比例定义的局部损伤指标。
- `pmbForce_formula_on_bond` 逐项检查 `f_ij = c s_ij e_ij`，其中 `e_ij` 用总函数 `unitOrZero` 表示。
- `pmbForce_formula_current_direction` 在当前键非零时把 `e_ij` 展开为 `(y_j-y_i)/||y_j-y_i||`，得到论文中的方向形式。
- `pairMoment_zero_of_central` 和 `pairTorque_zero_of_central_and_antisymmetric` 检查中心键力的内部力矩消失。
- `pmbPairTorque_zero` 将该结论直接应用到三维 PMB 力。
- `pmbFractureEnergy_of_bulkModulus` 和 `pmbCriticalStretch_of_bulkModulus` 将三维微模量代入后得到 `G_c = 9 K s_0^2 δ / 5` 和 `s_0 = sqrt(5 G_c / (9 K δ))`。

## 本次边界修正

PMB 力、单键势能和断键更新现在都显式检查 `isBond`。因此只有满足 horizon 邻域关系的粒子对才会产生键力、键势能或断键状态更新。

## 仍需补充的文献推导

当前 BBPD 形式化的是有限求和和代数恒等式。它没有把三维球坐标积分、连续体极限、应变能等效、材料参数拟合和裂面几何积分作为已证明定理。Madenci 与 Oterkus 的复合材料方向依赖键常数、纤维/基体/界面三类键以及层间断裂准则属于后续 BBPD 复合材料模块，不能从现有各向同性 PMB 定义直接推出。
