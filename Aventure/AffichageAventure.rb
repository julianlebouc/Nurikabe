require "yaml.rb"
require 'gtk3'
include Gtk
load "Aventure.rb"

class AffichageAventure

  # Deux VI accessibles en lecture et écriture pour de simplifier l'implémentation de thèmes
  # @couleurBase -> couleur d'origine des boutons
  @couleurBase = "white"
  # couleurVisible -> couleur des boutons lorsque l'on clique dessus ("effet de surbrillance")
  @couleurVisible = "grey"

  attr :couleurBase, :couleurVisible true
  
  def destruction
    Gtk.main_quit
    return
  end

  def setBackground(bouton, couleur)
    bouton.bg = couleur
  end

  def affichageEtoile(nbEtoiles)
    case nbEtoiles
    when 0
      imgEtoile1 = gtk_image_new_from_file ("etoile_sombre.png")
      imgEtoile2 = gtk_image_new_from_file ("etoile_sombre.png")
      imgEtoile3 = gtk_image_new_from_file ("etoile_sombre.png")
      imgEtoile4 = gtk_image_new_from_file ("etoile_sombre.png")
      imgEtoile5 = gtk_image_new_from_file ("etoile_sombre.png")
    when 1
      imgEtoile1 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile2 = gtk_image_new_from_file ("etoile_sombre.png")
      imgEtoile3 = gtk_image_new_from_file ("etoile_sombre.png")
      imgEtoile4 = gtk_image_new_from_file ("etoile_sombre.png")
      imgEtoile5 = gtk_image_new_from_file ("etoile_sombre.png")
    when 2
      imgEtoile1 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile2 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile3 = gtk_image_new_from_file ("etoile_sombre.png")
      imgEtoile4 = gtk_image_new_from_file ("etoile_sombre.png")
      imgEtoile5 = gtk_image_new_from_file ("etoile_sombre.png")
    when 3
      imgEtoile1 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile2 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile3 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile4 = gtk_image_new_from_file ("etoile_sombre.png")
      imgEtoile5 = gtk_image_new_from_file ("etoile_sombre.png")
    when 4
      imgEtoile1 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile2 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile3 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile4 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile5 = gtk_image_new_from_file ("etoile_sombre.png")
    when 5
      imgEtoile1 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile2 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile3 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile4 = gtk_image_new_from_file ("etoile2.png")
      imgEtoile5 = gtk_image_new_from_file ("etoile2.png")
    end
  end

  def afficheToi

#<<<<<<< Updated upstream
  #monBuildeur = Gtk::Builder.new();
  #monBuildeur.add_from_file("../Modele_Image/aventure_normal_img.glade")
  #unBouton = monBuildeur.get_object("bouton1")
#=======
    monBuildeur = Gtk::Builder.new()
    monBuildeur.add_from_file("../glade/aventure_normal_img.glade")
#>>>>>>> Stashed changes

    aventureFacile.generationAventure(10)
    aventureNormale.generationAventure(10)
    aventureHard.generationAventure(10)

    @aventure = Aventure.creer(aventureFacile,aventureNormale,aventureHard)

    bouton1 = monBuildeur.get_object('btn_grille_1')
    bouton2 = monBuildeur.get_object('btn_grille_2')
    bouton3 = monBuildeur.get_object('btn_grille_3')
    bouton4 = monBuildeur.get_object('btn_grille_4')
    bouton5 = monBuildeur.get_object('btn_grille_5')
    bouton6 = monBuildeur.get_object('btn_grille_6')
    bouton7 = monBuildeur.get_object('btn_grille_7')
    bouton8 = monBuildeur.get_object('btn_grille_8')
    bouton9 = monBuildeur.get_object('btn_grille_9')
    bouton10 = monBuildeur.get_object('btn_grille_10')

    modeFacile = monBuildeur.get_object('btn_facile')
    modeNormal = monBuildeur.get_object('btn_normal')
    modeHard = monBuildeur.get_object('btn_difficile')

    btnPreced = monBuildeur.get_object('btn_grille_preced')
    btnSuivant = monBuildeur.get_object('btn_grille_suiv')

    imgEtoile1 = monBuildeur.get_object('etoile_1')
    imgEtoile2 = monBuildeur.get_object('etoile_2')
    imgEtoile3 = monBuildeur.get_object('etoile_3')
    imgEtoile4 = monBuildeur.get_object('etoile_4')
    imgEtoile5 = monBuildeur.get_object('etoile_5')

    fenetre = monBuilder.get_object('fenetre_aventure')

    fenetre.signal_connect('btn_retour') {
      destruction
    }
    fenetre.signal_connect('btn_grille_preced') {@aventure.grillePrecedente}
    fenetre.signal_connect('btn_grille_suiv') {@aventure.prochaineGrille}

    fenetre.signal_connect('btn_facile') {
      @aventure.choixDifficulte(0)
      setBackground(modeFacile,@couleurVisible)
      setBackground(modeNormal,@couleurBase)
      setBackground(modeHard,@couleurBase)
    }

    fenetre.signal_connect('btn_normal') {
      @aventure.choixDifficulte(1)
      @aventure.unlockDifficulte
      setBackground(modeFacile,@couleurBase)
      setBackground(modeNormal,@couleurVisible)
      setBackground(modeHard,@couleurBase)
    }

    fenetre.signal_connect('btn_normal') {
      @aventure.choixDifficulte(2)
      @aventure.unlockDifficulte
      setBackground(modeFacile,@couleurBase)
      setBackground(modeNormal,@couleurBase)
      setBackground(modeHard,@couleurVisible)
    }

    fenetre.signal_connect('img_grille') {
      affichageEtoile(@aventure.getEtoileCourante)
    }

    fenetre.signal_connect('btn_grille_1') {
      @aventure.placerSurGrille(0)
      setBackground(bouton1,@couleurVisible)
      setBackground(bouton2,@couleurBase)
      setBackground(bouton3,@couleurBase)
      setBackground(bouton4,@couleurBase)
      setBackground(bouton5,@couleurBase)
      setBackground(bouton6,@couleurBase)
      setBackground(bouton7,@couleurBase)
      setBackground(bouton8,@couleurBase)
      setBackground(bouton9,@couleurBase)
      setBackground(bouton10,@couleurBase)
    }

    fenetre.signal_connect('btn_grille_2') {
      @aventure.placerSurGrille(1)
      setBackground(bouton1,@couleurBase)
      setBackground(bouton2,@couleurVisible)
      setBackground(bouton3,@couleurBase)
      setBackground(bouton4,@couleurBase)
      setBackground(bouton5,@couleurBase)
      setBackground(bouton6,@couleurBase)
      setBackground(bouton7,@couleurBase)
      setBackground(bouton8,@couleurBase)
      setBackground(bouton9,@couleurBase)
      setBackground(bouton10,@couleurBase)
    }

    fenetre.signal_connect('btn_grille_3') {
      @aventure.placerSurGrille(2)
      setBackground(bouton1,@couleurBase)
      setBackground(bouton2,@couleurBase)
      setBackground(bouton3,@couleurVisible)
      setBackground(bouton4,@couleurBase)
      setBackground(bouton5,@couleurBase)
      setBackground(bouton6,@couleurBase)
      setBackground(bouton7,@couleurBase)
      setBackground(bouton8,@couleurBase)
      setBackground(bouton9,@couleurBase)
      setBackground(bouton10,@couleurBase)
    }

    fenetre.signal_connect('btn_grille_4') {
      @aventure.placerSurGrille(3)
      setBackground(bouton1,@couleurBase)
      setBackground(bouton2,@couleurBase)
      setBackground(bouton3,@couleurBase)
      setBackground(bouton4,@couleurVisible)
      setBackground(bouton5,@couleurBase)
      setBackground(bouton6,@couleurBase)
      setBackground(bouton7,@couleurBase)
      setBackground(bouton8,@couleurBase)
      setBackground(bouton9,@couleurBase)
      setBackground(bouton10,@couleurBase)
    }

    fenetre.signal_connect('btn_grille_5') {
      @aventure.placerSurGrille(4)
      setBackground(bouton1,@couleurBase)
      setBackground(bouton2,@couleurBase)
      setBackground(bouton3,@couleurBase)
      setBackground(bouton4,@couleurBase)
      setBackground(bouton5,@couleurVisible)
      setBackground(bouton6,@couleurBase)
      setBackground(bouton7,@couleurBase)
      setBackground(bouton8,@couleurBase)
      setBackground(bouton9,@couleurBase)
      setBackground(bouton10,@couleurBase)
    }

    fenetre.signal_connect('btn_grille_6') {
      @aventure.placerSurGrille(5)
      setBackground(bouton1,@couleurBase)
      setBackground(bouton2,@couleurBase)
      setBackground(bouton3,@couleurBase)
      setBackground(bouton4,@couleurBase)
      setBackground(bouton5,@couleurBase)
      setBackground(bouton6,@couleurVisible)
      setBackground(bouton7,@couleurBase)
      setBackground(bouton8,@couleurBase)
      setBackground(bouton9,@couleurBase)
      setBackground(bouton10,@couleurBase)
    }

    fenetre.signal_connect('btn_grille_7') {
      @aventure.placerSurGrille(6)
      setBackground(bouton1,@couleurBase)
      setBackground(bouton2,@couleurBase)
      setBackground(bouton3,@couleurBase)
      setBackground(bouton4,@couleurBase)
      setBackground(bouton5,@couleurBase)
      setBackground(bouton6,@couleurBase)
      setBackground(bouton7,@couleurVisible)
      setBackground(bouton8,@couleurBase)
      setBackground(bouton9,@couleurBase)
      setBackground(bouton10,@couleurBase)
    }

    fenetre.signal_connect('btn_grille_8') {
      @aventure.placerSurGrille(7)
      setBackground(bouton1,@couleurBase)
      setBackground(bouton2,@couleurBase)
      setBackground(bouton3,@couleurBase)
      setBackground(bouton4,@couleurBase)
      setBackground(bouton5,@couleurBase)
      setBackground(bouton6,@couleurBase)
      setBackground(bouton7,@couleurBase)
      setBackground(bouton8,@couleurVisible)
      setBackground(bouton9,@couleurBase)
      setBackground(bouton10,@couleurBase)
    }

    fenetre.signal_connect('btn_grille_9') {
      @aventure.placerSurGrille(8)
      setBackground(bouton1,@couleurBase)
      setBackground(bouton2,@couleurBase)
      setBackground(bouton3,@couleurBase)
      setBackground(bouton4,@couleurBase)
      setBackground(bouton5,@couleurBase)
      setBackground(bouton6,@couleurBase)
      setBackground(bouton7,@couleurBase)
      setBackground(bouton8,@couleurBase)
      setBackground(bouton9,@couleurVisible)
      setBackground(bouton10,@couleurBase)
    }

    fenetre.signal_connect('btn_grille_10') {
      @aventure.placerSurGrille(9)
      setBackground(bouton1,@couleurBase)
      setBackground(bouton2,@couleurBase)
      setBackground(bouton3,@couleurBase)
      setBackground(bouton4,@couleurBase)
      setBackground(bouton5,@couleurBase)
      setBackground(bouton6,@couleurBase)
      setBackground(bouton7,@couleurBase)
      setBackground(bouton8,@couleurBase)
      setBackground(bouton9,@couleurBase)
      setBackground(bouton10,@couleurVisible)
    }

  end

end
