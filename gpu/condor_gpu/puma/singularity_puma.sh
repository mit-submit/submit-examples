echo "Start running."

# Needed to run singularity+docker from within condor/bosco
unset XDG_RUNTIME_DIR

# Prepare training config and clone PUMA code
curpath=$PWD
sed -i "s|XXX|$curpath|g" train.yaml 

# Getting ready for singularity
echo "About to enter the singularity container. This is the content of the current folder: "
pwd
ls -l
SINGULARITYENV_CUDA_VISIBLE_DEVICES=0,1,2,3 singularity exec --nv --bind /mnt/hadoop/cms/store/user/bmaier/:/mnt/hadoop/cms/store/user/bmaier/ --bind $PWD:$PWD docker://benediktmaier/puma:v230 /bin/sh $curpath/train_puma.sh 

echo "Done."
