#!/bin/sh

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

editfield=$DIR/editfield.pl
export GMX_MAXBACKUP=-1





echo "STEP 6.1 ------------------------------------------"
i=1
perl -w $editfield step6.${i}_equilibration.mdp > step6.${i}_equilibration.gromacs5.mdp <<EOF
cutoff-scheme = group
EOF
gmx grompp -f step6.1_equilibration.gromacs5.mdp -o step6.1_equilibration.tpr -c step5_assembly.box.pdb -p system.top -n index.ndx
gmx mdrun -deffnm step6.1_equilibration



for i in 2 3 4 5 6
do
    j=$((i-1))
    echo "step6.${i}_equilibration.mdp ----------------------------------------"
    # From http://md.chem.rug.nl/cgmartini/images/parameters/exampleMDP/martini_v2.x_new-rf.mdp
    perl -w $editfield step6.${i}_equilibration.mdp > step6.${i}_equilibration.gromacs5.mdp <<EOF
cutoff-scheme            = Verlet
coulombtype              = reaction-field
rcoulomb                 = 1.1
epsilon_r                = 15
epsilon_rf               = 0
vdw_type                 = cutoff  
vdw-modifier             = Potential-shift-verlet
rvdw                     = 1.1
verlet-buffer-tolerance  = 0.005
nstxout = 0
nstvout = 0
nstfout = 0
EOF
    gmx grompp -f step6.${i}_equilibration.gromacs5.mdp -o step6.${i}_equilibration.tpr -c step6.${j}_equilibration.gro -p system.top -n index.ndx
    gmx mdrun -deffnm step6.${i}_equilibration
done




echo "STEP 7 PRODUCTION ----------------------------------------"

perl -w $editfield step7_production.mdp > step7_production.gromacs5.mdp <<EOF
cutoff-scheme            = Verlet
coulombtype              = reaction-field
rcoulomb                 = 1.1
epsilon_r                = 15
epsilon_rf               = 0
vdw_type                 = cutoff  
vdw-modifier             = Potential-shift-verlet
rvdw                     = 1.1
verlet-buffer-tolerance  = 0.005
nstxout = 0
nstvout = 0
nstfout = 0
EOF
gmx grompp -f step7_production.gromacs5.mdp -o step7_production.tpr -c step6.6_equilibration.gro -p system.top -n index.ndx
gmx mdrun -deffnm step7_production


