gmx_mpi pdb2gmx -f JN.1_RBD.pdb -ignh -o jn1_pdb2gmx.pdb << EOF
1
1
EOF

pmx gmxlib
source ~/.bashrc
pmx mutate -f jn1_pdb2gmx.pdb -o mutant.pdb
gmx_mpi pdb2gmx -f mutant.pdb -o conf.pdb -p topol.top << EOF
6
1
EOF
pmx gentop -p topol.top -o newtop.top
gmx_mpi editconf -f conf.pdb -o conf_b.gro -bt dodec -d 1
gmx_mpi solvate -cp conf_b.gro -cs spc216.gro -o conf_s.gro -p newtop.top
gmx_mpi grompp -f ions.mdp -c conf_s.gro -r conf_s.gro -o ions.tpr -maxwarn 2 -p newtop.top
gmx_mpi genion -s ions.tpr -o conf_i.gro -p newtop.top -conc 0.15 -neutral << EOF
13
EOF

gmx_mpi make_ndx -f conf_i.gro -o index.ndx << EOF
q
EOF

gmx_mpi genrestr -f conf_i.gro -o rest_full_protein.itp -n index.ndx << EOF
1
EOF

#Add this in newtop.top
#ifdef POSRES_FULL
#include "rest_full_protein.itp"
#endif
