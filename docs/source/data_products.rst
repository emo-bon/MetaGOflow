.. _data_products:

Description of ``metaGOflow``'s data products
=============================================


Quality filtering step
-----------------------

- ``*.fastq.trimmed.fasta`` **files** 
Filtered .fasta files of the forward (R1) and reverse (R2) reads. Its content strongly depends on the 
``fastp``-related :doc:`/args_and_params` parameters. 
A record in a .fasta file consists of 2 parts: a *header* that always starts with a ``>`` and describes
the sequence (experiment id, coordinates etc.) and the sequence. 
Example:

.. code-block:: bash

    >SRR1620013.60-C038EACXX:5:1101:06662:02714-1
    GAATGGAATGGAATGGAATGGAACCTGTCTCTTATACACATCTCTGAGCGGGCTGGCAAG
    GCAGACCGATCACGATCTCGTATGCCGTCCTCTGCTTGACA

- ``.fastq.trimmed.qc_summary`` **files**
A report for the number of sequences removed after each trimming/filtering task
for the forward and the reverse reads.
Example:

.. code-block:: bash

    Submitted nucleotide sequences	100000
    Nucleotide sequences after format-specific filtering	3495
    Nucleotide sequences after length filtering	3477
    Nucleotide sequences after undetermined bases filtering	3477

- ``.merged.fasta`` **file**
A ``.fasta`` file with the filtered, merged reads; the forward and reverse reads merge into one. 

.. code-block:: bash

    >SRR1620013.10-C038EACXX:5:1101:04403:02479-1-merged-101-9
    GGGTGGGACTGCAAGCTTTCCAAACTACAGAAAATGCCAGGACGACTATTTTAAAATATT
    TTTAAAATCTGTAAAATAATTGGAATGAACAATACACATATTCCTGTCTC


- ``*.merged.qc_summary`` **file**
Like the ``.fastq.trimmed.qc_summary`` file but for the case of the merged reads.


- ``fastp.html`` **file**
An .html file with visual contents of the quality of both the forward and the reverse 
and the merged reads. 
For a thorough description of this file, the reader may watch this `video <https://youtu.be/VrIW4EcHly4?t=510>`_.


- ``*merged.unfiltered_fasta`` **file** 
Often, problematic characters in headers of .fasta and/or .fastq files may appear. 
In this file, the merged .fastq file has been edited so such characters have been replaced with dashes.


.. code-block:: bash

    @V1:1:HWLTKDRXY:1:2202:19524:21151-1-merged-108-0
    GCAAAGAGTACGCTGTCGTAGTTTCTCAAGTCTTTGCCGTGCCCCAATGCCTGATTCGCCGCAAAGGTGTCTAACCCTTGTTCTCGTTGCAGGGAGTAGACCTTCACC
    +
    FFFFFFFF:FFFFFFFFF:FFFFFFFFFFFFFFFFFFFFFFFFF:FFFFFFFFFFFFFFFFFFFF:FFFFFFFFFFF:FF:F:FFFF:FFFFFFFFFFFFFFF:FFFF


This file is necessary for running the `mOTUs package <https://github.com/motu-tool/mOTUs>`_.




Taxonomy inventory step 
------------------------

- ``*.merged.motus.tsv`` **file**
A three column file with the mOTUs found, their taxonomic assignment and their abundance:

.. code-block:: bash

    #mOTU	consensus_taxonomy	count
    meta_mOTU_v25_13231	k__Archaea|p__Euryarchaeota|c__Euryarchaeota class incertae sedis|o__Euryarchaeota order incertae sedis|f__Euryarchaeota fam. incertae sedis|g__Euryarchaeota gen. incertae sedis|s__uncultured Candidatus Thalassoarchaea euryarchaeote	12


- ``RNA-counts`` **file**

A file with the number of the LSU and SSU counts on the sample:

.. code-block:: bash 

    LSU count	709
    SSU count	475


- ``*.merged_LSU.fasta.mseq.gz`` and ``*.merged_SSU.fasta.mseq.gz`` **files** 

Compressed files with rRNA sequences used for taxonomic identification along with their hits and scores.
The decompressed files consist of 13 columns with the taxonomy assignment in the last one. 

.. code-block:: bash

    #query	dbhit	bitscore	identity	matches	mismatches	gaps	query_start	query_end	dbhit_start	dbhit_end	strand		SILVA	
    V1:1:HWLTKDRXY:1:2276:10818:25551-1-merged-143-11-LSU_rRNA_eukarya/q53-152	GEAN01107426.394.3747	98	0.9900000095367432	99	1	0	0	100	2246	2346	+		sk__Eukaryota;k__Metazoa;p__Arthropoda;c__Hexanauplia;o__Calanoida;f__Temoridae;g__Eurytemora;s__Eurytemora_affinis	
    V1:1:HWLTKDRXY:1:2247:17598:35540-1-merged-151-107-LSU_rRNA_bacteria/q1-253	CP000828.5638205.5641084	163	0.8589743375778198	201	32	1	0	233	26	260	+		sk__Bacteria;k__;p__Cyanobacteria;c__;o__Synechococcales	



- ``*.merged_LSU.fasta.mseq.tsv`` and ``*.merged_SSU.fasta.mseq.tsv`` **files**

Abundance tables consisting of 4 columns mentioning the OTU id and the taxonomic assignment of each. 
In addition, the NCBI Taxonomy Id of each assignment is mentioned in the last column. 


.. code-block:: bash

    # Constructed from biom file
    # OTU ID	LSU_rRNA	taxonomy	taxid
    1039	4.0	sk__Archaea;k__;p__Euryarchaeota;c__Thermoplasmata	183967
    3616	46.0	sk__Bacteria	2
    30206	2.0	sk__Bacteria;k__;p__Bacteroidetes;c__Bacteroidia	200643
    12319	1.0	sk__Bacteria;k__;p__Bacteroidetes;c__Bacteroidia;o__Marinilabiliales;f__Marinifilaceae	1573805


- ``*.merged_LSU.fasta.mseq.txt`` and ``*.merged_SSU.fasta.mseq.txt`` **files**

Like the ``*.fasta.mseq.tsv`` files but without the head columns and keeping only the abundance and the taxonomy columns, splitting 
the latter to its taxonomic levels. 


.. code-block:: bash 

    4	sk__Archaea	k__	p__Euryarchaeota	c__Thermoplasmata
    46	sk__Bacteria
    2	sk__Bacteria	k__	p__Bacteroidetes	c__Bacteroidia
    1	sk__Bacteria	k__	p__Bacteroidetes	c__Bacteroidia	o__Marinilabiliales	f__Marinifilaceae

These files are used as input to build the Krona plots. 


- ``*.fasta.mseq_json.biom`` **files** 

The output of the MAPseq classification as json in a biom format 



- ``*.fasta.mseq_json.biom`` **files** 

The biom format is based on HDF5 to provide the overall structure for the format. 
`HDF5 <https://www.hdfgroup.org>`_ is a widely supported binary format with native parsers available within many programming languages.




- ``krona.html`` **files**


A hierarchical visual component of the taxonomic profile based on the LSU and the SSU accordingly. 


.. image:: ../images/krona.png
   :width: 850


In this `video <https://www.youtube.com/watch?v=nzBiE5TEK9Y>`_  you may watch a thorough description on how to navigate a Krona plot.


- **Files** under the ``sequence-categorisation`` folder

A list of compressed .fasta files  (:ref:`usage/sequence-categorisation`) of the same notion is returned under the `sequence-categorisation` folder. 
Each file consists of the filtered and merged reads of the sample that are related to a specific `RNA family <https://rfam.org>`_.

For example, the ``tmRNA.RF00023.fasta.gz`` includes reads that are related to the  
transfer-messenger RNA (`RF00023 <https://rfam.org/family/RF00023>`_).





Gene prediction step 
--------------------

- ``*.merged_CDS.ffn`` **file**

Nucleotide coding sequences in a .fasta format,
that correspond to coding genes as returned by `FragGeneScan <https://pubmed.ncbi.nlm.nih.gov/20805240/>`_.

.. code-block:: bash

    >SRR1620013.54-C038EACXX:5:1101:02684:02629-1-merged-101-1_3_101_-
    GACAAGATCGACCGCATCATCGAGTTGTGCATCGCGCTGGAAGCGGACTTTGTTGAGCTCGCGACGTGCCAGTTCTACGGCTGGGCGCAGCTCAATCGT


- ``*.merged_CDS.faa`` **file**

Aminoacid coding sequences that correspond to the coding genes in the ``*.merged_CDS.ffn`` file.


.. code-block:: bash

    >SRR1620013.54-C038EACXX:5:1101:02684:02629-1-merged-101-1_3_101_-
    DKIDRIIELCIALEADFVELATCQFYGWAQLNR



Functional annotation step 
--------------------------



- ``*.merged_CDS.I5.tsv.gz`` **file**

Main output of the InterPro annotation. 
A compressed tab separated file consisting of 15 columns. 
The ``protein_accession`` is the id with which the protein can be found in the samples' reads. 
In the ``analysis`` column, it is mentioned which of the InterProScan analysis the entry is referring to
(i.e., Pfam, TIGRFAM, PrositePatterns, ProSiteProfiles).
In the ``go`` column, the corresponding Gene Ontology term is mentioned, 
while in the last column ("``pathways_annotations``") annotations linked to the original, from resources such as MetaCYC, Reactome etc are mentioned.

.. code-block:: bash

    protein_accession	sequence_md5_digest	sequence_length	analysis	signature_accession	signature_description	start_location	stop_location	score	status	date	accession	description	go	pathways_annotations
    SRR1620013.24594-C038EACXX:5:1101:20780:152561-1-merged-101-9_1_108_-	e9cde5b71a9a05b6f5140c51a445a8f4	36	Pfam	PF00742	Homoserine dehydrogenase	3	36	3.3E-10	T	28-04-2023IPR001342	Homoserine dehydrogenase, catalytic	GO:0006520	MetaCyc: PWY-2941|MetaCyc: PWY-2942|MetaCyc: PWY-5097|MetaCyc: PWY-6160|MetaCyc: PWY-6559|MetaCyc: PWY-6562|MetaCyc: PWY-7153|MetaCyc: PWY-7977



- ``*.merged.hmm.tsv.gz`` **file**

Similarly to the ``*.merged_CDS.I5.tsv.gz`` file, this is the main output file of the HMMER annotation. 
When decompressed, this tab separated files includes the HMM hits of the samples filtered reads to KEGG ORTHOLOGY terms
along with their scores. 


.. code-block:: bash
    query_name	query_accession	tlen	target_name	target_accession	qlen	full_sequence_e-value	full_sequence_score	full_sequence_bias	#	of	c-evalue	i-evalue	domain_score	domain_bias	hmm_coord_from	hmm_coord_to	ali_coord_from	ali_coord_to	env_coord_from	env_coord_to	acc	description_of_target
    SRR1620013.78392-C038EACXX:5:1103:10865:63862-1-merged-101-2_2_100_-	-	33	K00426	-	447	1.2e-09	36.2	0.1	1	1	1.6e-13	1.2e-09	36.1	0.1	136	168	1	33133	0.97	-




- The ``*.merged.summary.*`` **files**

Based on the ``*.merged.hmm.tsv`` and the ``*.merged_CDS.I5.tsv`` files, a list of summary files are returned 
including resource-specific information. 
All of them are 3 column tab separated files, including the annotation id, its description and the number of hits in the samples' reads.

For example, the first lines of a ``*.merged.summary.pfam`` would be:

.. code-block:: bash
    
    "26","PF00005","ABC transporter"
    "11","PF00012","Hsp70 protein"
    "8","PF00133","tRNA synthetases class I (I, L, M and V)"
    "7","PF00361","Proton-conducting membrane transporter"

where in the first column is the number of hits, in the second the Pfam id and in the third one its description.

The ``*.merged.summary.go_slim``, ``*.merged.summary.ips``, ``*.merged.summary.ko`` and ``*.merged.emapper.summary.eggnog``
have the same notion.


- **Files** under the ``stats`` subfolder in the ``functional-annotation`` folder

A list of text files including statistics about the number of matches with each annotation resource. 
For example, 

.. code-block:: bash 

    user@server:~/my_analysis/results/functional-annotation/stats/$ cat ko.stats
    Total KO matches	75
    Predicted CDS with KO match	75
    Reads with KO match	75


Assembly step 
-------------

- ``final.contigs.fa`` **file**

A .fasta file where each entry is a contig as returned from `MEGAHIT <https://doi.org/10.1093/bioinformatics/btv033>`_.


Output example
--------------

You may find the data products of complete runs of ``metaGOflow`` as example outputs,
in our `Zenodo repo <https://zenodo.org/record/8046421>`_.

Further, on this `GitHub pages <https://data.emobon.embrc.eu/MetaGOflow/>`_  you may find
visual components accompanying the metaGOflow publication. 
We performed all steps of metaGOflow for an EMO BON marine sediment (ERS14961254) and a water column (ERS14961281) sample. 
A quality control report, the taxonomic inventories as well as some of the functional annotations returned in each case are displayed there.












