.data
.globl	_ZNK6MatrixmlERKS_
.type	_ZNK6MatrixmlERKS_, @function

.text
_ZNK6MatrixmlERKS_:
pushl %ebp
movl  %esp, %ebp
pushl %ebx


#matrices 1 et 2 a multiplier
    movl 12(%ebp), %eax    #matrice 1 dans eax
    movl 16(%ebp), %ebx    #matrice 2 dans ebx


#verifier que les dimensions des matrices sont compatibles pour multiplication
    movl 8(%eax), %ecx     #nb colonnes matrice 1 dans ecx
    movl 4(%ebx), %edx     #nb lignes matrice 2 dans edx

    cmpl %ecx, %edx          #verification (m x n)(n x a)
    jne notMultiplicatable  # si pas n=n, peut pas multiplier

    movl 4(%eax), %ecx     #nb lignes matrice resultante
    movl 8(%ebx), %edx     #nb colonnes matrice resultante


#creation objet matrice resultante
    pushl 8(%eax)               #nb colonnes
    pushl 4(%eax)               #nb lignes
    pushl 8(%ebp)               # x86-32 convention as passing the argument of newMatrix as first parameter
    call _ZNK6MatrixmlEf        # call constructeur pour construire la matrice
    addl $12, %esp


#initialiser le nouveau objet matrice resultante
    movl 8(%ebp), %ebx          # ebx = pointeur de l'objet
    movl 12(%ebx), %edx         # elements
    pushl %edx                  # nb colonnes
    pushl  %ecx                 # nb lignes 



#debut du loop de multiplication
loop_i:
    movl $0, %esi               # Initialisation de l'indice i à 0
    movl %ebx, %edi             # Chargement de l'adresse de la matrice résultante dans edi

loop_j:
    movl $0, %edx               # Initialisation du résultat temporaire à 0
    movl $0, %eax               # Initialisation de l'indice j à 0
    
    # Calcul de la valeur du nouvel élément de la matrice résultante
    movl %esi, %ecx             # Chargement de l'indice i dans ecx
    imull %edx, %ecx            # Multiplication scalaire par le résultat temporaire
    addl %eax, %ecx             # Ajout de l'indice j
    pushl %ecx                  # Sauvegarde de l'indice calculé pour findAddrElem
    pushl %edx                  # Sauvegarde du résultat temporaire pour findAddrElem
    pushl %esi                  # Sauvegarde de l'indice i pour findAddrElem
    pushl %eax                  # Sauvegarde de l'indice j pour findAddrElem
    pushl %ebx                  # Chargement de l'adresse de la matrice 1 pour findAddrElem
    call findAddrElem           # Appel de findAddrElem pour obtenir l'adresse de l'élément correspondant de la matrice 1
    addl $20, %esp              # Nettoyage de la pile après l'appel de fonction
    movl (%eax), %ecx           # Chargement de la valeur de l'élément de la matrice 1
    popl %eax                   # Restauration de l'indice j
    popl %esi                   # Restauration de l'indice i
    popl %edx                   # Restauration du résultat temporaire
    imull (%esp), %ecx          # Multiplication scalaire avec l'élément de la matrice 1
    addl %ecx, %edx             # Addition du résultat à la somme temporaire
    addl $4, %esp               # Nettoyage de la pile après le calcul

    # Boucle sur les colonnes de la matrice 1
    addl $4, %eax               # Incrémentation de l'indice j
    cmpl 12(%ebx), %eax         # Comparaison avec le nombre de colonnes de la matrice 1
    jl loop_j                   # Si j < nombre de colonnes, continuer la boucle

    # Stockage du résultat temporaire dans la matrice résultante
    pushl %edx                  # Sauvegarde du résultat temporaire
    pushl %esi                  # Sauvegarde de l'indice i
    pushl %ebx                  # Chargement de l'adresse de la matrice résultante pour findAddrElem
    call findAddrElem           # Appel de findAddrElem pour obtenir l'adresse de l'élément correspondant de la matrice résultante
    addl $12, %esp              # Nettoyage de la pile après l'appel de fonction
    movl %edx, (%eax)           # Stockage du résultat temporaire dans la matrice résultante

    # Incrémentation de l'indice i
    addl $1, %esi               # Incrémentation de l'indice i
    cmpl 8(%ebx), %esi          # Comparaison avec le nombre de lignes de la matrice résultante
    jl loop_i                   # Si i < nombre de lignes, continuer la boucle


notMultiplicatable:
    pushl %edx
    call notMultiplicatableError

end:
    popl %ebx                   # Restauration du registre ebx
    leave                       # Nettoyage de la pile
    ret                         # Retour de la fonction





