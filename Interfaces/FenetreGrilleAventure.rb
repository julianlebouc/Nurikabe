require 'gtk3'
include Gtk

load "./Partie/Partie.rb"
load "./Interfaces/Fenetre.rb"

=begin

    La classe FenetreGrille :::
        - génère l'interface d'une partie
        - peut gérer les différents boutons et leur "cliquabilité" (s'ils sont cliquables ou non, en fonction du contexte de la partie)

    Les VI de la classe sont :::
        - @builder          ==> builder de la fenêtre courante
        - @object           ==> contient l'identifiant glade de l'interface courante
        - @grid             ==> contient l'identifiant glade de la grille
        - @interfaceRetour  ==>
        - @profil           ==> contient le profil courant
        - @menuParent       ==> contient l'interface parente de l'interface courante
        - @boutons          ==> table contenant une liste de boutons

    Les VC de la classe sont :::
        - @@partie  ==> partie en cours

    Voici ses méthodes :::
        - gestionSignaux : Récupère les boutons et créer tout les signaux correspondants 
        - affiche_victoire : Affiche une popup de victoire
        - construction : Construit la grille de boutons correpondants aux cases de la grille
        - afficheGrille : Créer un affichage de la grille pour la librarie de grille
        - signaux_boutons : Changes la couleur des boutons lorsqu'on clique dessus
        - griserBoutons : permet de griser un bouton si il est inutilisable
        - maj_boutons (version sans parametre): permet de changer l'etat du bouton courant
        - maj_boutons (version avec parametre) : recupere les coordoné du bouton et change sont etat dans la table des boutons

=end


class FenetreGrilleAventure < Fenetre

    attr_accessor :object, :popover

    def initialize(menuParent,fenetreAventure)
        self.initialiseToi
        @popover = Gtk::Popover.new
        @builder = Gtk::Builder.new
        @builder.add_from_file("glade/grille.glade")
        @object = @builder.get_object("menu")
        @boutons
        @menuParent = menuParent
        @fenetreAventure = fenetreAventure
        self.gestionSignaux
    end

    ##
    # gestionSignaux:
    #   Récupère les boutons et créer tout les signaux correspondants
    def gestionSignaux

        #Recuperation de la fenetre
        btn_retour = @builder.get_object('btn_retour')
        btn_undo = @builder.get_object('btn_undo')
        btn_redo = @builder.get_object('btn_redo')
        btn_pause = @builder.get_object('btn_pause')
        btn_rembobiner = @builder.get_object('btn_rembobiner')
        btn_clear = @builder.get_object('btn_clear')
        btn_aide = @builder.get_object('btn_aide')

        #Gestion Graphique CSS
        btn_retour.name = "btn_menu_grille"
        btn_undo.name = "btn_menu_grille_grise"
        btn_redo.name = "btn_menu_grille_grise"
        btn_pause.name = "btn_menu_grille"
        btn_rembobiner.name = "btn_menu_grille_grise"
        btn_clear.name = "btn_menu_grille"
        btn_aide.name = "btn_menu_grille"

        btn_aide.set_popover(@popover)

        #Gestion des signaux
        btn_redo.signal_connect('clicked'){#redo
            @@partie.redo
            maj_boutons
            griserBoutons
        }
        btn_undo.signal_connect('clicked'){#undo
            @@partie.undo
            maj_boutons
            griserBoutons
        }
        btn_rembobiner.signal_connect('clicked'){#retour tant qu'il y a des erreurs
            @@partie.reviensALaBonnePosition()
            maj_boutons
            griserBoutons
        }
        btn_aide.signal_connect('clicked'){#affiche un indice
            indice=@@partie.clicSurIndice
            if indice==@@partie.dernierIndice
                @boutons[[indice.coordonneesCase[0],indice.coordonneesCase[1]]].name = "case_indice"
            end
            @popover.destroy
            @popover = Gtk::Popover.new
            labelIndice = Gtk::Label.new(indice.to_s)
            @popover.add(labelIndice)
            @builder.get_object('btn_aide').set_popover(@popover)
            @popover.show_all
            @@partie.dernierIndice=indice

        }
        btn_clear.signal_connect('clicked'){#remet la partie a zero
            @@partie.raz
            griserBoutons
            maj_boutons
        }


    end

    ##
    # affiche_victoire:
    #    Affiche une popup de victoire
    def affiche_victoire
        dialog = Gtk::Dialog.new
        dialog.title = "Victoire"
        dialog.set_default_size(300, 100)
        dialog.child.add(Gtk::Label.new("Bravo, vous avez résolu le puzzle !"))
        dialog.add_button(Gtk::Stock::CLOSE, Gtk::ResponseType::CLOSE)
        dialog.set_default_response(Gtk::ResponseType::CANCEL)

        dialog.signal_connect("response") do |widget, response|
            case response
            when Gtk::ResponseType::CANCEL
            p "Cancel"
            when Gtk::ResponseType::CLOSE
            p "Close"
            dialog.destroy
            end
        end
        dialog.show_all
    end

    ##
    # construction:
    #   Construit la grille de boutons correpondants aux cases de la grille
    def construction
        taille_hauteur = @@partie.grilleEnCours.hauteur
        taille_largeur = @@partie.grilleEnCours.largeur
        @boutons = {}
        tableFrame = Frame.new();
        tableFrame.name = "grille"
        table = Table.new(taille_hauteur,taille_largeur,false)
        table.set_halign(3);
        table.set_valign(3);
        tableFrame.set_halign(3);
        tableFrame.set_valign(3);
        tableFrame.add(table)
        for i in 0..taille_largeur-1
            for j in 0..taille_hauteur-1
                if @@partie.grilleEnCours.matriceCases[i][j].is_a?(CaseNombre)
                    @boutons[[i,j]] = Button.new(:label=> @@partie.grilleEnCours.matriceCases[i][j].to_s)
                    @boutons[[i,j]].name = "case_chiffre"
                    table.attach(@boutons[[i,j]], i, i+1, j, j+1)
                else
                    @boutons[[i,j]] = Button.new()
                    @boutons[[i,j]].name = "case_vide"
                    table.attach(@boutons[[i,j]], i, i+1, j, j+1)
                end
            end
        end
        maj_boutons
        signaux_boutons(tableFrame)
        @object.add(table)
        # supprime les boutons
        @builder.get_object('btn_retour').signal_connect('clicked'){#quitter
            @object.remove(tableFrame)
            @@profilActuel.ajouterPartie(@@partie)
            self.changerInterface(@menuParent, "Libre")
        }
        @object.add(tableFrame)
        tableFrame.show_all
    end

	##
    # afficheGrille:
	#   Créer un affichage de la grille pour la librarie de grille
    #
    # @param hauteur represente la hauteur de la grille
    # @param largeur represente la largeur de la grille
    # @param grille represente la grille a afficher
    def afficheGrille(hauteur, largeur, grille)
        taille_hauteur = hauteur
        taille_largeur = largeur
        @boutons = {}
        tableFrame = Frame.new();
        tableFrame.name = "grille_preview"
        table = Table.new(taille_hauteur,taille_largeur,false)
        table.set_halign(3);
        table.set_valign(3);
        tableFrame.set_halign(3);
        tableFrame.set_valign(3);
        tableFrame.add(table)
        for i in 0..taille_largeur-1
            for j in 0..taille_hauteur-1
                if grille.matriceCases[i][j].is_a?(CaseNombre)
                    @boutons[[i,j]] = Button.new(:label=> grille.matriceCases[i][j].to_s)
                    @boutons[[i,j]].name = "case_chiffre_preview"
                    table.attach(@boutons[[i,j]], i, i+1, j, j+1)
                else
                    @boutons[[i,j]] = Button.new()
                    @boutons[[i,j]].name = "case_vide_preview"
                    table.attach(@boutons[[i,j]], i, i+1, j, j+1)
                end
            end
        end
        # maj_boutons
        # signaux_boutons(tableFrame)
        # @object.add(table)

        # # supprime les boutons
        # @builder.get_object('btn_retour').signal_connect('clicked'){#quitter
        #     @object.remove(tableFrame)
        #     @@profilActuel.ajouterPartie(@@partie)
        #     self.changerInterface(@menuParent, "Libre")
        # }

        return tableFrame
    end

    ##
    # signaux_boutons:
    #   Changes la couleur des boutons lorsqu'on clique dessus
    #
    # @param tableFrame represente la table qui contient tous les boutons du jeu
    def signaux_boutons(tableFrame)
        @boutons.each do |cle, val|
            if @@partie.grilleEnCours.matriceCases[cle[0]][cle[1]].is_a?(CaseJouable)
                val.signal_connect('clicked'){
                    @@partie.clicSurCase(cle[0],cle[1])
                    maj_bouton(cle[0],cle[1])
                    griserBoutons
                    if @@partie.dernierIndice!=nil && @@partie.dernierIndice.type!=nil && @@partie.grilleEnCours.matriceCases[@@partie.dernierIndice.coordonneesCase[0]][@@partie.dernierIndice.coordonneesCase[1]].is_a?(CaseNombre)
                        @boutons[[@@partie.dernierIndice.coordonneesCase[0],@@partie.dernierIndice.coordonneesCase[1]]].name = "case_chiffre"
                    end
                    if @@partie.partieFinie?
                        @fenetreAventure.compterNombreEtoile()
                        affiche_victoire
                        @object.remove(tableFrame)
                        @@profilActuel.ajouterPartie(@@partie)
                        self.changerInterface(@menuParent, "Libre")
                    end
                }
            end
        end
    end

    ##
    # griserBouton:
    #   permet de griser un bouton si il est inutilisable
    def griserBoutons
        btn_undo = @builder.get_object('btn_undo')
        btn_redo = @builder.get_object('btn_redo')
        btn_rembobiner = @builder.get_object('btn_rembobiner')
        if @@partie.undoPossible?
            btn_undo.name = "btn_menu_grille"
            btn_rembobiner.name = "btn_menu_grille"
        else
            btn_undo.name = "btn_menu_grille_grise"
            btn_rembobiner.name = "btn_menu_grille_grise"
        end
        if @@partie.redoPossible?
            btn_redo.name = "btn_menu_grille"
        else
            btn_redo.name = "btn_menu_grille_grise"
        end
    end

    ##
    # maj_bouton:
    #   permet de changer l'etat du bouton une fois cliqué, pour cela elle fait appel à une seconde methodes
    def maj_boutons
        @boutons.each do |cle, val|
            if @@partie.grilleEnCours.matriceCases[cle[0]][cle[1]].is_a?(CaseJouable)
                maj_bouton(cle[0],cle[1])
            end
        end
    end

    ##
    # maj_bouton:
    #   Change la couleur d'un bouton aux coordonnées passées en paramètres en fonction de l'état de la case correspondante
    #
    # @param i represente la coordoné x du bouton
    # @param i represente la coordoné y du bouton
    def maj_bouton(i,j)
        if(@@partie.grilleEnCours.matriceCases[i][j].etat==0)
            @boutons[[i,j]].name = "case_vide"
            @boutons[[i,j]].set_label(" ")
        elsif (@@partie.grilleEnCours.matriceCases[i][j].etat==1)
            @boutons[[i,j]].name = "case_noir"
            @boutons[[i,j]].set_label(" ")
        else
            @boutons[[i,j]].name = "case_point"
            @boutons[[i,j]].set_label("•")
        end
    end

end
