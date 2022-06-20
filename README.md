# adecco

## Prerequisites

- Docker
- `docker-compose`
- `tmux` and `tmuxinator` (optional)

## Run Server

### With `tmux` and `tmuxinator`

```bash
tmuxinator .
```

### Without `tmux` and `tmuxinator`

- Terminal 1

   ```bash
   make up
   ```

- Terminal 2

   ```bash
   make attach-django
   ```

- Terminal 3

   ```bash
   make attach-angular
   ```

## Deployment

### Development

- Automatically when pushed to `main` branch

### Production

- Automatically when pushed a tag with format: `v*`

## Common Commands

### Linting

```bash
make lint-django
make lint-angular
```

### Testing

```bash
make test-django
```

### Init Data

```bash
make init-data
```

### Django Shell Plus

```bash
make shell
```

### Run Migrations

```bash
make migrations
make migrate
```

### Reset Database

```bash
make reset-db
```

### Update Python Dependencies

Update `requirements.in`, then run:

```bash
make pip-compile
```


## Documentations

install **Obsidian**

open vault in folder `documentations`

https://obsidian.md/download
