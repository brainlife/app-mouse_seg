#!/bin/bash
#PBS -l nodes=1:ppn=2,walltime=4:00:00
#PBS -N app-mouse_seg

for prm in id anat orient do_n4 do_hist_match reg_type; do
    val=$(jq -r ".$prm" config.json)
    eval "$prm=$val"
done

mkdir -p input
cp $anat input/
anat=$(basename $anat)
mkdir -p output

#sudo docker run -v $(pwd)/input:/root/input -v $(pwd)/output:/root/output \
#    -i -rm -t mouse_seg /bin/bash /usr/local/scripts/run_mouse_pipeline.sh \
#    -s $id -n $do_n4 -a $anat -r $reg_type  \
#    -h $do_hist_match ${orient:+-i $orient} \
#    -o /root/output -c /root/input

singularity exec \
    -B $(pwd)/input:/root/input -B $(pwd)/output:/root/output \
    docker://katealpert/mouse_seg \
    /bin/bash /usr/local/scripts/run_mouse_pipeline.sh \
    -s $id -n $do_n4 -a $anat -r $reg_type  \
    -h $do_hist_match ${orient:+-i $orient} \
    -o /root/output -c /root/input

exit $?
