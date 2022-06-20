up:
	docker-compose up -d

attach-angular:
	bash -c "./scripts/wait-for-it.sh --timeout=0 localhost:4200"
	docker-compose exec angular sh -c "npm install && npm run start"

attach-django:
	bash -c "./scripts/wait-for-postgres.sh postgres"
	bash -c "./scripts/wait-for-it.sh --timeout=0 localhost:8000"
	docker-compose exec django sh -c "pip install -r requirements.txt && python manage.py collectstatic --noinput && python manage.py migrate && python manage.py init_data && uvicorn --host 0.0.0.0 --reload main.asgi:application"

.migrate:
	docker-compose exec django python manage.py migrate

migrate:
	docker-compose exec django python manage.py migrate $(filter-out $@,$(MAKECMDGOALS))

.migrations:
	docker-compose exec django python manage.py makemigrations

migrations:
	docker-compose exec django python manage.py makemigrations $(filter-out $@,$(MAKECMDGOALS))

migrations-migrate: .migrations .migrate

shell:
	docker-compose exec django sh -c "mkdir -p ~/.ipython/profile_default"
	docker-compose exec django sh -c "echo \"c.InteractiveShellApp.exec_lines = ['%autoreload 2']\nc.InteractiveShellApp.extensions = ['autoreload']\" > ~/.ipython/profile_default/ipython_config.py"
	docker-compose exec django python manage.py shell_plus

build-django:
	docker-compose build django celery-worker celery-beat

build-angular:
	docker-compose build angular

build: build-django build-angular

init-data:
	docker-compose exec django python manage.py init_data $(filter-out $@,$(MAKECMDGOALS))

init-fake-data:
	docker-compose exec django python manage.py init_fake_data $(filter-out $@,$(MAKECMDGOALS))

pip-compile:
	docker-compose exec django sh -c "pip install pip-tools && pip-compile"

reset-db:
	docker-compose stop django celery-worker celery-beat
	docker-compose exec postgres dropdb -U postgres adecco_db
	docker-compose exec postgres createdb -U postgres adecco_db
	docker-compose up -d django celery-worker celery-beat

delete-migrations:
	find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
	find . -path "*/migrations/*.pyc" -delete

reset-migrations: delete-migrations reset-db migrations-migrate

lint-django:
	docker-compose exec django pylint main

lint-angular:
	docker-compose exec angular npm run lint

lint: lint-django lint-angular

reformat-django:
	docker-compose exec django pip install yapf
	docker-compose exec django yapf -ipr --exclude "**/migrations/*" main

reformat: reformat-django

test-django:
	docker-compose exec django python manage.py test $(filter-out test,$(filter-out $@,$(MAKECMDGOALS))) --parallel

test-django-no-parallel:
	docker-compose exec django python manage.py test $(filter-out test,$(filter-out $@,$(MAKECMDGOALS)))

test: test-django

messages:
	docker-compose exec django python manage.py makemessages -l th

compilemessages:
	docker-compose exec django python manage.py compilemessages -l th

initialize_buckets:
	docker-compose exec django python manage.py initialize_buckets

down:
	docker-compose down --remove-orphans

%:
	@:

startapp:
	mkdir -p ./django/main/apps/$(filter-out $@,$(MAKECMDGOALS))
	docker-compose exec django python manage.py startapp $(filter-out $@,$(MAKECMDGOALS)) main/apps/$(filter-out $@,$(MAKECMDGOALS))

restore-from-dev: reset-db
	echo '- Dumping database from DEV Server'
	docker-compose exec postgres pg_dump --file=/var/lib/postgresql/data/dump.sql --dbname=postgresql://postgres:Codium123!@117.121.213.41:5432/adecco_db
	echo '- Restoring from dump'
	docker-compose exec postgres psql --quiet --file=/var/lib/postgresql/data/dump.sql --username=postgres --dbname=adecco_db
	docker-compose exec postgres rm /var/lib/postgresql/data/dump.sql
	echo '*** Database restoration completed'
	echo '----------------------------------'
