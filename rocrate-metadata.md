# An example of a RO-Crate metadata `.json` file


Here is the `ro-crate-metada.json` file that describes the RO-Crate built for the TARA OCEAN sample ([ERR599171](https://www.ebi.ac.uk/ena/browser/view/ERR599171)) that was analysed as part of the metaGOflow manuscript. 


```python

{
    "@context": "https://w3id.org/ro/crate/1.1/context",
    "@graph": [
        {
            "@id": "ro-crate-metadata.json",
            "@type": "CreativeWork",
            "about": {
                "@id": "./"
            },
            "conformsTo": {
                "@id": "https://w3id.org/ro/crate/1.1"
            }
        },
        {
            "@id": "./",
            "@type": "Dataset",
            "datePublished": "2023-05-10T09:59:46+00:00",
            "hasPart": [
                {
                    "@id": "results/"
                },
                {
                    "@id": "ERR599171.yml"
                },
                {
                    "@id": "config.yml"
                },
                {
                    "@id": "results/sequence-categorisation/"
                },
                {
                    "@id": "results/taxonomy-summary/"
                },
                {
                    "@id": "results/functional-annotation/"
                },
                {
                    "@id": "results/final.contigs.fa"
                },
                {
                    "@id": "results/fastp.html"
                },
                {
                    "@id": "results/ERR599171_1.fastq.trimmed.fasta"
                },
                {
                    "@id": "results/ERR599171_2.fastq.trimmed.fasta"
                },
                {
                    "@id": "results/ERR599171.merged.fasta"
                },
                {
                    "@id": "results/ERR599171.merged.qc_summary"
                },
                {
                    "@id": "results/ERR599171.merged.motus.tsv"
                },
                {
                    "@id": "results/ERR599171.merged.unfiltered_fasta"
                },
                {
                    "@id": "results/ERR599171.merged.cmsearch.all.tblout.deoverlapped"
                },
                {
                    "@id": "results/ERR599171.merged_CDS.faa"
                },
                {
                    "@id": "results/ERR599171.merged_CDS.ffn"
                },
                {
                    "@id": "results/ERR599171_1.fastq.trimmed.qc_summary"
                },
                {
                    "@id": "results/ERR599171_2.fastq.trimmed.qc_summary"
                },
                {
                    "@id": "results/RNA-counts"
                },
                {
                    "@id": "results/sequence-categorisation/5_8S.fa.gz"
                },
                {
                    "@id": "results/sequence-categorisation/LSU_rRNA_archaea.RF02540.fa.gz"
                },
                {
                    "@id": "results/sequence-categorisation/LSU_rRNA_bacteria.RF02541.fa.gz"
                },
                {
                    "@id": "results/sequence-categorisation/LSU_rRNA_eukarya.RF02543.fa.gz"
                },
                {
                    "@id": "results/sequence-categorisation/SSU_rRNA_archaea.RF01959.fa.gz"
                },
                {
                    "@id": "results/sequence-categorisation/SSU_rRNA_bacteria.RF00177.fa.gz"
                },
                {
                    "@id": "results/sequence-categorisation/SSU_rRNA_eukarya.RF01960.fa.gz"
                },
                {
                    "@id": "results/sequence-categorisation/Bacteria_large_SRP.RF01854.fasta.gz"
                },
                {
                    "@id": "results/sequence-categorisation/Bacteria_small_SRP.RF00169.fasta.gz"
                },
                {
                    "@id": "results/sequence-categorisation/RNaseP_bact_a.RF00010.fasta.gz"
                },
                {
                    "@id": "results/sequence-categorisation/alpha_tmRNA.RF01849.fasta.gz"
                },
                {
                    "@id": "results/sequence-categorisation/cyano_tmRNA.RF01851.fasta.gz"
                },
                {
                    "@id": "results/sequence-categorisation/tRNA-Sec.RF01852.fasta.gz"
                },
                {
                    "@id": "results/sequence-categorisation/tRNA.RF00005.fasta.gz"
                },
                {
                    "@id": "results/sequence-categorisation/tmRNA.RF00023.fasta.gz"
                },
                {
                    "@id": "results/taxonomy-summary/SSU/"
                },
                {
                    "@id": "results/taxonomy-summary/LSU/"
                },
                {
                    "@id": "results/taxonomy-summary/SSU/ERR599171.merged_SSU.fasta.mseq.gz"
                },
                {
                    "@id": "results/taxonomy-summary/SSU/ERR599171.merged_SSU.fasta.mseq.tsv"
                },
                {
                    "@id": "results/taxonomy-summary/SSU/ERR599171.merged_SSU.fasta.mseq.txt"
                },
                {
                    "@id": "results/taxonomy-summary/SSU/krona.html"
                },
                {
                    "@id": "results/taxonomy-summary/SSU/ERR599171.merged_SSU.fasta.mseq_hdf5.biom"
                },
                {
                    "@id": "results/taxonomy-summary/SSU/ERR599171.merged_SSU.fasta.mseq_json.biom"
                },
                {
                    "@id": "results/taxonomy-summary/LSU/ERR599171.merged_LSU.fasta.mseq.gz"
                },
                {
                    "@id": "results/taxonomy-summary/LSU/ERR599171.merged_LSU.fasta.mseq.tsv"
                },
                {
                    "@id": "results/taxonomy-summary/LSU/ERR599171.merged_LSU.fasta.mseq.txt"
                },
                {
                    "@id": "results/taxonomy-summary/LSU/krona.html"
                },
                {
                    "@id": "results/taxonomy-summary/LSU/ERR599171.merged_LSU.fasta.mseq_hdf5.biom"
                },
                {
                    "@id": "results/taxonomy-summary/LSU/ERR599171.merged_LSU.fasta.mseq_json.biom"
                },
                {
                    "@id": "results/functional-annotation/stats/"
                },
                {
                    "@id": "results/functional-annotation/ERR599171.merged.summary.ips"
                },
                {
                    "@id": "results/functional-annotation/ERR599171.merged.summary.ko"
                },
                {
                    "@id": "results/functional-annotation/ERR599171.merged.summary.pfam"
                },
                {
                    "@id": "results/functional-annotation/ERR599171.merged.summary.go"
                },
                {
                    "@id": "results/functional-annotation/ERR599171.merged.summary.go_slim"
                },
                {
                    "@id": "results/functional-annotation/ERR599171.merged.hmm.tsv.gz"
                },
                {
                    "@id": "results/functional-annotation/ERR599171.merged_CDS.I5.tsv.gz"
                },
                {
                    "@id": "results/functional-annotation/ERR599171.merged.hmm.tsv.chunks"
                },
                {
                    "@id": "results/functional-annotation/ERR599171.merged_CDS.I5.tsv.chunks"
                },
                {
                    "@id": "results/functional-annotation/stats/interproscan.stats"
                },
                {
                    "@id": "results/functional-annotation/stats/go.stats"
                },
                {
                    "@id": "results/functional-annotation/stats/ko.stats"
                },
                {
                    "@id": "results/functional-annotation/stats/pfam.stats"
                },
                {
                    "@id": "results/functional-annotation/stats/orf.stats"
                }
            ],
            "name": "MetaGoFlow Results",
            "publisher": {
                "@id": "https://ror.org/0038zss60"
            }
        },
        {
            "@id": "results/",
            "@type": "Dataset"
        },
        {
            "@id": "ERR599171.yml",
            "@type": "File"
        },
        {
            "@id": "config.yml",
            "@type": "File",
            "description": "The configuration file through which the user sets the values of the metaGOflow parameters.",
            "encodingFormat": "text/yaml",
            "name": "MetaGOflow configuration file"
        },
        {
            "@id": "results/sequence-categorisation/",
            "@type": "Dataset",
            "description": "Identify specific loci in the sample.",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/taxonomy-summary/",
            "@type": "Dataset"
        },
        {
            "@id": "results/functional-annotation/",
            "@type": "Dataset"
        },
        {
            "@id": "results/final.contigs.fa",
            "@type": "File",
            "description": "These are the assembled contig sequences from the merged reads in FASTA format",
            "encodingFormat": "text/plain",
            "name": "FASTA formatted contig sequences"
        },
        {
            "@id": "results/fastp.html",
            "@type": "File",
            "description": "Quality control and preprocessing of FASTQ files",
            "encodingFormat": "text/html",
            "name": "FASTP analysis of raw sequence data"
        },
        {
            "@id": "results/ERR599171_1.fastq.trimmed.fasta",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Filtered .fastq file of the single-end reads (forward/reverse)."
        },
        {
            "@id": "results/ERR599171_2.fastq.trimmed.fasta",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Filtered .fastq file of the single-end reads (forward/reverse)."
        },
        {
            "@id": "results/ERR599171.merged.fasta",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Merged filtered reads."
        },
        {
            "@id": "results/ERR599171.merged.qc_summary",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Summary with statistics of the merged reads."
        },
        {
            "@id": "results/ERR599171.merged.motus.tsv",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": ""
        },
        {
            "@id": "results/ERR599171.merged.unfiltered_fasta",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": ""
        },
        {
            "@id": "results/ERR599171.merged.cmsearch.all.tblout.deoverlapped",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Sequence hits against covariance model databases. Mandatory to run partially the functional annotation step of metaGOflow."
        },
        {
            "@id": "results/ERR599171.merged_CDS.faa",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Coding sequences with amino acids."
        },
        {
            "@id": "results/ERR599171.merged_CDS.ffn",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Coding sequences with nucleotides."
        },
        {
            "@id": "results/ERR599171_1.fastq.trimmed.qc_summary",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Summary with statistics of the single-end reads (forward/reverse)."
        },
        {
            "@id": "results/ERR599171_2.fastq.trimmed.qc_summary",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Summary with statistics of the single-end reads (forward/reverse)."
        },
        {
            "@id": "results/RNA-counts",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Numbers of RNA's counted"
        },
        {
            "@id": "results/sequence-categorisation/5_8S.fa.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/LSU_rRNA_archaea.RF02540.fa.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/LSU_rRNA_bacteria.RF02541.fa.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/LSU_rRNA_eukarya.RF02543.fa.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/SSU_rRNA_archaea.RF01959.fa.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/SSU_rRNA_bacteria.RF00177.fa.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/SSU_rRNA_eukarya.RF01960.fa.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/Bacteria_large_SRP.RF01854.fasta.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/Bacteria_small_SRP.RF00169.fasta.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/RNaseP_bact_a.RF00010.fasta.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/alpha_tmRNA.RF01849.fasta.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/cyano_tmRNA.RF01851.fasta.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/tRNA-Sec.RF01852.fasta.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/tRNA.RF00005.fasta.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/sequence-categorisation/tmRNA.RF00023.fasta.gz",
            "@type": "File",
            "description": "Identify specific loci in the sample.",
            "encodingFormat": "application/zip",
            "name": "Sequence categorisation"
        },
        {
            "@id": "results/taxonomy-summary/SSU/",
            "@type": "Dataset"
        },
        {
            "@id": "results/taxonomy-summary/LSU/",
            "@type": "Dataset"
        },
        {
            "@id": "results/taxonomy-summary/SSU/ERR599171.merged_SSU.fasta.mseq.gz",
            "@type": "File",
            "encodingFormat": "application/zip",
            "name": "LSU sequences used for indentification"
        },
        {
            "@id": "results/taxonomy-summary/SSU/ERR599171.merged_SSU.fasta.mseq.tsv",
            "@type": "File",
            "encodingFormat": "application/json-ld",
            "name": "Tab-separated formatted taxon counts for SSU sequences"
        },
        {
            "@id": "results/taxonomy-summary/SSU/ERR599171.merged_SSU.fasta.mseq.txt",
            "@type": "File",
            "encodingFormat": "application/json-ld",
            "name": "Text-based formatted taxon counts for SSU sequences"
        },
        {
            "@id": "results/taxonomy-summary/SSU/krona.html",
            "@type": "File",
            "encodingFormat": "application/html",
            "name": "Krona summary of LSU taxonomic inventory"
        },
        {
            "@id": "results/taxonomy-summary/SSU/ERR599171.merged_SSU.fasta.mseq_hdf5.biom",
            "@type": "File",
            "encodingFormat": "application/json-ld",
            "name": "BIOM formatted hdf5 taxon counts for SSU sequences"
        },
        {
            "@id": "results/taxonomy-summary/SSU/ERR599171.merged_SSU.fasta.mseq_json.biom",
            "@type": "File",
            "encodingFormat": "application/json-ld",
            "name": "BIOM formatted taxon counts for SSU sequences"
        },
        {
            "@id": "results/taxonomy-summary/LSU/ERR599171.merged_LSU.fasta.mseq.gz",
            "@type": "File",
            "encodingFormat": "application/zip",
            "name": "LSU sequences used for indentification"
        },
        {
            "@id": "results/taxonomy-summary/LSU/ERR599171.merged_LSU.fasta.mseq.tsv",
            "@type": "File",
            "encodingFormat": "application/json-ld",
            "name": "Tab-separated formatted taxon counts for LSU sequences"
        },
        {
            "@id": "results/taxonomy-summary/LSU/ERR599171.merged_LSU.fasta.mseq.txt",
            "@type": "File",
            "encodingFormat": "application/json-ld",
            "name": "Text-based taxon counts for LSU sequences"
        },
        {
            "@id": "results/taxonomy-summary/LSU/krona.html",
            "@type": "File",
            "encodingFormat": "application/html",
            "name": "Krona summary of LSU taxonomic inventory"
        },
        {
            "@id": "results/taxonomy-summary/LSU/ERR599171.merged_LSU.fasta.mseq_hdf5.biom",
            "@type": "File",
            "encodingFormat": "application/json-ld",
            "name": "BIOM formatted hdf5 taxon counts for LSU sequences"
        },
        {
            "@id": "results/taxonomy-summary/LSU/ERR599171.merged_LSU.fasta.mseq_json.biom",
            "@type": "File",
            "encodingFormat": "application/json-ld",
            "name": "BIOM formatted taxon counts for LSU sequences"
        },
        {
            "@id": "results/functional-annotation/stats/",
            "@type": "Dataset"
        },
        {
            "@id": "results/functional-annotation/ERR599171.merged.summary.ips",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Merged contigs InterProScan"
        },
        {
            "@id": "results/functional-annotation/ERR599171.merged.summary.ko",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Merged contigs KO summary"
        },
        {
            "@id": "results/functional-annotation/ERR599171.merged.summary.pfam",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Merged contigs PFAM summary"
        },
        {
            "@id": "results/functional-annotation/ERR599171.merged.summary.go",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Merged contigs GO summary"
        },
        {
            "@id": "results/functional-annotation/ERR599171.merged.summary.go_slim",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Merged contigs GO summary"
        },
        {
            "@id": "results/functional-annotation/ERR599171.merged.hmm.tsv.gz",
            "@type": "File",
            "encodingFormat": "application/zip",
            "name": "Merged contigs HMM summary"
        },
        {
            "@id": "results/functional-annotation/ERR599171.merged_CDS.I5.tsv.gz",
            "@type": "File",
            "encodingFormat": "application/zip",
            "name": "Merged contigs CDS I5 summary"
        },
        {
            "@id": "results/functional-annotation/ERR599171.merged.hmm.tsv.chunks",
            "@type": "File"
        },
        {
            "@id": "results/functional-annotation/ERR599171.merged_CDS.I5.tsv.chunks",
            "@type": "File"
        },
        {
            "@id": "results/functional-annotation/stats/interproscan.stats",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "InterProScan summary statistics"
        },
        {
            "@id": "results/functional-annotation/stats/go.stats",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Geno Ontology summary statistics"
        },
        {
            "@id": "results/functional-annotation/stats/ko.stats",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Kegg Ontology summary statistics"
        },
        {
            "@id": "results/functional-annotation/stats/pfam.stats",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "Pfam summary statistcs"
        },
        {
            "@id": "results/functional-annotation/stats/orf.stats",
            "@type": "File",
            "encodingFormat": "text/plain",
            "name": "ORF summary statistics"
        },
        {
            "@id": "https://www.apache.org/licenses/LICENSE-2.0",
            "@type": "CreativeWork",
            "identifier": "https://spdx.org/licenses/Apache-2.0.html",
            "name": "Apache License 2.0"
        },
        {
            "@id": "https://creativecommons.org/licenses/by/4.0/legalcode",
            "@type": "CreativeWork",
            "identifier": "https://spdx.org/licenses/CC-BY-4.0.html",
            "name": "Creative Commons (CC-BY 4.0)"
        },
        {
            "@id": "mailto:emobon@embrc.eu",
            "@type": "ContactPoint",
            "contactType": "Help Desk",
            "email": "emobon@embrc.eu",
            "identifier": "emobon@embrc.eu",
            "url": "https://www.embrc.eu/about-us/contact-us"
        },
        {
            "@id": "https://ror.org/0038zss60",
            "@type": "Organization",
            "contactPoint": {
                "@id": "mailto:emobon@embrc.eu"
            },
            "name": "European Marine Biological Resource Centre",
            "url": "https://ror.org/0038zss60"
        },
        {
            "@id": "#workflow/metaGOflow",
            "@type": [
                "File",
                "SoftwareSourceCode",
                "ComputationalWorkflow"
            ],
            "affiliation": "University of Flatland",
            "author": {
                "@id": "EMO BON"
            },
            "hasPart": [
                {
                    "@id": "config.yml"
                },
                {
                    "@id": "TARA_OCEANS_SAMPLE_3steps/ERR599171.yml"
                }
            ],
            "license": {
                "@id": "https://www.apache.org/licenses/LICENSE-2.0"
            },
            "name": "metaGOflow",
            "url": "https://github.com/emo-bon/MetaGOflow/releases/tag/v1.0.0"
        }
    ]
}
```
