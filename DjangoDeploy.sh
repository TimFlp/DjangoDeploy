#!/bin/bash

function install-dep() { 
    echo "[*] Installation des dépendances pour Django..."
    apt update -y && apt upgrade -y && apt install -y python3 python3-django python3-requests
}

function crea-arbo() { 
    echo -e "[*] Création de l'arborescence $HOME/$projet..."
    cd $HOME && mkdir $projet && cd $projet
    echo -e "[*] Création du squelette du main et de l'application..."
    django-admin startproject $projet
    cd $projet && python3 manage.py startapp $app
    touch $HOME/$projet/$projet/$app/urls.py
    mkdir $HOME/$projet/$projet/$app/templates
    touch $HOME/$projet/$projet/$app/templates/home.html
    mkdir $HOME/$projet/$projet/$app/static
    mkdir $HOME/$projet/$projet/$app/static/$app
    touch $HOME/$projet/$projet/$app/static/$app/style.css
}

function standard-settings() {

    echo "[*] Mise en place du fichier home.html..."
    html_data=$(cat <<'END'
{% load static %}

<!DOCTYPE html>
<html>
<head>
    <script type="text/javascript" src="{% static '$app/script.js' %}"></script>
    <link rel="stylesheet" type="text/css" href="{% static '$app/style.css' %}">
    <title>Hello World !</title>
</head>
<body>

    <h1>Hello {{ html_content.nom_user }} !</h1>

    <form method="get" action="/user">
   	 {% csrf_token %}
   	 {{ html_content.form.nom.label_tag }} {{ html_content.form.nom }}
    	<button type="submit">Envoyer</button>
    </form>

</body>
</html>

END
    )
    # Pour contourner l'erreur de $app introuvable (c'est pas beau mais je connais pas d'autres façons pour l'instant)
    html_data=$(echo "$html_data" | sed "s|\(\$app\)|$app|g")
    echo "$html_data" > "$HOME/$projet/$projet/$app/templates/home.html"

    echo "[*] Mise en place du fichier urls.py..."
    urls_py_main=$(cat <<'END'
from django.contrib import admin
from django.urls import path, include
from $app.views import home

urlpatterns = [
    path('admin/', admin.site.urls),
    path('user/', home, name='user_home'),
    path('', include('$app.urls')),
]
END
    )
    # Pour contourner l'erreur de $app introuvable (c'est pas beau mais je connais pas d'autres façons pour l'instant)
    urls_py_main=$(echo "$urls_py_main" | sed "s|\(\$app\)|$app|g")
    echo "$urls_py_main" > "$HOME/$projet/$projet/$projet/urls.py"
    
    echo "[*] Mise en place du fichier settings.py..."
    sed -i "s|STATIC_URL = '/static/'|STATIC_URL = '/static/$app/'|" "$HOME/$projet/$projet/$projet/settings.py"
    sed -i "s|ALLOWED_HOSTS = \[\]|ALLOWED_HOSTS = \['*'\]|" "$HOME/$projet/$projet/$projet/settings.py"
    sed -i "/^INSTALLED_APPS *= *\[/a\ \ \ \ '$app'," "$HOME/$projet/$projet/$projet/settings.py"

    echo "[*] Mise en place du fichier views.py..."
    views_py=$(cat <<'END'
from django.shortcuts import render
from .forms import NameForm

def home(request):
    user = "Inconnu."
    if request.method == 'GET':
        form = NameForm(request.GET)
        if form.is_valid():
            user = form.cleaned_data['nom']
            print("User recupere : ",user)
            if user is None:
                user = "Inconnu."
        else:
            user = "Inconnu."

    html_content = {
        "nom_user": user,
        "form": NameForm(),  # Créez une nouvelle instance du formulaire pour afficher dans le template
    }

    return render(request, 'home.html', {'html_content': html_content})
END
    )
    echo "$views_py" > "$HOME/$projet/$projet/$app/views.py"

    echo "[*] Mise en place du fichier urls.py (app)..."
    urls_py=$(cat <<'END'
from django.urls import path
from .views import home
from .forms import NameForm

urlpatterns = [
    path("", home, name="home"),
]
END
    )
    echo "$urls_py" > "$HOME/$projet/$projet/$app/urls.py"


    echo "[*] Mise en place du fichier models.py..."
    models_py=$(cat <<'END'
from django.db import models

class NomModel(models.Model):                        
    nom = models.CharField(max_length=100)

    def __str__(self):
        return self.nom
END
    )
    echo "$models_py" > "$HOME/$projet/$projet/$app/models.py"


    echo "[*] Mise en place du fichier forms.py..."
    forms_py=$(cat <<'END'
from django import forms
from .models import NomModel

class NameForm(forms.ModelForm):
    class Meta:
        model = NomModel
        fields = ['nom']

END
    )
    echo "$forms_py" > "$HOME/$projet/$projet/$app/forms.py"

# Pour rajouter un peu de couleur...
    style_css=$(cat <<'END'
html {
    background-color: bisque;
}
END
    )
    echo "$style_css" > "$HOME/$projet/$projet/$app/static/$app/style.css"


# Pour rajouter un fichier js...
    js=$(cat <<'END'
// You can add javascript here !
// Vous pouvez rajouter votre javascript ici !
END
    )
    echo "js" > "$HOME/$projet/$projet/$app/static/$app/script.js"
}

function launch(){
    cd $HOME/$projet/$projet/
    echo -e "[*] Lancement des migrations nécessaires..."
    python3 manage.py makemigrations
    python3 manage.py migrate
    echo -e "[*] Lancement du serveur web sur l'IP : $ip:80"
    python3 manage.py runserver $ip:80
}


echo "[*] Utilitaire d'installation pour Django"
read -p "Nom de votre projet : " projet
read -p "Nom de votre application : " app
echo -e "L'adresse IP de la machine ?\n$(ip -br a)\n"
read -p "IP : " ip


echo -e "Etes-vous sûr de votre choix ? app = $app, projet = $projet [y/n]"
read -p "Choix : " choice

if [ "$choice" != "${choice#[Yy]}" ] ;then 
    install-dep
    crea-arbo
    standard-settings
    launch
else
    echo "[!] Annulation du script..."
fi