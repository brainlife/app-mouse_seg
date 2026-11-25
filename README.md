# Mouse Segmentation Pipeline

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Skull-strips a mouse brain MRI by atlas registration and segments it into ROIs with the JHU Mori mouse atlas, using FSL, AFNI, ANTs and NiftyReg in one container.**

Runs a containerised mouse pipeline: optional N4 bias field correction, skull-stripping following the rat MRI/DTI method of Li et al. with the C57BL6 Brookhaven atlas (affine or rigid registration, optional histogram matching), then segmentation by mapping the Mori (JHU) mouse atlas. Use it for mouse, not human, anatomical images. Set orient only if the image's orientation string (as reported by AFNI 3dinfo) is wrong.

| | |
|---|---|
| 📥 **Inputs** | `neuro/anat/t1w` |
| 📤 **Outputs** | `raw` |
| 🐳 **Container** | `katealpert/mouse_seg:v0.0` |
| ⚙️ **Resources** | 2 CPUs · 4 h walltime |
| 🔗 **Run it** | [doi.org/10.25663/bl.app.75](https://doi.org/10.25663/bl.app.75) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `t1` | `neuro/anat/t1w` | yes | Mouse brain anatomical MRI volume (NIfTI). |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `output` | `raw` | Directory with the pipeline's skull-stripped image and atlas-based ROI segmentation. |

<details>
<summary><b>⚙️ Parameters</b> (4)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `orient` | string |  | leave blank unless orientation string is incorrect for image (3dinfo) |
| `reg_type` | enum | `affine` | When skull-stripping, register target to template affinely (allows scaling) or rigidly (no scaling). Options: `affine`, `rigid`. |
| `do_hist_match` | boolean | `true` | When skull-stripping, use histogram matching to propagate template tissue segmentations onto the target image. |
| `do_n4` | boolean | `true` | Perform N4 (improved nonparametric nonuniform normalization) bias field correction on input. |

</details>

📚 **References used by this App:**
- Automatic Skull-stripping of Rat MRI/DTI Scans and Atlas Building (PMC3168953).
- Complete Disruption of the Kainate Receptor Gene Family Results in Corticostriatal Dysfunction in Mice (PMID 28228252).

<!-- brainlife-app:end -->

## Skull-stripping
The skull stripping uses the algorithm outlined in [Automatic Skull-stripping of Rat MRI/DTI Scans and Atlas Building](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3168953/) with the C57BL6 Brookhaven atlas.

## Segmentation
The segmentation routine maps an atlas from Susumu Mori at JHU (see [Complete Disruption of the Kainate Receptor Gene Family Results in Corticostriatal Dysfunction in Mice](https://www.ncbi.nlm.nih.gov/pubmed/28228252)) onto the target image using [FNIRT](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FNIRT). Optional [N4 bias field correction](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3071855) may be performed on the skull-stripped image prior to registration.
