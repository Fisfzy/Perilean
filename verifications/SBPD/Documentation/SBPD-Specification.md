# SBPD 形式化规范

## 模型层次

1. `StateSystem` 保存有限参考构形、体积、密度和 horizon。
2. `ShapeWeight`、`shapeTensor` 和 `deformationGradient` 对应非普通态型 PD 的非局部几何层。
3. `forceState` 将应力矩阵、形状张量和参考位置态组合成离散力态。
4. `statePairForce` 将中心点力态和邻点力态组合成运动方程中的差值。
5. `OrthotropicPlaneStress`、`Lamina` 和 `Laminate` 对应复合材料的单层本构与铺层结构。
6. `HoffmanStrengths` 和 `Damage` 对应复合材料失效和断键可视化指标。

## 设计边界

SBPD 包不依赖 `SolidMechanics`，也不依赖 `BBPD`。这样可以单独升级态型本构、层间内聚模型和三维状态，而不改变键型包的接口。

当前版本使用有限求和表达离散模型。连续积分、有限形变本构、Cubic-Cell Integration、Gaussian 积分、人工阻尼和自适应动态松弛需要额外的离散化或分析接口。

## 后续扩展顺序

1. 加入层间法向/切向分离和双线性 CZM。
2. 加入 ABD 层合板刚度与铺层厚度积分。
3. 加入纤维、基体和分层三类损伤变量。
4. 加入零能模式控制项及其离散能量性质。
5. 加入时间积分步进和离散收敛测试。
