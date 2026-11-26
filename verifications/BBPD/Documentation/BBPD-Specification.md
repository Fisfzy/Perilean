# BB-PD 形式化规范

## 1. 目标

第一版包验证三维有限粒子键型近场动力学的离散数学核心。参数化维度 `d` 保留通用性，物理标定和 PMB 材料结论固定在 `d = 3`。

第一版不宣称已经验证连续积分模型的适定性、局部极限、裂纹路径收敛性或浮点求解器正确性。

## 2. 物理量语义

文献中的 `f(eta, xi)` 是成对力密度，单位是力除以参考体积平方。有限粒子中采用以下约定：

```text
f_ij       成对力密度
F_ij       实际粒子间力 = f_ij * V_i * V_j
F_i^int    粒子 i 的内力密度 = sum_j f_ij * V_j
P^int      全部粒子的内力 = sum_i V_i * F_i^int
```

`PeriLean.BBPD.Pairwise.weightedPairForce` 对应 `F_ij`，`internalForce` 对应 `F_i^int`，`totalInternalForce` 对应 `P^int`。

## 3. 基本对象

参考构形中的粒子位置为 `x_i`，位移为 `u_i`，当前构形位置为

```text
y_i = x_i + u_i
```

参考键和相对位移为

```text
xi_ij  = x_j - x_i
eta_ij = u_j - u_i
zeta_ij = xi_ij + eta_ij = y_j - y_i
```

有效键满足 `i != j` 且 `||xi_ij|| <= delta`。有限粒子结构中额外要求不同粒子的参考位置不重合，因此有效键的参考长度严格为正。

伸长率定义为

```text
s_ij = (||zeta_ij|| - ||xi_ij||) / ||xi_ij||
```

`unitOrZero` 在当前键长度为零时返回零向量。这个定义把 Lean 中实数除零的总函数语义与物理模型的奇异配置明确隔开。需要梯度或单位方向的定理必须另外提供当前键非零假设。

## 4. 成对力接口

通用成对力只要求反对称性：

```text
f_ij = -f_ji
```

离散合力定理只依赖这一性质和有限求和交换，不依赖 PMB 具体公式。

角动量定理还需要中心力条件：

```text
exists a, f_ij = a * (y_j - y_i)
```

这两个接口必须保持独立。反对称性推出线动量平衡，中心力条件才用于角动量平衡。

## 5. PMB 模型

无损伤 PMB 成对力采用

```text
f_ij = c * s_ij * e_ij
e_ij = zeta_ij / ||zeta_ij||
```

实现中用 `unitOrZero zeta_ij` 覆盖 `||zeta_ij|| = 0` 的总函数情况。

与 Silling–Askari 2005 的 PMB 公式逐项对应：文献中的标量函数为 `g(s) = c*s`，历史因子为 `l_ij`，向量成对力为 `g(s_ij) l_ij e_ij`。本包把 `l_ij` 表示为布尔状态 `alive_ij`，并把 `e_ij` 表示为 `unitOrZero zeta_ij`。在当前键长非零且键存活时，`pmbForce` 与文献公式完全相同。`pmbForce_norm` 还验证了其模长为 `|c*s_ij|`。

引入历史变量 `alive_ij` 后，力为零的断键不再承载力。更新规则采用文献中的严格失效条件：

```text
alive_new_ij = alive_old_ij and (s_ij <= s0)
```

因此 `s_ij = s0` 时仍保持，只有 `s_ij > s0` 时断裂。更新定理只允许 `true` 变成 `false`，不允许断键恢复。

## 6. 能量和标定边界

微弹性势能的连续定义是单键势能 `w(eta, xi)`，局部能量密度包含每条键一半的系数。要把势能导数证明成键力，需要：

- 参考键长非零。
- 当前键长非零，或采用在零点单独定义的总函数。
- 势能对相对位移具有相应可微性。
- 连续模型中满足 Bochner 可积性和换序条件。

三维常微模量 PMB 的文献标定为

```text
c = 18 K / (pi * delta^4)
G_c = pi * c * s0^2 * delta^5 / 10
s0 = sqrt(10 G_c / (pi * c * delta^5))
```

这里的第一式依赖三维各向同性中心力 PMB 和均匀膨胀能量等效。仅凭均匀膨胀不能推出一般各向同性线弹性的两个独立参数。剪切响应还会导出键型模型的泊松比限制，因此标定模块必须同时记录体积和剪切检验。

## 7. 连续模型后续层

连续版本将使用参考域 `Omega`、有限测度 `mu` 和核函数 `f(x, y)`。必须显式登记：

- `Omega` 的可测性。
- 成对力核的可测性和 Bochner 可积性。
- 乘积积分可以换序的条件。
- 时间导数和积分可以交换的正则性。
- 外力、密度和位移加速度的可积性。

只有这些条件明确后，才能形式化连续线动量、角动量和能量守恒。有限粒子定理不能自动替代这些分析条件。

## 7.1 当前离散动力学层

`satisfiesDiscreteEquation` 形式化

```text
rho_i * a_i = sum_j f_ij * V_j + b_i
```

`discrete_linear_momentum_balance` 在成对力反对称性下证明

```text
sum_i V_i * rho_i * a_i = sum_i V_i * b_i
```

这对应 Silling 2000 的线动量平衡在有限粒子模型下的直接特化。角动量的几何证明还需要三维叉积接口和中心力矩定理，当前由 `IsCentral` 接口保留依赖边界。

## 8. 数值算法后续层

离散运动方程采用

```text
rho_i * a_i = sum_j f_ij * V_j + b_i
```

中心差分、稳定时间步、体积修正、表面效应和邻域搜索都作为算法契约处理。基于 `Real` 的定义和定理不等于已经验证了浮点程序。浮点求解器需要另外建立离散实现到数学规范的对应关系，并记录舍入误差假设。
