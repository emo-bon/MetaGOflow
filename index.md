---
layout: default
---
[metaGOflow](https://github.com/emo-bon/MetaGOflow) is a pipeline based on [MGnify](https://www.ebi.ac.uk/metagenomics/) and its [workflows](github.com/ebI-Metagenomics/pipeline-v5),
aiming to address the challenges of the analysis of the European Marine Omics Biodiversity Observation Network (EMO BON) data.
[EMO BON](https://www.embrc.eu/emo-bon) is a long-term omics observatory of marine biodiversity that generates hundreds of metagenomic samples periodically from a range of stations around Europe.

In the following diagram is an overview of the metaGOflow steps:

![wf](https://raw.githubusercontent.com/hariszaf/metaGOflow-use-case/gh-pages/assets/img/eosc-life-marine-gos-wf.png)

<!-- As long as our sequences seem good enough, we can investigate the taxonomic inventories returned, based on the SSU and the LSU rRNA genes.  -->

Here we show visual components accompanying the [metaGOflow publication]().
We performed all steps of metaGOflow for an EMO BON marine sediment (ERS14961254) and a water column (ERS14961281) sample.
A quality control report, the taxonomic inventories as well as some of the functional annotations returned in each case are displayed below.

* To have an overview on the metaGOflow results for the **marine sediment** sample click [here](./marine-sediment.html).
* For the **water column** sample, you may have a look [here](./water-column.html)

We also tested metaGOflow with a TARA OCEAN sample.
You may find the RO-crate produced from the complete metaGOflow run for this sample through this [Zenodo repository]().
Last, you may have a look on the `ro-crate-metadata.json` file that describes the RO-Crate metaGOflow built for this sample [here](./rocrate-metadata.html).

**metaGOflow source code:**
[GitHub repo](https://github.com/emo-bon/MetaGOflow)

**Citation**

In case you are using metaGOflow for your analysis, please remember to cite us:

metaGOflow: a workflow for the analysis of marine Genomic Observatories shotgun metagenomics data (to be submitted in GigaScience)

**Contact**

[emobon@embrc.eu](mailto:emobon@embrc.eu)

![Octocat](https://github.githubassets.com/images/icons/emoji/octocat.png)
