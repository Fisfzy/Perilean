import PeriLean.BBPD.Basic
import PeriLean.BBPD.Potential
import Mathlib.Analysis.InnerProductSpace.Calculus
import Mathlib.Analysis.Calculus.FDeriv.Norm
import Mathlib.Analysis.Calculus.Gradient.Basic
import Mathlib.Analysis.SpecialFunctions.Sqrt

set_option maxHeartbeats 1000000

namespace PeriLean
namespace BBPD

open scoped InnerProductSpace

theorem fderiv_norm_apply {d : ℕ} (z h : Vec d) (hz : z ≠ 0) :
    fderiv ℝ (fun x : Vec d => ‖x‖) z h =
      ⟪z, h⟫_ℝ / ‖z‖ := by
  have hnorm : DifferentiableAt ℝ (fun x : Vec d => ‖x‖) z :=
    (contDiffAt_norm ℝ (n := 1) hz).differentiableAt (by norm_num)
  have hline : HasDerivAt (fun t : ℝ => z + t • h) h 0 := by
    convert (hasDerivAt_const (x := (0 : ℝ)) z).add
      ((hasDerivAt_id (0 : ℝ)).smul_const h) using 1
    funext t
    rfl
    simp
  have hsq0 : (‖z + (0 : ℝ) • h‖ ^ 2 : ℝ) ≠ 0 := by
    simpa [hz] using (show (‖z‖ ^ 2 : ℝ) ≠ 0 by positivity)
  have hsqrt := (Real.hasDerivAt_sqrt hsq0).comp 0 hline.norm_sq
  have hsqrt' : HasDerivAt (fun t : ℝ => ‖z + t • h‖)
      (⟪z, h⟫_ℝ / ‖z‖) 0 := by
    convert hsqrt using 1
    · ext t
      simp [Real.sqrt_sq_eq_abs, abs_of_nonneg]
    · simp [norm_ne_zero_iff.mpr hz]
      field_simp
  rw [← hnorm.lineDeriv_eq_fderiv]
  exact hsqrt'.deriv

noncomputable def microPotential (c : ℝ) (xi eta : Vec d) : ℝ :=
  (1 / 2 : ℝ) * c * ‖xi‖ *
    (((‖xi + eta‖ - ‖xi‖) / ‖xi‖) ^ 2)

noncomputable def microPotentialForce (c : ℝ) (xi eta : Vec d) : Vec d :=
  (c * ((‖xi + eta‖ - ‖xi‖) / ‖xi‖)) • unitOrZero (xi + eta)

theorem microPotential_deriv_line {d : ℕ} (c : ℝ) (xi eta h : Vec d)
    (hxi : xi ≠ 0) (hcurrent : xi + eta ≠ 0) :
    HasDerivAt (fun t : ℝ => microPotential c xi (eta + t • h))
      ⟪microPotentialForce c xi eta, h⟫_ℝ 0 := by
  have hxi_norm : ‖xi‖ ≠ 0 := norm_ne_zero_iff.mpr hxi
  have hcurrent_norm : ‖xi + eta‖ ≠ 0 := norm_ne_zero_iff.mpr hcurrent
  have hnorm : HasDerivAt (fun t : ℝ => ‖xi + eta + t • h‖)
      (⟪xi + eta, h⟫_ℝ / ‖xi + eta‖) 0 := by
    have hdiff : DifferentiableAt ℝ (fun x : Vec d => ‖x‖) (xi + eta) :=
      (contDiffAt_norm ℝ (n := 1) hcurrent).differentiableAt (by norm_num)
    have hpath : HasDerivAt (fun t : ℝ => xi + eta + t • h) h 0 := by
      convert (hasDerivAt_const (x := (0 : ℝ)) (xi + eta)).add
        ((hasDerivAt_id (0 : ℝ)).smul_const h) using 1
      funext t
      rfl
      simp
    have hcomp := hdiff.hasFDerivAt.comp_hasDerivAt_of_eq 0 hpath (by simp)
    rw [Function.comp_def] at hcomp
    convert hcomp using 1
    exact (fderiv_norm_apply (xi + eta) h hcurrent).symm
  have hnorm_sub : HasDerivAt
      (fun t : ℝ => ‖xi + eta + t • h‖ - ‖xi‖)
      (⟪xi + eta, h⟫_ℝ / ‖xi + eta‖) 0 := by
    convert hnorm.sub (hasDerivAt_const (x := (0 : ℝ)) ‖xi‖) using 1 <;> simp
  have hstretch : HasDerivAt
      (fun t : ℝ => (‖xi + eta + t • h‖ - ‖xi‖) / ‖xi‖)
      ((⟪xi + eta, h⟫_ℝ / ‖xi + eta‖) / ‖xi‖) 0 := by
    simpa using hnorm_sub.div_const ‖xi‖
  have hstretch_sq : HasDerivAt
      (fun t : ℝ => ((‖xi + eta + t • h‖ - ‖xi‖) / ‖xi‖) ^ 2)
      (2 * ((‖xi + eta‖ - ‖xi‖) / ‖xi‖) *
        ((⟪xi + eta, h⟫_ℝ / ‖xi + eta‖) / ‖xi‖)) 0 := by
    convert hstretch.mul hstretch using 1
    · funext t
      simp [pow_two]
    · simp [zero_smul]
      ring
  have hpotential : HasDerivAt
      (fun t : ℝ => (1 / 2 : ℝ) * c * ‖xi‖ *
        (((‖xi + eta + t • h‖ - ‖xi‖) / ‖xi‖) ^ 2))
      ((1 / 2 : ℝ) * c * ‖xi‖ *
        (2 * ((‖xi + eta‖ - ‖xi‖) / ‖xi‖) *
          ((⟪xi + eta, h⟫_ℝ / ‖xi + eta‖) / ‖xi‖))) 0 := by
    simpa [mul_assoc] using hstretch_sq.const_mul ((1 / 2 : ℝ) * c * ‖xi‖)
  convert hpotential using 1
  · funext t
    simp [microPotential, add_assoc, add_comm, add_left_comm]
  · simp [microPotentialForce, unitOrZero, hcurrent_norm, smul_smul,
      real_inner_comm, real_inner_smul_right, inner_add_right, div_eq_mul_inv]
    field_simp

theorem microPotential_fderiv_apply {d : ℕ} (c : ℝ) (xi eta h : Vec d)
    (hxi : xi ≠ 0) (hcurrent : xi + eta ≠ 0) :
    fderiv ℝ (fun e : Vec d => microPotential c xi e) eta h =
      ⟪microPotentialForce c xi eta, h⟫_ℝ := by
  have hdiff : DifferentiableAt ℝ (fun e : Vec d => microPotential c xi e) eta := by
    unfold microPotential
    have hnorm : DifferentiableAt ℝ (fun e : Vec d => ‖xi + e‖) eta := by
      have hbase : DifferentiableAt ℝ (fun x : Vec d => ‖x‖) (xi + eta) :=
        (contDiffAt_norm ℝ (n := 1) hcurrent).differentiableAt (by norm_num)
      have hadd : DifferentiableAt ℝ (fun e : Vec d => xi + e) eta := by
        convert (differentiableAt_const (𝕜 := ℝ) (x := eta) (c := xi)).add
          differentiableAt_id using 1
        funext e
        rfl
      exact hbase.comp eta hadd
    have hsub : DifferentiableAt ℝ
        (fun e : Vec d => ‖xi + e‖ - ‖xi‖) eta :=
      hnorm.sub_const ‖xi‖
    have hdiv : DifferentiableAt ℝ
        (fun e : Vec d => (‖xi + e‖ - ‖xi‖) / ‖xi‖) eta :=
      by
        simpa [div_eq_mul_inv] using hsub.mul_const (‖xi‖ : ℝ)⁻¹
    have hsq : DifferentiableAt ℝ
        (fun e : Vec d => ((‖xi + e‖ - ‖xi‖) / ‖xi‖) ^ 2) eta :=
      hdiv.pow 2
    simpa [mul_assoc] using hsq.const_mul ((1 / 2 : ℝ) * c * ‖xi‖)
  rw [← hdiff.lineDeriv_eq_fderiv]
  exact (microPotential_deriv_line c xi eta h hxi hcurrent).deriv

theorem microPotential_hasGradientAt {d : ℕ} (c : ℝ) (xi eta : Vec d)
    (hxi : xi ≠ 0) (hcurrent : xi + eta ≠ 0) :
    HasGradientAt (fun e : Vec d => microPotential c xi e)
      (microPotentialForce c xi eta) eta := by
  apply hasGradientAt_iff_hasFDerivAt.mpr
  have hdiff : DifferentiableAt ℝ (fun e : Vec d => microPotential c xi e) eta := by
    unfold microPotential
    have hnorm : DifferentiableAt ℝ (fun e : Vec d => ‖xi + e‖) eta := by
      have hbase : DifferentiableAt ℝ (fun x : Vec d => ‖x‖) (xi + eta) :=
        (contDiffAt_norm ℝ (n := 1) hcurrent).differentiableAt (by norm_num)
      have hadd : DifferentiableAt ℝ (fun e : Vec d => xi + e) eta := by
        convert (differentiableAt_const (𝕜 := ℝ) (x := eta) (c := xi)).add
          differentiableAt_id using 1
        funext e
        rfl
      exact hbase.comp eta hadd
    have hsub : DifferentiableAt ℝ
        (fun e : Vec d => ‖xi + e‖ - ‖xi‖) eta :=
      hnorm.sub_const ‖xi‖
    have hdiv : DifferentiableAt ℝ
        (fun e : Vec d => (‖xi + e‖ - ‖xi‖) / ‖xi‖) eta :=
      by
        simpa [div_eq_mul_inv] using hsub.mul_const (‖xi‖ : ℝ)⁻¹
    have hsq : DifferentiableAt ℝ
        (fun e : Vec d => ((‖xi + e‖ - ‖xi‖) / ‖xi‖) ^ 2) eta :=
      hdiv.pow 2
    simpa [mul_assoc] using hsq.const_mul ((1 / 2 : ℝ) * c * ‖xi‖)
  have hfd := hdiff.hasFDerivAt
  apply hfd.congr_fderiv
  ext h
  rw [microPotential_fderiv_apply c xi eta h hxi hcurrent]
  exact (InnerProductSpace.toDual_apply_apply (𝕜 := ℝ) (E := Vec d)).symm

theorem pmbBondPotential_eq_microPotential {N d : ℕ}
    (system : ParticleSystem N d) (c : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) (i j : Fin N)
    (hbond : isBond system i j) (halive : alive i j = true) :
    pmbBondPotential system c alive displacement i j =
      microPotential c (referenceBond system i j)
        (relativeDisplacement displacement i j) := by
  simp [pmbBondPotential, microPotential, hbond, halive, stretch, deformedBond]

theorem pmbForce_eq_microPotentialForce {N d : ℕ}
    (system : ParticleSystem N d) (c criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) (i j : Fin N)
    (hbond : isBond system i j) (halive : alive i j = true) :
    pmbForce system c criticalStretch alive displacement i j =
      microPotentialForce c (referenceBond system i j)
        (relativeDisplacement displacement i j) := by
  rw [pmbForce_formula_on_bond system c criticalStretch alive displacement hbond halive]
  rfl

theorem pmbBondPotential_hasGradientAt {N d : ℕ}
    (system : ParticleSystem N d) (c : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) (i j : Fin N)
    (hij : i ≠ j) (halive : alive i j = true)
    (hcurrent : deformedBond system displacement i j ≠ 0) :
    HasGradientAt
      (fun eta : Vec d => microPotential c (referenceBond system i j) eta)
      (microPotentialForce c (referenceBond system i j)
        (relativeDisplacement displacement i j))
      (relativeDisplacement displacement i j) := by
  apply microPotential_hasGradientAt
  · exact referenceBond_ne_zero system hij
  · simpa [deformedBond] using hcurrent

end BBPD
end PeriLean
