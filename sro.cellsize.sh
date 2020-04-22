NAME='SrO.scf'

####################################################

for CELLDM in 5 10 15 20 25 30 35 40 
do
cat > $NAME.cell$CELLDM.in << EOF

&control
    calculation = 'scf'
    prefix = 'sro'
    outdir = './out/'
    pseudo_dir = "/home/bond/Software/qe-6.4.1/pseudo/SSSP_efficiency_pseudos/"
/
&system
    ibrav=1
    celldm(1) = $CELLDM 
    nat=2
    ntyp=2
    ecutwfc= 70
    ecutrho =  560
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
 O 0.126181913   0.000000000   0.000000000
 Sr 2.053818087   0.000000000   0.000000000

K_POINTS (gamma)

EOF

mpirun -np 4 ~/Software/qe-6.4.1/bin/pw.x < $NAME.cell$CELLDM.in > $NAME.celldm$CELLDM.out

done
