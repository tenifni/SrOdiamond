#!/bin/sh
####################################################
# This is a sample script to run scf total-energy
# calculations on a unit cell of Si using three 
# different values for the input parameter 
# 'ecutwfc' (the plane-wave cutoff).
#
# Brandon Wood, 21-07-08
#
# You should copy this file and modify it as 
# appropriate for the tutorial.
####################################################
# Notes:
#
# 1. You can loop over a variable by using the 
#    'for...do...done' construction. As an example, 
#    this code loops over three different values
#    of ecut (5, 10, 15), designated by a
#    variable called CUTOFF.
# 2. Variables can be referred to within the script 
#    by typing the variable name preceded by the '$' 
#    sign. So whenever $CUTOFF appears in the 
#    script, it will be replaced by its current 
#    value.
#
####################################################
# Important initial variables for the code
# (change these as necessary)
####################################################

NAME='SrO.scf'

####################################################

for BOND in  1.6 1.8 3
do
cat > $NAME.bond$BOND.in << EOF

&control
    calculation = 'scf'
    prefix = 'sro'
    outdir = './out/'
    pseudo_dir = "/home/bond/Software/qe-6.4.1/pseudo/SSSP_efficiency_pseudos/"
/
&system
    ibrav=1
    celldm(1) = 20 
    nat=2
    ntyp=2,
    ecutwfc= 70
/
&electrons
    conv_thr=1e-8
/
&ions
    ion_dynamics='bfgs'
/
ATOMIC_SPECIES
 O      15.9994  O.pbe-n-kjpaw_psl.0.1.UPF
 Sr     87.62  Sr_pbe_v1.uspp.F.UPF

ATOMIC_POSITIONS (angstrom)
 O 0.00 0.00 0.00
 Sr $BOND 0.00 0.00

K_POINTS (gamma)
EOF

mpirun -np 8 ~/Software/qe-6.4.1/bin/pw.x < $NAME.bond$BOND.in > $NAME.bond$BOND.out

done

