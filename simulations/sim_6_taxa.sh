ml ms
ml Seq-Gen
ml IQ-TREE
ml ASTER/1.16-GCC-11.3.0

ms 6 500 -T -I 6 1 1 1 1 1 1 \
-ej 1 2 1 -ej 1 4 3 -ej 2 5 1 -ej 3 3 1 -ej 4 6 1 \
-em 0.5 1 5 0.5 | \
tail -n +4 | grep -v // |  grep -v ^$ > gene_trees_6t.tre

mkdir trees
mkdir seqs
mkdir est_trees

COUNTER=1
while read LINE; do
  echo $LINE > trees/${COUNTER}.tre
  seq-gen -l 1000 -s 0.1 -m GTR trees/${COUNTER}.tre > seqs/seqs_${COUNTER}.phy
  # cd est_trees
  # iqtree2 -s ../seqs/seqs_${COUNTER}.phy -m MFP -B 1000 --prefix $COUNTER
  # cd ..
  COUNTER=$((COUNTER + 1))
done < gene_trees_6t.tre

cat est_trees/*treefile > merged_est.tre
cat trees/*tre > merged_sim.tre

astral -i merged_sim.tre -o astral.sim.tre --root 6
