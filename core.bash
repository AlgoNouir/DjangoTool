#! /usr/bin/bash


# a tool for django

# create project


djangoSetting=$(cat <<- EOM
# ----------------------------------------------------------------------------------+
#                                                                                   |
#                                      IMPORTS                                      |
#                                                                                   |
# ----------------------------------------------------------------------------------+


from pathlib import Path


# ----------------------------------------------------------------------------------+
#                                                                                   |
#                                      SECURITY                                     |
#                                                                                   |
# ----------------------------------------------------------------------------------+


BASE_DIR = Path(__file__).resolve().parent.parent

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-d=v=t!s=yyho4i(r597@*28rs0m^d$*dcsz(kjx&*@*5)s)=vv3'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# ----------------------------------------------------------------------------------+
#                                                                                   |
#                                        CORS                                       |
#                                                                                   |
# ----------------------------------------------------------------------------------+


ALLOWED_HOSTS = []


# cors
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
]


# ----------------------------------------------------------------------------------+
#                                                                                   |
#                                   INSTALLED APPS                                  |
#                                                                                   |
# ----------------------------------------------------------------------------------+


DEPENDENCIES=[
    'rest_framework',
    "corsheaders",
]

MAIN_APPS = [

]


INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    *DEPENDENCIES
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    "corsheaders.middleware.CorsMiddleware",
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]


# ----------------------------------------------------------------------------------+
#                                                                                   |
#                                     DEFINITION                                    |
#                                                                                   |
# ----------------------------------------------------------------------------------+


ROOT_URLCONF = 'SERVER.urls'

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'SERVER.wsgi.application'


# ----------------------------------------------------------------------------------+
#                                                                                   |
#                                  DATABASE & FILES                                 |
#                                                                                   |
# ----------------------------------------------------------------------------------+


DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'data/db.sqlite3',
    }
}

STATIC_URL = 'static/'


# ----------------------------------------------------------------------------------+
#                                                                                   |
#                               INTERNATIONALIZATION                                |
#                                                                                   |
# ----------------------------------------------------------------------------------+


LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True


EOM
)


function getEnv {
    cat .env  2> /dev/null | grep "$1" | awk -F '[=]' '{ print $2 }'
}

function django_create_project () {
    read -p "insert your project name: [SERVER] " name
    if [ "$name" = "" ];then
        name="server"
    fi
    pipenv shell
    python3 -m pip install django django-cors-headers djangorestframework
    django-admin startproject "${name^^}" .
    mkdir Apps
    mkdir data
    echo "$djangoSetting"  > "./${name^^}/settings.py" 
    echo ALGO_DJANGO_TOOL="installed" >> .env
    echo ALGO_DJANGO_NAME="${name^^}" >> .env
}

function django_create_app () {
    if [ -d "./Apps/Core" ]; then
        echo "add another files"
    else

            mkdir "./Apps/Core"
            python3 manage.py startapp "Core" "./Apps/Core"
            rm -rf "./Apps/Core/admin.py"
            rm -rf "./Apps/Core/tests.py"
            rm -rf "./Apps/Core/__init__.py"
            rm -rf "./Apps/Core/migrations/"

            cat > "./Apps/Core/apps.py"<<EOM
from django.apps import AppConfig


class CoreConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'Apps.Core'
EOM
        

            echo "app Core installed"
        fi
    fi
    for item in "${@}"; do
        if [ -d "./Apps/${item^}" ];then
            echo "${item^} already exsist"
        else
            mkdir "./Apps/${item^}"
            python3 manage.py startapp "${item^}" "./Apps/${item^}"
            rm -rf "./Apps/${item^}/admin.py"
            rm -rf "./Apps/${item^}/tests.py"
            rm -rf "./Apps/${item^}/__init__.py"
            rm -rf "./Apps/${item^}/migrations/"

            cat > "./Apps/${item^}/apps.py"<<EOM
from django.apps import AppConfig


class HelloConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'Apps.${item^}'
EOM
        

            echo "app ${item^} installed"
        fi
    done
    

    # 
}


function django_rebase () {
    python3 manage.py makemigrations
    python3 manage.py migrate --run-syncdb
    python3 manage.py createsuperuser
}





# core
case $1 in 

    django)

        # check project installed
        if [ "$(getEnv ALGO_DJANGO_TOOL)" != 'installed' ] && [ "$1" != "startproject" ]; then
            read -p "env not set would you want to install project? [Y/n ] " ans
            if [ "$ans" != "n" ];then
                django_create_project
            fi

        fi

        # django core
        case $2 in
            startproject)
                if [  "$(getEnv ALGO_DJANGO_TOOL)" != 'installed'  ]; then
                    django_create_project
                else
                    echo "you allredy install the project"
                fi
            ;;
            createapp)
                django_create_app "${@:3}"
            ;;
            rebase)
                django_rebase
            ;;
        esac
    ;;

esac