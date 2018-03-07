# Mouse Segmentation Pipeline

## Skull-stripping
The skull stripping uses the algorithm outlined in [Automatic Skull-stripping of Rat MRI/DTI Scans and Atlas Building](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3168953/) with the C57BL6 Brookhaven atlas.

## Segmentation
The segmentation routine maps an atlas from Susumu Mori at JHU (see [Complete Disruption of the Kainate Receptor Gene Family Results in Corticostriatal Dysfunction in Mice](https://www.ncbi.nlm.nih.gov/pubmed/28228252)) onto the target image using [FNIRT](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FNIRT). Optional [N4 bias field correction](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3071855) may be performed on the skull-stripped image prior to registration.
