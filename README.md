# DjangoDeploy
Ce projet offre une solution automatisée pour déployer rapidement un site Django, incluant la création du squelette et la configuration pré-établie d'un formulaire pour une intégration encore plus rapide.

### 🚀 Pour déployer la solution sur votre serveur (Debian de préférence) :
    apt update -y && apt upgrade -y && apt install -y git && git clone https://github.com/TimFlp/DjangoDeploy && cd DjangoDeploy && bash DjangoDeploy.sh

### 💡 Ce que vous aurez :
L'arborescence obtenue après avoir choisi comme nom de projet 'meteo' et le nom d'application 'view_meteo'

    meteo/
    `-- meteo
        |-- db.sqlite3
        |-- manage.py
        |-- meteo
        |   |-- __init__.py
        |   |-- __pycache__
        |   |   |-- __init__.cpython-311.pyc
        |   |   |-- settings.cpython-311.pyc
        |   |   |-- urls.cpython-311.pyc
        |   |   `-- wsgi.cpython-311.pyc
        |   |-- asgi.py
        |   |-- settings.py
        |   |-- urls.py
        |   `-- wsgi.py
        `-- view_meteo
            |-- __init__.py
            |-- __pycache__
            |   |-- __init__.cpython-311.pyc
            |   |-- admin.cpython-311.pyc
            |   |-- apps.cpython-311.pyc
            |   |-- forms.cpython-311.pyc
            |   |-- models.cpython-311.pyc
            |   |-- urls.cpython-311.pyc
            |   `-- views.cpython-311.pyc
            |-- admin.py
            |-- apps.py
            |-- forms.py
            |-- migrations
            |   |-- 0001_initial.py
            |   |-- __init__.py
            |   `-- __pycache__
            |       |-- 0001_initial.cpython-311.pyc
            |       `-- __init__.cpython-311.pyc
            |-- models.py
            |-- static
            |   `-- view_meteo
            |       |-- script.js
            |       `-- style.css
            |-- templates
            |   `-- home.html
            |-- tests.py
            |-- urls.py
            `-- views.py

Un site très basique (bisque > les autres couleurs) mais fonctionnel avec un form pré-configuré !

![Photo_presentation](https://github.com/TimFlp/DjangoDeploy/Images/basique.PNG)

