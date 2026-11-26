# SBPD 形式化规范

## 模型层次

1. `StateSystem` 保存有限参考构形、体积、密度和 horizon。
2. `ShapeWeight`、`shapeTensor` 和 `deformationGradient` 对应态型 PD 的非局部几何层。
3. `paperStressMeasure` 对应 `σ̂ = det(F) τ F⁻ᵀ`。
4. `forceState` 和 `paperForceState` 对应 `T = ω σ̂ K X` 的有限点表达式。
5. `statePairForce` 和 `stateInternalForce` 对应运动方程中的态差和有限求和。

## 设计边界

SBPD 只定义通用态型 PD 核心。复合材料相关的正交各向异性本构、铺层、损伤和断裂由独立的 `PDComposite` 包实现。

当前版本使用有限求和表达离散模型。连续积分、应力测度的连续等价性、形状张量可逆性和数值算法收敛需要后续分析接口。
