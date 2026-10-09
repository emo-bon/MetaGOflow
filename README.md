# metaGOflow: A workflow for marine Genomic Observatories' data analysis

![logo](https://raw.githubusercontent.com/hariszaf/metaGOflow-use-case/gh-pages/assets/img/metaGOflow_logo_italics.png)


## An EOSC-Life project

The workflows developed in the framework of this project are based on `pipeline-v5` of the MGnify resource.

> This branch is a child of the [`pipeline_5.1`](https://github.com/hariszaf/pipeline-v5/tree/pipeline_5.1) branch
> that contains all CWL descriptions of the MGnify pipeline version 5.1.

## Dependencies

To run metaGOflow you need to make sure you have the following set on your computing environmnet first:

- python [v 3.8+]
- [Docker](https://www.docker.com) [v 19.+] or [Singularity](https://apptainer.org) [v 3.7.+]/[Apptainer](https://apptainer.org) [v 1.+]
- [cwltool](https://pypi.org/project/cwltool/) [v 3.+]
- [rocrate](https://pypi.org/project/rocrate/) [v 0.7.0]
- [ruamel.yaml](https://pypi.org/project/ruamel.yaml) [v 0.17.32+]
- [Node.js](https://nodejs.org/) [v 10.24.0+]
- Available storage ~160GB for databases

### Storage while running

Depending on the analysis you are about to run, disk requirements vary.
Indicatively, you may have a look at the metaGOflow publication for computing resources used in various cases.

## Installation

### Get the EOSC-Life marine GOs workflow

```bash
git clone https://github.com/emo-bon/MetaGOflow
cd MetaGOflow
```

### Download necessary databases (~235GB)

You can download databases for the EOSC-Life GOs workflow by running the
`download_dbs.sh` script under the `Installation` folder.

```bash
bash Installation/download_dbs.sh -f [Output Directory e.g. ref-dbs] 
```
If you have one or more already in your system, then create a symbolic link pointing
at the `ref-dbs` folder or at one of its subfolders/files.

The final structure of the DB directory should be like the following:

````bash
user@server:~/MetaGOflow: ls ref-dbs/
db_kofam/  diamond/  eggnog/  GO-slim/  interproscan-5.57-90.0/  kegg_pathways/  kofam_ko_desc.tsv  Rfam/  silva_lsu/  silva_ssu/
````

## How to run

We recommend utilizing [Conda](https://docs.conda.io/projects/conda/en/stable/) to create a virtual environment. We provide a Conda [environment file](conda_environment.yml) that includes the necessary dependencies.

### Set up the environment

#### Run once - Setup environment

This will create a conda env called `metagoflow`.

```bash
conda env create -f conda_environment.yml
```

#### Run every time

```bash
conda activate metagoflow
``` 

### Run the workflow

- Edit the `config.yml` file to set the parameter values of your choice. For selecting all the steps, then set to `true` the variables in lines [2-6].

#### Using Singularity

##### Standalone

```bash
./run_wf.sh -s -n osd-short \
-d short-test-case \
-f test_input/wgs-paired-SRR1620013_1.fastq.gz \
-r test_input/wgs-paired-SRR1620013_2.fastq.gz
```

##### Using a cluster with a queueing system (e.g. SLURM)

- Create a job file (e.g., SBATCH file)

- Enable Singularity, e.g. module load Singularity & all other dependencies 

- Add the run line to the job file


#### Using Docker

##### Standalone

``` bash
./run_wf.sh -n osd-short -d short-test-case \
-f test_input/wgs-paired-SRR1620013_1.fastq.gz \
-r test_input/wgs-paired-SRR1620013_2.fastq.gz
```
  HINT: If you are using Docker, you may need to run the above command without the `-s' flag.

## Testing samples
The samples are available in the `test_input` folder.

We provide metaGOflow with partial samples from the Human Metagenome Project ([SRR1620013](https://www.ebi.ac.uk/ena/browser/view/SRR1620013) and [SRR1620014](https://www.ebi.ac.uk/ena/browser/view/SRR1620014))
They are partial as only a small part of their sequences have been kept, in terms for the pipeline to test in a fast way. 


## Hints and tips

1. In case you are using Docker, it is strongly recommended to **avoid** installing it through `snap`.

2. `RuntimeError`: slurm currently does not support shared caching, because it does not support cleaning up a worker
   after the last job finishes.
   Set the `--disableCaching` flag if you want to use this batch system.

3. In case you are having errors like:

```
cwltool.errors.WorkflowException: Singularity is not available for this tool
```

You may run the following command:

```
singularity pull --force --name debian:stable-slim.sif docker://debian:stable-sli
```

## Contribution

To make contribution to the project a bit easier, all the MGnify `conditionals` and `subworkflows` under
the `workflows/` directory that are not used in the metaGOflow framework, have been removed.   
However, all the MGnify `tools/` and `utils/` are available in this repo, even if they are not invoked in the current
version of metaGOflow.
This way, we hope we encourage people to implement their own `conditionals` and/or `subworkflows` by exploiting the
currently supported `tools` and `utils` as well as by developing new `tools` and/or `utils`.


<!-- cwltool --print-dot my-wf.cwl | dot -Tsvg > my-wf.svg -->
