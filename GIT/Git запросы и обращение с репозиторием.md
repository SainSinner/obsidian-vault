#### Подключение к удаленному репозиторию GITHUB и создаем SSH

##### В терминале linux
проваливаемся в папку .ssh
`cd ~/.ssh`
Создаем ssh ключ
`ssh-keygen -t rsa -b 4096 -C "g.svyat@yandex.ru"`
Даем ему имя `id_ed25519`
Проверяем работу ssh клиента
`eval "$(ssh-agent -s)"`
Добавляем наш ssh ключ сгенерированный
`ssh-add ~/.ssh/id_ed25519`
Открываем публичную часть ключа и копируем ее
`cat ~/.ssh/id_ed25519.pub`

##### На GitHub SSH

Зайдите на GitHub и авторизуйтесь под аккаунтом SainSinner.

Перейдите в Settings → SSH and GPG keys → New SSH key или Add SSH key.
В поле Title дайте ключу имя (например, "Jupyter-Docker").
В поле Key вставьте скопированный публичный ключ.
Нажмите Add SSH key и подтвердите действие паролем, если потребуется.

##### На GitHub генерируем токен для доступа к репозиторию

Зайдите на GitHub и авторизуйтесь под аккаунтом SainSinner.

Перейдите в Settings → Developer settings → Personal access tokens → Tokens (classic) → Generate new token.
Выберите тип токена: Classic token.
Установите разрешения (scopes):
repo (для работы с репозиториями).
Опционально: workflow (для GitHub Actions).
Укажите срок действия (например, 30 дней или без истечения).
Нажмите Generate token и скопируйте токен (он отображается только один раз). Сохраните его в безопасном месте.

#### Create a new repository

`git clone git@git.ovp.ru:asg/it/esb/some-test-store-gs.git`
`cd some-test-store-gs`
`git switch --create main`
`touch README.md`
`git add README.md`
`git commit -m "add README"`

#### Push an existing folder

`cd existing_folder`
`git init --initial-branch=main`
`git remote add origin git@git.ovp.ru:asg/it/esb/some-test-store-gs.git`
`git add .`
`git commit -m "Initial commit"`

#### Push an existing Git repository

`cd existing_repo`
`git remote rename origin old-origin`
`git remote add origin git@git.ovp.ru:asg/it/esb/some-test-store-gs.git`

#### Push some changes from local GIT to GITHUB

`git status`
`git fetch --all`
`git checkout main`
`git add .`
`git commit -m "new changes"`
`git push origin HEAD`


