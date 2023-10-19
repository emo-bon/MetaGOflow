.. _args_and_params:

Arguments and parameters
=========================

.. autosummary::
   :toctree: generated

Arguments
----------

``metaGOflow`` has 2 levels where the user sets arguments. 
Inline, a few technical arguments are provided as described below:


.. code-block:: console

   -f                  Forward reads fasta file path (mandatory if and only if -e not used).
   -r                  Reverse reads fasta file path (mandatory if and only if -e not used).
   -e                  ENA run accession number. Its raw data will be fetched and then analysed (if used, -f and -r should not me set). 
   -d                  Output directory name (mandatory).
   -n                  Name of run and prefix to output files (mandatory).
   -s                  Run workflow using Singularity (Docker is the by default container technology). Works as a flag, i.e. by adding -s in your command, Singularity is going to be used.
   -u                  ENA username in case of private data. 
   -k                  ENA password in case of private data.
   -b                  Keep tmp folder. Works as flag. 

One may have the raw data to be used either already locally or fetch them from ENA.
In the first case, the ``-f`` and ``-r`` arguments are used to provide the forward and the reverse reads correspondingly.
In the latter, ``-f`` and ``-r`` are not to be used and the user may provide the accession id using the ``-e`` argument. 
If and only if private data from ENA are to be used, the used needs to provide his/her credentials to the corresponding ENA account 
through the ``-u`` and ``-k`` arguments.

``metaGOflow`` builds a great number of intermediate files that usually require a significant disk space, based on the sample and the steps to be performed.
By default it removes all the intermediate files once it's completed. 
The user may keep them by using the ``-b`` flag.


Parameters
-----------


The steps to be performed in a ``metaGOflow`` run and the parameters of the software to be invoked 
are provided through the  ``config.yml``  file [`url <https://github.com/emo-bon/MetaGOflow/blob/eosc-life-gos/config.yml>`_].


``metaGOflow`` does not need to perform all its steps at once; one may run the first *n* steps. 
On top of that, it can use the output of previous steps to run the next ones without the need of re-running the first ones. 


The steps to be performed are selected by setting ``True`` or ``False`` the following parameters in the ``config.yml`` file.

+---------------------------------+----------------------------------------------------------------------------------------------------------+
|**Parameter**                    |**Description**                                                                                           |
+---------------------------------+----------------------------------------------------------------------------------------------------------+
|``qc_and_merge_step``            | Performs a quality control of the raw reads, filters and merges them                                     |
+---------------------------------+----------------------------------------------------------------------------------------------------------+
|``taxonomic_inventory``          |  Using the filtered and merged sequences, it returns a taxonomic inventory                               |
+---------------------------------+----------------------------------------------------------------------------------------------------------+
|``cgc_step``                     |  Exports coding sequences                                                                                |
+---------------------------------+----------------------------------------------------------------------------------------------------------+
|``reads_functional_annotation``  |  Performs functional annotation on the coding genes found using a list of resources: InterPro, KEGG     |
+---------------------------------+----------------------------------------------------------------------------------------------------------+
|``assemble``                     |  Assembles the filtered and merged sequences to contigs                                                  |
+---------------------------------+----------------------------------------------------------------------------------------------------------+


.. Attention:: The intermediate files produced in a complete run of ``metaGOflow`` depending 
   on the sample size, may reach 1 TB of storage.
.. tip:: If you want to run only the first steps and at a later point the rest of those, you do not need to use the ``-b`` parameter.
   It is the end products of each step that are required for any following step.


Besides the steps to be performed, a number of parameters to best fit the idiosyncrasy of the sequences to be analysed need to be set
as well as, some resources-to-be-used related ones.

.. attention:: We strongly advised user not to use the default arguments without considering first their data and their computing system


+---------------------------------+------------------------------------------------------------------------------------------------------------+
|**Parameter**                    |**Description**                                                                                             |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``detect_adapter_for_pe``        | Enables adapter sequence auto-detection; by default adapters can be trimmed by overlap analysis            |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``overrepresentation_analysis``  | Enables overrepresented sequence analysis                                                                  |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``min_length_required``          | Length of shortest reads to be kept; sequences with a shorter length will be discarded                     |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``force_polyg_tail_trimming``    | Forces polyG tail trimming, by default trimming is automatically enabled for Illumina NextSeq/NovaSeq data |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``base_correction``              | Enables overlap analysis which tries to find an overlap of each pair of reads                              |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``qualified_phred_quality``      | The quality value that a base is qualified. Default 15 means phred quality >=Q15 is qualified.             |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``unqualified_percent_limit``    | Percents of bases allowed to be unqualified (0~100). Default 40 means 40% (int [=40])                      |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``disable_trim_poly_g``          | Enables the detection of polyG in read tails and trims them                                                |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``overlap_len_require``          | The minimum length to detect overlapped region of PE reads. This will affect overlap analysis based        |
|                                 | merge, adhttps://apptainer.orgapter trimming and correction. 30 by default. (int [=30])                    |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``cut_right``                    | Moves a sliding window from front to tail, if meet one window with mean quality < threshold, drops the     |
|                                 | bases in the window and the right part, and then stop.                                                     |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``min-contig-len``               | Minimum length of a contig to be returned                                                                  |
+---------------------------------+------------------------------------------------------------------------------------------------------------+

For more information about how the different analysis of ``fastp`` is performed, you may 
have a look at its `GitHub repository <https://github.com/OpenGene/fastp>`_.

Finally, a number of system related parameters need to be set. 
These parameters do not affect the final data products but they play a crucial role in the time efficiency 
of ``metaGOflow``. The size of the sample and the computing resources available need to be taken into account 
for the best tuning of those. 

+---------------------------------+------------------------------------------------------------------------------------------------------------+
|**Parameter**                    |**Description**                                                                                             |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``memory``                       | Memory to run assembly. When 0 < ``memory`` < 1, fraction of all available memory of the machine is used,  | 
|                                 | otherwise it specifies the memory in BYTE.                                                                 |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``threads``                      | Number of threads to be used in all tasks of the steps to be performed except of the InterProScan          |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``interproscan_threads``         | Number of threads to be used for the InterProScan task.                                                    |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``cgc_chunk_size``               | Size of each chunk to which filtered sequences will be split to to perform the ``cgc_step``                |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``protein_chunk_size_IPS``       | Size of each chunk to which the filtered sequences will be split to to perform the InterProScan task       |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``protein_chunk_size_eggnog``    | Size of each chunk to which the filtered sequences will be split to to perform the eggNOG task             |
+---------------------------------+------------------------------------------------------------------------------------------------------------+
|``protein_chunk_size_hmm``       | Size of each chunk to which the filtered sequences will be split to to perform the HMMER task              |
+---------------------------------+------------------------------------------------------------------------------------------------------------+

.. tip:: 
   The chunk size related parameters play a key role in the time efficiency of ``metaGOflow``. 
   Based on the sample to be analysed and the computing environment to be used, the value of chunks may range 
   from a few thousands to millions. 
   In our experience, by setting the ``protein_chunk_size_hmm`` and ``protein_chunk_size_eggnog`` in a similar value and the ``protein_chunk_size_IPS`` 2-3 times higher,
   we get an efficient performance.
   Likewise, the ``interproscan_threads`` parameter affects critically the performance of the workflow. 
   As a rule of thumb, the user may use the floor of the ``threads``/8 ratio.


Running ``metaGOflow`` partially
---------------------------------

To use previous data products of a study and run steps not performed in the first place,
certain files that were produced (in the first run) are required, based on the steps performed and those to be performed.

+-----------------------------------+------------------------------------------------------------------------------------------------------------+
|**Parameter**                      |**Description**                                                                                             |
+-----------------------------------+------------------------------------------------------------------------------------------------------------+
|``processed_reads``                | Filtered sequences files. Mandatory for running any step after the ``qc_and_merge_step`` one;              |
|                                   | merged pre-processed reads; file suffix: ``.merged.fasta``                                                 |
+-----------------------------------+------------------------------------------------------------------------------------------------------------+
| ``input_for_motus``               | Filtered sequences files with cleaned headers. Mandatory for running the ``taxonomy_inventory`` step;      |
|                                   | file suffix: ``.merged.unfiltered.fasta``                                                                  |
+-----------------------------------+------------------------------------------------------------------------------------------------------------+
| ``maskfile``                      | Sequence files with hits against covariance model databases. Mandatory for running the functional          |
|                                   | annotation steps; file suffix: ``.merged.cmsearch.all.tblout.deoverlapped``                                |
+-----------------------------------+------------------------------------------------------------------------------------------------------------+
| ``count_faa_from_previous_run``   | Number of the sequences included in the ``*merged_CDS.faa`` file. Mandatory for the                        |
|                                   | ``reads_functional_annotation`` step;    You may get this by running: ``grep -c ">" <*..merged_CDS.faa>``  |
+-----------------------------------+------------------------------------------------------------------------------------------------------------+
|``predicted_faa_from_previous_run``| Mandatory for the functional annotation step; file suffix: ``.merged_CDS.faa``                             |
+-----------------------------------+------------------------------------------------------------------------------------------------------------+
| ``processed_read_files``          | Forward and reverse files with unmergerd filteres sequences. Mandatory for running the assembly step;      |
|                                   | file suffix: ``clean.fastq.trimmed.fasta``                                                                 |
+-----------------------------------+------------------------------------------------------------------------------------------------------------+


.. caution:: Up to now, due to `CWL limitations <https://github.com/common-workflow-language/cwl-v1.3/issues/3>`_, the ``config.yml`` file **requires** the parameters that point to a 
   file that would be used for a partial run to be non-empty. Thus, we provide these ``pseudo*`` files. 
   Remember to always include those in your config file. 
   If these parameters are empty, ``metaGOflow`` will fail.


Example of the ``config.yml`` file
-----------------------------------

An example of the ``config.yml`` file to perform all the steps. 

.. code:: yaml

   # Steps to go for
   qc_and_merge_step: true
   taxonomic_inventory: true
   cgc_step: true
   reads_functional_annotation: true
   assemble: true

   # Parameters
   threads: 40
   interproscan_threads: 5

   detect_adapter_for_pe: false
   overrepresentation_analysis: false
   min_length_required: 108
   force_polyg_tail_trimming: 
   base_correction: false
   qualified_phred_quality: 
   unqualified_percent_limit: 
   disable_trim_poly_g:
   overlap_len_require: 
   cut_right: false
   correction: false


   memory: 0.9
   min-contig-len: 500

   cgc_chunk_size: 200
   protein_chunk_size_IPS: 1000000
   protein_chunk_size_eggnog: 4000000
   protein_chunk_size_hmm: 4000000

   # Files for running partially
   processed_reads: {
   class: File, 
   format: "edam:format_1929",
   path:  results/ERR599171.merged.fasta
   }

   input_for_motus: {
   class: File, 
   path:  workflows/pseudo_files/pseudo.merged.unfiltered.fasta
   }


   maskfile: {
   class: File, 
   path:  results/ERR599171.merged.cmsearch.all.tblout.deoverlapped
   }

   count_faa_from_previous_run: 18934897


   predicted_faa_from_previous_run: {
   class: File, 
   format: "edam:format_1929",
   path:  results/ERR599171.merged_CDS.faa
   }

   processed_read_files: 
   - class: File
      path:  workflows/pseudo_files/pseudo_1_clean.fastq.trimmed.fasta
   - class: File
      path:  workflows/pseudo_files/pseudo_2_clean.fastq.trimmed.fasta





