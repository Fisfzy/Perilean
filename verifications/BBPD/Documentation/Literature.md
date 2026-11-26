# 文献与实现对应

## 本地原始资料

以下文件位于本机 `C:\Users\Fisfzy\Desktop\硕士课题PD资料`，构建方案时已直接提取文本核对。

| 文献 | 本地文件 | 采用内容 |
| --- | --- | --- |
| Silling, 2000, Reformulation of elasticity theory for discontinuities and long-range forces | `Silling - 2000 - Reformulation of elasticity theory for discontinui.pdf` | 成对力积分方程、线动量反对称、角动量中心力、有限视界、微弹性势能和宏观能量 |
| Silling and Askari, 2005, A meshfree method based on the peridynamic model of solid mechanics | `A meshfree method based on the peridynamic model.pdf` | PMB、键伸长率、历史变量、局部损伤、三维微模量、断裂能、节点体积离散和中心差分稳定性 |
| Madenci and Oterkus, 2014, Peridynamic Theory and Its Applications | `Madenci 和 Oterkus - 2014 - Peridynamic Theory and Its Applications.pdf` | 统一理论目录、连续与离散模型、平衡律、材料参数、表面效应和数值实现章节结构 |

## 设计决策

Silling 2000 的基本框架把 `f` 解释为单位参考体积平方的力密度。Silling–Askari 2005 的离散方程把积分替换为节点体积加权和。包因此同时保留 `force`、`weightedPairForce` 和 `internalForce` 三层，防止把力密度和实际粒子力混用。

PMB 的历史变量在文献中是每条键的 `0/1` 状态，而局部损伤是邻域内断键比例。第一版先验证状态更新的不可逆性和成对力性质，局部损伤比例放到有限加权求和模块。

## 需要谨慎引用的结论

- 三维 `c = 18 K / (pi delta^4)` 是特定 PMB 模型的标定式，不是任意键型模型的普适定理。
- 三维键型模型的泊松比限制来自同时匹配体积和剪切响应，不能由单独的均匀膨胀能量等效推出。
- 连续守恒律需要可积性、Fubini 换序和时间正则性，不能由有限粒子双重和定理直接替代。
- 数学实数模型的证明不等于浮点求解器已经验证。
