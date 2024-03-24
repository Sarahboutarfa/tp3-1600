.data
.globl	_ZNK6MatrixmlEf
.type	_ZNK6MatrixmlEf, @function


.text
_ZNK6MatrixmlEf:
pushl %ebp
movl  %esp, %ebp
pushl %ebx

#matrices 1 et 2 a additionner
    movl 12(%ebp), %eax    #matrice 1 dans eax
   

#dimension de la matrice a multiplier
    movl 8(%eax), %ebx           #nb colonnes
    movl 4(%eax), %edx           #nb lignes
   
    
#creation de la nouvelle matrice
    pushl %ebx                  #nb colonnes matrice resultante               
    pushl %edx                  #nb lignes
    pushl 8(%ebp)               #adresse de la matrice resultante
    call _ZNK6MatrixmlEf        # call constructeur pour construire la matrice
    addl $12, %esp


#initialiser le nouveau objet matrice resultante
    movl 8(%ebp), %ebx          # ebx = pointeur de l'objet
    movl 12(%ebx), %edx         # pointeur vers elements de la matrice resultante
    pushl 8(%eax)               # nb colonnes
    pushl 4(%eax)               # nb lignes 

    movl $0, %ecx               # Initialisation de l'indice i à 0


loop_i:
    movl $0, %edx               # Initialisation du résultat temporaire à 0
    movl $0, %eax               # Initialisation de l'indice j à 0

loop_j:
    pushl %eax                  # Sauvegarder l'indice j
    pushl %ecx                  # Sauvegarder l'indice i
    pushl %ebx                  # Adresse de la matrice résultante
    call findAddrElem           # Appel de findAddrElem pour obtenir l'adresse de l'élément correspondant
    addl $12, %esp              # Nettoyer la pile après l'appel de fonction
    movl (%eax), %eax           # Charger l'élément correspondant de la matrice résultante dans eax

    fmull 16(%ebp)              # Multiplier l'élément de la matrice 1 par le scalaire (passé en argument)
    
    
    # Ajouter le résultat à la somme temporaire dans st(0)
    flds (%esp)                 # Charger le résultat temporaire dans la pile en virgule flottante (st(0))
    addl $4, %esp               # Nettoyer la pile après le chargement
    fadd                        # Ajouter le résultat temporaire (st(0)) à la somme en virgule flottante (st(1))


    popl %ecx                   # Récupérer l'indice i
    incl %eax                   # Incrémenter l'indice j
    cmpl 12(%ebx), %eax         # Comparer avec le nombre de colonnes
    jne loop_j                  # Boucler si j < nombre de colonnes

    pushl %edx                  # Sauvegarder le résultat temporaire
    pushl %ecx                  # Sauvegarder l'indice i
    pushl %ebx                  # Adresse de la matrice résultante
    call findAddrElem           # Appel de findAddrElem pour obtenir l'adresse de l'élément correspondant
    addl $12, %esp              # Nettoyer la pile après l'appel de fonction
    fstpl (%eax)                # Stocker le résultat temporaire dans la matrice résultante

    incl %ecx                   # Incrémenter l'indice i
    cmpl 8(%ebx), %ecx          # Comparer avec le nombre de lignes
    jne loop_i                  # Boucler si i < nombre de lignes



end:
    popl %ebx                   # Restauration du registre ebx
    leave                       # Nettoyage de la pile
    ret                         # Retour de la fonction
