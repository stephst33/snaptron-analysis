rule MoveFullJunctionCountTableToGitRepo:
    input:
        numers_merged = "leafcutter/clustering/{Samples_TargetJunctions}/Merged/leafcutter_perind.counts.numers.gz".format(Samples_TargetJunctions = Samples_TargetJunctions),
        denoms_merged = "leafcutter/clustering/{Samples_TargetJunctions}/Merged/leafcutter_perind.counts.denoms.gz".format(Samples_TargetJunctions = Samples_TargetJunctions),
    output:
        numers = Prefix + "CountTableNumerators.gz",
        denoms = Prefix + "CountTableDenominators.gz"
    shell:
        """
        cp {input.numers_merged} {output.numers}
        cp {input.denoms_merged} {output.denoms}
        """

rule MoveLeafcutterDsToGitRepo:
    input:
        EffectSize = "leafcutter/differential_splicing/{leafcutter_outprefix}_effect_sizes.txt".format(leafcutter_outprefix = leafcutter_ds_outprefix),
        ClusterSig = "leafcutter/differential_splicing/{leafcutter_outprefix}_cluster_significance.txt".format(leafcutter_outprefix = leafcutter_ds_outprefix),
    output:
        EffectSize = Prefix + "leafcutter.ds.effect_sizes.txt.gz",
        ClusterSig = Prefix + "leafcutter.ds.cluster_sig.txt.gz"
    shell:
        """
        cat {input.EffectSize} | gzip - > {output.EffectSize}
        cat {input.ClusterSig} | gzip - > {output.ClusterSig}
        """

rule MoveSnaptronSamplesInfoToGitRepo:
    input:
        juncfile = juncfiles,
        snaptron_metadata = lambda wildcards: snaptron_samples.loc[wildcards.snapdb, "local_metadata_file"]
    output:
        Prefix + "SnaptronMetadata.{snapdb}.txt.gz"
    shell:
        """
        awk -F'/' '{{ split($NF,a,"."); print a[1] }}' {input.juncfile} > temp.{wildcards.snapdb}.txt
        scripts/FilterSampleInfoByRailID.py {input.snaptron_metadata} temp.{wildcards.snapdb}.txt | gzip - > {output}
        rm temp.{wildcards.snapdb}.txt
        """

