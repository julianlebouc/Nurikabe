
=begin 

    La classe LectureGrille :::
        - permet de lire une grille depuis un fichier texte
        - permet de convertir cette grille du fichier texte en une grille jouable
        - permet de générer la grille contenant la bonne réponse

=end


class LectureGrille

    # Constantes de difficulté
    FACILE ||= 0
    NORMAL ||= 1
    DIFFICILE ||= 2

    def lireGrille(unIndex, uneDifficulte)
        compteur = 0
        chaine = ""

        if (uneDifficulte == FACILE)
            File.foreach('./Grille/Fichiers/grillesEasy.txt') do |line|

				# Si on arrive au mot "END" dans le fichier, on arrête la recherche en envoyant le mot-clé "END"
				if line.eql?("END") 
					return "END"
				elsif line.eql?("\n")
                    compteur += 1
				elsif compteur == unIndex
                    chaine << line
                end

                return chaine if (compteur == unIndex + 1)

            end
        end

    end

    def toGrilleJouable(unIndex, uneDifficulte)

        chaine = lireGrille(unIndex, uneDifficulte)
        
        numeroCases = chaine.lines.first.split(' ')
        grille = chaine.lines.drop(1)

		# p grille[0].split <-- print chaque caractère de la ligne à part

		# Génération de la matrice de cases
		matriceCases = Array.new(grille.length) { Array.new(grille[0].split.length) }

		x = 0, y = 0, compteur = 0
		grille.each_with_index do |line, index|
			x = 0
			for j in grille[index].split do
				if (j == "2" || j == 2)
					matriceCases[y][x] = numeroCases[compteur].to_i
					compteur += 1
				else
					matriceCases[y][x] = j.to_i
				end
				
				x += 1
			end
			y += 1
		end

		p matriceCases

    end

    # faire def toGrilleSolution

end

