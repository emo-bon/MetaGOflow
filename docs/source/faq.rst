
.. _faq:


Frequently asked questions (FAQs)
----------------------------


Can I use ``metaGOflow`` with host-associated data?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In case of host-associated data, the user would probably want to remove the host sequences before running ``metaGOflow``. 
If not, then (as expected) the host will be present in the taxonomic inventory outputs. 


Does my choice of sequencing platform affect the ``metaGOflow`` performance?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes and no. You can use ``metaGOflow`` using any type of adapters or set up. 
However, you need to consider these settings when filling in the ``config.yml`` file
especially for the filtering related parameters. 


What is an RO-Crate and how it benefits?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An RO-Crate (Research Object Crate) is a specification and community-driven standard for packaging and exchanging research data 
and its associated metadata. 
It is designed to provide a consistent way of describing and packaging research data and all its dependencies, 
making it easier to share and reproduce scientific experiments and analyses.

In the framework of ``metaGOflow``, an  RO-Crate is created automatically to store the data products along with the associated metadata 
(including the user set parameters, the version and the source of the workflow used).




Docker or Singularity?
~~~~~~~~~~~~~~~~~~~~~~

metaGOflow supports both Docker (default) and Singularity container technologies. 
By default, metaGOflow will use Docker; therefore, in this case Docker is a dependency for the workflow to run. 
However, in most HPC systems Singularity is preferred.

.. hint:: In case you are using Docker, it is strongly recommended to avoid installing it through `snap`.


What can I do with the ``metaGOflow`` data products?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Based on the questions one needs to address, there are several types of downstream analysis one might run using 
``metaGOflow``'s data products. 

Here is a short, not comprehensive, list of resources that might be found useful: 

- `SHAMAN <https://shaman.pasteur.fr>`_ supports a bioinformatic workflow for metataxonomic analysis and a reliable statistical modelling based on `DESeq2 <https://doi.org/10.1186/s13059-014-0550-8>_` 
- `LEfSe <https://github.com/biobakery/biobakery/wiki/lefse>`_ aims at explaining differences between classes by coupling standard tests for statistical significance with additional tests encoding biological consistency and effect relevance
- `flashWeave <https://github.com/meringlab/FlashWeave.jl>`_ allows to build co-occurrence networks using an abundance table as input but also metadata describing the samples under study


