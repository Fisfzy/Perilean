# 公理审计

运行以下命令可以查看关键定理的内核公理依赖：

```powershell
lake env lean PeriLean/BBPD/AxiomAudit.lean
```

审计入口包含参考键反对称性、离散内部合力为零、PMB 成对力反对称性和 PMB 状态不可逆性。结果应以当前 Lean 和 Mathlib 版本的实际输出为准，不在文档中手工复制推测结果。
