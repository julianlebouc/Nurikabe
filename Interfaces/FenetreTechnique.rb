require 'gtk3'
include Gtk

load "Interfaces/Fenetre.rb"

=begin

    La classe FenetreTechnique :::
        - permet de générer l'interface "Technique de jeu" du jeu

    Les VI de la classe sont :::
        - @builder      ==> builder contenant la fenêtre courante (ici la fenêtre "technique")
        - @object       ==> contient l'identifiant de l'interface
        - @btnRetour    ==> contient l'identifiant du bouton retour
        - @menuParent   ==> contient le fenêtre parente de la fenêtre courante

    Voici ses méthode : 
        - gestionSignaux : permet d'attribuer des actions à tous les objets de l'interface récupéré dans le constructeur.
=end

class FenetreTechnique < Fenetre

    attr_accessor :object

    def initialize(menuParent)
        self.initialiseToi

        @builder = Gtk::Builder.new(:file => 'glade/techniqueResolution.glade')
        @object = @builder.get_object("menu")

        @btnRetour = @builder.get_object("btn_retour")

        @menuParent = menuParent

        self.gestionSignaux
    end

    ##
	# gestionSignaux :
	#	Cette methode permet d'assigner des actions à chaques boutons récupérés dans le fichier galde.
    def gestionSignaux()
        @btnRetour.signal_connect( "clicked" ) {
            self.changerInterface(@menuParent, "Menu")
        }
    end
end