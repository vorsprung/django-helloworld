cd /opt/django
python3 manage.py migrate
python3 manage.py createsuperuser --no-input --username admin --email admin@mail.com
python manage.py runserver
