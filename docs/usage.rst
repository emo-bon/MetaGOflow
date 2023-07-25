.. _usage:

How to run ``metaGOflow``
==========================


Raw data
----------------

``metaGOflow`` takes as input shotgun sequences in ``.fastq`` format without any particual dependency on their production.

The sequences file can be provided to ``metaGOflow`` directly or an ENA accession id of the run of intereste can be provided and 
``metaGOflow`` will fetch the data automatically. 


Fill in the ``config.yml`` file and set the parameters as described in the :doc:`/args_and_params`.


Run ``metaGOflow``
-------------------

Assuming ``metaGOflow`` is about to perform in a HPC environment where `Singularity <>`_ is set
and that we have built a ``conda`` environment as shown in :doc:`/installation` 
let's break down how we would execute a run given the ``config.yml`` is set. 


.. code-block:: bash

   #SBATCH --partition=fat
   #SBATCH --nodes=1
   #SBATCH --nodelist=
   #SBATCH --ntasks-per-node=40
   #SBATCH --mem=
   #SBATCH --mail-user=my_accountr@email.com
   #SBATCH --mail-type=ALL
   #SBATCH --requeue
   #SBATCH --job-name="mg_run"
   #SBATCH --output=metagoflow_run.output

   # Deactivate conda if already there
   conda activate metagoflow

   # Load module
   module load singularity/3.7.1 

   # To run an ENA run
   ./run_wf.sh -e ERR599171 -d my_analysis -n ERR599171 -s


The first lines starting with a ``#``` stand for `SLURM commands <https://slurm.schedmd.com/overview.html>`_
SLURM is a widely used cluster management and job scheduling system among several ones. 
In any case, you need to ensure you are in line with your HPC instructions.

We activate the ``conda`` environment and ensure that the computing node can use Singularity.
Then we run ``metaGOflow`` by executing hte ``run_wf.sh`` script.  
In this case, the `ERR599171 <https://www.ebi.ac.uk/ena/browser/view/ERR599171>`_
sample from ENA will be fetched
and the workflow will be performed using Singularity (`-s`).
An output directory will be built called ``my_analysis`` and the prefix of the data products will be the same 
as the accession id, as ``-n`` has the same value with ``-e``.

.. attention:: Remember to always keep the ``config.yaml`` file in the root directory of the
      folder as downloaded from the GitHub repository.


In case an HPC is not used, then the SLURM commands or any similar ones are not required.


Output / data products
----------------------

Apparently, based on the steps asked to be performed ``metaGOflow`` returns a series of data products. 
In all cases, the main output is a ``.zip`` file including the RO-Crate produced. 

In the root of the output folder there are 4 data products:

+---------------------------------+-------------------------------------------------------------+
|**Data product**                 |**Description**                                              |
+---------------------------------+-------------------------------------------------------------+
| ``results``                     | Folder with the metaGOflow findings                         |
+---------------------------------+-------------------------------------------------------------+
| ``ro-crate-metadata.json``      | JSON-LD file describing the structure of the RO-Crate       |
+---------------------------------+-------------------------------------------------------------+
|   ``config.yml``                | metaGOflow configuration file                               |
+---------------------------------+-------------------------------------------------------------+
|   ``my_prefix.yml``             | Extended configuration file automatically produced          |
+---------------------------------+-------------------------------------------------------------+

If the ``-b`` flag was used, asking to save the ``tmp`` folder, then a folder called like this would be also present. 



The data products of the ``qc_and_merge`` step can be found in the root of the ``results`` directory.
In the same place, the output of the assembly step (``final.contigs.fa``) will be found, if asked to be performed.

+----------------------------------------------+------------------------------------------------------+
|**Data product**                              |**Description**                                       |
+----------------------------------------------+------------------------------------------------------+
| ``*_1.fastq.trimmed.fasta``                  | Filtered .fastq file of the forward (R1) reads       |
+----------------------------------------------+------------------------------------------------------+
| ``*_2.fastq.trimmed.fasta``                  | Filtered .fastq file of the reverse (R2) reads       |
+----------------------------------------------+------------------------------------------------------+
| ``*_1.fastq.trimmed.qc_summary``	           | Summary with statistics of the forward (R1) reads    |
+----------------------------------------------+------------------------------------------------------+
| ``*_2.fastq.trimmed.qc_summary``	           | Summary with statistics of the reverse (R2) reads    |
+----------------------------------------------+------------------------------------------------------+
|``*merged_CDS.faa``	                          | Aminoacid coding sequences                           |
+----------------------------------------------+------------------------------------------------------+
|``*.merged_CDS.ffn``	                       | Nucleotide coding sequences                          |
+----------------------------------------------+------------------------------------------------------+
|``*.merged.cmsearch.all.tblout.deoverlapped`` | Sequence hits against covariance model databases     |
+----------------------------------------------+------------------------------------------------------+
|``*.merged.fasta``                            | Merged filtered sequences                            |
+----------------------------------------------+------------------------------------------------------+
|``*.merged.motus.tsv``	                       | Merged sequences MOTUs                               |
+----------------------------------------------+------------------------------------------------------+
|``*.merged.qc_summary``                       | Quality control (QC) summary of the merged sequences |
+----------------------------------------------+------------------------------------------------------+
|``*.merged.unfiltered_fasta``                 | Merged sequences that did not pass the filtering     |
+----------------------------------------------+------------------------------------------------------+
|``fastp.html``                                | FASTP analysis of raw sequence data                  |
+----------------------------------------------+------------------------------------------------------+
|``final.contigs.fa``                          | FASTA formatted contig sequences                     |
+----------------------------------------------+------------------------------------------------------+
| RNA-counts                                   | Numbers of RNAs counted                              |
+----------------------------------------------+------------------------------------------------------+


The taxonomic inventory related data products can be found in a subfolder inside the ``results`` folder called ``taxonomy-summary``.

+---------------------------------------+-------------------------------------------------------------------+
|**Data product**                       |**Description**                                                    |
+---------------------------------------+-------------------------------------------------------------------+
| LSU	                                  |                                                                   |
+---------------------------------------+-------------------------------------------------------------------+
| ``*.merged_LSU.fasta.mseq.gz``	       | LSU rRNA sequences used for taxonomic indentification             |
+---------------------------------------+-------------------------------------------------------------------+
| ``*.merged_LSU.fasta.mseq_hdf5.biom`` | OTUs and taxonomic assignments for LSU rRNA (hdf5 formatted BIOM) |
+---------------------------------------+-------------------------------------------------------------------+
| ``*.merged_LSU.fasta.mseq_json.biom`` | OTUs and taxonomic assignments for LSU rRNA (json formatted BIOM) |
+---------------------------------------+-------------------------------------------------------------------+
| ``*.merged_LSU.fasta.mseq.tsv``	    | Tab-separated formatted taxon counts for LSU rRNA sequences       |
+---------------------------------------+-------------------------------------------------------------------+
| ``*.merged_LSU.fasta.mseq.txt``       | Text-based taxon counts for LSU rRNA sequences                    |
+---------------------------------------+-------------------------------------------------------------------+
| krona.html                            | Interactive krona charts for LSU rRNA taxonomic inventory         |
+---------------------------------------+-------------------------------------------------------------------+
| SSU	                                  |                                                                   |
+---------------------------------------+-------------------------------------------------------------------+
| ``*.merged_SSU.fasta.mseq.gz``	       | SSU rRNA sequences used for taxonomic indentification             |
+---------------------------------------+-------------------------------------------------------------------+
| ``*.merged_SSU.fasta.mseq_hdf5.biom`` | OTUs and taxonomic assignments for SSU rRNA (hdf5 formatted BIOM) |
+---------------------------------------+-------------------------------------------------------------------+
| ``*.merged_SSU.fasta.mseq_json.biom`` | OTUs and taxonomic assignments for SSU rRNA (json formatted BIOM) |
+---------------------------------------+-------------------------------------------------------------------+
| ``*.merged_SSU.fasta.mseq.tsv``       | Tab-separated formatted taxon counts for SSU rRNA sequences       |
+---------------------------------------+-------------------------------------------------------------------+
| ``*.merged_SSU.fasta.mseq.txt``       | Text-based taxon counts for SSU rRNA sequences                    |
+---------------------------------------+-------------------------------------------------------------------+
| ``krona.html``                        | Interactive krona charts for SSU rRNA taxonomic inventory         |
+---------------------------------------+-------------------------------------------------------------------+

Likewise, the data products of the functional annotation step can be found in the ``functional-annotation`` subfolder
including:

+-------------------------------------+---------------------------------------------------------------------+
|**Data product**                     |**Description**                                                      |
+-------------------------------------+---------------------------------------------------------------------+
| ``*.merged_CDS.I5.tsv``             | .chunks	                                                            | 
+-------------------------------------+---------------------------------------------------------------------+
| ``*.merged_CDS.I5.tsv.gz``          | 	Merged contigs CDS I5 summary                                     | 
+-------------------------------------+---------------------------------------------------------------------+
| ``*.merged.hmm.tsv.chunks``         | 	            d                                                     |
+-------------------------------------+---------------------------------------------------------------------+
| ``*.merged.hmm.tsv.gz``             | 	Merged contigs HMM summary                                        | 
+-------------------------------------+---------------------------------------------------------------------+
| ``*.merged.summary.go``             | 	Gene Ontology annotation summary                                  | 
+-------------------------------------+---------------------------------------------------------------------+
| ``*.merged.summary.go_slim``        | 	GO slim annotation summary                                        | 
+-------------------------------------+---------------------------------------------------------------------+
| ``*.merged.summary.ips``	           | InterProScan annotation summary                                     | 
+-------------------------------------+---------------------------------------------------------------------+
| ``*.merged.summary.ko``             | KO annotation summary                                               | 
+-------------------------------------+---------------------------------------------------------------------+
| ``*.merged.summary.pfam``           |  Pfam annotation summary                                            | 
+-------------------------------------+---------------------------------------------------------------------+
| ``*.merged.emapper.summary.eggnog`` | eggNOG annotation summary                                           | 
+-------------------------------------+---------------------------------------------------------------------+
| ``stats``                           |                                                                     |  
+-------------------------------------+---------------------------------------------------------------------+
| ``go.stats``                        | Gene Ontology (GO) annotation summary statistics                    |   
+-------------------------------------+---------------------------------------------------------------------+
| ``interproscan.stats``              | InterProScan annotation summary statistics                          | 
+-------------------------------------+---------------------------------------------------------------------+
| ``ko.stats``	                       | Kegg Orthology (KO) annotation summary statistics                   |  
+-------------------------------------+---------------------------------------------------------------------+
| ``orf.stats``                       | Open Reading Frame (ORF) annotation summary statistics              | 
+-------------------------------------+---------------------------------------------------------------------+
| ``pfam.stats``                      | Pfam annotation summary statistics                                  | 
+-------------------------------------+---------------------------------------------------------------------+

Last, a subfolder called ``sequence-categorisation`` is also part of the ``results`` folder 
including information about specific reads assigned in various categories.


+---------------------------------------+---------------------------------------------------------------------+
|**Data product**                       |**Description**                                                      |
+---------------------------------------+---------------------------------------------------------------------+
| 5_8S.fa.gz	                         | 5.8S ribosomal RNA sequences                                        | 
+---------------------------------------+---------------------------------------------------------------------+
| alpha_tmRNA.RF01849.fasta.gz	       | Predicted Alphaproteobacteria transfer-messenger RNA (RF01849)      | 
+---------------------------------------+---------------------------------------------------------------------+
| Bacteria_large_SRP.RF01854.fasta.gz   | Predicted Bacterial large signal recognition particle RNA (RF01854) | 
+---------------------------------------+---------------------------------------------------------------------+
| Bacteria_small_SRP.RF00169.fasta.gz	 | Predicted Bacterial small signal recognition particle RNA (RF00169) | 
+---------------------------------------+---------------------------------------------------------------------+
| cyano_tmRNA.RF01851.fasta.gz          | Predicted Cyanobacteria transfer-messenger RNA (RF01851)            | 
+---------------------------------------+---------------------------------------------------------------------+
| LSU_rRNA_archaea.RF02540.fa.gz        | Predicted Archaeal large subunit ribosomal RNA (RF02540)            | 
+---------------------------------------+---------------------------------------------------------------------+
| LSU_rRNA_bacteria.RF02541.fa.gz       | Predicted Bacterial large subunit ribosomal RNA (RF02541)           | 
+---------------------------------------+---------------------------------------------------------------------+
| LSU_rRNA_eukarya.RF02543.fa.gz        | Predicted Eukaryotic large subunit ribosomal RNA (RF02543)          | 
+---------------------------------------+---------------------------------------------------------------------+
| RNaseP_bact_a.RF00010.fasta.gz	       | Predicted Bacterial RNase P class A (RF00010)                       | 
+---------------------------------------+---------------------------------------------------------------------+
| SSU_rRNA_archaea.RF01959.fa.gz        | Predicted Archaeal small subunit ribosomal RNA (RF01959)            | 
+---------------------------------------+---------------------------------------------------------------------+
| SSU_rRNA_bacteria.RF00177.fa.gz       | Predicted Bacterial small subunit ribosomal RNA (RF00177)           | 
+---------------------------------------+---------------------------------------------------------------------+
| SSU_rRNA_eukarya.RF01960.fa.gz        | Predicted Eukaryotic small subunit ribosomal RNA (RF01960)          | 
+---------------------------------------+---------------------------------------------------------------------+
| tmRNA.RF00023.fasta.gz	             | Predicted transfer-messenger RNA (RF00023)                          | 
+---------------------------------------+---------------------------------------------------------------------+
| tRNA.RF00005.fasta.gz	                | Predicted transfer RNA (RF00005)                                    | 
+---------------------------------------+---------------------------------------------------------------------+
| tRNA-Sec.RF01852.fasta.gz	          | Predicted Selenocysteine transfer RNA (RF01852)                     | 
+---------------------------------------+---------------------------------------------------------------------+
| taxonomy-summary	                   | sd                                                                  | 
+---------------------------------------+---------------------------------------------------------------------+






