load "Partie/CaseNombre.rb"
load "Partie/Case.rb"
load "Partie/CaseJouable.rb"

=begin
	@author Julian LEBOUC
	La classe Grille :::
		- représente la grille de la partie

	Les VI de la classe sont :::

		- @numero			==> identifiant de la grille
		- @hauteur			==> hauteur de la grille
		- @largeur			==> largeur de la grille
		- @matriceCases		==> matrice de @Case sur laquelle le joueur jouera
		- @correction		==> matrice corrigée
		- @etoiles			==> nombre d'étoiles 
		- @difficulte       ==> la difficulté de la grille

=end

class Grille

	@numero
	@hauteur
	@largeur
	@matriceCases
	@correction
	@etoiles
	@difficulte

	FACILE ||= 0
	MOYEN ||= 1
	DIFFICILE ||= 2
	#constructeur de test
	def Grille.creer(num,h,l)
		new(num,h,l)
	end

	##
	#Constructeur pour chargement via fichier texte
	def Grille.creer()
		new()
	end

	private_class_method :new
	attr :matriceCases, false
	attr :numero, false
	attr :correction, false
	attr :etoiles, true
	attr :hauteur, false
	attr :largeur, false
	attr :difficulte, true

	attr_reader :hauteur, :largeur

	def initialize(num,h,l)
		@numero=num
		@hauteur=h
		@largeur=l
		@matriceCases=Array.new(@largeur){Array.new(@hauteur)}
		@correction=Array.new(@largeur){Array.new(@hauteur)}
		@etoiles=0
	end

	def initialize()
		@etoiles=0
	end

	##
	#affectes les cases de la matrice passée en paramètre à la matriceCases
	def copierMatrice(mat2)
		for i in 0..@hauteur-1  do
			for j in 0..@largeur-1 do
				if(mat2[j][i].is_a?(CaseJouable))
					c = CaseJouable.creer()
					c.etat=mat2[j][i].etat
					@matriceCases[j][i]=c
				else
					@matriceCases[j][i]=CaseNombre.creer(mat2[j][i].valeur)
				end
			end
		end
	end

	#affectes les cases de la matrice passée en paramètre à la matrice correction
	def copierCorrection(mat2)
		for i in 0..@hauteur-1  do
			for j in 0..@largeur-1 do
				if(mat2[j][i].is_a?(CaseJouable))
					c = CaseJouable.creer()
					c.etat=mat2[j][i].etat
					@correction[j][i]=c
				else
					@correction[j][i]=CaseNombre.creer(mat2[j][i].valeur)
				end
			end
		end
	end


	def to_s()
		res = "-------------\n"
		for i in 0..@hauteur-1  do
			for j in 0..@largeur-1 do
				res+= @matriceCases[j][i].to_s
				res+= " "
			end
			res+= "\n"
		end
		return res
	end

	# retournes le pourcentage de complétion de la matriceCases
	def pourcentageCompletion()
		nbPareil = 0
		nbCasesNombre = 0
		for j in 0..@hauteur - 1
			for i in 0..@largeur - 1
				if(@matriceCases[i][j].is_a?(CaseJouable) && @matriceCases[i][j].etat==@correction[i][j].etat)
					nbPareil += 1
				elsif (@matriceCases[i][j].is_a?(CaseNombre))
					nbCasesNombre+=1
				end
			end
		end
		return (nbPareil/(@hauteur*@largeur-nbCasesNombre).to_f)*100
	end

	# retournes le nombre d'erreurs de la matriceCases
	def nbErreurs()
		nbErr = 0
		for j in 0..@hauteur - 1
			for i in 0..@largeur - 1
				if(@matriceCases[i][j].is_a?(CaseJouable)&&@matriceCases[i][j].etat!=@correction[i][j].etat&&@matriceCases[i][j].etat!=0)
					nbErr += 1
				end
			end
		end
		return nbErr
	end

	# retournes un booléen : vrai si la matriceCases est finie, faux sinon
	def grilleFinie()
		nbErr = 0
		for j in 0..@hauteur - 1
			for i in 0..@largeur - 1
				if(@matriceCases[i][j].is_a?(CaseJouable)&&@matriceCases[i][j].etat!=@correction[i][j].etat)
					nbErr += 1
				end
			end
		end
		return nbErr==0
	end

	# Remet toutes les cases jouables de la matriceCases à l'état non joué
	def raz()
		for j in 0..@hauteur - 1
			for i in 0..@largeur - 1
				if(@matriceCases[i][j].is_a?(CaseJouable))
					@matriceCases[i][j].etat=0
				end
			end
		end
	end

	##
	# Lis les fichiers Texte contenants les grilles, retournes une chaine correspondant à la grille d'index et de difficulté passé en paramètres
	def lireGrille(unIndex, uneDifficulte)
        compteur = 0
        chaine = ""

        if (uneDifficulte == FACILE)
            File.foreach('./Partie/grillesEasy.txt') do |line|
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
        elsif (uneDifficulte == MOYEN)
            File.foreach('./Partie/grillesMedium.txt') do |line|
                if line.eql?("\n")
                    compteur += 1
				elsif compteur == unIndex
                    chaine << line
                end

                return chaine if (compteur == unIndex + 1)

            end
        elsif (uneDifficulte == DIFFICILE)
            File.foreach('./Partie/grillesHard.txt') do |line|

                if line.eql?("\n")
                    compteur += 1
				elsif compteur == unIndex
                    chaine << line
                end

                return chaine if (compteur == unIndex + 1)

            end
        end

    end

	##
	# Affectes à @matriceCases et @correction la grille d'index et de difficulté passée en paramètres
    def chargerGrille(unIndex, uneDifficulte)

        chaine = lireGrille(unIndex, uneDifficulte)
        
        numeroCases = chaine.lines.first.split(' ')
        grille = chaine.lines.drop(1)

		# p grille[0].split <-- print chaque caractère de la ligne à part

		# Génération de la matrice de cases
		matriceCases = Array.new(grille.length) { Array.new(grille[0].split.length) }
		correction = Array.new(grille.length) { Array.new(grille[0].split.length) }

		x = 0, y = 0, compteur = 0
		grille.each_with_index do |line, index|
			x = 0
			for j in grille[index].split do
				if (j == "2" || j == 2)
					correction[x][y] = CaseNombre.creer(numeroCases[compteur].to_i) 
					matriceCases[x][y] = CaseNombre.creer(numeroCases[compteur].to_i) 
					compteur += 1
				else
					correction[x][y] = CaseJouable.creer()
					matriceCases[x][y] = CaseJouable.creer()
					if j.to_i == 0
						correction[x][y].etat=1
					else
						correction[x][y].etat=2
					end
				end
				
				x += 1
			end
			y += 1
		end
		@numero=unIndex
		@hauteur=y
		@largeur=x
		@matriceCases=Array.new(@largeur){Array.new(@hauteur)}
		@correction=Array.new(@largeur){Array.new(@hauteur)}
		self.copierMatrice(matriceCases)
		self.copierCorrection(correction)
    end

end
