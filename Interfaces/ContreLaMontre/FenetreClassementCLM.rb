require 'gtk3'

load "Interfaces/Fenetre.rb"
load "Sauvegarde/SauvegardeClassementContreLaMontre.rb"	
load "Sauvegarde/Score.rb"

##
# 	@author Quenault Maxime
#
#	Cette classe va permettre d'afficher le classement de la grille courante.
#
#	Voici les methodes de la classe FenetreClassementCLM :
#
#	- initialize : cette methode est le constructeur, elle recupere le fichier glade et initialise ses VI.
#	- gestionSignaux : permet d'attribuer des actions à tous les objets de l'interface récupéré dans le constructeur.
#   - getObjet : permet de recuperer l'interface courante
#   - recupeTab : permet de recuperer le tableau des scores de la grille courante
#   - ajoutScore : permet d'ajouter un score au classement et d'actualiser l'affichage
#   - construction : permet de construire la grille si on commence une partie
#   - affichageSore : permet d'afficher le tableau des scores à l'ecran.
#
#	Voici ses VI :
#
#	@builder : represente le fichier glade
#	@object : represente l'interface de la classe
#   @boutonRetour : permet de revenir au menu parent
#   @@boutonPartie : permet de lancer la partie
#   @menuParent : represente l'interface de menu parent, elle devra être affiché si on clique sur le bouton retour
#   @interfaceGrille : represente l'interface de la grille qui devra être afficher au besoin
#   @pseudo{1..10} : represente le pseudo d'un profil
#   @score{1..10} : represente un score associé à un profil
class FenetreClassementCLM < Fenetre

    attr_accessor :object

	##
	# initialize :
	# 	Cette methode est le constructeur de la classe FenetreClassementCLM, il permet de recuperer
	#	le fichier glade et tout les objets qui le compose. Ensuite nous attribuons les bonnes 
	#	actions a chaque objets récupérés.
	#
	# @param menuParent represente l'interface parent, elle sera util pour le bouton retour en arrière.
    def initialize(menuParent)

        self.initialiseToi

		@menuParent = menuParent

		#recuperation du fichier glade
        @builder = Gtk::Builder.new(:file => 'glade/contre_la_montre_nouvelle_partie.glade')
        @object = @builder.get_object("menu")

		#recuperation des boutons de l'interface
		@pseudo1 = @builder.get_object("pseudo1")
        @pseudo2 = @builder.get_object("pseudo2")
        @pseudo3 = @builder.get_object("pseudo3")
        @pseudo4 = @builder.get_object("pseudo4")
        @pseudo5 = @builder.get_object("pseudo5")
        @pseudo6 = @builder.get_object("pseudo6")
        @pseudo7 = @builder.get_object("pseudo7")
        @pseudo8 = @builder.get_object("pseudo8")
        @pseudo9 = @builder.get_object("pseudo9")
        @pseudo10 = @builder.get_object("pseudo10")

        @temps1 = @builder.get_object("temps1")
        @temps2 = @builder.get_object("temps2")
        @temps3 = @builder.get_object("temps3")
        @temps4 = @builder.get_object("temps4")
        @temps5 = @builder.get_object("temps5")
        @temps6 = @builder.get_object("temps6")
        @temps7 = @builder.get_object("temps7")
        @temps8 = @builder.get_object("temps8")
        @temps9 = @builder.get_object("temps9")
        @temps10 = @builder.get_object("temps10")

        @boutonPartie = @builder.get_object("btn_partie")
        @boutonRetour = @builder.get_object("btn_retour")
		
        # Création d'une interface grille
        @interfaceGrille = FenetreGrilleCLM.new(@object, self)
        
        #gestion et affiche par default
		self.gestionSignaux

    end

    
	##
	# getObjet:
	# 	Cette methode permet d'envoyer sont objet (interface) a l'objet qui le demande.
	#
	# @return object qui represente l'interface de la fenetre du mode libre.
	def getObjet
		return @object
	end


    ##
    # recupeTab:
    #   permet de recuperer le tableau des scores de la grille courante.
    def recupeTab
        @uneSave = SauvegardeClassementContreLaMontre.new(self.getNumGrille)
        @tabScore = @uneSave.tabScore
        self.affichageScore
    end

    ##
    # ajoutScore:
    #   permet d'ajouter un score au classmement des profils du mode de jeu,
    #   elle met à jour l'affichage.
    def ajoutScore
        unScore = Score.new(@interfaceGrille.getTempsPartie, @@profilActuel)
        @uneSave.ajoutScore(unScore)
        @tabScore = @uneSave.tabScore
        self.affichageScore
    end

	##
	# gestionSignaux:
	#	Cette methode permet d'assigner des actions à chaques boutons récupérés dans le fichier galde.
	def gestionSignaux

        @boutonRetour.signal_connect("clicked"){
            self.changerInterface(@menuParent, "Contre-La-Montre")
        }

        @boutonPartie.signal_connect("clicked"){
            construction
            self.changerInterface(@interfaceGrille.object, "Contre La Montre") #à modifier ensuite
        }

	end

    ##
    # construction:
    #   génère la grille
    def construction
        @interfaceGrille.construction
    end

    ##
    # affichageScore:
    #   Affiche le classement des 10 meilleurs scores
    def affichageScore
    
        if @tabScore[0] != nil
            @pseudo1.set_text(@tabScore[0].profil.pseudo)
            @temps1.set_text("#{@tabScore[0].getHeures}h#{@tabScore[0].getMinutes}m#{@tabScore[0].getSecondes}s")
        else
            @pseudo1.set_text("-")
            @temps1.set_text("-:-:-")
        end

        if @tabScore[1] != nil
            @pseudo2.set_text(@tabScore[1].profil.pseudo)
            @temps2.set_text("#{@tabScore[1].getHeures}h#{@tabScore[1].getMinutes}m#{@tabScore[1].getSecondes}s")
        else
            @pseudo2.set_text("-")
            @temps2.set_text("-:-:-")
        end

        if @tabScore[2] != nil
            @pseudo3.set_text(@tabScore[2].profil.pseudo)
            @temps3.set_text("#{@tabScore[2].getHeures}h#{@tabScore[2].getMinutes}m#{@tabScore[2].getSecondes}s")
        else
            @pseudo3.set_text("-")
            @temps3.set_text("-:-:-")
        end

        if @tabScore[3] != nil
            @pseudo4.set_text(@tabScore[3].profil.pseudo)
            @temps4.set_text("#{@tabScore[3].getHeures}h#{@tabScore[3].getMinutes}m#{@tabScore[3].getSecondes}s")
        else
            @pseudo4.set_text("-")
            @temps4.set_text("-:-:-")
        end

        if @tabScore[4] != nil
            @pseudo5.set_text(@tabScore[4].profil.pseudo)
            @temps5.set_text("#{@tabScore[4].getHeures}h#{@tabScore[4].getMinutes}m#{@tabScore[4].getSecondes}s")
        else
            @pseudo5.set_text("-")
            @temps5.set_text("-:-:-")
        end

        if @tabScore[5] != nil
            @pseudo6.set_text(@tabScore[5].profil.pseudo)
            @temps6.set_text("#{@tabScore[5].getHeures}h#{@tabScore[5].getMinutes}m#{@tabScore[5].getSecondes}s")
        else
            @pseudo6.set_text("-")
            @temps6.set_text("-:-:-")
        end

        if @tabScore[6] != nil
            @pseudo7.set_text(@tabScore[6].profil.pseudo)
            @temps7.set_text("#{@tabScore[6].getHeures}h#{@tabScore[6].getMinutes}m#{@tabScore[6].getSecondes}s")
        else
            @pseudo7.set_text("-")
            @temps7.set_text("-:-:-")
        end

        if @tabScore[7] != nil
            @pseudo8.set_text(@tabScore[7].profil.pseudo)
            @temps8.set_text("#{@tabScore[7].getHeures}h#{@tabScore[7].getMinutes}m#{@tabScore[7].getSecondes}s")
        else
            @pseudo8.set_text("-")
            @temps8.set_text("-:-:-")
        end

        if @tabScore[8] != nil
            @pseudo9.set_text(@tabScore[8].profil.pseudo)
            @temps9.set_text("#{@tabScore[8].getHeures}h#{@tabScore[8].getMinutes}m#{@tabScore[8].getSecondes}s")
        else
            @pseudo9.set_text("-")
            @temps9.set_text("-:-:-")
        end

        if @tabScore[9] != nil
            @pseudo10.set_text(@tabScore[9].profil.pseudo)
            @temps10.set_text("#{@tabScore[9].getHeures}h#{@tabScore[9].getMinutes}m#{@tabScore[9].getSecondes}s")
        else
            @pseudo10.set_text("-")
            @temps10.set_text("-:-:-")
        end
    end

end

